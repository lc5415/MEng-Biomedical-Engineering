#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <locale>
#include <stdlib.h>
#include <iterator>

using namespace std;
int a;

struct protein{
	string gi;
	string ref;
	string name;
	string mainchain;
}; 

void AAchain();
void secondmenu();
void description_menu();
void AAcount();
void protein_stats();
void first_menu();


string pointer;
int pnumber;
string pgiid;
string prefid;
ifstream f_in;
string keyword;


vector <protein> p;

int main()
{	
	first_menu();
	return 0;
}

void AAcount() // aminoacid count of every protein
{	
	int AAcount=0; 
	AAcount=(p[pnumber-1].mainchain).length();
	
	for(int i =0; i<AAcount;i++) // for loop in order not to count the spaces
	{
		if (((p[pnumber-1].mainchain[i])< 'A') || ((p[pnumber-1].mainchain[i])> 'Z'))
		{
			AAcount--;
		}
	}
	cout<<"Total number of amino acids: ";
	AAcount--; // I always found that the number of AA the program gave me was one more than the actual one
	cout<<AAcount;
}

void protein_stats() //Count of every single AA per protein sequence
{	int iterator=0;
	int Acount=0;
	int Bcount=0;
	int Ccount=0;
	int Dcount=0;
	int Ecount=0;
	int Fcount=0;
	int Gcount=0;
	int Hcount=0;
	int Icount=0;
	int Kcount=0;
	int Lcount=0;
	int Mcount=0;
	int Ncount=0;
	int Pcount=0;
	int Qcount=0;
	int Rcount=0;
	int Scount=0;
	int Tcount=0;
	int Ucount=0;
	int Vcount=0;
	int Wcount=0;
	int Ycount=0;
	int Zcount=0;
	int Xcount=0;
	int asteriskcount=0;
	int hyphencount=0;
	while (iterator<((p[pnumber-1]).mainchain).length())
	{
		if((p[pnumber-1]).mainchain[iterator]=='A')
		{
			Acount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='B')
		{
			Bcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='C')
		{
			Ccount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='D')
		{
			Dcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='E')
		{
			Ecount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='F')
		{
			Fcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='G')
		{
			Gcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='H')
		{
			Hcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='I')
		{
			Icount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='K')
		{
			Kcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='L')
		{
			Lcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='M')
		{
			Mcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='N')
		{
			Ncount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='P')
		{
			Pcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='Q')
		{
			Qcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='R')
		{
			Rcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='S')
		{
			Scount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='T')
		{
			Tcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='U')
		{
			Ucount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='V')
		{
			Vcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='W')
		{
			Wcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='Y')
		{
			Ycount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='Z')
		{
			Zcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='X')
		{
			Xcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='*')
		{
			asteriskcount++;
			iterator++;
		}
		else if((p[pnumber-1]).mainchain[iterator]=='-')
		{
			hyphencount++;
			iterator++;
		}	
		else
		{
		iterator++;
		}
	}
		cout<<endl;
		cout<< "A  "<<Acount;
		cout<<"\tP  "<<Pcount<< endl;
		cout<< "B  "<<Bcount;
		cout<<"\tQ  "<<Qcount<<endl;
		cout<< "C  "<<Ccount;
		cout<<"\tR  "<<Rcount<<endl;
		cout<< "D  "<<Dcount;
		cout<<"\tS  "<<Scount<<endl;
		cout<< "E  "<<Ecount;
		cout<<"\tT  "<<Tcount<<endl;
		cout<< "F  "<<Fcount;
		cout<<"\tU  "<<Ucount<<endl;
		cout<< "G  "<<Gcount;
		cout<<"\tV  "<<Vcount<<endl;
		cout<< "H  "<<Hcount;
		cout<<"\tW  "<<Wcount<<endl;
		cout<< "I  "<<Icount;
		cout<<"\tY  "<<Ycount<<endl;
		cout<< "K  "<<Kcount;
		cout<<"\tZ  "<<Zcount<<endl;
		cout<< "L  "<<Lcount;
		cout<<"\tX  "<<Xcount<<endl;
		cout<< "M  "<<Mcount;
		cout<<"\t*  "<<asteriskcount<<endl;
		cout<< "N  "<<Ncount;
		cout<<"\t-  "<<hyphencount<<endl;
		cout<<endl;
}


void first_menu() //this displays the first menu and access the chosen database
{
int menu_input, checker;	
	checker =0;
	while (checker == 0)
	{
		cout<< "Welcome to the Protein Database\n";
		cout<< "Select an option from the menu below:\n";
		cout<< "1) Load the abridged protein data\n";
		cout<< "2) Load the complete protein data\n";
		cout<< "3) Quit database\n";
		cout<< ">> "; 
		cin>> menu_input;
		cout<<endl;
		if (menu_input==1)
		{
			f_in.open("protein_a.fa");
			secondmenu();
			checker++;			
		}
			else if (menu_input==2)
			{
			f_in.open("protein_c.fa");
			secondmenu();
			checker++;
			
			}
			
			else if (menu_input ==3)
			{
			cout<< "End of program";
			
			checker++;
			exit(1);
			}
			
			else
			{ 
			cout<< "Please enter a number between 1 and 3.\n";
			}
		
	}
}


void secondmenu()
{		
			char data;
			f_in >> data;
			cout<< "Loading database..."<<endl;
			if (f_in.is_open())// you dont need to write everything
			{
			while(!f_in.eof()) // associates every variable of the file to the current protein id
			{
				protein ptemp;
		
				getline(f_in,pointer,'|');
				getline(f_in,ptemp.gi, '|');
		
				getline(f_in,pointer, '|');
				getline(f_in,ptemp.ref, '|');
		
				getline(f_in,ptemp.name);
		
				getline(f_in,ptemp.mainchain,'>');
			
				ptemp.mainchain.erase(remove(ptemp.mainchain.begin(),ptemp.mainchain.end(),' '),ptemp.mainchain.end());
				
				(p).push_back(ptemp);	//and then it is added to an element of a vector p
			}
		
			f_in.clear();
			f_in.seekg(0);
		
			int menu_input;
			int checker2 = 0;
			int protein_count=0;
			char data2; 
			int menu_input2;
			f_in >> data2;
			while (getline(f_in, pointer,'>'))// by counting every '>' character, this counts the number of proteins
			{
       		 protein_count++;
       		 }
       		 cout<<"Database loaded. :)"<<endl<<endl;
       				
			while (checker2==0) // display of the second menu
			{ 
				cout<< "Select an option from the menu below:\n";
				cout<< "1) Overview of the database\n";
				cout<< "2) Search by protein #\n";
				cout<< "3) Search by gi #\n";
				cout<< "4) Search by ref #\n";
				cout<< "5) Search by keyword \n";
				cout<< "6) Quit database\n";
				cout<< ">>";
				cin>>menu_input2;
				cout<<endl;
				
				if(menu_input2==1)
				{
				cout<< "The proteins in the database are from GenBank(R)\n";
				cout<< "Total number of proteins in the database: ";
				cout<<protein_count<<endl;
				cout<< "Amino acids are represented by the following characters:\n";
				cout<< "A  alanine\t\tP  proline\n";
				cout<< "B  aspartate/asparagine\tQ  glutamine\n";
				cout<< "C  cystine\t\tR  arginine\n";
				cout<< "D  aspartate\t\tS  serine\n";
				cout<< "E  glutamate\t\tT  threonine\n";
				cout<< "F  phenylalanine\tU  selenocysteine\n";
				cout<< "G  glycine\t\tV  valine\n";
				cout<< "H  histidine\t\tW  tryptophan\n";
				cout<< "I  isoleucine\t\tY  tyrosine\n";
				cout<< "K  lysine\t\tZ  glutamate/glutamine\n";
				cout<< "L  leucine\t\tX  any\n";
				cout<< "M  methionine\t\t*  trasnlation stop\n";
				cout<< "N  asparagine\t\t-  gap of indeterminate length\n";
				cout<<endl;
				}
				else if(menu_input2==2)
				{
					cout<< "Enter the number of the protein you want to study: ";
					cin>> pnumber; 
					cout<<endl;
					description_menu();
					checker2++;
				}
				
				/*in my program every protein is mainly associated to its item id, so when
				I find a gi id or ref id match I associate a temporary variable "a" to the 
				item id "pnumber"*/
				else if(menu_input2==3)
				{	
					int checku=0;
					cout<< "Enter the gi id of the protein you want to study: ";
					
					
					while(checku==0)
					{	cin>>pgiid;
						for (int a=0;a<= protein_count; a++)
						{
							if (pgiid==p[a].gi)
								{
									pnumber=(a+1);
									checku++;
									break;
								}  
						}
						
						if (checku==0)
						{
						cout<<"Please enter a valid gi id.\n>>";
						}
						
					}
					cout<<endl;
					description_menu();
					checker2++;
				}
				else if(menu_input2==4)
				{	
					int checkv=0;
					cout<< "Enter the ref id of the protein you want to study: ";
					
					
					while(checkv==0)
					{	cin>>prefid;
						for (int a=0;a<= protein_count; a++)
						{
							if (prefid==p[a].ref)
								{
									pnumber=(a+1);
									checkv++;
									break;
								}  
						}
						
						if (checkv==0)
						{
						cout<<"Please enter a valid gi id.\n>>";
						}
						
					}
					cout<<endl;
					description_menu(/*p, pnumber*/);
					checker2++;
				}
				else if(menu_input2==5)
				{	
					cout<< " I could not do the keyword search.\n\n";
					
					checker2++;
				}
				else if(menu_input2==6)
				{
					cout<< "End of program\n\n";
			
					checker2++;
					exit(1);
				}
				else
				{
					cout<<"Please enter a number between 1 and 6\n";
				}
			}
			f_in.close();
			}
			else
			{
			cout<<"Error opening file.Please check if the file is in\nthe same folder as this program ";
			cout<<"or if the file names are correct and then run the program again.\n\n";
			}
			
}


void description_menu() // third menu
{	
	int checker3 = 0;
	int menu_input3;
	
	while (checker3==0)
	{	
		cout<< "Select an option from the menu below\n";
		cout<< "1) Description of the protein\n";
		cout<< "2) Protein sequence\n";
		cout<< "3) Protein statistics\n";
		cout<< "4) Record protein to file\n";
		cout<< "5) Return to main menu \n";
		cout<< ">>";
		cin>> menu_input3;
		cout<<endl;
		
		
		if (menu_input3==1)// displays every id of the selected protein
		{	
			cout<<"Description of the protein:"<<endl<<endl;	
				cout<< "the item id of this protein is: ";
				cout<<pnumber<<endl;
				cout<< "gi id: ";
				cout<< (p[pnumber-1]).gi<<endl;
				cout<< "ref id: ";
				cout<< (p[pnumber-1]).ref<<endl;
				cout<< "name: ";
				cout<< (p[pnumber-1]).name<<endl;
			cout<<endl;
			
		}
		else if(menu_input3==2)//display the sequence of the selected protein
		{	
			int i=0;
			cout<<"Protein sequence:\n";
			for (i=0; i<(p[pnumber-1].mainchain).size();i++)
				{
  				  cout << (p[pnumber-1].mainchain)[i];
				}
			cout<<endl;
		}
		else if(menu_input3==3)// display protein stats
		{
			cout<<"Report on the protein statistics:\n";
			AAcount();
			protein_stats();
			cout<<endl;
		}
		else if(menu_input3==4)// stores selected protein into a file (once at each time)
		{
			ofstream f_out;
			int pstored=1;
			string output = "stored_protein.txt";
			f_out.open(output.c_str(), ios_base::out);
			for(int i=0; i<1;i++)
			{
			f_out<<"Item id: "<<pnumber<<endl;
			f_out<<"gi id: "<<(p[pnumber-1]).gi<<endl<<"Reference id: "<< (p[pnumber-1]).ref<<endl;
			f_out<<"name id: "<<(p[pnumber-1]).name<<endl<<"Sequence: \n"<< (p[pnumber-1]).mainchain;
			cout<<endl;
			pstored++;
			}
      		f_out.close();
      		cout<< "Your protein has been succesfully stored.\n";
			
			
		}
		else if(menu_input3==5)//comes back to the second menu
		{
			secondmenu();
		}
		else 
		{
			cout<<"Please enter a number between 1 and 5\n";
		}
	}
}
