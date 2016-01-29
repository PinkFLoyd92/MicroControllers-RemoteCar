
_darVuelta:

;auto.c,37 :: 		void darVuelta(){
;auto.c,39 :: 		}
	RETURN
; end of _darVuelta

_moverManual:

;auto.c,40 :: 		void moverManual(){
;auto.c,41 :: 		while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
L_moverManual0:
	MOVF       _uart_rd_temp+0, 0
	XORLW      101
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual1
;auto.c,42 :: 		if (uart_rd_temp == 'u' && bandera_mover) { /* Up: En la interrupción para el auto */
	MOVF       _uart_rd_temp+0, 0
	XORLW      117
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual4
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual4
L__moverManual33:
;auto.c,43 :: 		Lcd_Out(2,6,txtArriba);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtArriba+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,44 :: 		}
	GOTO       L_moverManual5
L_moverManual4:
;auto.c,45 :: 		else if (uart_rd_temp == 'd' && bandera_mover) { /* Down:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual8
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual8
L__moverManual32:
;auto.c,46 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,47 :: 		}
	GOTO       L_moverManual9
L_moverManual8:
;auto.c,48 :: 		else if (uart_rd_temp == 'l' && bandera_mover) { /* left:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      108
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual12
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual12
L__moverManual31:
;auto.c,49 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,50 :: 		}
	GOTO       L_moverManual13
L_moverManual12:
;auto.c,51 :: 		else if (uart_rd_temp == 'r' && bandera_mover) { /* right:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual16
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual16
L__moverManual30:
;auto.c,52 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,53 :: 		}
L_moverManual16:
L_moverManual13:
L_moverManual9:
L_moverManual5:
;auto.c,54 :: 		}
	GOTO       L_moverManual0
L_moverManual1:
;auto.c,55 :: 		}
	RETURN
; end of _moverManual

_pararVehiculo:

;auto.c,57 :: 		void pararVehiculo(){
;auto.c,58 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,59 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,60 :: 		RC7_bit = 0;
	BCF        RC7_bit+0, 7
;auto.c,61 :: 		RC6_bit = 0;
	BCF        RC6_bit+0, 6
;auto.c,62 :: 		}
	RETURN
; end of _pararVehiculo

_girarDerecha:

;auto.c,66 :: 		void girarDerecha(){
;auto.c,67 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;auto.c,68 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,69 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,70 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,71 :: 		}
	RETURN
; end of _girarDerecha

_girarIzquierda:

;auto.c,73 :: 		void girarIzquierda(){
;auto.c,74 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,75 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;auto.c,76 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,77 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,78 :: 		}
	RETURN
; end of _girarIzquierda

_moverAtras:

;auto.c,81 :: 		void moverAtras(){
;auto.c,82 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,83 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,84 :: 		RC5_bit = 1;
	BSF        RC5_bit+0, 5
;auto.c,85 :: 		RC4_bit = 1;
	BSF        RC4_bit+0, 4
;auto.c,86 :: 		}
	RETURN
; end of _moverAtras

_moverEnAutomatico:

;auto.c,87 :: 		void moverEnAutomatico(){
;auto.c,88 :: 		while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
L_moverEnAutomatico17:
	MOVF       _uart_rd_temp+0, 0
	XORLW      101
	BTFSC      STATUS+0, 2
	GOTO       L_moverEnAutomatico18
;auto.c,89 :: 		Lcd_Out(2,6,txtAutomatic);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAutomatic+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,91 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;auto.c,92 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;auto.c,93 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,94 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,97 :: 		}
	GOTO       L_moverEnAutomatico17
L_moverEnAutomatico18:
;auto.c,99 :: 		}
	RETURN
; end of _moverEnAutomatico

_checkADC:

;auto.c,101 :: 		si está cerca de choque, se cambia bandera a 0*/
;auto.c,102 :: 		bandera_mover = 0;
	CLRF       _bandera_mover+0
	CLRF       _bandera_mover+1
;auto.c,103 :: 		return -1;
	MOVLW      255
	MOVWF      R0+0
	MOVLW      255
	MOVWF      R0+1
;auto.c,104 :: 		}
	RETURN
; end of _checkADC

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;auto.c,106 :: 		void interrupt(){
;auto.c,116 :: 		if (PIR1 & 0x01)
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt19
;auto.c,119 :: 		PIR1 &= ~0x01; // Clear flag
	BCF        PIR1+0, 0
;auto.c,120 :: 		T1CON &= ~0x01; // Disable counter to avoid errors
	BCF        T1CON+0, 0
;auto.c,123 :: 		temp_res_forward = ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_res_forward+0
	MOVF       R0+1, 0
	MOVWF      _temp_res_forward+1
;auto.c,124 :: 		temp_res_backward = ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_res_backward+0
	MOVF       R0+1, 0
	MOVWF      _temp_res_backward+1
;auto.c,127 :: 		TMR1L = 0x24;
	MOVLW      36
	MOVWF      TMR1L+0
;auto.c,128 :: 		TMR1H = 0xCF;
	MOVLW      207
	MOVWF      TMR1H+0
;auto.c,129 :: 		T1CON |= 0x01; // Enable counter
	BSF        T1CON+0, 0
;auto.c,130 :: 		return;
	GOTO       L__interrupt34
;auto.c,131 :: 		}
L_interrupt19:
;auto.c,132 :: 		}
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;auto.c,133 :: 		void main() {
;auto.c,134 :: 		ANSEL  = 0b00001100;              // Configure AN2/AN3 pin as analog
	MOVLW      12
	MOVWF      ANSEL+0
;auto.c,135 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;auto.c,136 :: 		C1ON_bit = 0;                      // Disable comparators
	BCF        C1ON_bit+0, 7
;auto.c,137 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;auto.c,138 :: 		INTCON = 0x80; // This will set GIE (Global interrupts)
	MOVLW      128
	MOVWF      INTCON+0
;auto.c,139 :: 		T1CON = 0x00; // Timer1 Stopped and preescale 1:1
	CLRF       T1CON+0
;auto.c,140 :: 		TMR1L = 0x24;
	MOVLW      36
	MOVWF      TMR1L+0
;auto.c,141 :: 		TMR1H = 0xCF;
	MOVLW      207
	MOVWF      TMR1H+0
;auto.c,142 :: 		T1CON |= 0x01; // Enable counter
	BSF        T1CON+0, 0
;auto.c,143 :: 		PIE1 = 0x01; // Enable Timer1 interrupt
	MOVLW      1
	MOVWF      PIE1+0
;auto.c,144 :: 		TRISC = 0;                          // designate PORTC pins as output
	CLRF       TRISC+0
;auto.c,145 :: 		PORTC = 0;                          // set PORTC to 0
	CLRF       PORTC+0
;auto.c,146 :: 		PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;auto.c,147 :: 		PWM2_Init(5000);                    // Initialize PWM2 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;auto.c,148 :: 		PWM1_Start();                       // start PWM1
	CALL       _PWM1_Start+0
;auto.c,149 :: 		PWM2_Start();                       // start PWM2
	CALL       _PWM2_Start+0
;auto.c,150 :: 		PWM1_Set_Duty(16);        // Set current duty for PWM1
	MOVLW      16
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;auto.c,151 :: 		PWM2_Set_Duty(16);       // Set current duty for PWM2
	MOVLW      16
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;auto.c,153 :: 		Delay_us(10);                 /* wait for acquisition time*/
	MOVLW      6
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	NOP
;auto.c,154 :: 		UART1_Init(9600);                         // initialize UART1 module
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;auto.c,155 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
;auto.c,157 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;auto.c,159 :: 		Lcd_Out(2,6,txtDefault);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtDefault+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,160 :: 		while (1) {
L_main22:
;auto.c,161 :: 		Lcd_Out(2,6,txtDefault);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtDefault+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,162 :: 		if (UART1_Data_Ready()) {     // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;auto.c,164 :: 		uart_rd = 'A';
	MOVLW      65
	MOVWF      _uart_rd+0
;auto.c,165 :: 		switch (uart_rd) {
	GOTO       L_main25
;auto.c,166 :: 		case 'A': {               /* Modo automático */
L_main27:
;auto.c,167 :: 		Lcd_Out(2,6,txtAutomatic);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAutomatic+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,168 :: 		moverEnAutomatico();
	CALL       _moverEnAutomatico+0
;auto.c,169 :: 		break;
	GOTO       L_main26
;auto.c,171 :: 		case 'M': {
L_main28:
;auto.c,172 :: 		moverManual();
	CALL       _moverManual+0
;auto.c,173 :: 		break;
	GOTO       L_main26
;auto.c,175 :: 		default:
L_main29:
;auto.c,176 :: 		break;
	GOTO       L_main26
;auto.c,177 :: 		}
L_main25:
	MOVF       _uart_rd+0, 0
	XORLW      65
	BTFSC      STATUS+0, 2
	GOTO       L_main27
	MOVF       _uart_rd+0, 0
	XORLW      77
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	GOTO       L_main29
L_main26:
;auto.c,178 :: 		}
L_main24:
;auto.c,179 :: 		}
	GOTO       L_main22
;auto.c,180 :: 		}
	GOTO       $+0
; end of _main
