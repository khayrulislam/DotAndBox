#include<stdio.h>

char box[29]={' ','.',' ','.',' ','.',' ','.',
                 '.',' ','.',' ','.',' ','.',
                 '.',' ','.',' ','.',' ','.',
                 '.',' ','.',' ','.',' ','.'};

int array[9] = {9,11,13,16,18,20,23,25,27};

unsigned int m_w;
unsigned int m_z;
char ch;


unsigned int get_random(unsigned int m_w,unsigned int m_z)
{
    m_z = 36969 * (m_z & 65535) + (m_z >> 16);
    m_w = 18000 * (m_w & 65535) + (m_w >> 16);
    return (unsigned int )(m_z << 16) + m_w; 
}

void printBox(){
    int i;
    printf("  1 2 3 4\n");
    for(i=1;i<=28;i++){
        if(i==1) printf("a ");
        if(i==8) printf("b ");
        if(i==15) printf("c ");
        if(i==22) printf("d ");
        if((i)%7==0 ){
            printf("%c",box[i]);
            printf("\n");
        }
        else printf("%c",box[i]);
    }
    
return ;    
}

int validInput(char ch1,int number1,char ch2,int number2){
    
    if(ch1<='d' && ch2<='d' && ch1>='a' && ch2>='a' && number1<=4 && number2<=4 && number1>=1 && number2>=1) return 1;
    
    return 0;      
}

int rowValidationCheck(char ch1,int number1,char ch2,int number2){
    
    int difference=0;
    if(ch1==ch2){
    
        if(number1>number2){
            difference = number1 - number2;         
        }
        else if(number1<number2){
            difference = number2 - number1; 
        }    
    }
    
    if(difference==1) return (number2 + number1);
    else return 0;
}


int columnValidationCheck(char ch1,int number1,char ch2,int number2){
    int difference=0;
    
    if(number1==number2){
        
        if(ch1>ch2){
            difference = ch1 - ch2;
            ch = ch1;
        }
        else if(ch2>ch1){
            difference = ch2 - ch1;
            ch = ch2;
        }
    }
    
    if(difference==1) return (number2 + number1);
    else return 0;
}

int adderssCount(int sum,int ch1){
    
    if(ch1=='a') return (sum-1) ;
    else if(ch1=='b') return (sum+6) ;
    else if(ch1=='c') return (sum+13) ;
    else if(ch1=='d') return (sum+20) ;   
}

int isNewFilledUp(int index){
    
    if(box[index]=='.' || box[index]==' ') return 0;
    else return 1;
}

int isFilledUp(int index){
    
    if(box[index]=='.' || box[index]==' ') return 1;
    else return 0;
}

int boxChecking(int temp){
    
    int i,x1,x2,x3,x4;
    for(i=0;i<9;i++){
        
        x1 = isNewFilledUp(array[i]);
        x2 = isNewFilledUp(array[i]-7);
        x3 = isNewFilledUp(array[i]-1);
        x4 = isNewFilledUp(array[i]+1);
        
        if((x1+x2+x3+x4)==3  && temp==1 ) {
                    
            if(x1==0) return array[i];
            else if(x2==0) return (array[i] -7);
            else if(x3==0) return (array[i]-1);
            else if(x4==0) return (array[i]+1);
            
        }
        
        else if( ((x1+x2+x3+x4)==4) && temp==2 && box[array[i]]=='_'  ){
            return array[i];
        }
     
    }    
    
    return 0;
}


int defaultSpace(unsigned int m_w, unsigned int m_z){

    int index = 2,temp;
    
    while(index<29){
    
        if(box[index]=='.' || box[index]==' ') return index;
        if(index<7) index = index+2;
        else index++;
    }    
}  



int IsItRowIndex(int index){
    
    if( (index%7)%2==0 && (index%7)>0 ){
        return 1;
    }
    
    else return 0;
}



void computersTurn(unsigned int m_w, unsigned int m_z){
    
    int index,number1,number2;
    char ch1,ch2;
    
    index = boxChecking(1);
    
    if(index) {     
       
        if( IsItRowIndex(index) ){
            box[index] = '_';
            //ch1 = letterOfBox(index/7);
            ch1 = index/7 + 97;
            ch2 = ch1;
            number1 = (index%7)/2;
            number2 = number1 + 1;
        }
       
        else {
            box[index] = '|';
            ch1 = (index-1)/7 + 97 ;
            ch2 = ch1-1; 
            number1 = (index%7)/2+1;
            number2 = number1;
        }    
    }
    
    else{
        
        index = defaultSpace(m_w,m_z);
        
        if(IsItRowIndex(index)){
            
            //printf("ok\n");
            box[index] = '_';
            ch1 = index/7 + 97;
            ch2 = ch1;
            number1 = (index%7)/2;
            number2 = number1 + 1;
        }
        else {
            box[index] = '|';
            ch1 = (index-1)/7 + 97 ;
            ch2 = ch1-1; 
            number1 = (index%7)/2+1;
            number2 = number1;
        } 
                    
    }   
    
    printf("My turn: I draw between %c%d and %c%d\n",ch1,number1,ch2,number2);

}


void humansTurn(){
    
    int index,number1,number2,flag,flag1;
    char ch1,ch2,temp,buffer;
    
    printf("Your turn: \n");
    
    while(1){
       
        scanf("%c", &buffer);
        printf("Enter coordinate of the first dot: ");
        scanf("%c%d%c",&ch1,&number1, &buffer);
        
        //printf("%c   %d \n", ch1, number1);
        printf("Enter coordinate of the second dot: ");
        scanf("%c%d",&ch2,&number2);
        
        //printf("%c   %d \n", ch2, number2);
        
        if (validInput(ch1,number1,ch2,number2)){
        
            int index=0;
            flag = rowValidationCheck(ch1,number1,ch2,number2);
            flag1 = columnValidationCheck(ch1,number1,ch2,number2);
           
            if(flag){
               index = adderssCount(flag,ch1); 
            }
            else if(flag1){
                index = adderssCount(flag1,ch);
            }
            //printf("%d         %d        %d\n",flag,flag1,index);
            
            if(!index){
               printf("wrong input second\n"); 
            }
            else{
                
                if (isFilledUp(index)){
                    if(flag) box[index] = '_';
                    else if(flag1) box[index] ='|';
                    
                    break;                          
                }
                else {
                    printf("There is already a line there.\n");
                }
                
            }
                     
        }
        
        else{
            
            printf("wrong input first\n");
        }
        
    }

}

int main(){
    
    unsigned int m_w;
    unsigned int m_z;
    
    int i=0,number1,number2,flag,flag1,posibilityOfMakingBox,index,temp1,humanScore=0,computerScore=0;
    
    char currentPlayer,nextPlayer,ch1,ch2,temp,buffer;
    
    printf("Welcome to Dots and Boxes!\n");
    printf("Version 1.0\n");
    printf("Implemented by Ibrahim, Atiq, Khayrul, Taslima\n");
    printf("Enter two positive numbers to initialize the random number generator.\n");
   
    printf("Number 1: ");
    scanf("%d",&m_w);
    printf("Number 2: ");
    scanf("%d",&m_z);
     
     
       
    if((get_random(m_w,m_z)/2)%2==0){
       currentPlayer='C';
       nextPlayer = 'H';
       printf("I will make the first move.\n");

    }
    else{
       currentPlayer='H';
       nextPlayer = 'C'; 

    }
   

   // printBox();
    
    while(i<24){
       
       if(currentPlayer=='C') {
            
            computersTurn(m_w,m_z);
 
       }
       
       else if(currentPlayer=='H'){
            
            humansTurn();                    
      
       }
       
       i++;
       
       temp1= boxChecking(2);
       
       if(temp1){
            box[temp1] = currentPlayer ;
            
            if(currentPlayer == 'C')  computerScore++;
            else if (currentPlayer == 'H') humanScore++; 
                         
      }
       
       box[temp1] = currentPlayer ;
       
       printBox();
       temp = currentPlayer;
       currentPlayer = nextPlayer;
       nextPlayer = temp; 
        
        
       if(computerScore>=5) {
            printf("Computer win!\n");
            break;
       } 
       else if (humanScore>=5){
            printf("You win!\n");
            break;
       }
    
    }
    
return 0;
}
