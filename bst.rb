#Defining Node class
# ----------------------------------------------------------------------------------------------------
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(node)
    @data <=> node.data
  end
end

# ----------------------------------------------------------------------------------------------------

#Defining Tree class
# ----------------------------------------------------------------------------------------------------
class Tree 
  attr_accessor :arr, :root
  def initialize(arr = [])
    @arr = arr
    @root = build_tree(@arr)
  end

  def build_tree(arr)
    arr.uniq!
    arr.sort!
    if arr.length < 2
      return Node.new(arr[0]) if arr[0]
      return nil
    else
      mid = arr.length / 2
      left_arr = arr[0...mid]
      right_arr = arr[mid + 1..-1]
      parent = Node.new(arr[mid])
      children = [build_tree(left_arr), build_tree(right_arr)]
      parent.left = children[0]
      parent.right = children[1]
    end
    return parent
  end

  def is_leaf?(node)
    return node.left.nil? && node.right.nil?
  end

  def insert(value)
    @root = insert_rec(value)
  end

  def insert_rec(value, root=@root)
    if root.nil?
      root = Node.new(value)
      return root
    end
    root.left = insert_rec(value, root.left) if value<root.data
    root.right = insert_rec(value, root.right) if value > root.data

    return root
  end

  def insert_node(node, root)
    if root.nil?
      root = node
      return root
    end
    root.left = insert_node(node, root.left)
    return root
  end
 

  def one_child?(node)
    return true if (node.left && node.right.nil?) || (node.right && node.left.nil?)
    return false
  end

  def delete(value)
    @root = delete_rec(value)
  end

  def delete_rec(value, root=@root)
    if root.data == value
      if is_leaf?(root)
        return root = nil
      elsif one_child?(root)
        root.left.nil? ? root = root.right : root = root.left
      else
        left = root.left
        root.right = insert_node(left, root.right)
        root = root.right
      end
    elsif root.data > value
      root.left = delete_rec(value, root.left)
    else
      root.right = delete_rec(value, root.right) 
    end
    return root
  end

  def find(value, root=@root)
    return root if root.nil?
    if root.data == value
      return root
    end
    root.data > value ? find(value, root.left) : find(value, root.right)
  end

  def level_order
    queue = [@root]
    data = []
    until queue.length == 0
      node = queue.pop
      block_given? ? yield(node,data) : data << node.data
      queue.unshift(node.left) if node.left
      queue.unshift(node.right) if node.right
    end
    unless block_given?
      data
    end
  end

  def inorder(data=[], root = @root)
    inorder(data, root.left) if root.left
    block_given? ? yield(root) : data << root.data
    inorder(data, root.right) if root.right
    unless block_given?
      data
    end
  end

  def preorder(data = [], root = @root)
    block_given? ? yield(root) : data << root.data
    preorder(data, root.left) if root.left
    preorder(data, root.right) if root.right
    unless block_given?
      data
    end
  end

  def postorder(data=[], root=@root)
    postorder(data, root.left) if root.left
    postorder(data, root.right) if root.right
    block_given? ? yield(root) : data << root.data
    unless block_given?
      data
    end
  end

  def depth(value)
    counter = 0
    curr_node = @root
    while !curr_node.nil?
      return counter if curr_node.data == value
      curr_node.data > value ? curr_node = curr_node.left : curr_node = curr_node.right
      counter += 1
    end
    return -1
  end 

  def max_depth(node = @root)
    if node.nil?
      return 0
    else
      left = max_depth(node.left)
      right = max_depth(node.right)

      return left > right ? left+1 : right+1
    end
  end

  def balanced?
    left_subtree = @root.left
    right_subtree = @root.right
    return (max_depth(left_subtree) - max_depth(right_subtree)).abs <= 1
  end

  def rebalance!
    nodes = self.level_order
    @root = build_tree(nodes)
  end
end
# ----------------------------------------------------------------------------------------------------
