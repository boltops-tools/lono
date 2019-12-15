require "yaml"
require "graph"

module Lono::Inspector
  class Graph < Base
    def initialize(options={})
      super
      @nodes = [] # lookup map
    end

    def perform(template)
      # little dirty but @template is used in data method so we dont have to pass it to the data method
      @template = template

      puts "Generating dependencies tree for template #{@template}..."
      return if @options[:noop]

      # First loop through top level nodes and build set depends_on property
      node_list = [] # top level node list
      resources = data["Resources"]
      resources.each do |logical_id, resource|
        node = Node.new(logical_id)
        node.depends_on = normalize_depends_on(resource)
        node.resource_type = normalize_resource_type(resource)
        node_list << node
      end

      # Now that we have loop through all the top level resources once
      # we can use the depends_on attribute on each node and set the
      # children property since the identity nodes are in memory.
      node_list.each do |node|
        node.children = normalize_children(node_list, node)
      end

      # At this point we have a tree of nodes.
      if @options[:display] == "text"
        puts "CloudFormation Dependencies:"
        node_list.each { |node| print_tree(node) }
      else
        print_graph(node_list)
        puts "CloudFormation Dependencies graph generated."
      end
    end

    # normalized DependOn attribute to an Array of Strings
    def normalize_depends_on(resource)
      dependencies = resource["DependOn"] || []
      [dependencies].flatten
    end

    def normalize_resource_type(resource)
      type = resource["Type"]
      type.sub("AWS::", "") # strip out AWS to make less verbose
    end

    # It is possible with bad CloudFormation templates that the dependency is not
    # resolved, but we wont deal with that.  Users can validate their CloudFormation
    # template before using this tool.
    def normalize_children(node_list, node)
      kids = []
      node.depends_on.each do |dependent_logical_id|
        node = node_list.find { |n| n.name == dependent_logical_id }
        kids << node
      end
      kids
    end

    def print_tree(node, depth=0)
      spacing = "  " * depth
      puts "#{spacing}#{node.name}"
      node.children.each do |node|
        print_tree(node, depth+1)
      end
    end

    def print_graph(node_list)
      check_graphviz_installed
      digraph do
        # graph_attribs << 'size="6,6"'
        node_attribs << lightblue << filled

        node_list.each do |n|
          node(n.graph_name)
          n.children.each do |child|
            edge n.graph_name, child.graph_name
          end
        end

        random = (0...8).map { (65 + rand(26)).chr }.join
        path = "/tmp/cloudformation-depends-on-#{random}"
        save path, "png"
        # Check if open command exists and use it to open the image.
        system "open #{path}.png" if system("type open > /dev/null")
      end
    end

    # Check if Graphiz is installed and prints a user friendly message if it is not installed.
    # Provide instructions if on macosx.
    def check_graphviz_installed
      installed = system("type dot > /dev/null") # dot is a command that is part of the graphviz package
      unless installed
        puts "It appears that the Graphviz is not installed.  Please install it to generate the graph."
        if RUBY_PLATFORM =~ /darwin/
          puts "You can install Graphviz with homebrew:"
          puts "  brew install brew install graphviz"
        end
        exit 1
      end
    end

    class Node
      attr_accessor :name, :resource_type, :children, :depends_on
      def initialize(name)
        @name = name
        @children = []
        @depends_on = []
      end

      def graph_name
        type = "(#{resource_type})" if resource_type
        [name, type].compact.join("\n")
      end
    end
  end
end
