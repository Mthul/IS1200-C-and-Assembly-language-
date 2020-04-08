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
timstr:	.ascii "text:\n "      # Ändrade strängen från "text lost of text" till "tid" för utseendemässigt skäl, 
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
	    addi $v0,$t0, 0x30      # $v0 = $t0 + 0x30 för att konvertera till hexadecimlt 
	    jr $ra    
	    nop              #hoppar till den adress som $ra bär på, alltså efter jal statement 
	            
        high:                       #har intervallet (A-F)
         
	    addi $v0,$t0, 0x37      # $v0 = $t0 + 0x37 för att konverterar till hexadecimalt 
	    jr $ra  
	    nop                #hoppar till den adress som $ra bär på, alltså efter jal statement 
  
  
  #delay:
   #  jr $ra
    # nop
     
     delay:
     
     PUSH ($ra)

	# konstant, som bestämmer hur lång tid delayn skall vara 
	li $t1, 4    
	 
	# ms
	move $t2, $a0     # t2 = a0  = ms 

	
	while:     # while ms > 0 hoppar 
	
		# ms > 0;
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
POP ($ra)
		jr $ra
		nop
 
 

 
 
 #time2string 
 
 time2string:
	PUSH $ra      
	PUSH $s0      
	PUSH $s1      

	move $s0, $a0 # Address where well store printable time //  addressen för den lagrade informationen som kan printas ut 
	move $s1, $a1 # Address of mytime // innehåller tidsinformationen 
		
	#ADD CHECK FOR RESET?
	
	#Suprise: OM två sista = 00 -> DING 
	andi $t7,$s1,0xffff		# mask last two digits but eight bits of ASCII code
	beq $t7, 0x0000, DING		# compare to 0 and branch to DING function
	nop
	
	andi $t0, $s1, 0xf000 # Get first digit /  10 minuters visaren  
	srl $a0, $t0, 0x0c    # Shift right by 12  / skiftningen är anpassad efter hexasc då dne endast omvandlar LSB 
	jal hexasc
	nop
	move $t1, $v0         # t1 = v0
	sb $t1, 0($s0)        #lagrar informationen från första index 
 	
	andi $t0, $s1, 0xf00  # Get second digit / minuter visaren 
	srl $a0, $t0, 0x8    # Shift right by 8	
	
	jal hexasc           # kallar på hexasc för omvandling 
	nop
	move $t1, $v0        # t1 = v0 
	sb $t1, 1($s0)       #lagrar informationen från andra indexet 
	
	li $t1, 0x3a        # Load : laddar över (:) till t1 
	sb $t1, 2($s0)        # lagrar : vid tredje index i t1 
	
	andi $t0, $s1, 0xf0   # Get third digit / 10 sekunder visaren 
	srl $a0, $t0, 0x4
	  # Shift right by 4
	jal hexasc
	nop
	move $t1, $v0         # t1 = v0 
	sb $t1, 3($s0)        #lagrar 
     
       
	andi $a0, $s1, 0xf # Get last digit, no shift needed / sekunder visaren 		
	jal hexasc
	nop
	move $t1, $v0
	sb $t1, 4($s0)
	
	
end:
POP $ra
POP $s1
POP $s0
	
	jal main 
	nop
	
	DING:
		li $t1, 0x48   #D 
		li $t2, 0x4f   #I
		li $t3, 0x55   #N
		li $t4, 0x52   #G
		li $t5,0x0     #NULL
		
		sb $t1,0($s0)
		sb $t2,1($s0)
		sb $t3,2($s0)
		sb $t4,3($s0)
		sb $t5,4($s0)
	
	j end
	nop
 
	