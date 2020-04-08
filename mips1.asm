 # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

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
mytime:	.word 0x1010
timstr:	.ascii "The time is >"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
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
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
hexasc : 
	
	move $t0, $a0
	andi $t0 ,  0xf	
	addi $t1 , $0 , 9
	ble  $t0 , $t1 , next
	addi $v0 , $t0 , 0x37

	jr $ra
	
	next :
	addi $v0 , $t0 , 0x30
	move $a0 , $v0 
         li $v0,11
         syscall
 
	jr $ra
	
delay:
	addi $t5 , $0 , 130000    # here we set a constent 
	addi $t4 , $0 , 1
	addi $t0 , $0 , 0       # here we set the value of i
	addi $t1 , $0 , 1000    # here we set the ms
	
	slt $t2 , $t0 ,$t1      # we set a while loop 1000 > i
	beq $t2 , $t0 ,loop     # the loop will keep going untill i is greater than 1000 
	
	
	
loop: 
	sub $t1 , $t1 , $t4     # here we subtract 1 from 1000 untill the previous loop is true 
	
loop1 : 
	slt $t6 , $t0 , $t5     # here a for loop 4711> i
	add $t0 , $t0 , $t4     # here we add 1 to i untill i is greater than 4711
	beq $t6 , $t4 , loop1 
	j stop
	
	
	
stop : nop 






 	jr $ra
 	nop





 li $v0,11
 syscall




time2string :
 	 PUSH($a0)
	 PUSH($ra) 
	 #PUSH($a0)	
	  
 	 li $a1 , 0x10010000
 	 
 	 
 	 lb $a0, 0x01($a1)
         srl $a0 , $a0 , 4
 	 andi $a0 , 0xff
 	 sb $a0 , 0x23($a1)
 	 jal hexasc
 	 
 	  lb $a0, 0x01($a1)
 	 andi $a0 , 0xf
 	 sb $a0 , 0x22($a1)
 	 jal hexasc
 	 
 	
 	  addi $a0 ,$0 , 0x3a
	 li $v0,11
	 syscall
 	 
 	 
 	 lb $a0, 0x00($a1)
	 srl $a0 , $a0 , 4
 	 andi $a0 , 0xff
 	 sb $a0 , 0x21($a1)
 	jal hexasc
 	 
 	 lb $a0, 0x00($a1)
 	 andi $a0 , 0xf
 	 sb $a0 , 0x20($a1)
 	 jal hexasc
 	
 	 
 	 
 	 
 	 
 	 POP($ra) 
	
	 
	 POP($a0)
 	 
	 
 	 
 	 jr $ra
 	 
 	 
 	 
 	 
 	 #POP($a0)
 	 #POP($a1)
 	 #POP($v0)
 	 
