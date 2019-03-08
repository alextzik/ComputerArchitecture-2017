######################## 1st Exercise ###########################
######## Alexandros Tzikas ############
############################# Αρχιτεκτονική Υπολογιστών #######################

###### Filename: MatrixMult.s ##########
########### 18.04.2017 ####################################




######### Data Segment #########
.data

######## Matrices #######
	A:		.space 32
	B:		.space 32
	C:		.space 32
######## Strings ########
	astr11: .asciiz "a(1,1)="
	astr12: .asciiz "a(1,2)="
	astr21: .asciiz "a(2,1)="
	astr22: .asciiz "a(2,2)="
	bstr11: .asciiz "b(1,1)="
	bstr12: .asciiz "b(1,2)="
	bstr21: .asciiz "b(2,1)="
	bstr22: .asciiz "b(2,2)="
	cstr11: .asciiz "c(1,1)="
	cstr12: .asciiz " c(1,2)="
	cstr21: .asciiz "\nc(2,1)="
	cstr22: .asciiz " c(2,2)="

######## Special Characters ########
nl: .asciiz "\n"
	




.text 

.globl my_main

my_main:
	#set addressesof matrices in $a0, $a1, $a2 
		la $a0, A
		la $a1, B
		la $a2, C

		addi $t0, $a0, 0 ##$a0, $a1 will be used in syscalls so A-> $t0, B -> $t1
		addi $t1, $a1, 0
	#get values for matrix cells
	##### Matrix A ######	
		#display astr11
		li $v0, 4
		la $a0, astr11
		syscall
		#get a(1,1) input
		li $v0, 7
		syscall
		sdc1 $f0, 0($t0)


		#display astr12
		li $v0, 4
		la $a0, astr12
		syscall
		#get a(1,2) input
		li $v0, 7
		syscall
		sdc1 $f0, 8($t0)


		#display astr21
		li $v0, 4
		la $a0, astr21
		syscall
		#get a(2,1) input
		li $v0, 7
		syscall
		sdc1 $f0, 16($t0)


		#display astr22
		li $v0, 4
		la $a0, astr22
		syscall
		#get a(2,2) input
		li $v0, 7
		syscall
		sdc1 $f0, 24($t0)


	###### Matrix B #####
		#display bstr11
		li $v0, 4
		la $a0, bstr11
		syscall
		#get b(1,1) input
		li $v0, 7
		syscall
		sdc1 $f0, 0($t1)

		#display bstr12
		li $v0, 4
		la $a0, bstr12
		syscall
		#get b(1,2) input
		li $v0, 7
		syscall
		sdc1 $f0, 8($t1)


		#display bstr21
		li $v0, 4
		la $a0, bstr21
		syscall
		#get b(2,1) input
		li $v0, 7
		syscall
		sdc1 $f0, 16($t1)


		#display bstr22
		li $v0, 4
		la $a0, bstr22
		syscall
		#get b(2,2) input
		li $v0, 7
		syscall
		sdc1 $f0, 24($t1)

		##!!!!matrix addresses loaded to $a0, $a1, $a2!!!
		##input saved as a matrix

		la $a0, A
		la $a1, B
		la $a2, C

		jal mm ### jump-and-link to matrix mult branch
			   ### address of "print c(1,1) in $ra"




##print c(1,1)
	la $a0, cstr11
	li $v0, 4

	syscall
	ldc1 $f12, 0($a2)
	li $v0, 3
	syscall

##print c(1,2)
	la $a0, cstr12
	li $v0, 4

	syscall
	ldc1 $f12, 8($a2)
	li $v0, 3
	syscall

##print c(2,1)
	la $a0, cstr21
	li $v0, 4

	syscall
	ldc1 $f12, 16($a2)
	li $v0, 3
	syscall

##print c(2,2)
	la $a0, cstr22
	li $v0, 4

	syscall
	ldc1 $f12, 24($a2)
	li $v0, 3
	syscall


#### Exit #####
	li	$v0, 10
	syscall	








##Διαδικασία Προς Κλήση - 3πλό FOR
mm:
#save $s0, $s1, $s2
addi $sp, $sp, -12
sw $s0, 8($sp)
sw $s1, 4($sp)
sw $s2, 0($sp)

#creating the nested for-pass addresses as parameters
	addiu $t2, $zero, 1
	andi $t0, 0x0
	andi $t1, 0x0

for:
	##set address of a[i][k] in a register
		sll $t0, $s0, 1
		add $t0, $t0, $s2
		sll $t0, $t0, 3
		add $t0, $t0, $a0 ##$t0 contains a[i][k] address
		ldc1 $f0, 0($t0)

	##set address of b[k][j] in a register
		sll $t1, $s2, 1
		add $t1, $t1, $s1
		sll $t1, $t1, 3
		add $t1, $t1, $a1 ##$t1 contains b[k][j] address
		ldc1 $f2, 0($t1)

	##set address of c[i][j] in a register
		sll $t3, $s0, 1
		add $t3, $t3, $s1
		sll $t3, $t3, 3
		add $t3, $t3, $a2 ##t3 contains address of c[i][j]
		ldc1 $f4, 0($t3)
	#multiply a[i][k]*b[k][j]
	mul.d $f0, $f0, $f2
	add.d $f4, $f4, $f0
	sdc1 $f4, 0($t3)



	bne $s2, $t2, L1 #if k!=2 go to L1
		andi $s2, 0x0 #else k=0

	bne $s1, $t2, L2 #if j!=2 go to L2
		andi $s1, 0x0

	bne $s0, $t2, L3 #if i!=2 go to L3
		j EXIT

L1:
	addiu $s2, $s2, 1
	j for

L2:
	addiu $s1, $s1, 1
	j for

L3:
	addiu $s0, $s0, 1
	j for
EXIT:

#return previous values to registers
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	