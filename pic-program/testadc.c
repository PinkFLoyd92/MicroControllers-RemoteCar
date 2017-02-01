#define Trig    PORTA.RA0
#define Echo    PORTB.RB6

// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

unsigned int distance_cm = 0, distance_inc = 0, TMR = 0;
int a = 0;
char txt[7];

void setupTimer1(){
  /* Configurando timer 1 a preescalador 1:4 GIE, PORTB6 interrupcion */
  // TImer1 Contador 1x4x preescalador
  T1CON = 0b00000100; // 0b00001010 --> bit 1 internal clock en 0, bit
  TMR1H = 0;                  //Sets the Initial Value of Timer
  TMR1L = 0;                  //Sets the Initial Value of Timer
  // Interrupcion en cambio de estado de PORTB6
  /* IOCB.IOCB6 = 1; */
}
void measureDistance(){
  TMR1H = 0;                  //Sets the Initial Value of Timer
  TMR1L = 0;                  //Sets the Initial Value of Timer

  Trig = 1;               //TRIGGER HIGH
  Delay_us(10);               //10uS Delay
  Trig = 0;               //TRIGGER LOW

  while(!Echo);           //Waiting for Echo
  T1CON.F0 = 1;               //Timer Starts
  while(Echo);            //Waiting for Echo goes LOW
  T1CON.F0 = 0;               //Timer Stops

  a = (TMR1L | (TMR1H<<8));   //Reads Timer Value
  a = a/58.82;                //Converts Time to Distance
  a = a + 1;                  //Distance Calibration
}


void printDistance(){
Lcd_Cmd(_LCD_CLEAR);
  IntToStr(a,txt);
  Ltrim(txt);
  Lcd_Out(1,12,txt);
  Lcd_Out(1,15,"cm");
}
void main() {

  TRISA = 0b00000000; // set PORTA -> salidas
  TRISB = 0b01000000; // set PORTB -> salida menos el pin 6.
  /* TRISB.f6 = 1; */
  ANSEL  = 0;              // Configure AN2 pin as analog
  ANSELH = 0;
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;
  TRISC = 0b10000000;                          // PUERTOC COMO SALIDA exepto pin 7
  /* TRISC.f7 = 1; */
  PORTC = 0;                          // LIMPIAR PUERTOC
  setupTimer1();
  Delay_us(10);                 /* wait for acquisition time*/
  Lcd_Init();                        // Initialize LCD

  /* Programa principal */
  Lcd_Out(2,0,"inicio");                 // Write text in second row
  printDistance();
  UART1_Init(19200);                         // initialize UART1 module
  Delay_ms(100);                  // Wait for UART module to stabilize
  /* moverEnAutomatico(); */
  while (1) {
    measureDistance();
    printDistance();
    }
  }