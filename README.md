#GAME OF LIFE

Yet another implementation of Conway's Game of Life.  Initially built as a straightforward kata.  As an exercise, I sought two obvious optimizations:

  1. Instead of counting neighbors, I cached the number of neighbors for each cell, and updated them as I changed the value of a given cell.
  2. Instead of updating every cell, I maintained a set of those cells having a changing neighbor, and only updated those cells.

These required some changes to the initial design. 
