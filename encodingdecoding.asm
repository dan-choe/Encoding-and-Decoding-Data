##############################################################
# Homework #2
# name: DAN CHOE
# sbuid: 110131643
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

atoui:

    beq $t5, 1, runBack
    #Define your code here
    li $t1, 0			# sum = 0
    li $t2, 10			# set $t2 = 10 for multiplication
    li $t3, '0'			# set $t3 = '0' for subtraction (48)
   
    		la $s3 ($a0)				# Load address of $a0
    		L3:   					# 
			lb $s2,0($s3)			# Read a character by each address of string
			beqz $s2,L3end			# Loop end if string is end
			move $s4, $s2			# converting value
			addi $s3,$s3,1			# Add 1 to Address(Current Pointer)
			j L4				# L4 : Convert String to Integer
			
# L4 : Convert String to Integer
L4:
	bge $s4, '0', if2		# character >= '0' and if1, else break
	j L3end				# until the end of the string is reached or an invalid character is reached
	
if2:
	ble $s4, '9', convert		# character <= '9'
	j L3end
	
convert:
	mult $t1, $t2
	mflo $t1
	sub $s4, $s4, $t3
	add $t1, $t1, $s4
	j L3				# Go back to L3 in order to read next character   
   	
L3end:
	move $v0, $t1
	jr $ra

runBack:
	jr $ra
	
####################################################################################################


uitoa:
	# To count length of string
	la $s3, ($a0)				# Load address of $a0 ---- uitoa_output '987654321'
	li $t4, 0				# Holds the counted length of string
    	li $t2, 10				# set $t2 = 10 for divide
    	
    	ble $s3, 0, InvaildConvert
	
	ForLength:
		divu $s3, $t2			# Divide by 10 to get rightmost digit
    		mflo     $s3                    # get lo  = quotient
		addi $t4,$t4,1			# Add 1
		blt  $s3, $t2, EndForLength		# EndForLength:  if the value is less then 10
		j ForLength
	
	EndForLength:
		beqz $s3, passLine
		addi $t4,$t4,1
		passLine:
		j CheckOutputsize
		
	CheckOutputsize:
		move $t5, $a2
		bgt $t4, $t5, InvaildConvert
		
	
# Convert Integer to String
    la $t1, 0($a1)			# Load address of $a1 0x400
    add $t1, $t1, $t4			# Move pointer to length of string (ex: 0x403)
    addi $t1, $t1, -1
    					# $t4 holds the length
    
    li $t2, 10				# set $t2 = 10 for divide
    li $t3, '0'				# set $t3 = 48 for add
   
    la $s1 ($a0)				# Load address of $a1 ---- uitoa_output '987654321'		

    	For1:
    		blt $s1, 10, onedigit
    		divu $s1, $t2			# Divide by 10 to get rightmost digit
    		mflo     $s1                    # get lo  = quotient
        	mfhi     $t5			# get hi = remainder
        	add $t5 $t5 $t3			# $s4 = $s4 + 48	Convert into ASCII char
        	
    		sb $t5 ($t1)
    		#beq $t7, 1, skipliness		# Set $7 = 0 as usecase of runLengthEncode
    		addi $t1,$t1,-1
    		#skipliness:
    		blt  $s1, $t2, EndFor1		# EndFor1  if the value is less then 10
    		
        	j For1
        	
        onedigit:
        	add $s1 $s1 $t3			# $s1 = $s1 + 48	Convert into ASCII char
        	sb $s1 0($t1)
        	addi $t1,$t1,1
        	jr $ra
			
	EndFor1:
		add $s1 $s1 $t3			# $s1 = $s1 + 48	Convert leftmost digit into ASCII char				
		sb $s1 ($t1)			# Store
    		addi $t1,$t1,-1
    		
    		add $t1, $t1, $t4
    		addi $t1, $t1, 1		# After add 2 > 1   for 12, move 2 point
    		li $t4, 100
    		la $v0, ($t1)			# holds the first return value
    		li $v1, 1			# holds the second return value
    		
    		jr $ra
    
InvaildConvert:
		la $v0, ($a1)
		li $v1, 0
	    	jr $ra

    
    

##############################
# PART 2 FUNCTIONS 
##############################    

decodedLength:
    #Define your code here
    
    li $t8, 0				# Count the total char for returning value
    
    bnez $s5 skipLines				# This function is called from runLengthDecode
    						# So, do not set values again.
    
    la $s1 ($a1)				# Load address of $a1 - hold the symbol
    lb $s1, 0($s1)
    li $s5, 0					# reset $s5 = 0
    
    skipLines:
    
    bge $s1, 65, NOTsymbolFlag			# Do not Decode - END
    
    # Symbol is correct. Just Keep progress!
    la $s3 ($a0)				# Load address of $a0 - Read input
    
    
    # To count length of string
	#la $s3, ($a0)				# Load address of $a0 ---- uitoa_output '987654321'
	#li $t4, 0				# Holds the counted length of string
    	#li $t2, 10				# set $t2 = 10 for divide
	
	ForDecodedLength:
		lb $t1, 0($s3)			# Read leftmost char of input
		beqz  $t1, EndForDecodedLength	# EndForDecodedLength: Read all input string
		beq $t1, $s1, Flag 		# Found the flag symbol
		#blt $t1, 48, NOTsymbolFlag	# This is symbol but not same as flag. ERROR CASE
		
		addi $s3, $s3, 1		# Move pointer 1 to right
		addi $t8, $t8, 1		# Count
	
		j ForDecodedLength
	
	Flag:
		addi $s3, $s3, 3		# Move pointer 3 to right to read a number
		
		# Must check the number is 1 digit or more
		lb $t1, 0($s3)			# Read leftmost char of input
		ble $t1, 57, ReadNextNumber1	# The number is not 1 digit! or just pass the line :D
		
		addi $s3, $s3, -1
		lb $t1, 0($s3)			# Read leftmost char of input
		li $t3, '0'			# Set $t3 = 48
		sub $t1, $t1, $t3		# Convert string number to integer
		add $t8, $t8, $t1		# Count
		addi $s3, $s3, 1		# Move pointer 1 to right
		
		j ForDecodedLength		# Go back to loop to read next character
		
	# The next of number might be 0. This means there is no more string, so just read a number
	ReadNextNumber1:
		#beq $t1, $s1, ReadNextNumber4
		bge $t1, 48, ReadNextNumber2	# That is another symbol. you just have one digit number
				#bnez $t1, ReadNextNumber4	# if it is not zero
				#PassSymbol2:	
		#bge $t1, 48, PassSymbol 	# That is another symbol. you just have one digit number
		#bnez $t1, ReadNextNumber2	# if it is not zero
		#PassSymbol:	 
		addi $s3, $s3, -1
		lb $t1, 0($s3)
		sub $t1, $t1, $t3		# Convert string number to integer
		add $t8, $t8, $t1		# Count
		addi $s3, $s3, 1
		j ForDecodedLength
		
	# The number is bigger than 9.
	ReadNextNumber2:
		li $t2, 10			# Set $t3 = 10 for multification
		li $t3, '0'			# Set $t2 = 48 for converting
		
		addi $s3, $s3, -1
		lb $t1, 0($s3)
		sub $t1, $t1, $t3		# Convert string number to integer
		mul $t1, $t1, $t2
		add $t8, $t8, $t1		# Count
		addi $s3, $s3, 1
		
		lb $t1, 0($s3)
		sub $t1, $t1, $t3		# Convert string number to integer
		add $t8, $t8, $t1		# Count
		addi $s3, $s3, 1		# Move pointer 1 to right
		j ForDecodedLength		# Go back to loop to read next character
		
	
	EndForDecodedLength:
		beqz $t8, NOTsymbolFlag		# if the return value is 0, it has error case.
		addi $t8, $t8, 1		# Add 1 for \0
		beq $s5, 1, gobackRunLengthDecodeSTACK
		move $v0, $t8
		jr $ra
    
    NOTsymbolFlag:
    		li $v0, 0
    		jr $ra
    
    gobackRunLengthDecodeSTACK:
    		jr $ra
                                                
decodeRun:
	#li $t8, 0				# Loop Run until reach 0
	
	bnez $s5, skipLine			# $s3 is already holded the input character
	
	la $s3 ($a0)				# Load address of $a1 - hold input
   	lb $s3, 0($s3)				# Load char
   	# Check input is a letter or symbol
   	blt $s3, 65, ERRORCASE
   	
   	skipLine:
   	
   	la $s4 ($a1)				# Load address of $a1 - hold a number for runLength
   	la $s2 ($a2)				# Location of output string
   	
   	
   	ble $s4, 0, ERRORCASE
	
	ForDecodeRun:
		beqz $s4, ENDForDecodeRun
		sb $s3, 0($s2)
		addi $s4, $s4, -1
		addi $s2, $s2, 1
		j ForDecodeRun
	
	ENDForDecodeRun:
		move $s3, $s6
		beq $s5, 1, ComebackFromDecodeRun
		move $v0, $s2
    		li $v1, 1
    		jr $ra
	
	
	ERRORCASE:
		move $v0, $a2
    		li $v1, 0
    		jr $ra
         
runLengthDecode:
	la $s1, ($a3)		# Set Symbol
	lb $s1, 0($s1)
	la $s2, ($a1)		# Set the location of output
	la $s4, ($a2)		# Set the total length				#Set the runLength number
	
	#move $a2, $s2		# Set the location of output into argu
	#move $a1, $s4		# Set the total length into argu
	
	li $s5, 1		# if $s5 holds 1, the program runs for runLengthDecode function

	addi $sp, $sp, -12
	sw $ra, 0($sp)		
	sw $s2, 4($sp)		# Set the location of output into argu
	sw $s4, 8($sp)		# Set the total length into argu
			
	jal decodedLength		# Check the input has vaild given size
    	
    	lw $ra, 0($sp)
	lw $s2, 4($sp)
	lw $s4, 8($sp)
	addi $sp, $sp, 12
    	
    	
    	# Compare the requiring size of input
    	gobackRunLengthDecode:
    		bgt $t8, $s4, InvaildInputsize
    		la $s3 ($a0)				# Load address of $a0 - hold input
   		
   		addi $sp, $sp, -4
		sw $ra, 0($sp)	
   		
   		ForCheckWrongSymbol:
    			lb $t5, 0($s3)				# Load char
   			beqz $t5, ForStoreLetter2
   			# Check input is a letter or symbol
   			blt $t5, 48, symbolcheck		# Check Wrong symbol case
   			combacksymbol:
   			addi $s3, $s3, 1
   			j ForCheckWrongSymbol
   			
   			symbolcheck:
   				bne $t5, $s1, InvaildInputsize
   				j combacksymbol
   				
   		ForStoreLetter2:
   			la $s3 ($a0)
   			j ForStoreLetter
   			
    		ForStoreLetter:
    			lb $t5, 0($s3)				# Load char
   			beqz $t5, endRunLengthDecode
   			# Check input is a letter or symbol
   			beq $t5, $s1, FlagSymbol
   			#ble $s4, 0, ERRORCASE
   			
   			sb $t5, 0($s2)
   			addi $s2, $s2, 1
   			addi $s3, $s3, 1
   			j ForStoreLetter
   				
   			
   			ComebackFromDecodeRun:
   				move $s3, $s6		# Store current point of input
   				j ForStoreLetter
   					
   			
   			FlagSymbol:
				addi $s3, $s3, 3		# Move pointer 3 to right to read a number
		
				# Must check the number is 1 digit or more
				lb $t1, 0($s3)			# Read leftmost char of input
				ble $t1, 57, ReadNextNumber3	# The number is not 1 digit! or just pass the line :D
		
				addi $s3, $s3, -1
				lb $t1, 0($s3)			# Read leftmost char of input
				li $t3, '0'			# Set $t3 = 48
				sub $t1, $t1, $t3		# Convert string number to integer
				
				move $a1, $t1			# Store the runLength number
				lb $t1, -1($s3)			# Read the char which have to duplicate
				#move $a0, $t1			# Store the char
				addi $s3, $s3, 1
				
				move $s6, $s3			# Store current point of input
				move $s3, $t1
				move $a2, $s2			# Store current point of output
				
				#addi $sp, $sp, -12
				#sw $ra, 0($sp)		
				#sw $t1, 4($sp)		# Set the location of output into argu
				#sw $s3, 8($sp)		# Store current point of input
			
				jal decodeRun		# Go to the decodeRun to duplicate the char
    	
    				#lw $ra, 0($sp)
				#lw $t1, 4($sp)
				#lw $s3, 8($sp)		# Store current point of input
				#addi $sp, $sp, 12

				addi $sp, $sp, -4
				sw $ra, 0($sp)
				
				jal atoui		# Go to the decodeRun to duplicate the char
    	
    				lw $ra, 0($sp)
				addi $sp, $sp, 4				
				
				
				
			# The next of number might be 0. This means there is no more string, so just read a number
			ReadNextNumber3:
				#beq $t1, $s1, ReadNextNumber4
				bge $t1, 48, ReadNextNumber4	# That is another symbol. you just have one digit number
				#bnez $t1, ReadNextNumber4	# if it is not zero
				#PassSymbol2:	 
				addi $s3, $s3, -1
				lb $t1, 0($s3)
				sub $t1, $t1, $t3		# Convert string number to integer
				
				move $a1, $t1			# Store the runLength number
				lb $t1, -1($s3)			# Read the char which have to duplicate
				#move $a0, $t1			# Store the char
				addi $s3, $s3, 1
				
				move $s6, $s3			# Store current point of input
				move $s3, $t1
				move $a2, $s2			# Store current point of output
				
				#addi $sp, $sp, -12
				#sw $ra, 0($sp)		
				#sw $t1, 4($sp)		# Set the location of output into argu
				#sw $s3, 8($sp)		# Store current point of input
			
				jal decodeRun		# Go to the decodeRun to duplicate the char
    	
    				#lw $ra, 0($sp)
    				#jr $ra
				#lw $t1, 4($sp)
				#lw $s3, 8($sp)		# Store current point of input
				#addi $sp, $sp, 12
				
				
			# The number is bigger than 9.
			ReadNextNumber4:
				li $t2, 10			# Set $t3 = 10 for multification
				li $t3, '0'			# Set $t2 = 48 for converting
				
				addi $s3, $s3, -1
				lb $t1, 0($s3)
				sub $t1, $t1, $t3		# Convert string number to integer
				mul $t1, $t1, $t2
				move $s7, $t1
				addi $s3, $s3, 1
		
				lb $t1, 0($s3)
				sub $t1, $t1, $t3		# Convert string number to integer
				add $t1, $t1, $s7
				move $a1, $t1			# Store the runLength number
				lb $t1, -2($s3)			# Read the char which have to duplicate
				#move $a0, $t1			# Store the char
				addi $s3, $s3, 1
				
				move $s6, $s3			# Store current point of input
				move $s3, $t1
				move $a2, $s2			# Store current point of output
				
				#addi $sp, $sp, -12
				#sw $ra, 0($sp)		
				#sw $t1, 4($sp)		# Set the location of output into argu
				#sw $s3, 8($sp)		# Store current point of input
			
				jal decodeRun		# Go to the decodeRun to duplicate the char
    	
    				#lw $ra, 0($sp)
				#lw $t1, 4($sp)
				#lw $s3, 8($sp)		# Store current point of input
				#addi $sp, $sp, 12
		
   	endRunLengthDecode:
   		li $v0, 1
   		li $s7, '\0'
   		sb $s7, 0($s2)				# Add null terminator
    		#li $v1, 1
    		lw $ra, 0($sp)
    		addi $sp, $sp, 4
    		#move $s6, $s3
    		jr $ra	
   		
    	
    	InvaildInputsize:
    		li $v0, 0
    		li $v1, 0
    		jr $ra
    
    

##############################
# PART 3 FUNCTIONS 
##############################

                # g                
encodeRun:
	
	la $s3, ($a0)		# Load address Input
	beq $t7, 1, skiplines		# Set $7 = 0 as usecase of runLengthEncode
	
	lb $s3, 0($s3)		# Hold individual letter
	
	skiplines:
	la $s4, ($a1)		# Available input length
	la $s2, ($a2)		# Output Address
	
	la $s1, ($a3)		# Symbol
	lb $s1, 0($s1)		# Hold Symbol
	
	bgt $s1, 48, InvaildType	# the given symbol is not vaild type
	blt $s3, 65, InvaildType	# the given letter is not vaild type
	blt $s4, 1, InvaildType		# the given length is not vaild
	
	bgt $s4, 3, VaildFlag
	
	#Does not need to put flag case. length < 4
	ForUnflag:
		beqz $s4, EndEncode2
		sb $s3, 0($s2)
		addi $s2, $s2, 1
		addi $s4, $s4, -1
		j ForUnflag
	
	VaildFlag:
		sb $s1, 0($s2)		# Store symbol
		addi $s2, $s2, 1
		sb $s3, 0($s2)		# Store letter
		addi $s2, $s2, 1
		#sb $s4, 0($s2)		# Store length
		#addi $s2, $s2, 1
		
		move $a0, $s4		# Set the length
		move $a1, $s2		# Output location
		li $a2, 100		# Set outputSize. 
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)		
		jal uitoa		# Go to the uitoa to convert integer to string
		
		lw $ra, 0($sp)
    		addi $sp, $sp, 4
		
		j EndEncode
	
	EndEncode:
		addi $s2, $s2, 1
		move $t0, $s2
		li $v1, 1
    		jr $ra
    	EndEncode2:
    		#addi $s2, $s2, 1
		move $t1, $s2
		li $v1, 1
    		jr $ra
	
	
	InvaildType:
		move $v0, $a2
		li $v1, 0
    		jr $ra  

encodedLength:
	li $s1, 0 		# check length of same letter
	li $s4, 0 		# Total result value
	
	la $s2, ($a0)		# Load address Input
	lb $s3, 0($s2)		# Hold individual letter
	beqz $s3, invaildEncode
	
	ForCountLength:
		lb $s5, 0($s2)

		beqz $s5, EndCountLength
		bne $s3, $s5, anotherCountLength	# if it meets another letter, stop counting
		
		addi $s1, $s1, 1 			# Count the length of same letter
		addi $s2, $s2, 1 			# Move pointer
		j ForCountLength
		
	anotherCountLength:
		beq $t7, 1, skipline01			# Bring the length to runLengthEncode
		bgt $s1, 3, convertAsFlag		# Convert to Flag if $s1 => 4
		add $s4, $s4, $s1			# Add up the length if $s1 < 4
		li $s1, 0
		move $s3, $s5
		
		j ForCountLength
		
	skipline01:
		# You completely read all of same letter. Bring the length to runLengthEncode
		# $s1 holds the length. encodeRun will store
		jr $ra
		
	convertAsFlag:
		bge $s1, 10, add2		# if $s1 >= 10, add 2
		addi $s4, $s4, 1			# if $s1 < 9, add 1
		addi $s4, $s4, 2			# !j
		li $s1, 0
		move $s3, $s5
		j ForCountLength
	add2:
		addi $s4, $s4, 2			# if $s1 < 9, add 1
		addi $s4, $s4, 2			# !j
		li $s1, 0
		move $s3, $s5
		j ForCountLength
	
	addchar:
		add $s4, $s4, $s1			# Add length of letter < 4
		addi $s4, $s4, 1			# Add 1 for null terminators
		move $v0, $s4
		jr $ra
	
	EndCountLength:
		beq $t7, 1, skipline01			# Bring the length to runLengthEncode
		bgt $s1, 3, convertAsFlag			# Only a letter has
		bgt $s1, 0, addchar
		addi $s4, $s4, 1			# Add 1 for null terminators
		move $v0, $s4
		jr $ra
       
       invaildEncode:
       		li $s4, 0
       		li $s1, 0
       		li $v0, 0
		jr $ra
    

runLengthEncode:
	li $t7, 1		# Set $7 = 0 as usecase of runLengthEncode
    	la $s3, ($a0)		# Load address Input
	
	la $s2, ($a1)		# Output Address
	move $t6, $s2
	la $s4, ($a2)		# Available input length
	
	la $s1, ($a3)		# Symbol
	lb $s1, 0($s1)		# Hold Symbol
	
	bgt $s1, 48, InvaildType	# the given symbol is not vaild type
	#blt $s3, 65, InvaildType	# the given letter is not vaild type
	blt $s4, 1, InvaildType		# the given length is not vaild
	
	#bgt $s4, 4, VaildFlag
	li $t9, 0		# check the length of each letter
	lb $s6, 0($s3)		# Hold individual letter
    	ForReadInput:
    		lb $s7, 0($s3)
    		beqz $s7, EndForReadInput
    		bne $s7, $s6, otherCountLength	# if it meets another letter, stop counting
    		addi $t9, $t9, 1 			# Count the length of same letter
		addi $s3, $s3, 1 			# Move pointer
    		j ForReadInput
    
	otherCountLength:
		bgt $t9, 3, LinkencodedLength		# Convert to Flag if $s1 => 4
		#add $s4, $s4, $s1			# Add up the length if $s1 < 4
		ForStoreLetters:
			beqz $t9, EndForStoreLetters
			sb $s6, 0($s2)
			addi $s2, $s2, 1
			addi $t9, $t9, -1
			j ForStoreLetters
			
		EndForStoreLetters:
			# save the current pointer of output where it is stopped printing
			move $t6, $s2
			move $s6, $s7
			j ForReadInput
    	
    	LinkencodedLength:
    		addi $sp, $sp, -16
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $s3, 12($sp)			# Save the latest pointer of input to read it later
		
		sub $s3, $s3, $t9		# Move back to String the letter from the current pointer
		move $a0, $s3			# Set current pointer of input
    		jal encodedLength
    		
    		move $a1, $s1			# run length from encodedLength
    		la $a0, ($s6)			# the run letter
    		move $a2, $t6			# the location of output
    		move $s2, $t1			# the symbol
    		
    		jal encodeRun
    		
    		beq $t4, 100, addOne
    		
    		comeback:
    		move $t6, $t1			# output pointer
    		move $s2, $t6
    		
    		lw $ra, 0($sp)
    		lw $a0, 4($sp)
    		lw $a1, 8($sp)
    		lw $s3, 12($sp)
    		addi $sp, $sp, 16
    		
    		lb $s6, 0($s3)			# reset $s6 to read next char
    		li $t9, 0			# reset read the char length
    		
    		j ForReadInput			# Go back to read next char
    	
    	addOne:
    		addi $t1, $t1, 1
    		li $t4, 0
    		j comeback
    		
    	EndForReadInput:
    		bnez $t9, LinkencodedLength
    		li $s7, '\0'
    		#sb $s6, 0($s2)
    		#addi $s2, $s2, -1
    		sb $s7, 0($s2)
    		jr $ra
    	
    
    


.data 
.align 2
