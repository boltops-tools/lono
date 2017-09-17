require "byebug"
require "yaml"

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
end
