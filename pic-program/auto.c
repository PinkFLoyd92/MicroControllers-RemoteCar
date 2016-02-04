/* #include <xc.h> */

//=============================================================================
//      Configuration Bits
//=============================================================================
/*#pragma config FOSC = HS        // HS oscillator
  #pragma config FCMEN = OFF      // Fail-Safe Clock Monitor disabled
  #pragma config IESO = OFF       // Oscillator Switchover mode disabled
  #pragma config PWRTE = OFF      // PWRT disabled
  #pragma config BOREN = OFF      // Brown-out Reset disabled in hardware and software
  #pragma config WDTE = OFF       // WDT disabled (control is placed on the SWDTEN bit)
  #pragma config MCLRE = ON       // MCLR pin enabled; RE3 input pin disabled
  #pragma config LVP = OFF        // Single-Supply ICSP disabled*/

/* =========================================================================== */
/*     Configuracion de bits para echo y trig usados en ADC */
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


/* -----------------------LCD TEXTO--------------*/
char txtDefault[] = "Esperando Seleccion A-M";
char txtArriba[] = "Arriba";
char txtIzquierda[] = "Izquierda";
char txtDerecha[] = "Derecha";
char txtAbajo[] = "Abajo";
char txtAutomatic[] = "Automatico";


/* ----------------------ADC--------------------- */
unsigned int distance_cm = 0, distance_inc = 0, TMR = 0;

/*-----------------------UART-------------------- */
char uart_rd;                   /* char leido enviado desde aplicacion Android */
char uart_rd_temp;
int bandera_mover = 1;          /* Por defecto, se puede mover, si sensor detecta tropiezo,
                                   no mueve */
int bandera_automatico = 1;
/* HABILITACION INTERRUPCION */
int contadorInterrupt = 0;

void setupTimer1(){
/* Configurando timer 1 a preescalador 1:4 GIE, PORTB6 interrupcion */
// TImer1 Contador 1x4x preescalador
T1CON = 0b00100000;
INTCON.GIE = 1;
INTCON.PEIE = 1;
INTCON.RBIE = 1;
INTCON.RBIF = 0;

// Interrupcion en cambio de estado de PORTB6
IOCB.IOCB6 = 1;
}
void waitSignal(){
TMR1H = 0;          // Clear Timer1
TMR1L = 0;
if(Echo == 0){
Trig = 0;
Delay_us(2);
Trig = 1;
Delay_us(10); // Send LOW-to-HIGH Pulse of 10us to Ultrasonic
Trig = 0;
}
}



/* Avanzar vehiculo */
void avanzarVehiculo(){
RC1_bit = 1;
RC2_bit = 1;
RC7_bit = 0;
RC6_bit = 0;
}
/* Logica para detener el vehiculo. */
void pararVehiculo(){
RC1_bit = 0;
RC2_bit = 0;
RC7_bit = 0;
RC6_bit = 0;
}

/* 2 Motores: motor derecha es ccp2, motor izquierda es ccp1
   giroderecha: detener motor derecha, mover izquierdo*/
void girarDerecha(){
RC1_bit = 1;
RC2_bit = 0;
RC5_bit = 0;
RC4_bit = 0;
Delay_ms(2000);               /* 2 segundos de giro */
/* Se para el carro con la posicion ya girada. */
RC1_bit = 0;
RC2_bit = 0;
RC7_bit = 0;
RC6_bit = 0;
}
/*   giroizquierda: mover motor derecha, detener izquierdo*/
void girarIzquierda(){
RC1_bit = 0;
RC2_bit = 1;
RC5_bit = 0;
RC4_bit = 0;
Delay_ms(2000);               /* 2 segundos de giro */
/* Se para el carro con la posicion ya girada. */
RC1_bit = 0;
RC2_bit = 0;
RC7_bit = 0;
RC6_bit = 0;
}

/*   giroizquierda: mover motor derecha, detener izquierdo*/
void moverAtras(){
RC1_bit = 0;
RC2_bit = 0;
RC5_bit = 1;
RC4_bit = 1;
}
/* Funcion usada en modo automatico para esquivar obstaculo */
void darVuelta(){
girarDerecha();
avanzarVehiculo();
Delay_ms(1000);
girarIzquierda();
avanzarVehiculo();
}
void cargarDato(){
if (UART1_Data_Ready())     // If data is received,
  uart_rd_temp = UART1_Read();     // leer el dato recibido del celular

}
void moverManual(){
uart_rd_temp = ' ';
cargarDato();
bandera_automatico = 0;       /* Se limpia la bandera de automatico por si acaso. */
while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */

waitSignal();
cargarDato();
if (uart_rd_temp == 'u' && bandera_mover) { /* Up: En la interrupción para el auto */
Lcd_Out(2,6,txtArriba);
avanzarVehiculo();
}
 else if (uart_rd_temp == 'd' && bandera_mover) { /* Down:  */
Lcd_Out(2,6,txtAbajo);
moverAtras();
}
 else if (uart_rd_temp == 'l' && bandera_mover) { /* left:  */
Lcd_Out(2,6,txtAbajo);
girarIzquierda();
avanzarVehiculo();
}
 else if (uart_rd_temp == 'r' && bandera_mover) { /* right:  */
Lcd_Out(2,6,txtAbajo);
girarDerecha();
avanzarVehiculo();
}

}
pararVehiculo();
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(2,6,"Se salió de modo manual.");
Delay_ms(100);
uart_rd_temp = ' ';


}

void moverEnAutomatico(){
uart_rd_temp = ' ';
bandera_automatico = 1;       /* Con esta bandera se valida en la interrupcion que hacer cuando ocurre un choque. */
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(2,6,txtAutomatic);
/* Inicio de movimiento en automatico hacia adelante. */
 RC1_bit = 1;
 RC2_bit = 1;
 RC5_bit = 0;
 RC4_bit = 0;
 cargarDato();
 while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo automatico. */
   waitSignal();
   cargarDato();

   /* Al salir de modo automatico paramos los motores.*/
   if(uart_rd_temp == 'e')
     {
       RC1_bit = 0;
       RC2_bit = 0;
       RC5_bit = 0;
       RC4_bit = 0;
     }

 }
 pararVehiculo();
 bandera_automatico = 0;       /* al enviar e se sale de modo automatico.*/
}

/* Interrupciones: TIMER1 */
void interrupt(){
  unsigned long duration = 0;
  // If the interrupt was generated by timer0 overflow
  /* Con 8MHz: 4/(8*10^6)*256*256*3 = 0.09 segundos ingreso a interrupcion */
  if(INTCON.RBIF){
    T1CON.TMR1ON = 1;       // ON Counter
    while(Echo == 1);
    T1CON.TMR1ON = 0;
    TMR = (unsigned int) TMR1H << 8;
    TMR = TMR + TMR1L;          // Combine 2x counter byte into single integer

    duration = (TMR/10) * 8;  // Duration Formula = TMR * 0.2us(Clock speed) * 4 (Timer Prescale)

    distance_cm = duration / 58 ;   // Refer HC-SR04 Datasheet
    distance_inc = duration / 148;
    if(distance_cm < 30)
      {
        if (!bandera_mover && bandera_automatico) {/* Si hay obstaculo y esta en Automatico*/
          darVuelta();
        }else if(!bandera_mover && !bandera_automatico){
          pararVehiculo();
          bandera_mover = 0;
        }
      }else {
      bandera_mover = 1;
      avanzarVehiculo();
    }
      distance_cm = 0, distance_inc = 0, TMR = 0;

    INTCON.RBIF = 0;        // Clear PortB Interrupt Flag
  }

  contadorInterrupt++;                /* contando 20 entradas a la interrupcion */
  return;
}
void main() {

  TRISA = 0b00000000; // set PORTA -> salidas
  TRISB = 0b01000000; // set PORTB -> salida menos el pin 6.
  ANSEL  = 0;              // Configure AN2 pin as analog
  ANSELH = 0;
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;
  INTCON = 0b10100000; // INTERRUPCION POR TIMER0 Y GIE ACTIVADOS.
  /* INTCON.T0IE = 1;                 /\* Activado interrupcion por timer0 *\/ */
  OPTION_REG = 0b10000111; //  TMR0 temporizado:  RBPU, TOCS= INTERNAL INSTRUCTION CLOCK= 0 PSA =0   1:256
  TRISC = 0b10000000;                          // PUERTOC COMO SALIDA exepto pin 7
  PORTC = 0;                          // LIMPIAR PUERTOC
  setupTimer1();
  Delay_us(10);                 /* wait for acquisition time*/
  Lcd_Init();                        // Initialize LCD

  /* Programa principal */
  Lcd_Out(2,0,txtDefault);                 // Write text in second row
  UART1_Init(9600);                         // initialize UART1 module
  Delay_ms(100);                  // Wait for UART module to stabilize
  moverEnAutomatico();
  while (1) {
    waitSignal();
    if (UART1_Data_Ready()) {     // If data is received,
      uart_rd = UART1_Read();     // leer el dato recibido del celular
      waitSignal();
      switch (uart_rd) {
      case 'A': {               /* Modo automático */
        Lcd_Out(2,6,txtAutomatic);
        moverEnAutomatico();
        break;
      }
      case 'M': {
        moverManual();
        break;
      }
      default:
        break;
      }
    }
  }
}
