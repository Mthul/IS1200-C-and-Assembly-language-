  # timetemplate.asm
  # Written 2015 by F Lundevall 
  # Copyright abandonded - this file is in the public domain.
  # Redigerad 2020 av Magnus Thulin 

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text:\n "      # �ndrade str�ngen fr�n "text lost of text" till "tid" f�r utseendem�ssigt sk�l, 
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little

	li	$a0, 2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check sekond digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
    hexasc:
  
	andi	$t0, $a0, 0xf

	slti	$t1,$a0,10		# kollar om $t0 < 9
	bne	$t1,$zero,low	  
	nop      # om $t0 <= t0, hoppar den till low (low 
	
	slti	$t1,$a0,16		# koallar  om $t0 < 15
	bne     $t1,$zero,high	 
	nop       # om $t0 <= t0, hoppar den till high

        low:                        # har intervallet (0-9)
	    addi $v0,$t0, 0x30      # $v0 = $t0 + 0x30 f�r att konvertera till hexadecimlt 
	    jr $ra    
	    nop              #hoppar till den adress som $ra b�r p�, allts� efter jal statement 
	            
        high:                       #har intervallet (A-F)
         
	    addi $v0,$t0, 0x37      # $v0 = $t0 + 0x37 f�r att konverterar till hexadecimalt 
	    jr $ra  
	    nop                #hoppar till den adress som $ra b�r p�, allts� efter jal statement 
  
  
  #delay:
   #  jr $ra
    # nop
     
     delay:

	# konstant, som best�mmer hur l�ng tid delayn skall vara / int i = 0
	li $t1, 20   
	 
	# ms
	move $t2, $a0     # t2 = a0  = ms 

	
	while:     # while ms > 0 hoppar till for loopen 
	
		# ms < 0;
		ble $t2, 0, exit
		nop 
		# ms = ms - 1;
		sub $t2, $t2, 1
		# int i = 0;
		li $t0, 0
	
		for:
		
			# i < $t1
			bge $t0, $t1, while
			nop
			addi $t0, $t0, 1
			
			j for
			nop
						
		j while
		nop
	
	exit:

		jr $ra
		nop
 
 

 
 
 #time2string 
 
 time2string:
	PUSH $ra      # pushar nner ra u stacken 
	PUSH $s0      #pushar ner utrymme i stacken 
	PUSH $s1      #pushar ner utrymme i stacken 

	move $s0, $a0 # Address where well store printable time //  addressen f�r den lagrade informationen som kan printas ut 
	move $s1, $a1 # Address of mytime // inneh�ller tidsinformationen 
		
	#ADD CHECK FOR RESET?
	
	andi $t0, $s1, 0xf000 # Get first digit /  10 minuters visaren  
	srl $a0, $t0, 0x0c # Shift right by 12  / skiftningen �r anpassad efter hexasc d� dne endast omvandlar LSB 
	jal hexasc
	nop
	move $t1, $v0         # t1 = v0
	sb $t1, 0($s0)        #lagrar informationen fr�n f�rsta index 
	
	andi $t0, $s1, 0xf00  # Get second digit / minuter visaren 
	srl $a0, $t0, 0x8    # Shift right by 8
	jal hexasc           # kallar p� hexasc f�r omvandling 
	nop
	move $t1, $v0        # t1 = v0 
	sb $t1, 1($s0)       #lagrar informationen fr�n andra indexet 
	
	li $t1, 0x3a        # Load : laddar �ver (:) till t1 
	sb $t1, 2($s0)        # lagrar : vid tredje index i t1 
	
	andi $t0, $s1, 0xf0   # Get third digit / 10 sekunder visaren 
	srl $a0, $t0, 0x4     # Shift right by 4
	jal hexasc
	nop
	move $t1, $v0         #
	sb $t1, 3($s0)        #
	
	andi $a0, $s1, 0xf    # Get last digit, no shift needed / sekunder visaren 
	jal hexasc
	nop
	move $t1, $v0
	sb $t1, 4($s0)
	
	jal main              # Beh�vs denna jummp? vid varje loop printas �ven str�ngen ut..... 
	nop 
	
	
	
	

	
  #vilka register anv�nds ohc vilka sparas? varf�r?
  
  #vilka anv�nds men inte sparas 
  
  # vilka radder illustrerar tiosekundersvisaren?
  
  #Matchar delay funkitonen C ursprunget? : ja, 
  
  # Om v�rdet i register  $a0 �r noll, vilken information i delay programmet �r exekverade? Huur m�nga g�nger? varf�r? programmet exekeveras 0 g�nger d� 
   
  #samma som ovan men om v�rdet �r -1, om a0 < 0 kommer delay funktionen inte verka d� den hoppar ur while-loopen till exit, 
  
  