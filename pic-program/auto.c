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

/* -----------------------LCD TEXTO-------------- */
char txtDefault[] = "Esperando Seleccion de Modo (Automático/Manual)...";
char txtArriba[] = "Arriba...";
char txtIzquierda[] = "Izquierda...";
char txtDerecha[] = "Derecha...";
char txtAbajo[] = "Abajo...";
char txtAutomatic[] = "Automatico";

/*-----------------------UART-------------------- */
char uart_rd;                   /* char leido enviado desde aplicacion Android */
char uart_rd_temp = '';
int bandera_mover = 1;          /* Por defecto, se puede mover, si sensor detecta tropiezo,                                     no mueve */
void moverManual(){
  while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
    if (usart_rd_temp == 'u') { /* Up: En la interrupción para el auto */
      Lcd_Out(2,6,txtArriba);
    }
    else if (usart_rd_temp == 'd') { /* Down:  */
      Lcd_Out(2,6,txtAbajo);
    }
    else if (usart_rd_temp == 'l') { /* left:  */
      Lcd_Out(2,6,txtAbajo);
    }
    else if (usart_rd_temp == 'r') { /* right:  */
      Lcd_Out(2,6,txtAbajo);
    }
  }
}
void moverEnAutomatico(){
  while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
      Lcd_Out(2,6,txtAutomatic);    
  }

}
/* Interrupciones: ADC */
void interrupt(){

}
void main() {
  ANSEL  = 0;                        // Configure AN pins as digital I/O
  ANSELH = 0;
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;

  UART1_Init(9600);                         // initialize UART1 module
  Delay_ms(100);                  // Wait for UART module to stabilize

  Lcd_Init();                        // Initialize LCD
  /* Programa principal */
  Lcd_Out(2,6,txtDefault);                 // Write text in second row
  while (1) {
    if (UART1_Data_Ready()) {     // If data is received,
      uart_rd = UART1_Read();     // read the received data
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
