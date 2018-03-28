##################################################################################
#                                                                                #
#                                                                                #
#                                                                                #
#                                                                                #
#                                                                                #
#                       data segment                                             #
#                                                                                #
#                                                                                #
#                                                                                #
#                                                                                # 
#                                                                                #
##################################################################################
.data 

m_w: .word 0
m_z: .word 0 
randomValue: .word 0
boxCheckingArray: .word 13, 15, 17, 23, 25, 27, 33, 35, 37
validSpaceArray: .word 3, 5, 7, 12, 13, 14, 15, 16, 17, 18, 22, 23, 24, 25, 26, 27, 28, 32, 33, 34, 35, 36, 37, 38
validSpaceArraySize: .word 24
countComputer: .word 0
countHuman: .word 0
number1: .word 0
number2: .word 0

current: .byte 'w'
next: .byte 'w'
character1: .byte 'w'
character2: .byte 'w'


header: .asciiz "  1 2 3 4\n"            
box: .asciiz   "a . . . .\nb . . . .\nc . . . .\nd . . . .\n"                                   
message1: .asciiz "Enter two positive numbers to initialize the random number generator.\n"
messageOfNum1: .asciiz "Enter number 1: "           
messageOfNum2: .asciiz "Enter number 2: " 
messageOfNum3: .asciiz "Welcome to Dots and Boxes!\n" 
messageOfNum4: .asciiz "Version 1.0\n"
messageOfNum5: .asciiz "Implemented by Ibrahim, Atiq, Khayrul, Taslima\n"
messageOfplayerChoser: .asciiz "I will make the first move.\n"
newLine: .asciiz "\n"         

messageOfComputerInput1: .asciiz "My turn: I draw between " 
messageOfComputerInput2: .asciiz " and "
userInputMessage: .asciiz "Your turn: \n"
userInputPromt1: .asciiz "Enter coordinate of the first dot: "
userInputPromt2: .asciiz "Enter coordinate of the second dot: "             
wrongInputMessage: .asciiz "wrong input \n" 
wrongInputMessage2: .asciiz "There is already a line there.\n" 
computerWinMessage: .asciiz "computer win!\n"
humanWinMessage: .asciiz "You win!\n"
  

#################################################
#                                               #
#						#
#						#	
#              text segment			#
#						#
#						#
#						#
#################################################
        
.text

main:

	jal showMessageAndSelectPlayer						# Calling showMessageAndSelectPlayer 
	jal randomFunction							# Calling randomFunction
	jal playerChoser							# Calling playerChoser	
	lw $t9, validSpaceArraySize						# load word validSpaceArraySize to t9
	
##
##	starting moves of game
##
continueGame:
	
	beq $t9, $zero, printResult						# if t9=0 go to printResult
	
	lb $t0, current								# load byte current to t0
	
	beq $t0, 67, playComputer						#if t0='C' goto play computer
	j playUser								# jump to playUser

	
	
######### boxcheking start
#________________________________________________________________________________________________________________________________


##
##	start boxChecking
#________________________________________________________________________________________________________________________________
boxChecking:
		
		li $t8, 0							# load immidiate value 0 t0 t8		
		la $t6, boxCheckingArray					# load address of boxCheckArray to t6

		boxCheckingArrayLoop:
			li $t7, 0						# load immidiate value 0 t0 t7
			
			beq $t8, 9, breakBoxCheckingArrayLoop			# if t8 == 9 goto breakBoxCheckingArrayLoop
			
			lw $t0, 0($t6)						# load word to t0 from boxCheckingArray of address t6
			
			lb $t1, box($t0)					# t1 = box[t0]
			beq $t1, 32, boxCheckingIncrement			# if t1 == 32 boxCheckingIncrement
			addi $t7, $t7, 1					# t7 = t7 + 1
			
			addi $t0, $t0, -1					# t0 = t0 - 1
			lb $t1, box($t0)					# t1 = box[t0]
			beq $t1, 46, boxCheckingIncrement			# if t1 = 46 boxCheckingIncrement
			addi $t7, $t7, 1					# # t7 = t7 + 1
			
			addi $t0, $t0, 2					# t0 = t0 + 2
			lb $t1, box($t0)					# t1 = box[t0]
			beq $t1, 46, boxCheckingIncrement			# if t1 = 46 boxCheckingIncrement
			addi $t7, $t7, 1					# t7 = t7 + 1
			
			addi $t0, $t0, -11					# t0 = t0 - 11				
			lb $t1, box($t0)					# t1 = box[t0]
			beq $t1, 32, boxCheckingIncrement			# if t1 = 32 boxCheckingIncrement
			addi $t7, $t7, 1					# # t7 = t7 + 1
			
			
			
			addi $t0, $t0, 10					# t0 = t0 - 11
			lb $t5, box($t0)					# t5 = box[t0]
			bne $t5, 95, boxCheckingIncrement			# if t5 != 95 goto boxCheckingIncrement
			
			lb $t1, current						# t1 = current
			sb $t1, box($t0)					# box[t0] = t1
			
			beq $t1, 67, incrementComputerPoint			# if t1 != 67 goto incrementComputerPoint
			lw $t1, countHuman					# t1 = countHuman
			addi $t1, $t1, 1					# t1 = t1 + 1
			sw $t1, countHuman					# countHuman = t1
			
			j boxCheckingIncrement					# jump to boxCheckingIncrement
			
			incrementComputerPoint:		
				
				lw $t1, countComputer				# t1 = countComputer
				addi $t1, $t1, 1				# t1 = t1 + 1
				sw $t1, countComputer				# countComputer = t1
				
		boxCheckingIncrement:
			addi $t8, $t8, 1					# t8 = t8 + 1	
			addi $t6, $t6, 4					# t6 = t6 + 4
			
			 moreThan5:
            
            			lw $t4, countComputer				# t4 = countComputer	
           			lw $t3, countHuman				# t3 = countHuman
            
            			beq $t4, 5, winBeforeEnd			# if t4=5 goto winBeforeEnd
            			beq $t3, 5, winBeforeEnd			# if t3=5 goto winBeforeEnd
			
			j boxCheckingArrayLoop					# jump to boxCheckingArrayLoop
			
	breakBoxCheckingArrayLoop:
		
		addi $t9, $t9, -1						# t9 = t9+(-1)
		
		jal printBox							# calling printBox
		
		lb $t1, current							# t1 = current 
		lb $t2, next							# t2 = next
		sb $t2, current							# current = t2
		sb $t1, next							# current = next
		
		j continueGame							# jump to continueGame					

########## box checking end
#_________________________________________________________________________________________________________________________________


##
##	printResult start
#_______________________________________________________________________________________________________________________________
printResult:

	lw $t1, countComputer					# load word value from 	countComputer to t1	
	lw $t2, countHuman					# load word value from 	countHuman to t2
	
	
	bgt $t1, $t2, computerWinResult				# if t1 > t2 go to computerWinResult
	la $a0, humanWinMessage					# load address of humanWinMesage to a0
	li $v0, 4						# load immediate value to 4 to print message
	syscall							# print string
	
	j exit							# jump to exit
	
	
	computerWinResult:
		la $a0, computerWinMessage			# load address of computerWinMessage to a0
		li $v0, 4					# load immediate value to 4 to print message
		syscall						# print string

	j exit							# jump to exit
	
##
##	end of printResult
#____________________________________________________________________________________________________________________________________


##
##	printBox function
#___________________________________________________________________________________________________________________________________

printBox:
				
	la $a0, newLine								# load address of newLine to a0								# 
	li $v0, 4								# load 4 to v0 to print newLine
	syscall

	la $a0, header								# load address of header to a0
	li $v0, 4								# load 4 to v0 to print header
	syscall

	la $a0,box								# load address of box to a0
	li $v0, 4								# load 4 to v0 to print box
	syscall

	jr $ra									# jump to the next instruction from where it was called
	
##
##	end of printBox
#______________________________________________________________________________________________________________________________________
	
			
	
##
## start of randomFunction
#-----------------------------------------------------------------------------------------------------------------------------------
randomFunction:
	
	li $t0, 36969					# load immediate value 36969 into t0 

	andi $t1, $a1, 65535				# t1 = a1 & 65535 		here a1 = m_z
	mult  $t0, $t1					# multiply t0 and t1
	mflo $t1					# load result of multiplication into t1 
	srl $t0, $a1, 16				# t0 = a1 >> 16			here a1 = m_z
	addu $t1, $t0, $t1				# t1 = t0 + t1
	
	sw $t1, m_z					# store t1 into m_z
	
	li $t0,18000					# load immediate value 18000 into t0
	
	andi $t1, $a0, 65535				# t1 = a0 & 65535 		here a1 = m_z
	mult $t0,$t1					# multiply t0 and t1
	mflo $t1					# load result of multiplication into t1
	srl $t0, $a0, 16				# t0 = a1 >> 16			here a1 = m_z
	addu $t1, $t1, $t0				# t1 = t1 + t0
	
	sw $t1, m_w					# store t1 into m_w
	
	lw $t0, m_z					# load word from m_z to t0
	sll $t0, $t0, 16				# t0 = t0 << 16
	
	addu $t0, $t0, $t1				# t0 = t0 + t1
	sw $t0, randomValue				# store t0 into randomValue 
	
	jr $ra						# return to the next instruction address from where it was called
##
##	end of randomFunction
#___________________________________________________________________________________________________________________________________--
	
##
## showMessageAndSelectPlayer function
#-------------------------------------------------------------------------------------------------------------------------------	
showMessageAndSelectPlayer:
	
	la $a0, messageOfNum3			# load the address of messageOfNum3 to a0
	li $v0, 4				# load 4 to v0 to print messageOfNum3
	syscall 
	
	la $a0, messageOfNum4			# load the address of messageOfNum4 to a0
	li $v0, 4				# load 4 to v0 to print messageOfNum3
	syscall
	
	la $a0, messageOfNum5			# load the address of messageOfNum5 to a0
	li $v0, 4				# load 4 to v0 to print messageOfNum3
	syscall

	la $a0, message1			# load the address of message1 to a0
	li $v0, 4				# load 4 to print messageOfNum3
	syscall                           
	
	la $a0, messageOfNum1			# load the address of messageOfNum1 to a0
	li $v0, 4				# load 4 to v0 to print messageOfNum3
	syscall                          
	
	li $v0, 5				# load 4 to v0 input a word
	syscall                          	# input from user a positive number
	
	move $t1,$v0				# t1 = v0
	
	sw $v0, m_w				# store v0 to m_w
	
	la $a0, messageOfNum2			# load the address of messageOfNum3 to a0
	li $v0, 4				# load 4 to v0 to print messageOfNum3
	syscall                          
		
	li $v0, 5				# load 5 to v0 to input a word
	syscall	                          	
	
	sw $v0, m_z				# store v0 to m_z
	
	lw $a0, m_w				# load m_w to a0
	lw $a1, m_z				# load m_z to a1
	
	jr $ra					# return to the next address of call
		
##
##	end of showMessageAndSelectPlayer function
#-----------------------------------------------------------------------------------------------------------------------------	
	
	
##
##	playerChoser function 
#__________________________________________________________________________________________________________________________________
	
playerChoser:	
	
	lw $t0, randomValue 				# lode word from  randomValue to t0
	addi $t0, $t0, -2				# t0 = t0 - 2
	li $t1, 2					# load immediate value 2 to t1 
	div $t0, $t1					# divide t0 by t1
	mfhi $t1					# load module of division to t1
	
	beq $t1, $zero, playerChoserElse		# if(t1 == 0) goto playerChoserElse 
	li $t0, 72					# t0 = 72  for setting t0='H'
	sb $t0, current 				# store t0 to current                  
	
	li $t0, 67					# load 67 to t0 for setting t0='C'
	sb $t0, next					# store t0 to next
	
	la $a0, messageOfplayerChoser			# load the address of messageOfplayerChoser to a0
	li $v0, 4					# load 4 to v0 to print  messageOfplayerChoser
	syscall
	
	j returnFromPlayerChoser			# jump to returnFromPlayerChoser
	
	playerChoserElse:
		li $t0, 67				# load 67 to t0 for setting t0='C'
		sb $t0, current 			# store t0 to current 
	
		li $t0, 72				#l oad 72 to t0 for setting t0='H'
		sb $t0, next				# store t0 to next
		
	returnFromPlayerChoser:				# return label
		jr $ra					# return to the next instruction address from where it was called
##
##	end of playerChoser function 
#______________________________________________________________________________________________________________________________________

##
##	isThePlaceEmpty
#____________________________________________________________________________________________________________________________________
isThePlaceIsEmpty:
	
	lb $t6, box($a1)				# load byte box[a1] to t6								
	beq $t6, ' ', storeTheAddress			# if t6=' ' go to storeTheAdress
	beq $t6,'.', storeTheAddress			# if t6='.' go to storeTheAdress
	li $t1, 1					# load immediate value 1 to t1
	jr $ra						# return to the next instruction from where it was called 
	
	storeTheAddress:
		move $t0, $a1				# t0=a1
		li $t1, 0				# load immediate value 0 to t1
		jr $ra					# return to the next instruction from where it was called


##
##	posibilityOfMakingBox label
#_________________________________________________________________________________________________________________________________
posibilityOfMakingBox:
	
	li $t8, 0									# load immwdiate value 0 to t8
	la $s7, boxCheckingArray							# load the address of boxCheckingArray to s7
	
	posibilityOfMakingBoxLoop:
		
		li $t5, 0								# load immediate value 0 to t5
		beq $t8, 9, breakPosibilityOfMakingBoxLoop				# if t8=9 goto breakPosibilityOfMakingBoxLoop
		
		lw $t7, 0($s7)								# load the value of boxCheckingArray[t8] to t7
		
		move $a1, $t7								# a1=t7
		jal isThePlaceIsEmpty							# call the function isTheEmpty 
		addu $t5, $t5, $t1							# t5 = t5+t1
		
		
		addiu $t7, $t7, -1							# t7= t7 - 1							
		move $a1, $t7								# a1 = t7
		jal isThePlaceIsEmpty							# call the function isThePlaceIsEmpty	
		addu $t5, $t5, $t1							# t5 = t5+t1
		
		
		addiu $t7, $t7, 2							# t7 = t7-2
		move $a1, $t7								# a1=t7
		jal isThePlaceIsEmpty							# call the function isThePlaceIsEmpty	
		addu $t5, $t5, $t1							# t5 = t5+1
	
		addiu $t7, $t7, -11							# t7 = t7+(-11)
		move $a1, $t7								# a1 = t7
		jal isThePlaceIsEmpty							# call the function isThePlaceIsEmpty	
		addu $t5, $t5, $t1							# t5 = t5+t1
		
		beq $t5, 3,gotAPossibleValue						#if t5=3 goto gotAPossibleValue
		
		addiu $s7, $s7, 4							# s7 = s7+4
		addiu $t8, $t8, 1							# t8 = t8+1
		
		j posibilityOfMakingBoxLoop						# jump to label posibilityOfMakingBoxLoop

		
breakPosibilityOfMakingBoxLoop:
		j startOfLinearSearch							# jump to label startOfLinearSearch 	

##
##	end of probabilityOfBoxes
#__________________________________________________________________________________________________________________________________


##
##	start of playComputer
#____________________________________________________________________________________________________________________________________
	
 playComputer:
 	
 	#li $s0, 0
 	
 	j posibilityOfMakingBox								#jump to posibilityOfMakingBox	
 	
 	gotAPossibleValue:						
 		
 		move $t1, $t0								# t1 = t0
 		j findEmptySpace							# jump to findEmptySpace							
 	
 	startOfLinearSearch:
 	
 	li $t0, 0									# load 0 to t0
 	la $t6, validSpaceArray								# load address of validSpaceArray to t6
 	
 	  
 	    
 	linearIndexSearch:
 		
 		#lw $t1, validSpaceArray($t0)
 		lw $t1, 0($t6)								# load word validSpaceArray[t6] to t1
 		lb $t2, box($t1)							# load byte box[t1] to t2
 		
 		beq $t2, ' ', findEmptySpace						# if t2=' ' jump to findEmptySpace
 		beq $t2, '.', findEmptySpace						# if t2='.' jump to findEmptySpace
 		addiu $t0, $t0, 1							# t0 = t0+1
 		addi $t6, $t6, 4							# t6 = t6+4
 		j linearIndexSearch							# jump to linearIndexSearch
 		
 	 findEmptySpace:
 	 	
 	 	li $t0, 10							# load immediate value 10 to t0
 	 	div $t1, $t0							# divide t1 by t0
 	 	mflo $s7							# load result of division to s7
 	 	mfhi $s6							# load module of division to s6
 	 	
 	 	li $t0, 2							# load immediate value 2 to t0
 	 	div $t1, $t0							# divide t1 by t0
 	 	mfhi $t0							# load module of division to t0
 	 	beq $t0, $zero, evenLabel					# if t0 = 0 go to evenLabel
 	 	
 	 	oddLabel:
 	 		li $s3, 95						# load immediate value 95 to s3
 	 		sb $s3, box($t1)					# store byte s3 to box[t1]
 	 		addi $t0, $s7, 97					# t0 = s7+97
 	 		sb ,$t0, character2					# store byte t0 to character2
 	 		sb ,$t0, character1					# store byte t0 to character1
 	 		
 	 		li $t0, 2						# load immediate value 2 to t0
			div $t0, $s6, $t0  					# t0 = s6/t0
			sw $t0, number1						# store word t0 to number1
			addi $t0, $t0, 1					# t0 = t0+1
			sw $t0, number2						# store word t0 to number2
 	 		
 	 		j printFoundIndex					# jump to label printFoundIndex
 	 		
 		evenLabel:
 			li $s3, 124						# load immediate value 124 to s3
 			sb $s3, box($t1)					# store byte box[t1] to s3
 			addi $t0, $s7, 97					# t0 = s7+97
 			sb ,$t0, character2					# store byte t0 to character2
 			addi $t0,  $t0, -1					# t0 = t0+(-1)
 			sb ,$t0, character1					# store byte t0 to character1
			
			li $t0, 2						# load immediate value 2 to t0
			div $t0, $s6, $t0  					# t0 = s6/t0
			sw $t0, number1						# store word t0 to number1
			sw $t0, number2						# store word t0 to number2
		
			j printFoundIndex					# jump to label printFoundBox
		
		printFoundIndex:
			
			la $a0, messageOfComputerInput1				# load the address of messageOfComputerInput1 to a0
			li $v0, 4						# load 4 to v0 to print
			syscall
			
			lb $a0, character1					# load byte character1 to a0
			li $v0, 11						# load 11 to to print byte
			syscall
			
			lw $a0, number1						# load word number1 to a0
			li $v0, 1						# load immediate 1 to v0
			syscall	
			
			la $a0, messageOfComputerInput2				# load the adrress of messageOfComputerInput2 a0
			li $v0, 4						# load 4 to v0 to print 
			syscall	
			
			lb $a0, character2					# load byte character2 to a0
			li $v0, 11						# load 11 to vo to print byte
			syscall
			
			lw $a0, number2						# load word number2 to a0
			li $v0, 1						# load 1 to v0 to print 
			syscall	
			
			la $a0, newLine						# load  adddress of newLine to a0
			li $v0, 4						# load 4 to v0 print
			syscall
			
			j  boxChecking						# jump to boxChecking
				

################### computerPlay end
#___________________________________________________________________________________________________________________________________

################### user play start
#___________________________________________________________________________________________________________________________________

playUser:
	
	la $a0, userInputMessage						# load address of userInputMessage to a0					
	li $v0, 4								# load 4 to v0 to print
	syscall
	
	takeValidInput:
		
		firstInput:
		
			la $a0,userInputPromt1					# load address of userInputPromt1 to a0	
			li $v0, 4						# load 4 to v0 to print
			syscall
		
			li $v0, 12						# load 12 to to v0 to take a character input
			syscall
			move $t0, $v0						# t0 = v0
			
			li $v0, 5						# load 5 t0 v0 to take input
			syscall 
			move $t1, $v0						# t1=v0
			
			blt $t0, 97, invalid1					# if t0<97 go to invalid1
			bgt $t0, 100, invalid1					# if t0>100 got to invalid1
			blt $t1, 1, invalid1					# if t1<1 go to invalid1
			bgt $t1, 4, invalid1					# if t1>4 go to invalid1
			
			sb $t0, character1					# store byte t0 to character1
			sw $t1, number1						# store word t1 to number1
			
		secondInput:
			
			la $a0,userInputPromt2					# load address of userInputPromt2 to a0	
			li $v0, 4						# load 4 to v0 to print						
			syscall
		
			li $v0, 12						# load 12 to to v0 to take a character input
			syscall
			move $t0, $v0						# t0 = v0
			
			li $v0, 5						# load 5 t0 v0 to take input
			syscall 
			move $t1, $v0						# t1=v0
			
			blt $t0, 97, invalid2					# if t0<97 go to invalid2
			bgt $t0, 100, invalid2					# if t0>100 got to invalid2					
			blt $t1, 1, invalid2					# if t1<1 go to invalid2
			bgt $t1, 4, invalid2					# if t1>4 go to invalid2					
			
			sb $t0, character2					# store byte t0 to character2
			sw $t1, number2						# store word t1 to number2
			
			lb $t0, character1					# load byte t0 to character1
			lb $t1, character2					# load byte t1 to character2
			lw $t2, number1						# load word t2 to number1
			lw $t3, number2						# load word t3 to number2
			
			j rowcheck						# jump to rowcheck
			
		invalid1:
			
			la $a0, wrongInputMessage				# load address of wrongInputMessage to a0
			li $v0, 4						# load 4 to v0 to print
			syscall
			
			j firstInput						# jump to firstInput
		
					
		invalid2:
			
			la $a0, wrongInputMessage				# load address of wrongInputMessage to a0
			li $v0, 4						# load 4 to v0 to print
			syscall
			
			j secondInput						# jump to secondInput
			
		rowcheck:
			
			
			bne $t0, $t1, columnCheck				# if t0 != t1 goto columnCheck
			sub $t4, $t2, $t3					# t4 = t2-t3
			abs $t4, $t4						# t4 = |t4|
			bne $t4, 1, invalid1					# if t4 != 1 go to invalid1
			
			addu $t4, $t2,$t3					# t4 = t2+t3
			addi $t2, $t0, -97					# t2 = t0+(-97)
			li $t3, 10						# load immediate value 10 to t3
			mult $t2, $t3						# multiply t2 and t3
			mflo $t2						# load the result of multiplication to t2
			addu $t2, $t2, $t4					# t2 = t2 + t4
			li $t3, 95						# load immediate 95 to t3 for setting t3='_'
			
			lb $t4, box($t2)					# load byte box[t2] to t4
			bne $t4, 32, invalid3					# if t4 != 32 goto invalid3
			sb $t3, box($t2) 					# store byte t3 to box[t2]
			 
			j boxChecking						# jump to boxChecking
			
			
	columnCheck:
			
			bne $t2, $t3, invalid1					# if t2 != t3 goto invalid1
			sub $t3, $t0, $t1					# t3 = t0 + t1
			abs $t3, $t3						# t3 = abs(t3)
			bne $t3, 1, invalid1					# if t3 != 1  goto invalid1
			
			bgt $t0, $t1, swapCharacter				# if t0 > t1 goto swapCharacter
			j swapCompleted						# jump swapCompleted
					
			swapCharacter:						
				move $t1, $t0					# t1 = t0		
	
	swapCompleted:
				
			li $s0, 97						# load immediate value 97 to s0
			sub $t0, $t1, $s0					# t0 = t1 - s0
			li $t1, 10						# load immediate value 10 to t1				
			mult $t1, $t0						# multiply t1 and t0
			mflo $t0						# load result of multiplication to t0
			addu $t2, $t2, $t2					# t2 = t2 + t2
			addu $t0, $t0, $t2					# t0 = t0 + t2
			
			lb $t4, box($t0)					# load byte value of t4 to box[t0]
			beq $t4, 124, invalid3					# if t4 != 124 goto invalid3
			li $t4, 124						# load immediate value 124 to t4
			sb $t4, box($t0)					# load byte value of t4 to box[t0]
			
			j boxChecking						# jump boxChecking
			
		
	invalid3:				
		
		la $a0, wrongInputMessage2					# load address of wrongInputMessage2 to a0
		li $v0, 4							# load immediate value 4 to v0
		syscall								# print a string
		
		j firstInput							# jump to firstInput
		


################## user play end
##______________________________________________________________________________________________________________________________________


##		start winBeforeEnd
##______________________________________________________________________________________________________________
winBeforeEnd:
    jal printBox								# calling printBox
    j printResult								# jump to printResult
##
##	end of winBeforeEnd
#_____________________________________________________________________________________________________________________________________

######################################		
exit:						
	li $v0, 10								# load immediate value 10 to v0
	syscall									# exit from program
#####################################
