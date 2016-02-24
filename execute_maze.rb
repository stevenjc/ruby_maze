
require_relative 'maze'
#Execution Script
    m = Maze.new(4,5)
    m.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
    puts "Maze Loaded... Showing Display"
    m.display
    puts "Solving maze going from 1,1 to 7,7"
    puts m.solve(1,1, 7, 7)
    puts "Solving maze going from 1,1 to 7,3"
    puts m.solve(1,1, 7, 3)
    puts "Solving maze with trace going from 1,1 to 7,7"
    puts m.trace(1,1, 7, 7)
    puts "Solving maze with trace going from 1,1 to 7,3"
    puts m.trace(1,1, 7, 3)
