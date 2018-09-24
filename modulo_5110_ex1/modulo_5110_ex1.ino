#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <Keypad.h>
#include <string.h>
#include <stdlib.h>
Adafruit_PCD8544 display = Adafruit_PCD8544(8, 9, 10, 11, 12);


const byte linhas = 4; //4 linhas
const byte colunas = 4; //4 colunas
 
//teclado matricial
char matrizteclado[linhas][colunas] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
byte pinoslinhas[linhas] = {22,23,24,25}; //pinos utilizados nas linhas
byte pinoscolunas[colunas] = {26,27,28,29}; //pinos utilizados nas colunas
 /*  Declarando variaveis para o uso Global*/
 int jogo1,jogo2,jogo3;

/*/tempo*/
unsigned long time=0;
unsigned long inicio=0;             
int s, su=0,sd=0, t02s=0;
String operando="";
 int cont=0;

/*Variaveis para o jogo 2*/
int op1, op2,pontos=0,resposta=0, resultado,operador,resposta_user=0;

/*Fim para o jogo 2*/


//inicializando o teclado
Keypad teclado = Keypad( makeKeymap(matrizteclado), pinoslinhas, pinoscolunas, linhas, colunas );
 
void setup()
{
display.begin();
digitalWrite(1,LOW);
}
void game1(){
    display.setTextSize(1);
    display.setCursor(0,0);
    display.print("Jogando jogo 1...");
    char respostas[2][30]={"Quem descobriu o Brasil.","EU"};
    char respostas1[5][10]={"Pes."," as"," as"," as"," as" };
    char respostas2[5][10]={"as","as","as","as","as"};
    char respostas3[5][10]={"1.80","","as","as","as"};
    display.setCursor(0,25);
    char pergunta2 [] = "Teste";
    display.println(respostas[0]);
    display.print(pergunta2);
    
}



/*Função do Jogo de Matematica*/
void fim(){ 

    display.setTextSize(1);
    display.clearDisplay();
    display.print("FIM");
}
void game2(){
  
  do{
      tempos();
      display.clearDisplay();
      display.setTextSize(1);
      display.setCursor(70,0);
      display.print(s-t02s);
      display.display();
      op1 = random(1,9);
      op2 = random(1,9);
      operador = random(1,4);
      switch(operador){
        case 1:
          result = op1+op2;
          break;
        case 2:
          result = op1-op2;
        case 3:
          break;
        case 4: 
          break;
        
      }
    }while((s-t02s)<20);
    fim();
}

void tempos(){  
    time = millis();
    s=(time/1000)%60;
    su=s%10;                            
    sd=(s-su)/10;
}

/*Fim jogo da matematica*/






void game3(){
    display.setTextSize(1);
    display.setCursor(0,0);
    display.print("Jogando jogo 3..."); 
}
 void menu(){
    display.clearDisplay();
    display.setTextSize(1);
    display.clearDisplay();
    display.setTextColor(BLACK, WHITE);
    display.setCursor(10, 0);
    display.print("MENU PIROCAS:");
    display.setCursor(0, 15);
    display.print(">Jogo A");
    display.setCursor(0, 25);
    display.print(">Jogo B");
    display.setCursor(0, 35);
    display.print(">Jogo C");
    display.drawFastHLine(0,10,83,BLACK);
    display.setCursor(0, 15);
    s=0;
    su=0;
    sd=0;
 }
void loop()
{
   char apertatecla = teclado.getKey(); // verifica se alguma tecla foi pressionada
    if (apertatecla=='#') {
      menu();
      display.setTextSize(5);
      display.setTextColor(BLACK);
      display.setCursor(0,0);
      jogo1=0;
      jogo2=0;
      jogo3=0;
     display.display();
    }
    
  if (apertatecla=='A' && jogo2==0 && jogo3==0){
    game1();
    jogo1=1;
    display.display();
    }
   else if(apertatecla=='B'&& jogo1==0 && jogo3==0){
    tempos();
    t02s = s;
    game2();
    jogo2=1;
    display.display();
    }
    else if(apertatecla=='C'&& jogo2==0 && jogo1==0){
      game3();
      jogo3=1;
      display.display();
    }
   display.clearDisplay();

}
