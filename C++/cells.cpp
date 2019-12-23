#include <iostream>
#include <string>
#include <cstdlib>
#include <vector>
#include <stdio.h>
#include <time.h>

using namespace std;

class Cells
{
	protected:
	
	//char celltype_c;
	
	
	public:
	
	char celltype_c;
	vector< vector <char> > boardtemp;
	Cells();
	void celltype(int type_in);
	//int celltype(int type_in);
	int NextStateNormal(vector< vector<char> > board_in, int i, int j);
	
}; 
  
Cells::Cells()
{

}

void Cells::celltype(int type_in)
{

	if (type_in==1)
	{
		celltype_c = 'O';
	}
	else if(type_in==2)
	{
		celltype_c = 'X';
	}
	cout<<celltype_c<<endl<<endl;
}

int Cells:: NextStateNormal(vector< vector<char> > board_in, int i, int j)
{
		if (board_in[i][j]==celltype_c)
		{		
			int neighbour_count_alive = 0;
			for (int m=-1;m<=1;m++)
			{	
				for (int n=-1;n<=1;n++)
				{	
					if (board_in[i+m][j+n]!=' ')
					{
						neighbour_count_alive++;
					}	
				}
			}
		
			neighbour_count_alive--;// to discard the count of the center cell, where m=0, n=0 
				
			if (celltype_c=='O')			
			{
						if (neighbour_count_alive>=4 || neighbour_count_alive<=1)
						{
							boardtemp[i][j]=' ';
						}
						else
						{
							boardtemp[i][j]=board_in[i][j];
						}
					}
			else if (celltype_c=='X')
			{
						if (neighbour_count_alive>=5 || neighbour_count_alive<=1)
						{
							boardtemp[i][j]=' ';
						}
						else
						{
							boardtemp[i][j]=board_in[i][j];
						}
					}
		}
				
		else if (board_in[i][j]==' ')
		{	
			int neighbour_count_dead = 0;
			for (int a=-1;a<=1;a++)
			{	
				for (int b=-1;b<=1;b++)
				{	
					if (board_in[i+a][j+b]!=' ')
					{
						neighbour_count_dead++;
					}
				}
			}
					
			if (neighbour_count_dead==3)
			{
				boardtemp[i][j]=celltype_c;
			}
             else
             {
                boardtemp[i][j]=board_in[i][j];  
             }
                }
                
        return 0;
}

class Cancer: public Cells
{
	public:
	Cancer();
	//vector< vector <char> > boardtemp;
	int NextStateCancer(vector< vector<char> > board_in, int i, int j);
};

Cancer::Cancer()
{

}

int Cancer::NextStateCancer(vector< vector<char> > board_in, int i, int j)
{
		if (board_in[i][j]==celltype_c)
		{		
			int neighbour_count_alive = 0;
			for (int m=-1;m<=1;m++)
			{	
				for (int n=-1;n<=1;n++)
				{	
					if (board_in[i+m][j+n]!=' ')
					{
						neighbour_count_alive++;
					}	
				}
			}
		
			neighbour_count_alive--;// to discard the count of the center cell, where m=0, n=0 
							
			if (neighbour_count_alive>=5 || neighbour_count_alive<=1)
			{
				boardtemp[i][j]=' ';
			}
			else
			{
				boardtemp[i][j]=board_in[i][j];	
			}
					
		}
				
		else if (board_in[i][j]==' ')
		{	
			int neighbour_count_dead = 0;
			for (int a=-1;a<=1;a++)
			{	
				for (int b=-1;b<=1;b++)
				{	
					if (board_in[i+a][j+b]!=' ')
					{
						neighbour_count_dead++;
					}
				}
			}
					
			if (neighbour_count_dead==3)
			{
				boardtemp[i][j]=celltype_c;
			}
             else
             {
                boardtemp[i][j]=board_in[i][j];  
             }
                }
                
        return 0;
}

class Board
{	
	private:
	
	int row;
	int column;
	int selection,confluence;
	vector< vector<char> > board;
	Cells cell;
	Cancer cancer;
	int cell_count;
	char celltype;
	int time;
	
	public:
	Board(int row_in,int column_in);
	int seed_cells(int selection,int confluence);
	int next_state();
	void display();
	int get_time();
	int get_num_cells();
	
};

Board::Board(int row_in, int column_in) //board constructor, builds the boards
{
	row = row_in+2; 		//we overfill the board with kind of a frame so that the 
	column = column_in+2; 	//neighbour count of the border cells can be done
	for (int i = 0; i < (row); i++) 
	{	
		vector<char> boardrowtemp;
		for (int j=0; j < (column);j++)
		{
			boardrowtemp.push_back(' ');
		}
		board.push_back(boardrowtemp);
		(cell.boardtemp).push_back(boardrowtemp);
		(cancer.boardtemp).push_back(boardrowtemp);
	}

} 

int Board::get_num_cells()
{
	cell_count=0;
	for (int i = 1; i < (row-1); i++) 
	{
		for (int j=1; j < (column-1);j++)
		{
          	if (board[i][j]==celltype)//everytime there is a match, add one to the cell count
          	{
          		cell_count++;
          	}
		}
	}
	return cell_count;
}

int Board::get_time()// return time
{
	return time;
}

void Board::display() //classic nested-for loop to print the board
{	
	for (int i = 1; i < (row-1); i++) 
	{
		for (int j=1; j < (column-1);j++)
		{
           cout<< board[i][j];
		}
		cout<<endl;
	}
}

int Board::next_state() 
{

	if (selection==1)
	{
		for (int i = 1; i < (row-1); i++) 
		{
			for (int j=1; j < (column-1);j++)
			{
				cell.NextStateNormal(board,i,j);
			}
		}
		for (int i = 1; i < (row-1); i++) 
		{
			for (int j=1; j < (column-1);j++)
			{
				board[i][j]=cell.boardtemp[i][j];
			}
		}		
	
	}

	else if (selection==2)
	{
		for (int i = 1; i < (row-1); i++) 
		{
			for (int j=1; j < (column-1);j++)
			{
				cancer.NextStateCancer(board,i,j);
			}
		}
		for (int i = 1; i < (row-1); i++) 
		{
			for (int j=1; j < (column-1);j++)
			{
				board[i][j]=cancer.boardtemp[i][j];
			}
		}
	}
			
	time++; 
	return 0;
}

int Board::seed_cells(int selection_in,int confluence_in)
{	
	time=0;
	selection = selection_in; 	//takes in input values and stores them as private variables
	confluence = confluence_in;
	int limit=0; //to limit the number of cells we want to fill the board with  
	int total = (row-2)*(column-2); // maximum number of cells the board can hold(i.e. 1500)
	int random; //number that will store every random number created at every iteration
	float percentage = (float)confluence/100; //actual percentage we are working with
	int test = total*percentage; // top number the limit is going to(i.e. total number of cells)
	
	if (selection == 1)
	{
		celltype = 'O'; //variable to work with inside board class
		cell.celltype(1); //variable to work with inside cell class
	}
	else
	{
		celltype = 'X'; //same as above
		cancer.celltype(2);
		
	}
	
	while(limit <test) //this is going to run until the board is filled with 
	{					//the number of cells we want to be filled in with
		for (int i = 1; i < (row-1); i++) 
		{
			for (int j=1; j < (column-1);j++)
			{
				random = rand()% (total+1);// random numbers from 1 to 1500
				if (board[i][j]==' ') // if the spot is free, then proceed
				{
					if (random == (i*j)) // if this random event happens fill-in the spot
					{
						board[i][j]=celltype ;
						limit++; // one less cell to go
					}
				}
			}
			
		}
	}
	return 0;
}

int main() //main from Dr. Choi
{
	int selection = 0;
	int confluence = 0;
	int c;
	Board board(20,75);
	string trash;
	system("clear"); //cls on windows, clear on mac
	
	cout << "Welcome to the cell simulator" << endl;
	cout << endl;
	cout << "Select your cell type: (1) normal cells or (2) cancer cells" << endl;
	
	while ( (selection < 1) || (selection > 2))
	{
		cout << ">";
		cin >> selection;
	}
	getline(cin,trash);
	cout << "Select the confluence percentage (%)" << endl;

	while ( (confluence <= 0) || (confluence >100))
	{
		cout << ">";
		cin >> confluence;
	}	
	getline(cin,trash);
	
	board.seed_cells(selection, confluence);
	system("clear"); //cls on windows, clear on mac

	while(c!='q')
	{
		system("clear"); //cls on windows, clear on mac
		cout << "time: " << board.get_time() << endl;
		cout << "number of cells: " << board.get_num_cells() << endl;
		board.display();
		c = cin.get();
		board.next_state();
	}
	
	return 0;
}
