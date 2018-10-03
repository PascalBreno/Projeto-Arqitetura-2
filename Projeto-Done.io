#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <Keypad.h>
#include <string.h>
extern uint8_t SmallFont[];
#include <stdlib.h>
//#include <ArduinoJson.h>
Adafruit_PCD8544 display = Adafruit_PCD8544(8, 9, 10, 11, 12);


const byte linhas = 4; //4 linhas
const byte colunas = 4; //4 colunas
char idplayer[5] = "";
char id_user = 'B';

#define DEBUG true
unsigned long lastTimeMillis = 0;

//Funções auxiliares ESP8266
String sendData(String command, const int timeout, boolean debug);

String sendData(String command, const int timeout, boolean debug) {
  // Envio dos comandos AT para o modulo
  String response = "";
  Serial3.print(command);
  long int time = millis();
  while ( (time + timeout) > millis())
  {
    while (Serial3.available())
    {
      // The esp has data so display its output to the serial window
      char c = Serial3.read(); // read the next character.
      response += c;
    }
  }
  if (debug)
  {
    Serial.print(response);
  }
  return response;
}

void sendRecord(int ID, int record, int game) {
  Serial3.println("AT+CIPSTART=4,\"TCP\",\"35.198.6.145\",80");
  printResponse();
  for (int x = 0; x < 2; x++) {
    display.setCursor(0,0);
    display.print(".");
    display.display(); 
    String cmd = "GET /ArchII-Web/update_record.php?id=";
    cmd += ID;
    cmd += "&game=";
    cmd += game;
    cmd += "&record=";
    cmd += record;
    cmd += " HTTP/1.1";
    Serial3.println("AT+CIPSEND=4," + String(cmd.length() + 4));
    Serial.print(cmd);
    delay(1000);
    printResponse();
    Serial3.println(cmd);
    delay(1000);
    Serial3.println();
    delay(1000);
    printResponse();
  }
  display.clearDisplay();
  display.setCursor(0, 0);
  display.print("Enviado");
  display.setCursor(0,20);
  display.print("#- Para ir para o Menu");
  display.display();
}

void printResponse() {
  while (Serial3.available()) {
    Serial.println(Serial3.readString());
  }
}

int getResponse() {
  String c;
  c = Serial3.readString();
  if (c.indexOf("STATUS:1")<0) {
    return 0;
  } else {
    return 1;
  }
}

//teclado matricial
char matrizteclado[linhas][colunas] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
byte pinoslinhas[linhas] = {22, 23, 24, 25}; //pinos utilizados nas linhas
byte pinoscolunas[colunas] = {26, 27, 28, 29}; //pinos utilizados nas colunas
/*  Declarando variaveis para o uso Global*/
int jogo1, jogo2, jogo3;
int sim;
int nao;
char tecladoapertado[5] = "";

/*/auxiliaro*/
unsigned long time = 0;
char teclaapertada;
unsigned long inicio = 0;
int s, su = 0, sd = 0, t02s = 0;
int valordoteclado = 0;

/*  Game 1 */
char respostas[2][30] = {"Maior floresta do mundo todo", "Idade do Moacyr"};
char respostas1[5][10] = {"1.67.", "18", " as", " as", " as" };
char respostas2[5][10] = {"1.72", "21", "as", "as", "as"};
char respostas3[5][10] = {"1.80", "22", "as", "as", "as"};
int acertando = 0;
char respostaGame1;
/* ================*/
String operando = "";
int cont = 0;
int acerto = -1;

/*Variaveis para o jogo 2*/
//int op1, op2,operador,resposta_user;
int numero1, numero2, numero3, operacao, resultado, test_r, controle, aux_t, pontos = 0;
float valida;
char tecla [1];
int valor_do_usuario;
/*Fim para o jogo 2*/

//Variaveis da funcao id
int aleatorio;

//inicializando o teclado
Keypad teclado = Keypad( makeKeymap(matrizteclado), pinoslinhas, pinoscolunas, linhas, colunas );


int i=0;
void game1() {
   typedef struct{
        String pergunta;
        char resposta;
        String alternativas;
    }Ask;
    i=0;
    int erro;
    char tec="1",valUser;
    Ask pergun[10];
    /*Parte do codigo que seta todas as perguntas e respectivas respostas*/
    pergun[0].pergunta="Tarsila do Amaral foi?";
    pergun[0].resposta='A';
    pergun[0].alternativas ="A. Pintora\n B. Cantora\n C. Modelo";
    pergun[1].pergunta="Qual menor pais do mundo?";
    pergun[1].resposta='C';
    pergun[1].alternativas ="A. Panama\n B. Cuba\n C. Vaticano";
    pergun[2].pergunta="Segundo livro + vendido no mundo";
    pergun[2].resposta='B';
    pergun[2].alternativas ="A.Biblia\n B.Dom Quixote\n C.A Odisseia";
    pergun[3].pergunta="Quem pintou Guernica?";
    pergun[3].resposta='A';
    pergun[3].alternativas ="A. Pablo Picasso\n B. Van Gogh\n C. Diego Rivera";
    pergun[4].pergunta="Montanha mais alta do Brasil";
    pergun[4].resposta='B';
    pergun[4].alternativas ="A.S.Antonio\nB. Pico da Neblina\nC.Everest";
    pergun[5].pergunta="Nao e planeta do sistema solar:";
    pergun[5].resposta='C';
    pergun[5].alternativas ="A. Saturno\n B. Venus\n C. Plutao";
    pergun[6].pergunta="Sucuri e um(a):?";
    pergun[6].resposta='B';
    pergun[6].alternativas ="A. Ave\nB.Cobra\nC.Mamifero";
    pergun[7].pergunta="Qual o maior animal terrestre";
    pergun[7].resposta='C';
    pergun[7].alternativas ="A. Baleia Azul\n B. Girafa\n C. Elefante Africano";
    pergun[8].pergunta="Qual maior orgao do corpo humano?";
    pergun[8].resposta='A';
    pergun[8].alternativas ="A. Pele\n B. Intestino\n C. Pulmao";
    pergun[9].pergunta="Quem disse 'Penso,logo existo'?";
    pergun[9].resposta='B';
    pergun[9].alternativas ="A. Platao\n B.Descartes\n C. Descarto";
   
    /*Fim*/
    display.setTextSize(1);
    display.setCursor(20,0);
    display.println("Show do Milhao:");
    display.display();
    do{
      do{
        erro=1;
        tec="1";
        display.clearDisplay();
        //printa a pergunta e as alternativas
        display.println(pergun[i].pergunta);
        display.println(pergun[i].alternativas);
        display.display();

        //Parte responsavel pela leitura do
            tec = teclado.getKey();
            if(tec == 'A' || tec == 'B'|| tec == 'C'){            
              display.display();
              Serial.print(tec);
              Serial.println(pergun[i].resposta);
              int ret = 1;
               ret = strcmp(tec, pergun[i].resposta);
                if(tec==pergun[i].resposta){
            //se sim, imprime e incrementa pontos
                display.clearDisplay();
                display.print("Acertou :D");
                pontos++;
                i++;
                tec='4';
                }else {
            //se nao, imprime nao e zera os pontos
                display.clearDisplay();
                display.print("Perdeu Tudo :( ");            
                display.display();
                erro=0;  
                tec='2';//recebe zero para encerrar o laco
                break;
              }
            }
    } while(tec!='2' && i>='9');
    }while(erro!=0 && i!=9); 
    display.display();
    fim(1);
    return;    
}


/*Função do Jogo de Matematica*/

void fim(int game) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setCursor(15, 0);
  display.print("PARABENS");
  display.setTextColor(WHITE, BLACK);
  display.setCursor(15, 15);
  display.print(" Pontos: ");
  display.print(pontos);
  display.setTextColor(BLACK, WHITE);
  display.setCursor(0, 35);
  display.print("#- MENU");
  display.display();
  int idplayerint = atoi(idplayer);
  sendRecord(idplayerint, pontos, game);
  pontos = 0;
}

void check(int ans) {
  if (ans == resultado) {
    acerto = 1;
    printjogo2();
    pontos = pontos + 1;
    rodada();
  } else {
    acerto = 0;
    printjogo2();
    pontos = pontos - 1;
    rodada();
  }
}

void rodada() {
  numero1 = random(1, 9);
  numero2 = random(1, 9);
  numero3 = random(1, 5);
  int temp = 0;
  switch (numero3) {
    case 1:
      operando = "+";
      resultado = numero1 + numero2;
      break;
    case 2:
      operando = "-";
      if (numero1 < numero2)
      {
        temp = numero1;
        numero1 = numero2;
        numero2 = temp;
      }
      resultado = numero1 - numero2;
      break;
    case 3:
      operando = "*";
      resultado = numero1 * numero2;
      break;
    case 4:
      operando = "/";
      resultado = numero1 % numero2;
      if (resultado != 0)
      {
        operando = "*";
        resultado = numero1 * numero2;
      }
      else
      {
        resultado = numero1 / numero2;
      }
  }
}

int resposta(int *numero) {
  int aleatorio = random(0, 3);
  if (aleatorio != 0) {
    *numero = *numero + random(1, 9);
  }
  return aleatorio;
}

void game2() {
  tempos();
  t02s = s;
  do {
    tempos();
    tecla[1] = teclado.getKey();

    if (tecla[1] == '*' || tecla[1] == '1' || tecla[1] == '2' || tecla[1] == '3' || tecla[1] == '4' || tecla[1] == '5' ||
        tecla[1] == '6' || tecla[1] == '7' || tecla[1] == '8' || tecla[1] == '9' || tecla[1] == '0') {
      if (tecla[1] != '*') {
        tecladoapertado[(valordoteclado++)] = tecla[1];
        valor_do_usuario = atoi(tecladoapertado);
        display.clearDisplay();
        Serial.print(valor_do_usuario);
      } else if (tecla[1] == '*') {
        for (int i = 0; i < 5; i++) {
          tecladoapertado[i] = "";
        }
        check(valor_do_usuario);
        valor_do_usuario = 0;
        valordoteclado = 0;
      }
      sim = 0;
    }
  } while ((s - t02s) < 20);
  fim(2);
  return;
}

void printjogo2() {
  display.clearDisplay();
  display.setTextSize(1);
  display.setCursor(0, 0);
  display.print("P:");
  display.print(pontos);
  display.setCursor(60, 0);
  display.print("T:");
  display.print(20 - (s - t02s));
  display.setTextSize(1);
  if (numero1 == 0 && numero2 == 0) {
    display.setCursor(0, 15);
    display.println("Aperte uma");
    display.print("tecla");
  } else {
    display.setCursor(20, 15);
    display.print(numero1 + operando + numero2 + "=");
    display.setTextColor(WHITE, BLACK);
    display.print(" ??? ");
    display.setTextColor(BLACK, WHITE);
    display.setCursor(0, 25);
    display.print("Resultado :");
    display.print(valor_do_usuario);
    display.setCursor(0, 35);
    display.print("* - Confirmar");
  }
}

void tempos() {
  time = millis();
  s = (time / 1000);
  su = (s % 60) % 10;
  sd = ((s % 60) - su) / 10;
  printjogo2();
  display.display();
}
/*Fim jogo da matematica*/


/*FUncao do jogo 3*/
void game3() {
    int valor, vidas = 5,  valorTeclado = 0;
    char tec;
    pontos=0;
    char respox[] = "0000";
    char valUser[] = "0000";
    char valorBin[] = "0000";
    do{
        display.clearDisplay();
        display.setTextSize(1);
        display.print("P: ");
        display.print(pontos);
        display.setCursor(60, 0);
        display.print("V: ");
        display.print(vidas);
        display.println("\n Complemento 2 ");
        valor = random(1,15);
        /*parte do codigo que converte o valor */
        for(int ind=3;ind>=0;ind--){
            if(valor%2==0){
                valorBin[ind]='0';
            }else{
                valorBin[ind]='1';
            }
            valor = valor/2;
        }
        /*Fim da convercao*/

        display.println(valorBin);
        display.print("Resposta: ");
        display.display();
       
        //Laco responsavel pela leitura da resposta do usuario
        do{  
          tec = teclado.getKey();
          if(tec == '*' || tec == '1' || tec == '0'){
              if(tec != '*' && valorTeclado<4){
                  valUser[valorTeclado] = tec; 
                  display.print(valUser[valorTeclado]);
                  display.display();
                  valorTeclado++;
                  tec="";
                  Serial.println(valUser);
              }
          }
        } while (tec!='*');//fim
        //parte do codigo que faz o complemento de dois
        //Laco para inverter o binario
        for(int ind=0;ind<4;ind++){
            if(valorBin[ind]=='1')
                respox[ind]='0';
            else
                respox[ind]='1';
        }//fim
        //laco para somar 1
        char vai1[4]={'0','0','0','1'};//variavel que salva os 1s exedentes
        for(int ind=3;ind>=0;ind--){
            if(respox[ind]=='1' && vai1[ind] == '1'){
                respox[ind]='0';
                vai1[ind-1]='1';
            }else if(respox[ind]=='0' && vai1[ind] == '0'){
                 respox[ind]='0';
            }else {
                 respox[ind]='1';
            }
                
        }
   
        Serial.print("Vai 1");
        Serial.println(vai1);
        Serial.print("Valor certo:");
        Serial.println(respox);
        Serial.print("terminei");
        if(atoi(respox) == atoi(valUser)){
            pontos++;
            display.clearDisplay();
            display.print("Acertou :) \n");
            display.display();
            delay(1000);
        }else{
            display.clearDisplay();
            display.print("Errou :( \n");
            display.println(respox);
            display.display();
            delay(1000);
            vidas--;  
        }       
        tec='4';
        valorTeclado=0;
    }while(vidas>0);
    fim(3);
}
/*FIM do jogo 3*/

/*Funcao para entrada da ID do Jogador*/
void idUsuario() {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(0, 0);
  display.print("Digite sua ID:");
  display.display();
  do{
    id_user = teclado.getKey();
    if (id_user == '1' || id_user == '2' || id_user == '3' || id_user == '4' || id_user == '5' ||
        id_user == '6' || id_user == '7' || id_user == '8' || id_user == '9' || id_user == '0') {
        idplayer[(cont++)] = id_user;
        display.print(id_user);
        display.display();
        id_user = 'b';
    }        
  }while(id_user!='#');
  return;
}

void menu() {
  display.clearDisplay();
  display.setTextSize(1);
  display.clearDisplay();
  display.setTextColor(BLACK, WHITE);
  display.setCursor(10, 0);
  display.print("MENU JOGOS:");
  display.setCursor(0, 15);
  display.print(">Jogo A");
  display.setCursor(0, 25);
  display.print(">Jogo B");
  display.setCursor(0, 35);
  display.print(">Jogo C");
  display.drawFastHLine(0, 10, 83, BLACK);
  display.setCursor(0, 15);
  display.display();
}

void setup()
{
  Serial.begin(9600);
  display.begin();
  digitalWrite(1, LOW);
  Serial3.begin(115200);
  // Conecta a rede wireless
  int val=1;
  do {
    sendData("AT+RST\r\n", 2000, DEBUG);
    display.clearDisplay();
    display.setCursor(0, 0);
    display.print("Conectando");
    display.display();
    sendData("AT+CWJAP=\"IC_ACADEMICO\",\"\"\r\n", 2000, DEBUG);
    display.print(".");
    display.display();
    delay(3000);
    sendData("AT+CWMODE=1\r\n", 1000, DEBUG);
    display.print(".");
    display.display();
    sendData("AT+CIPMUX=1\r\n", 1000, DEBUG);
    display.print(".");
    display.display();
    Serial3.println("AT+CIPSTATUS\r");
    display.print(".");
    display.display();
    val = getResponse();
  }while(val!=1);
  idUsuario();
  display.clearDisplay();
  display.setCursor(0, 0);
  display.print("APERTE #");
  display.display();
}

void loop()
{
  // Criar função para ler o ID
  char apertatecla = teclado.getKey(); // verifica se alguma tecla foi pressionada
  if (apertatecla == '#') {
    menu();
    display.setTextSize(5);
    display.setTextColor(BLACK);
    display.setCursor(0, 0);
    jogo1 = 0;
    jogo2 = 0;
    jogo3 = 0;
    display.display();
  }
  if (apertatecla == 'A' && jogo2 == 0 && jogo3 == 0) {
    jogo1 = 1;
    game1();
    display.display();
    jogo1 = 0;
  }
  else if (apertatecla == 'B' && jogo1 == 0 && jogo3 == 0) {
    jogo2 = 1;
    display.setTextColor(BLACK, WHITE);
    game2();
    jogo2 = 0;
  }
  else if (apertatecla == 'C' && jogo2 == 0 && jogo1 == 0) {
    jogo3 = 1;
    game3();
    display.display();
    jogo3 = 0;

  }
  display.clearDisplay();
}
