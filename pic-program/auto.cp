#line 1 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
#line 21 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
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




char txtDefault[] = "Esperando Seleccion";
char txtArriba[] = "Arriba";
char txtIzquierda[] = "Izquierda";
char txtDerecha[] = "Derecha";
char txtAbajo[] = "Abajo";
char txtAutomatic[] = "Automatico";



unsigned int distance_cm = 0, distance_inc = 0, TMR = 0;


char uart_rd;
char uart_rd_temp;
#line 53 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
int bandera_mover = 1;
int bandera_automatico = 1;



void setupTimer1(){


 T1CON = 0b00100000;
 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 INTCON.RBIE = 1;
 INTCON.RBIF = 0;


 IOCB.IOCB6 = 1;
}
void waitSignal(){
 TMR1H = 0;
 TMR1L = 0;
 if( PORTB.RB6  == 0){
  PORTA.RA0  = 0;
 Delay_us(2);
  PORTA.RA0  = 1;
 Delay_us(10);
  PORTA.RA0  = 0;
 }
}




void avanzarVehiculo(){
 RC1_bit = 1;
 RC2_bit = 1;
 RC7_bit = 0;
 RC6_bit = 0;
}

void pararVehiculo(){
 RC1_bit = 0;
 RC2_bit = 0;
 RC7_bit = 0;
 RC6_bit = 0;
}
#line 101 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
void girarDerecha(){
 RC1_bit = 1;
 RC2_bit = 0;
 RC5_bit = 0;
 RC4_bit = 0;
 Delay_ms(2000);

 RC1_bit = 0;
 RC2_bit = 0;
 RC7_bit = 0;
 RC6_bit = 0;
}

void girarIzquierda(){
 RC1_bit = 0;
 RC2_bit = 1;
 RC5_bit = 0;
 RC4_bit = 0;
 Delay_ms(2000);

 RC1_bit = 0;
 RC2_bit = 0;
 RC7_bit = 0;
 RC6_bit = 0;
}


void moverAtras(){
 RC1_bit = 0;
 RC2_bit = 0;
 RC5_bit = 1;
 RC4_bit = 1;
}

void darVuelta(){
 girarDerecha();
 avanzarVehiculo();
 Delay_ms(1000);
 girarIzquierda();
 avanzarVehiculo();
}
void cargarDato(){
 if (UART1_Data_Ready())
 uart_rd_temp = UART1_Read();

}
void moverManual(){
 uart_rd_temp = ' ';
 cargarDato();
 bandera_automatico = 0;
 while (uart_rd_temp != 'e') {

 waitSignal();
 cargarDato();
 if (uart_rd_temp == 'u' && bandera_mover) {
 Lcd_Out(2,6,txtArriba);
 avanzarVehiculo();
 }
 else if (uart_rd_temp == 'd' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 moverAtras();
 }
 else if (uart_rd_temp == 'l' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 girarIzquierda();
 avanzarVehiculo();
 }
 else if (uart_rd_temp == 'r' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 girarDerecha();
 avanzarVehiculo();
 }

 }
 pararVehiculo();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,6,"Se salio de modo manual...");
 Delay_ms(1000);
 uart_rd_temp = ' ';


}

void moverEnAutomatico(){
 uart_rd_temp = ' ';
 bandera_automatico = 1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,6,txtAutomatic);

 RC1_bit = 1;
 RC2_bit = 1;
 RC5_bit = 0;
 RC4_bit = 0;
 cargarDato();
 while (uart_rd_temp != 'e') {
 waitSignal();
 cargarDato();


 if(uart_rd_temp == 'e')
 {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,6,"Se paro el vehiculo");
 RC1_bit = 0;
 RC2_bit = 0;
 RC5_bit = 0;
 RC4_bit = 0;
 }

 }
 pararVehiculo();
 bandera_automatico = 0;
}


void interrupt(){
 unsigned long duration = 0;


 if(INTCON.RBIF){
 T1CON.TMR1ON = 1;
 while( PORTB.RB6  == 1);
 T1CON.TMR1ON = 0;
 TMR = (unsigned int) TMR1H << 8;
 TMR = TMR + TMR1L;

 duration = (TMR/10) * 8;

 distance_cm = duration / 58 ;
 distance_inc = duration / 148;
 if(distance_cm < 30)
 {
 if (bandera_mover && bandera_automatico) {
 darVuelta();
 }else if(bandera_mover && !bandera_automatico){
 pararVehiculo();
 bandera_mover = 0;
 }
 }else {
 bandera_mover = 1;
 avanzarVehiculo();
 }
 distance_cm = 0, distance_inc = 0, TMR = 0;

 INTCON.RBIF = 0;
 }


 return;
}
void main() {

 TRISA = 0b00000000;
 TRISB = 0b01000000;
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;
 INTCON = 0b10000000;

 OPTION_REG = 0b10000111;
 TRISC = 0b10000000;
 PORTC = 0;
 setupTimer1();
 Delay_us(10);
 Lcd_Init();


 Lcd_Out(2,0,txtDefault);
 UART1_Init(9600);
 Delay_ms(100);

 while (1) {

 if (UART1_Data_Ready()) {
 uart_rd = UART1_Read();
 waitSignal();
 switch (uart_rd) {
 case 'A': {
 Lcd_Out(2,6,txtAutomatic);
 moverEnAutomatico();
 uart_rd = ' ';
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,0,txtDefault);
 break;
 }
 case 'M': {
 moverManual();
 uart_rd = ' ';
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,0,txtDefault);
 break;
 }
 default:
 break;
 }
 }
 }
}
