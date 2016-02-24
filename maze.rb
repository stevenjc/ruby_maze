#Author: Steven Colon
#CS166b PA3: Mazes
#Code limitations: Maze cannot have any loops and start/end points must be at dead ends
require 'tree'

class Maze
    #initializes the maze with a specfic amount of row and columns
    def initialize(row, col)
        #row_size and col_size take into account representing the walls in between
        @row_size = row * 2 + 1
        @col_size = col * 2 + 1
        @maze = Array.new
    end
    #loads bitstring into the maze
    def load(bitstring)
        row = Array.new
        bitstring.each_char do |bit|
            row.push(bit)
            if row.size == @row_size
                @maze.push(row)
                row = Array.new
            end
        end
    end
    #Prints out display of maze
    def display
        @maze.each do |row|
            row.each do |element|
                print element
            end
            print "\n"
        end
    end

    def solve(begR, begC, endR, endC)
        valid?(begR,begC)
        valid?(endR,endC)
        #Create root_node for graph
        root_node = Tree::TreeNode.new("Start", [begR, begC])
        #populate the graph
        populate_tree(root_node, begR, begC)
        #answer is a tuple with the node in the 1st index
        answer = find_exit(root_node, endR, endC)
        #extracting node
        answer = answer[0]
        #if no answer is found then answer will have children
        if answer.has_children?
            return false
        else
            return true
        end
    end

    def trace(begR, begC, endR, endC)
        valid?(begR,begC)
        valid?(endR,endC)
        #Create root_node for graph
        root_node = Tree::TreeNode.new("Start", [begR, begC])
        #populate the graph
        populate_tree(root_node, begR, begC)
        #answer is a tuple with the node in the 1st index
        answer = find_exit(root_node, endR, endC)
        #extracting node
        answer = answer[0]
        #if no answer is found then answer will have children
        if answer.has_children?
            return false
        else
            #prints out ancestry of answer to show steps used to get to it
            answer.parentage.reverse_each do |step|
                puts step.content.to_s
            end
            puts answer.content.to_s
            return true
        end

    end

    #checks that coordinates don't land on a wall {1}
    def valid?(r, c)
        #checks that starting coordinates are not on a wall (1)
        if @maze[r][c] == "1"
            raise ArgumentError, "Starting or Ending coordinates are invalid"
        end
    end

    #Populates a tree with coordinates. Begins are start point where children represent next possible step
    def populate_tree(node,begR, begC)
        #Retrieve list of next steps that can be taken which are possible children
        children = possible_next_steps(begR,begC)
        #iterate through children list
        children.each do |child|
            child_content = child.content  #Retrive content of child
            parent = node.parent
            if parent   #Parent is not the root
                #Check that parent and possible child are not the same to prevent backtracking
                parent_content = parent.content
                if parent_content[0]!= child_content[0] or parent_content[1] != child_content[1]
                    #Add child to node and recursively continue populating tree
                    node<<child
                    populate_tree(child,child_content[0], child_content[1])
                end
            else #parent is a root so just add child and recursively continue
                node<<child
                populate_tree(child,child_content[0], child_content[1])
            end

        end
    end
    #determines next possible steps from a set of coordinates and returns an array of possible child nodes
    def possible_next_steps(begR, begC)
        next_steps = Array.new
        #Go through each possible direction, if not a wall then create the possible child and add to the array
        if @maze[begR+1][begC] != "1"
            coor = Tree::TreeNode.new("{#{begR+1}, #{begC}}", [begR+1, begC])
            next_steps.push(coor)
        end
        if @maze[begR-1][begC] != "1"
            coor = Tree::TreeNode.new("{#{begR-1}, #{begC}}", [begR-1, begC])
            next_steps.push(coor)
        end
        if @maze[begR][begC+1] != "1"
            coor = Tree::TreeNode.new("{#{begR}, #{begC+1}}",[begR, begC+1])
            next_steps.push(coor)
        end
        if @maze[begR][begC-1] != "1"
            coor = Tree::TreeNode.new("{#{begR}, #{begC-1}}",[begR, begC-1])
            next_steps.push(coor)
        end
        next_steps
    end
    #finds exit through an implemention of DFS
    def find_exit(node, endR, endC)
        #node has children so need to continue traversal
        if node.has_children?
            node.children do |child|
                #x is a tuple with a node and true if answer was found
                x = find_exit(child, endR, endC)
                #exit has been found
                if x[1]==true
                    return x
                end
            end
        #Reached a dead end, check if that is the exit
        else
            node_content = node.content
            if node_content[0] == endR and node_content[1] == endC
                return [node, true]
            else
                return [node,false]
            end
        end
    end

    def to_s
        str = ""
        @maze.each do |row|
            str += row.to_s + "\n"
        end
        str
    end
end
