require "byebug"
require "yaml"
require "graph"

class Node
  attr_accessor :name, :children, :depends_on
  def initialize(name)
    @name = name
    @children = []
    @depends_on = []
  end
end

class Lono::Inspector::Depends
  def initialize(stack_name, options)
    @stack_name = stack_name
    @project_root = options[:project_root] || '.'
    @options = options
    @nodes = [] # lookup map
  end

  def run
    Lono::Template::DSL.new(@options.clone).run
    # TODO: check if the stack exists and print friend error message
    data = YAML.load(IO.read("#{@project_root}/output/#{@stack_name}.yml"))

    # First loop through top level nodes and build set depends_on property
    node_list = [] # top level node list
    resources = data["Resources"]
    resources.each do |logical_id, resource|
      node = Node.new(logical_id)
      node.depends_on = normalize_depends_on(resource)
      node_list << node
    end

    # Now that we have loop through all the top level resources once
    # we can use the depends_on attribute on each node and set the
    # children property since the identity nodes are in memory.
    node_list.each do |node|
      node.children = normalize_children(node_list, node)
    end

    # At this point we have a tree of nodes.
    puts "CloudFormation Dependencies:"
    node_list.each do |node|
      print_tree(node)
    end

    ####################
    print_graph(node_list)
  end

  def print_tree(node, depth=0)
    spacing = "  " * depth
    puts "#{spacing}#{node.name}"
    node.children.each do |node|
      print_tree(node, depth+1)
    end
  end

  # normalized DependsOn attribute to an Array of Strings
  def normalize_depends_on(resource)
    dependencies = resource["DependsOn"] || []
    [dependencies].flatten
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

  def print_graph(node_list)
    digraph do
      node_list.each do |n|
        node(n.name)
        # n.children.each do |child|
        #   edge n.name, child.name
        # end
      end
      # many ways to access/create edges and nodes
      # edge "a", "b"
      # self["b"]["c"]
      # node("c") >> "a"

      # square   << node("a")
      # triangle << node("b")

      # red   << node("a") << edge("a", "b")
      # green << node("b") << edge("b", "c")
      # blue  << node("c") << edge("c", "a")
      random = (0...8).map { (65 + rand(26)).chr }.join
      path = "/tmp/simple_example-#{random}"
      save path, "png"
      # TODO: check if open command exists
      system "open #{path}.png"
    end
  end
end
