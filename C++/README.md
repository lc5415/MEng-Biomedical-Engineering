These 3 pieces of code(cells.cpp, connect4.cpp, protein.cpp) are all my own and were written as pieces of Programming II coursework in Biomedical Engineering Year 2 at Imperial College. cells.cpp and connect4.cpp were awarded full marks whereas protein.cpp was awarded 80%

to run any of the scripts, clone this repository or download either file (and its related files), and run the following in terminal:
    sudo g++ code.cpp
    ./a.out
And then follow the instructions given by the command window

What does each script do?

cells.cpp consists of a cell growth simulator where the state of a population of cells changes iteratively each time the user presses any key. Two types of cells are simulated: normal and cancerous, they follow different growth rules:
      • Death.          If a cell is alive, it will die under the following circumstances:
          - Overpopulation: If the cell has four or more alive neighbours, it dies.
          - Loneliness:     If the cell has one or fewer alive neighbours, it dies.
      • Birth.          If a cell is dead, it will come to life if it has exactly three alive neighbours.
      • Stasis.         In all other cases, the cell state does not change.
      
protein.cpp is a protein database search engine which allows the user to search a protein by number, GI id... (implementation to search by keyword could not be worked out by the time of submission of the code.      

connect4.cpp is the a digital implementation of the classic connect4 game where in order to win a player needs to align 4 pieces of the same kind (X or O) in any direction
