
_setupTimer1:

;auto.c,58 :: 		void setupTimer1(){
;auto.c,61 :: 		T1CON = 0b00100000;
	MOVLW      32
	MOVWF      T1CON+0
;auto.c,62 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;auto.c,63 :: 		INTCON.PEIE = 1;
	BSF        INTCON+0, 6
;auto.c,64 :: 		INTCON.RBIE = 1;
	BSF        INTCON+0, 3
;auto.c,65 :: 		INTCON.RBIF = 0;
	BCF        INTCON+0, 0
;auto.c,68 :: 		IOCB.IOCB6 = 1;
	BSF        IOCB+0, 6
;auto.c,69 :: 		}
	RETURN
; end of _setupTimer1

_waitSignal:

;auto.c,70 :: 		void waitSignal(){
;auto.c,71 :: 		TMR1H = 0;          // Clear Timer1
	CLRF       TMR1H+0
;auto.c,72 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;auto.c,73 :: 		if(Echo == 0){
	BTFSC      PORTB+0, 6
	GOTO       L_waitSignal0
;auto.c,74 :: 		Trig = 0;
	BCF        PORTA+0, 0
;auto.c,75 :: 		Delay_us(2);
	NOP
	NOP
	NOP
	NOP
;auto.c,76 :: 		Trig = 1;
	BSF        PORTA+0, 0
;auto.c,77 :: 		Delay_us(10); // Send LOW-to-HIGH Pulse of 10us to Ultrasonic
	MOVLW      6
	MOVWF      R13+0
L_waitSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_waitSignal1
	NOP
;auto.c,78 :: 		Trig = 0;
	BCF        PORTA+0, 0
;auto.c,79 :: 		}
L_waitSignal0:
;auto.c,80 :: 		}
	RETURN
; end of _waitSignal

_avanzarVehiculo:

;auto.c,85 :: 		void avanzarVehiculo(){
;auto.c,86 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;auto.c,87 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;auto.c,88 :: 		RC7_bit = 0;
	BCF        RC7_bit+0, 7
;auto.c,89 :: 		RC6_bit = 0;
	BCF        RC6_bit+0, 6
;auto.c,90 :: 		}
	RETURN
; end of _avanzarVehiculo

_pararVehiculo:

;auto.c,92 :: 		void pararVehiculo(){
;auto.c,93 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,94 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,95 :: 		RC7_bit = 0;
	BCF        RC7_bit+0, 7
;auto.c,96 :: 		RC6_bit = 0;
	BCF        RC6_bit+0, 6
;auto.c,97 :: 		}
	RETURN
; end of _pararVehiculo

_girarDerecha:

;auto.c,101 :: 		void girarDerecha(){
;auto.c,102 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;auto.c,103 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,104 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,105 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,106 :: 		Delay_ms(2000);               /* 2 segundos de giro */
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_girarDerecha2:
	DECFSZ     R13+0, 1
	GOTO       L_girarDerecha2
	DECFSZ     R12+0, 1
	GOTO       L_girarDerecha2
	DECFSZ     R11+0, 1
	GOTO       L_girarDerecha2
	NOP
;auto.c,108 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,109 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,110 :: 		RC7_bit = 0;
	BCF        RC7_bit+0, 7
;auto.c,111 :: 		RC6_bit = 0;
	BCF        RC6_bit+0, 6
;auto.c,112 :: 		}
	RETURN
; end of _girarDerecha

_girarIzquierda:

;auto.c,114 :: 		void girarIzquierda(){
;auto.c,115 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,116 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;auto.c,117 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,118 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,119 :: 		Delay_ms(2000);               /* 2 segundos de giro */
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_girarIzquierda3:
	DECFSZ     R13+0, 1
	GOTO       L_girarIzquierda3
	DECFSZ     R12+0, 1
	GOTO       L_girarIzquierda3
	DECFSZ     R11+0, 1
	GOTO       L_girarIzquierda3
	NOP
;auto.c,121 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,122 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,123 :: 		RC7_bit = 0;
	BCF        RC7_bit+0, 7
;auto.c,124 :: 		RC6_bit = 0;
	BCF        RC6_bit+0, 6
;auto.c,125 :: 		}
	RETURN
; end of _girarIzquierda

_moverAtras:

;auto.c,128 :: 		void moverAtras(){
;auto.c,129 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,130 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,131 :: 		RC5_bit = 1;
	BSF        RC5_bit+0, 5
;auto.c,132 :: 		RC4_bit = 1;
	BSF        RC4_bit+0, 4
;auto.c,133 :: 		}
	RETURN
; end of _moverAtras

_darVuelta:

;auto.c,135 :: 		void darVuelta(){
;auto.c,136 :: 		girarDerecha();
	CALL       _girarDerecha+0
;auto.c,137 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,138 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_darVuelta4:
	DECFSZ     R13+0, 1
	GOTO       L_darVuelta4
	DECFSZ     R12+0, 1
	GOTO       L_darVuelta4
	DECFSZ     R11+0, 1
	GOTO       L_darVuelta4
	NOP
	NOP
;auto.c,139 :: 		girarIzquierda();
	CALL       _girarIzquierda+0
;auto.c,140 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,141 :: 		}
	RETURN
; end of _darVuelta

_cargarDato:

;auto.c,142 :: 		void cargarDato(){
;auto.c,143 :: 		if (UART1_Data_Ready())     // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_cargarDato5
;auto.c,144 :: 		uart_rd_temp = UART1_Read();     // leer el dato recibido del celular
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd_temp+0
L_cargarDato5:
;auto.c,146 :: 		}
	RETURN
; end of _cargarDato

_moverManual:

;auto.c,147 :: 		void moverManual(){
;auto.c,148 :: 		uart_rd_temp = ' ';
	MOVLW      32
	MOVWF      _uart_rd_temp+0
;auto.c,149 :: 		cargarDato();
	CALL       _cargarDato+0
;auto.c,150 :: 		bandera_automatico = 0;       /* Se limpia la bandera de automatico por si acaso. */
	CLRF       _bandera_automatico+0
	CLRF       _bandera_automatico+1
;auto.c,151 :: 		while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo manual */
L_moverManual6:
	MOVF       _uart_rd_temp+0, 0
	XORLW      101
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual7
;auto.c,153 :: 		waitSignal();
	CALL       _waitSignal+0
;auto.c,154 :: 		cargarDato();                                   /* se verifica si se tiene que cambiar o no la variable uart_rd_temp */
	CALL       _cargarDato+0
;auto.c,155 :: 		if (uart_rd_temp == 'u' && bandera_mover) { /* Up: En la interrupción para el auto */
	MOVF       _uart_rd_temp+0, 0
	XORLW      117
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual10
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual10
L__moverManual52:
;auto.c,156 :: 		Lcd_Out(2,6,txtArriba);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtArriba+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,157 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,158 :: 		}
	GOTO       L_moverManual11
L_moverManual10:
;auto.c,159 :: 		else if (uart_rd_temp == 'd' && bandera_mover) { /* Down:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual14
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual14
L__moverManual51:
;auto.c,160 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,161 :: 		moverAtras();
	CALL       _moverAtras+0
;auto.c,162 :: 		}
	GOTO       L_moverManual15
L_moverManual14:
;auto.c,163 :: 		else if (uart_rd_temp == 'l' && bandera_mover) { /* left:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      108
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual18
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual18
L__moverManual50:
;auto.c,164 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,165 :: 		girarIzquierda();
	CALL       _girarIzquierda+0
;auto.c,166 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,167 :: 		}
	GOTO       L_moverManual19
L_moverManual18:
;auto.c,168 :: 		else if (uart_rd_temp == 'r' && bandera_mover) { /* right:  */
	MOVF       _uart_rd_temp+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_moverManual22
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_moverManual22
L__moverManual49:
;auto.c,169 :: 		Lcd_Out(2,6,txtAbajo);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAbajo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,170 :: 		girarDerecha();
	CALL       _girarDerecha+0
;auto.c,171 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,172 :: 		}
L_moverManual22:
L_moverManual19:
L_moverManual15:
L_moverManual11:
;auto.c,174 :: 		}
	GOTO       L_moverManual6
L_moverManual7:
;auto.c,175 :: 		pararVehiculo();              /* como se manda e entonces, se detiene el movimiento del auto y se sale a esperar seleccion de otro modo. */
	CALL       _pararVehiculo+0
;auto.c,176 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;auto.c,177 :: 		Lcd_Out(2,6,"Se salio de modo manual...");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_auto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,178 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_moverManual23:
	DECFSZ     R13+0, 1
	GOTO       L_moverManual23
	DECFSZ     R12+0, 1
	GOTO       L_moverManual23
	DECFSZ     R11+0, 1
	GOTO       L_moverManual23
	NOP
	NOP
;auto.c,179 :: 		uart_rd_temp = ' ';
	MOVLW      32
	MOVWF      _uart_rd_temp+0
;auto.c,182 :: 		}
	RETURN
; end of _moverManual

_moverEnAutomatico:

;auto.c,184 :: 		void moverEnAutomatico(){
;auto.c,185 :: 		uart_rd_temp = ' ';
	MOVLW      32
	MOVWF      _uart_rd_temp+0
;auto.c,186 :: 		bandera_automatico = 1;       /* Con esta bandera se valida en la interrupcion que hacer cuando ocurre un choque. */
	MOVLW      1
	MOVWF      _bandera_automatico+0
	MOVLW      0
	MOVWF      _bandera_automatico+1
;auto.c,187 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;auto.c,188 :: 		Lcd_Out(2,6,txtAutomatic);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAutomatic+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,190 :: 		RC1_bit = 1;
	BSF        RC1_bit+0, 1
;auto.c,191 :: 		RC2_bit = 1;
	BSF        RC2_bit+0, 2
;auto.c,192 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,193 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,194 :: 		cargarDato();
	CALL       _cargarDato+0
;auto.c,195 :: 		while (uart_rd_temp != 'e') { /* Si se le envía e se sale de modo automatico. */
L_moverEnAutomatico24:
	MOVF       _uart_rd_temp+0, 0
	XORLW      101
	BTFSC      STATUS+0, 2
	GOTO       L_moverEnAutomatico25
;auto.c,196 :: 		waitSignal();
	CALL       _waitSignal+0
;auto.c,197 :: 		cargarDato();
	CALL       _cargarDato+0
;auto.c,200 :: 		if(uart_rd_temp == 'e')
	MOVF       _uart_rd_temp+0, 0
	XORLW      101
	BTFSS      STATUS+0, 2
	GOTO       L_moverEnAutomatico26
;auto.c,202 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;auto.c,203 :: 		Lcd_Out(2,6,"Se paro el vehiculo");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_auto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,204 :: 		RC1_bit = 0;
	BCF        RC1_bit+0, 1
;auto.c,205 :: 		RC2_bit = 0;
	BCF        RC2_bit+0, 2
;auto.c,206 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, 5
;auto.c,207 :: 		RC4_bit = 0;
	BCF        RC4_bit+0, 4
;auto.c,208 :: 		}
L_moverEnAutomatico26:
;auto.c,210 :: 		}
	GOTO       L_moverEnAutomatico24
L_moverEnAutomatico25:
;auto.c,211 :: 		pararVehiculo();
	CALL       _pararVehiculo+0
;auto.c,212 :: 		bandera_automatico = 0;       /* al enviar e se sale de modo automatico.*/
	CLRF       _bandera_automatico+0
	CLRF       _bandera_automatico+1
;auto.c,213 :: 		}
	RETURN
; end of _moverEnAutomatico

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;auto.c,216 :: 		void interrupt(){
;auto.c,217 :: 		unsigned long duration = 0;
	CLRF       interrupt_duration_L0+0
	CLRF       interrupt_duration_L0+1
	CLRF       interrupt_duration_L0+2
	CLRF       interrupt_duration_L0+3
;auto.c,220 :: 		if(INTCON.RBIF){
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt27
;auto.c,221 :: 		T1CON.TMR1ON = 1;       // ON Counter
	BSF        T1CON+0, 0
;auto.c,222 :: 		while(Echo == 1);
L_interrupt28:
	BTFSS      PORTB+0, 6
	GOTO       L_interrupt29
	GOTO       L_interrupt28
L_interrupt29:
;auto.c,223 :: 		T1CON.TMR1ON = 0;
	BCF        T1CON+0, 0
;auto.c,224 :: 		TMR = (unsigned int) TMR1H << 8;
	MOVF       TMR1H+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	MOVWF      _TMR+0
	MOVF       R0+1, 0
	MOVWF      _TMR+1
;auto.c,225 :: 		TMR = TMR + TMR1L;          // Combine 2x counter byte into single integer
	MOVF       TMR1L+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _TMR+0
	MOVF       R0+1, 0
	MOVWF      _TMR+1
;auto.c,227 :: 		duration = (TMR/10) * 8;  // Duration Formula = TMR * 0.2us(Clock speed) * 4 (Timer Prescale)
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVLW      3
	MOVWF      R2+0
	MOVF       R0+0, 0
	MOVWF      interrupt_duration_L0+0
	MOVF       R0+1, 0
	MOVWF      interrupt_duration_L0+1
	MOVF       R2+0, 0
L__interrupt56:
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt57
	RLF        interrupt_duration_L0+0, 1
	RLF        interrupt_duration_L0+1, 1
	BCF        interrupt_duration_L0+0, 0
	ADDLW      255
	GOTO       L__interrupt56
L__interrupt57:
	MOVLW      0
	MOVWF      interrupt_duration_L0+2
	MOVWF      interrupt_duration_L0+3
;auto.c,229 :: 		distance_cm = duration / 58 ;   // Refer HC-SR04 Datasheet
	MOVLW      58
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       interrupt_duration_L0+0, 0
	MOVWF      R0+0
	MOVF       interrupt_duration_L0+1, 0
	MOVWF      R0+1
	MOVF       interrupt_duration_L0+2, 0
	MOVWF      R0+2
	MOVF       interrupt_duration_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _distance_cm+0
	MOVF       R0+1, 0
	MOVWF      _distance_cm+1
;auto.c,230 :: 		distance_inc = duration / 148;
	MOVLW      148
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       interrupt_duration_L0+0, 0
	MOVWF      R0+0
	MOVF       interrupt_duration_L0+1, 0
	MOVWF      R0+1
	MOVF       interrupt_duration_L0+2, 0
	MOVWF      R0+2
	MOVF       interrupt_duration_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _distance_inc+0
	MOVF       R0+1, 0
	MOVWF      _distance_inc+1
;auto.c,231 :: 		if(distance_cm < 30)
	MOVLW      0
	SUBWF      _distance_cm+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt58
	MOVLW      30
	SUBWF      _distance_cm+0, 0
L__interrupt58:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt30
;auto.c,233 :: 		if (bandera_mover && bandera_automatico) {/* Si hay obstaculo y esta en Automatico*/
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt33
	MOVF       _bandera_automatico+0, 0
	IORWF      _bandera_automatico+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt33
L__interrupt54:
;auto.c,234 :: 		darVuelta();
	CALL       _darVuelta+0
;auto.c,235 :: 		}else if(bandera_mover && !bandera_automatico){
	GOTO       L_interrupt34
L_interrupt33:
	MOVF       _bandera_mover+0, 0
	IORWF      _bandera_mover+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt37
	MOVF       _bandera_automatico+0, 0
	IORWF      _bandera_automatico+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt37
L__interrupt53:
;auto.c,236 :: 		pararVehiculo();
	CALL       _pararVehiculo+0
;auto.c,237 :: 		bandera_mover = 0;
	CLRF       _bandera_mover+0
	CLRF       _bandera_mover+1
;auto.c,238 :: 		}
L_interrupt37:
L_interrupt34:
;auto.c,239 :: 		}else {
	GOTO       L_interrupt38
L_interrupt30:
;auto.c,240 :: 		bandera_mover = 1;
	MOVLW      1
	MOVWF      _bandera_mover+0
	MOVLW      0
	MOVWF      _bandera_mover+1
;auto.c,241 :: 		avanzarVehiculo();
	CALL       _avanzarVehiculo+0
;auto.c,242 :: 		}
L_interrupt38:
;auto.c,243 :: 		distance_cm = 0, distance_inc = 0, TMR = 0;
	CLRF       _distance_cm+0
	CLRF       _distance_cm+1
	CLRF       _distance_inc+0
	CLRF       _distance_inc+1
	CLRF       _TMR+0
	CLRF       _TMR+1
;auto.c,245 :: 		INTCON.RBIF = 0;        // Clear PortB Interrupt Flag
	BCF        INTCON+0, 0
;auto.c,246 :: 		}
L_interrupt27:
;auto.c,249 :: 		return;
;auto.c,250 :: 		}
L__interrupt55:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;auto.c,251 :: 		void main() {
;auto.c,253 :: 		TRISA = 0b00000000; // set PORTA -> salidas
	CLRF       TRISA+0
;auto.c,254 :: 		TRISB = 0b01000000; // set PORTB -> salida menos el pin 6.
	MOVLW      64
	MOVWF      TRISB+0
;auto.c,255 :: 		ANSEL  = 0;              // Configure AN2 pin as analog
	CLRF       ANSEL+0
;auto.c,256 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;auto.c,257 :: 		C1ON_bit = 0;                      // Disable comparators
	BCF        C1ON_bit+0, 7
;auto.c,258 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;auto.c,259 :: 		INTCON = 0b10000000; // INTERRUPCION POR TIMER0 Y GIE ACTIVADOS.
	MOVLW      128
	MOVWF      INTCON+0
;auto.c,261 :: 		OPTION_REG = 0b10000111; //  TMR0 temporizado:  RBPU, TOCS= INTERNAL INSTRUCTION CLOCK= 0 PSA =0   1:256
	MOVLW      135
	MOVWF      OPTION_REG+0
;auto.c,262 :: 		TRISC = 0b10000000;                          // PUERTOC COMO SALIDA exepto pin 7
	MOVLW      128
	MOVWF      TRISC+0
;auto.c,263 :: 		PORTC = 0;                          // LIMPIAR PUERTOC
	CLRF       PORTC+0
;auto.c,264 :: 		setupTimer1();
	CALL       _setupTimer1+0
;auto.c,265 :: 		Delay_us(10);                 /* wait for acquisition time*/
	MOVLW      6
	MOVWF      R13+0
L_main39:
	DECFSZ     R13+0, 1
	GOTO       L_main39
	NOP
;auto.c,266 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;auto.c,269 :: 		Lcd_Out(2,0,txtDefault);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	CLRF       FARG_Lcd_Out_column+0
	MOVLW      _txtDefault+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,270 :: 		UART1_Init(9600);                         // initialize UART1 module
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;auto.c,271 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
;auto.c,273 :: 		while (1) {
L_main41:
;auto.c,275 :: 		if (UART1_Data_Ready()) {     // If data is received,
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main43
;auto.c,276 :: 		uart_rd = UART1_Read();     // leer el dato recibido del celular
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _uart_rd+0
;auto.c,277 :: 		waitSignal();
	CALL       _waitSignal+0
;auto.c,278 :: 		switch (uart_rd) {
	GOTO       L_main44
;auto.c,279 :: 		case 'A': {               /* Modo automático */
L_main46:
;auto.c,280 :: 		Lcd_Out(2,6,txtAutomatic);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txtAutomatic+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,281 :: 		moverEnAutomatico();
	CALL       _moverEnAutomatico+0
;auto.c,282 :: 		uart_rd = ' ';          /* esperamos nuevo envío de modo. */
	MOVLW      32
	MOVWF      _uart_rd+0
;auto.c,283 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;auto.c,284 :: 		Lcd_Out(2,0,txtDefault);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	CLRF       FARG_Lcd_Out_column+0
	MOVLW      _txtDefault+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,285 :: 		break;
	GOTO       L_main45
;auto.c,287 :: 		case 'M': {
L_main47:
;auto.c,288 :: 		moverManual();
	CALL       _moverManual+0
;auto.c,289 :: 		uart_rd = ' ';  /* esperamos nuevo envío de modo. */
	MOVLW      32
	MOVWF      _uart_rd+0
;auto.c,290 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;auto.c,291 :: 		Lcd_Out(2,0,txtDefault);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	CLRF       FARG_Lcd_Out_column+0
	MOVLW      _txtDefault+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;auto.c,292 :: 		break;
	GOTO       L_main45
;auto.c,294 :: 		default:
L_main48:
;auto.c,295 :: 		break;
	GOTO       L_main45
;auto.c,296 :: 		}
L_main44:
	MOVF       _uart_rd+0, 0
	XORLW      65
	BTFSC      STATUS+0, 2
	GOTO       L_main46
	MOVF       _uart_rd+0, 0
	XORLW      77
	BTFSC      STATUS+0, 2
	GOTO       L_main47
	GOTO       L_main48
L_main45:
;auto.c,297 :: 		}
L_main43:
;auto.c,298 :: 		}
	GOTO       L_main41
;auto.c,299 :: 		}
	GOTO       $+0
; end of _main
