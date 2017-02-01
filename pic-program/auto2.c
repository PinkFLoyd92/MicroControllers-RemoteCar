#define Trig    PORTA.RA0
#define Echo    PORTB.RB6
#define Led 	PORTC.RC4


/* ----------------------ADC--------------------- */
unsigned int distance_cm = 0, distance_inc = 0, TMR = 0;
int a = 0;
char txt[7];

/*-----------------------UART-------------------- */
char uart_rd;                   /* char leido enviado desde aplicacion Android */
char uart_rd_temp;
int bandera_mover = 1;          /* Por defecto, se puede mover, si sensor detecta tropiezo,
                                   no mueve */
int bandera_automatico = 1;
/* HABILITACION INTERRUPCION */
//int contadorInterrupt = 0;

void setupTimer1(){
  /* Configurando timer 1 a preescalador 1:4 GIE, PORTB6 interrupcion */
  // TImer1 Contador 1x4x preescalador
  T1CON = 0b11000000; // 0b00001010 --> bit 1 internal clock en 0, bit
  TMR1H = 0;                  //Sets the Initial Value of Timer
  TMR1L = 0;                  //Sets the Initial Value of Timer
  // Interrupcion en cambio de estado de PORTB6
  /* IOCB.IOCB6 = 1; */
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
  RC0_bit = 0;
  RC1_bit = 1;
  RC2_bit = 0;
  RC3_bit = 1;
}
/* Logica para detener el vehiculo. */
void pararVehiculo(){
  RC0_bit = 0;
  RC1_bit = 0;
  RC2_bit = 0;
  RC3_bit = 0;
}

/* 2 Motores: motor derecha es ccp2, motor izquierda es ccp1
   giroderecha: detener motor derecha, mover izquierdo*/
void girarDerecha(){
  RC0_bit = 0;
  RC1_bit = 0;
  RC2_bit = 0;
  RC3_bit = 1;
  Delay_ms(2000);               /* 2 segundos de giro */
  /* Se para el carro con la posicion ya girada. */
  RC0_bit = 0;
  RC1_bit = 0;
  RC2_bit = 0;
  RC3_bit = 0;
}
/*   giroizquierda: mover motor derecha, detener izquierdo*/
void girarIzquierda(){
  RC0_bit = 0;
  RC1_bit = 1;
  RC2_bit = 0;
  RC3_bit = 0;
  Delay_ms(2000);               /* 2 segundos de giro */
  /* Se para el carro con la posicion ya girada. */
  RC0_bit = 0;
  RC1_bit = 0;
  RC2_bit = 0;
  RC3_bit = 0;
}

/*   giroizquierda: mover motor derecha, detener izquierdo*/
void moverAtras(){
  RC0_bit = 1;
  RC1_bit = 0;
  RC2_bit = 1;
  RC3_bit = 0;
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
void checkDistance(){
  /* char txt[7]; */
  TMR1H = 0;                  //Sets the Initial Value of Timer
  TMR1L = 0;                  //Sets the Initial Value of Timer

  Trig = 1;               //TRIGGER HIGH
  Delay_us(10);               //10uS Delay
  Trig = 0;               //TRIGGER LOW

  while(!Echo);           //Waiting for Echo
  T1CON.F0 = 1;               //Timer Starts
  while(Echo);            //Waiting for Echo goes LOW
  T1CON.F0 = 0;               //Timer Stops

  /* a = (TMR1L | (TMR1H<<8));   //Reads Timer Value */
  a = (256 * TMR1H) + TMR1L;
  a = a/58.82;                //Converts Time to Distance
  a = a + 1;                  //Distance Calibration
  if(a>10)          //Check whether the result is valid or not
    {
      if(bandera_mover && bandera_automatico) {/* Si hay obstaculo y esta en Automatico*/
        darVuelta();
      }else if(bandera_mover && !bandera_automatico){
        //pararVehiculo();
        bandera_mover = 0;
      }

    }else {
    bandera_mover = 1;
    avanzarVehiculo();
  }

}
void moverManual(){
  Led = 1;
  bandera_mover = 1;
  uart_rd_temp = ' ';
  cargarDato();
  bandera_automatico = 0;       /* Se limpia la bandera de automatico por si acaso. */
  while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
    checkDistance();
    cargarDato();                                   /* se verifica si se tiene que cambiar o no la variable uart_rd_temp */
    if (uart_rd_temp == 'u' && bandera_mover) { /* Up: En la interrupción para el auto */
      avanzarVehiculo();
    }
    else if (uart_rd_temp == 'd') { /* Down:  */
      moverAtras();
    }
    else if (uart_rd_temp == 'l') { /* left:  */
      girarIzquierda();
      avanzarVehiculo();
    }
    else if (uart_rd_temp == 'r') { /* right:  */
      girarDerecha();
      avanzarVehiculo();
    }

  }
  pararVehiculo();              /* como se manda e entonces, se detiene el movimiento del auto y se sale a esperar seleccion de otro modo. */
  Delay_ms(500);
  uart_rd_temp = ' ';

}

void moverEnAutomatico(){
  Led = 0;
  uart_rd_temp = ' ';
  bandera_automatico = 1;       /* Con esta bandera se valida en la interrupcion que hacer cuando ocurre un choque. */
  bandera_mover = 1;
  /* Inicio de movimiento en automatico hacia adelante. */
  avanzarVehiculo();
  cargarDato();
  while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo automatico. */
    checkDistance();
    /* waitSignal(); */
    cargarDato();

    /* Al salir de modo automatico paramos los motores.*/
    if(uart_rd_temp == 'e')
      {
        pararVehiculo();
      }

  }
  pararVehiculo();
  bandera_automatico = 0;       /* al enviar e se sale de modo automatico.*/
  uart_rd_temp = ' ';

}

void printDistance(){
  IntToStr(a,txt);
  Ltrim(txt);
}
void main() {

  ANSEL  = 0;              // Configure AN2 pin as analog
  ANSELH = 0;
  TRISA = 0; // set PORTA -> salidas
  TRISB = 0b01000000; // set PORTB -> salida menos el pin 6.
  /* TRISB.f6 = 1; */
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;
  TRISC = 0b10000000;                          // PUERTOC COMO SALIDA exepto pin 7
  /* TRISC.f7 = 1; */
  PORTC = 0;                          // LIMPIAR PUERTOC
  setupTimer1();
  Delay_us(10);                 /* wait for acquisition time*/

  /* Programa principal */
  measureDistance();
  printDistance();
  UART1_Init(19200);                         // initialize UART1 module
  Delay_ms(100);                  // Wait for UART module to stabilize
  /* moverEnAutomatico(); */
  while (1) {
    /* waitSignal(); */
    if (UART1_Data_Ready()) {     // If data is received,
      uart_rd = UART1_Read();     // leer el dato recibido del celular
      /* waitSignal(); */
      switch (uart_rd) {
      case 'A': {               /* Modo automático */
        moverEnAutomatico();
        uart_rd = ' ';          /* esperamos nuevo envío de modo. */
        measureDistance();
        break;
      }
      case 'M': {
        moverManual();
        uart_rd = ' ';  /* esperamos nuevo envío de modo. */
        measureDistance();
        break;
      }
      default:{
        uart_rd = ' ';
        break;
      }

      }
    }
  }
}



