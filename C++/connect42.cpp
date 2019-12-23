#include <iostream>
#include <string>

using namespace std;
void board();
void player();
void question();
void rules();
char table[6][7]={ };
char play;
int a=0;
int z=1;
int b=1;


void question()  //FINE
{	
	cout<<"Player ";
	player();
	cout<<", enter a column: ";
}

void board()  //FINE
{
cout<<endl<<" Connect Four Game \n";
	cout<<"1 2 3 4 5 6 7 \n";
	 for (int r=0; r<6; r++)
	 {	
	 	cout<<"|";
		for (int c=0; c<7; c++)
		 {
			 cout<<table[r][c]<<"|"; //put space on mac, do not on windows
		 }
		 cout<<endl<<"--------------"<<endl;
	 }
}

void player() //FINE
{
	if ((a%2)==0)
	{
	play = 'O';
	}
	else
	{
	play = 'X';
	}	
	cout<<play;
}


int main() //FINE 
{	
	board();
	
	while(z<=42)
	{
		rules();
		z++;
	}
	return 0;
}

void rules()
{	
	int i = 5,j=7;//keep them inside rules(), otherwise it crashes
	int column=0;
	question();
	cin>>column;
	while(column < 1 || column > 7)
	{	
		cout<< "There are only 7 columns, please enter a number between 1 and 7\n";
		question();
		cin>>column;
	}
	
	while (table[0][column-1] == 'O' || table[0][column-1]=='X')
	{
		cout << "That column is full, please enter another column.\n";
		question();
		cin>>column;
	}
	
	while (column != j)
	{
	j--;
	}
		
	while (table[i][j-1] == 'O' || table[i][j-1]=='X')
	{
	i--;
	}
			
	if (column == j)
	{
	table[i][j-1] = play;
	}
	
	board();
			
			for (int m=0; m<=5;m++)
			{
				for (int n=0; n<=3; n++)
					{
						if (table[m][n]== play && table[m][n+1]==play && table[m][n+2]==play && table[m][n+3]==play)
						{
							z=42;
							b--;
							cout<<"Congratulations player "<<play<<endl;
						}
					}
			}
					
			for (int e=0; e<=2;e++)
			{
				for (int f=0; f<=6;f++)
				{
					if (table[e][f]== play && table[e+1][f]==play && table[e+2][f]==play && table[e+3][f]==play)
					{	
						z=42;
						b--;
						cout<<"Congratulations player "<<play<<endl;
					}
		
				}
			}
			
			for (int g=0; g<=2;g++)
			{
				for (int h=0; h<=3;h++)
				{
					if (table[g][h]== play && table[g+1][h+1]==play && table[g+2][h+2]==play && table[g+3][h+3]==play)
					{	
						z=42;
						b--;
						cout<<"Congratulations player "<<play<<endl;
					}
				}
			}
			
			for (int o=5; o>=3;o--)
			{
				for (int p=0; p<=3; p++)
				{
					if (table[o][p]== play && table[o-1][p+1]==play && table[o-2][p+2]==play && table[o-3][p+3]==play)
					{	
						z=42;
						b--;
						cout<<"Congratulations player "<<play<<endl;
					}
				}
			}
					if (z==42 && b==1)
				{	
					cout<< " Player O, you are as good as Player X";
				}
	
				a++;
	
}