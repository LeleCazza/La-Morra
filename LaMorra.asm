.data

x:              .word 11
y:              .word 87
z:              .word 10000
seme:           .word 0
Punti:          .asciiz "\nA quanti punti si raggiunge la vittoria? "
Pensa_somma:    .asciiz "\nQUALE SARA' LA SOMMA DEI NUMERI GIOCATI (min 1 max 10)? "
Gioca:          .asciiz "\nCHE NUMERO VUOI GIOCARE (min 0 max 5)? "
Numero_pensato: .asciiz "\nIL COMPUTER HA PENSATO IL NUMERO: "
Numero_giocato: .asciiz "\nIL COMPUTER HA GIOCATO IL NUMERO: "
A_capo:         .asciiz "\n"
Hai_vinto:      .asciiz "\nHAI VINTO "
Hai_perso:      .asciiz "\nHAI PERSO "
Stampa_seme:    .asciiz "\nInserisci un valore arbitrario per iniziare il gioco: "
Somma_numeri:   .asciiz "\nLa somma dei due numeri giocati è: "
Punteggio_Gioc: .asciiz "\nHai vinto la mano, Punti giocatore = "
Punteggio_Comp: .asciiz "\nHai perso la mano, Punti giocatore = "
Punt_comp:      .asciiz ", Punti computer = "
Niente:         .asciiz "\nNessuno ha vinto la mano\n"
Errore:         .asciiz "\nIl valore inserito non rispetta le regole del gioco, reinserire\n"
.text

main:

########### PRIMA DOMANDA ###################################################################################################

li $v0,4				#carico codice print_string
la $a0,Stampa_seme   	#carico argomenti
syscall					#syscall print_string
li $v0,5				#carico codice read_int
syscall					#syscall read_int
move $t2,$v0			#sposto seme nel registro $t2
sw $t2,seme($0)			#carico in memoria il seme contenuto in $t2

########### SECONDA DOMANDA #################################################################################################

li $v0,4				#carico codice print_string
la $a0,Punti			#carico argomenti
syscall					#syscall print_string
li $v0,5				#carico codice read_int
syscall					#syscall read_int
move $s0,$v0			#sposto risultato Punti in $s0

Loop:

########### TERZA DOMANDA ###################################################################################################

li $v0,4				#carico codice print_string
la $a0,Pensa_somma		#carico argomenti
syscall					#syscall print_string
li $v0,5				#carico codice read_int
syscall					#syscall read_int
move $t0,$v0			#sposto risultato Pensa_somma in $t0

########### QUARTA DOMANDA ##################################################################################################

Quarta_domanda:
li $v0,4				#carico codice print_string
la $a0,Gioca			#carico argomenti
syscall					#syscall print_string
li $v0,5				#carico codice read_int
syscall					#syscall read_int
move $t1,$v0			#sposto risultato Gioca in $t1

########### CONTROLLO DEL VALORE INSERITO ###################################################################################

li $t4,0				#carico in $t4 il valore minimo
li $t5,5				#carico in $t5 il valore massimo
blt $t1,$t4,Non_valido	#se il valore inserito è minore di 0 salta a Non_valido
bgt $t1,$t5,Non_valido  #se il valore inserito è maggiore di 5 salta a Non_valido
j Corretto      		#se il valore è corretto prosegui
Non_valido:
li $v0,4				#carico codice print_string
la $a0,Errore   		#carico argomenti
syscall					#syscall print_string
j Quarta_domanda		#se valore inserito non è corretto ripeti la domanda
Corretto:

########### COMPUTER PENSA UN NUMERO ########################################################################################

### CHIAMATA A PROCEDURA #################

sw $ra,0($sp)			#salvo valore del registro $ra sullo stack
li $a0,10				#carico parametri della procedura (modulo 10)
jal Random				#chiamata procedura Random
lw $ra,0($sp)			#carico nel registro $ra il valore precedentemente salvato sullo stack
move $s1,$v0			#sposto risultato procedura in $s1
addi $s1,$s1,1			#aggiungo 1 per ottenere valori 1 <= x <= 10

### STAMPA DEL RISULTATO #################

li $v0,4				#carico codice print_string
la $a0,Numero_pensato	#carico argomenti
syscall					#syscall print_string
li $v0,1				#carico codice print_int
move $a0,$s1			#sposto numero random pensato dal computer nel registro $a0
syscall					#syscall print_int
li $v0,4				#carico codice print_string
la $a0,A_capo			#carico argomenti
syscall					#syscall print_string

########### COMPUTER GIOCA UN NUMERO ########################################################################################

### CHIAMATA A PROCEDURA #################

Ripeti:
sw $ra,0($sp)			#salvo valore del registro $ra sullo stack
li $a0,6				#carico parametri della procedura (modulo 6)
jal Random				#chiamata procedura Random
lw $ra,0($sp)			#carico nel registro $ra il valore precedentemente salvato sullo stack
move $s2,$v0			#sposto risultato procedura in $s2

### MOSSE INTELLIGENTI ###################

bgt $s2,$s1,Ripeti		#se il numero giocato è maggiore del numero pensato non accettare il valore
li $t3,6				#carico 6 nel registro $t3
beq $s1,$t3,Caso_1      #se numero pensato è uguale a 6 vai al Caso_1
addi $t3,$t3,1			#carico 7 nel registro $t3
beq $s1,$t3,Caso_2      #se numero pensato è uguale a 7 vai al Caso_2
addi $t3,$t3,1          #carico 8 nel registro $t3
beq $s1,$t3,Caso_3      #se numero pensato è uguale a 8 vai al Caso_3
addi $t3,$t3,1			#carico 9 nel registro $t3
beq $s1,$t3,Caso_4      #se numero pensato è uguale a 9 vai al Caso_4
addi $t3,$t3,1          #carico 10 nel registro $t3
beq $s1,$t3,Caso_5      #se numero pensato è uguale a 10 vai al Caso_5
Caso_1:
li $t3,1				#carico 1 nel registro $t3
blt $s2,$t3,Ripeti		#se il numero pensato è 6 devo giocare un numero maggiore o uguale a 1
j Stampa				#se il numero pensato è maggiore o uguale a 1 Stampa
Caso_2:
li $t3,2				#carico 2 nel registro $t3
blt $s2,$t3,Ripeti		#se il numero pensato è 7 devo giocare un numero maggiore o uguale a 2
j Stampa				#se il numero pensato è maggiore o uguale a 2 Stampa
Caso_3:
li $t3,3				#carico 2 nel registro $t3
blt $s2,$t3,Ripeti		#se il numero pensato è 8 devo giocare un numero maggiore o uguale a 3
j Stampa				#se il numero pensato è maggiore o uguale a 3 Stampa
Caso_4:
li $t3,4				#carico 2 nel registro $t3
blt $s2,$t3,Ripeti		#se il numero pensato è 9 devo giocare un numero maggiore o uguale a 4
j Stampa				#se il numero pensato è maggiore o uguale a 4 Stampa
Caso_5:
li $t3,5				#carico 2 nel registro $t3
blt $s2,$t3,Ripeti		#se il numero pensato è 10 devo giocare un numero maggiore o uguale a 5
j Stampa				#se il numero pensato è maggiore o uguale a 5 Stampa

### STAMPA DEL RISULTATO #################

Stampa:
li $v0,4				#carico codice print_string
la $a0,Numero_giocato	#carico argomenti
syscall					#syscall print_string
li $v0,1				#carico codice print_int
move $a0,$s2			#sposto numero random pensato dal computer nel registro $a0
syscall					#syscall print_int
li $v0,4				#carico codice print_string
la $a0,A_capo			#carico argomenti
syscall					#syscall print_string

########### CALCOLO DEL PUNTO ###############################################################################################

bne $zero,$t1,Somma		#se il numero giocato dal giocatore non è uguale a zero vai a Somma
beq $t1,$s2,Nullo		#se il numero giocato dal giocatore è uguale a zero ed al numero giocato dal computer salta a Nullo
Somma:
sw $ra,0($sp)			#salvo valore del registro $ra sullo stack
move $a0,$s2			#sposto numero giocato dal computer in $a0 (da usare come primo argomento)
move $a1,$t1			#sposto numero giocato dall'utente in $a1 (da usare come secondo argomento)
jal Somma_ricorsiva		#chiamata procedura ricorsiva
lw $ra,0($sp)			#carico nel registro $ra il valore precedentemente salvato sullo stack
move $s3,$v0			#sposto risultato procedura ricorsiva in $s3

### STAMPA DELLA SOMMA ##########################################################
                                                                                #
li $v0,4				#carico codice print_string                             #
la $a0,Somma_numeri     #caico argomenti                                        #
syscall					#syscall print_string                                   #
li $v0,1				#carico codice print_int                                #
move $a0,$s3			#sposto somma dei numeri giocati nel registro $a0       #
syscall					#syscall print_int                                      #
li $v0,4				#carico codice print_string                             #
la $a0,A_capo			#carico argomenti                                       #
syscall					#syscall print_string                                   #
#################################################################################

bne $s3,$t0,Maybe1      #se la somma dei numeri giocati è diversa dal numero pensato dal giocatore vai a Maybe1
bne $s3,$s1,Maybe2      #se la somma dei numeri giocati è diversa dal numero pensato dal computer vai a Maybe2
j Nullo                 #se sia il giocatore sia il computer hanno indovinato la somma vai a Nullo
Maybe2:
j Vittoria				#Num pensato dal gioc è uguale alla somma dei due numeri giocati e diverso dal num pensato dal comp
Maybe1:
beq $s3,$s1,Sconfitta	#confronto il numero pensato dal computer con il risultato della somma
Nullo:

### STAMPA IN CASO NULLO ########################################################
                                                                                #
li $v0,4				#carico codice print_string                             #
la $a0,Niente		    #caico argomenti                                        #
syscall					#syscall print_string                                   #
#################################################################################

j Loop					#se nessuno ottiene il punto si avvia una nuova mano

########### CALCOLO DEL PUNTEGGIO TOALE #####################################################################################

Vittoria:
addi $s4,$s4,1			#incremento di uno il punteggio del giocatore

### STAMPA DEL PUNTO ############################################################
li $v0,4				#carico codice print_string                             #
la $a0,Punteggio_Gioc   #caico argomenti                                        #
syscall					#syscall print_string                                   #
li $v0,1				#carico codice print_int                                #
move $a0,$s4			#sposto punti totali giocatore nel registro $a0         #
syscall					#syscall print_int                                      #
li $v0,4				#carico codice print_string                             #
la $a0,Punt_comp        #caico argomenti                                        #
syscall					#syscall print_string                                   #
li $v0,1				#carico codice print_int                                #
move $a0,$s5			#sposto punti totali computer nel registro $a0          #
syscall					#syscall print_int                                      #
li $v0,4				#carico codice print_string                             #
la $a0,A_capo			#carico argomenti                                       #
syscall					#syscall print_string                                   #
#################################################################################

j Risultato				#salto al calcolo del risultato
Sconfitta:
addi $s5,$s5,1			#incremento di uno il punteggio del computer

### STAMPA DEL PUNTO #####################

li $v0,4				#carico codice print_string
la $a0,Punteggio_Comp   #caico argomenti
syscall					#syscall print_string
li $v0,1				#carico codice print_int
move $a0,$s4			#sposto punti totali giocatore nel registro $a0
syscall					#syscall print_int
li $v0,4				#carico codice print_string
la $a0,Punt_comp        #caico argomenti
syscall					#syscall print_string
li $v0,1				#carico codice print_int
move $a0,$s5			#sposto punti totali computer nel registro $a0
syscall					#syscall print_int
li $v0,4				#carico codice print_string
la $a0,A_capo			#carico argomenti
syscall					#syscall print_string

########### CALCOLO DEL RISULTATO ###########################################################################################

Risultato:
bne $s0,$s4,Or			#se il punteggio totale del giocatore non ha raggiunto il punteggio stabilito in partenza salta a Or
j Vinto					#se il punteggio totale del giocatore ha raggiunto il punteggio stabilito in partenza salta a Vinto
Or:
bne $s0,$s5,Loop		#se il punteggio totale del computer non ha raggiunto il punteggio stabilito in partenza salta a Loop
j Perso					#se il punteggio totale del computer ha raggiunto il punteggio stabilito in partenza salta a Perso

########### STAMPA DEL VINCITORE ############################################################################################

Vinto:
li $v0,4				#carico codice print_string
la $a0,Hai_vinto		#carico argomenti
syscall					#syscall print_string
j Fine					#salta a Fine
Perso:
li $v0,4				#carico codice print_string
la $a0,Hai_perso		#carico argomenti
syscall					#syscall print_string
j Fine					#salta a Fine

########### PROCEDURA RANDOM ################################################################################################

Random:
addi $sp,$sp,-12    	#allocazione stack frame
sw $t0,0($sp)           #salvataggio di $t0
sw $t1,4($sp)           #salvataggio di $t1
sw $ra,8($sp)           #salvataggio di $ra
lw $t0,x($0)            #carico in $t0 il numero contenuto in x (11)
lw $t1,seme($0)         #carico in $t1 il seme scelto in partenza
move $t2,$a0			#sposto l'argomento contenuto nel registro $a0 nel registro $t2
mul $t0,$t0,$t1         #calcolo 11 * seme e metto il risultato in $t0
lw $t1,y($0)            #carico in $t1 il numero contenuto in y (87)
add $t0, $t0, $t1       #sommo al contenuto di $t0 87 ($t0 = (11 * seme) + 87)
lw $t1,z($0)            #carico in $t1 il numero contenuto in z (10000)
div $t0, $t1            #divido il contenuto di $t0 per 10000 ($hi = ((11 * seme) + 87) mod 10000)
mfhi $t0                #sposto il resto della divisione nel registro $t0
sw $t0,seme($0)         #aggiorno il seme con il contenuto di $t0
div $t0,$t2             #divido il contenuto di $t0 per l'argomento scelto (modulo 10 , modulo 6)
mfhi $t0                #sposto il resto della divisione nel registro $t0
move $v0,$t0			#sposto il numero random trovato nel registro di uscita $v0
lw $t0,0($sp)        	#ripristino di $t0
lw $t1,4($sp)        	#ripristino di $t1
lw $ra,8($sp)        	#ripristino di $ra
addi $sp,$sp,12        	#deallocazione stack frame
jr $ra                  #restituzione controllo al chiamante

########### PROCEDURA RICORSIVA #############################################################################################

Somma_ricorsiva:
addi $sp,$sp,-12   	    #allocazione stack frame
sw $t0 0($sp)           #salvataggio di $t0
sw $t1,4($sp)           #salvataggio di $t1
sw $ra,8($sp)           #salvataggio di $ra
move $t0,$a0			#sposto primo argomento in $t0
bne $t0,$zero,Step_ric  #branch se $t1 != 0
move $v0,$t1            #caso base (0 + x = x), restituisco x
Somma_termina:
lw $t0 0($sp)           #ripristino di $t0
lw $t1,4($sp)           #ripristino di $t1
lw $ra,8($sp)           #ripristino di $ra
addi $sp,$sp,12		    #deallocazione stack frame
jr $ra					#restituzione controllo al chiamante
Step_ric:
move $t1,$a1            #sposto secondo argomento in $t1
addi $t0,$t0,-1			#tolgo uno al valore contenuto in $t0
addi $t1,$t1,1			#aggiungo uno al valore contenuto in $t1
move $a0,$t0			#aggiorno primo argomento
move $a1,$t1			#aggiorno secondo argomento
jal Somma_ricorsiva		#chiamata ricorsiva
j Somma_termina			#termina

########### FINE GIOCO ######################################################################################################

Fine:
jr $ra					#salta al registro $ra che termina
