#line 1 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"

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



char txtDefault[] = "Esperando Seleccion de Modo (Automático/Manual)...";
char txtArriba[] = "Arriba...";
char txtIzquierda[] = "Izquierda...";
char txtDerecha[] = "Derecha...";
char txtAbajo[] = "Abajo...";
char txtAutomatic[] = "Automatico";


unsigned int temp_res_forward;
unsigned int temp_res_backward;


char uart_rd;
char uart_rd_temp;
#line 33 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
int bandera_mover = 1;



void darVuelta(){

}
void moverManual(){
 while (uart_rd_temp != 'e') {
 if (uart_rd_temp == 'u' && bandera_mover) {
 Lcd_Out(2,6,txtArriba);
 }
 else if (uart_rd_temp == 'd' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 }
 else if (uart_rd_temp == 'l' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 }
 else if (uart_rd_temp == 'r' && bandera_mover) {
 Lcd_Out(2,6,txtAbajo);
 }
 }
}

void pararVehiculo(){
 RC1_bit = 0;
 RC2_bit = 0;
 RC7_bit = 0;
 RC6_bit = 0;
}
#line 66 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
void girarDerecha(){
 RC1_bit = 1;
 RC2_bit = 0;
 RC5_bit = 0;
 RC4_bit = 0;
}

void girarIzquierda(){
 RC1_bit = 0;
 RC2_bit = 1;
 RC5_bit = 0;
 RC4_bit = 0;
}


void moverAtras(){
 RC1_bit = 0;
 RC2_bit = 0;
 RC5_bit = 1;
 RC4_bit = 1;
}
void moverEnAutomatico(){
 while (uart_rd_temp != 'e') {
 Lcd_Out(2,6,txtAutomatic);

 RC1_bit = 1;
 RC2_bit = 1;
 RC5_bit = 0;
 RC4_bit = 0;


 }

}
#line 101 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
int checkADC(valor){
 bandera_mover = 0;
 return -1;
}

void interrupt(){
#line 116 "Z:/home/sebas/Documents/ESPOL/Laboratorio de Microcontroladores/proyecto2doparcial/pic-program/auto.c"
 if (PIR1 & 0x01)
 {

 PIR1 &= ~0x01;
 T1CON &= ~0x01;


 temp_res_forward = ADC_Read(2);
 temp_res_backward = ADC_Read(3);


 TMR1L = 0x24;
 TMR1H = 0xCF;
 T1CON |= 0x01;
 return;
 }
}
void main() {
 ANSEL = 0b00001100;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;
 INTCON = 0x80;
 T1CON = 0x00;
 TMR1L = 0x24;
 TMR1H = 0xCF;
 T1CON |= 0x01;
 PIE1 = 0x01;
 TRISC = 0;
 PORTC = 0;
 PWM1_Init(5000);
 PWM2_Init(5000);
 PWM1_Start();
 PWM2_Start();
 PWM1_Set_Duty(16);
 PWM2_Set_Duty(16);

 Delay_us(10);
 UART1_Init(9600);
 Delay_ms(100);

 Lcd_Init();

 Lcd_Out(2,6,txtDefault);
 while (1) {
 Lcd_Out(2,6,txtDefault);
 if (UART1_Data_Ready()) {

 uart_rd = 'A';
 switch (uart_rd) {
 case 'A': {
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
