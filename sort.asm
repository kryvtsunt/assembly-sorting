.globl main 

.data 
count_prompt: .asciiz "Input array size: "
item_prompt: .asciiz " element: "
program_prompt: .asciiz "This program sorts an array of integers using Stooge Sort. Please follow following instructions. \n"
input_prompt: .asciiz "Input "
output_prompt1: .asciiz "Original array:"
output_prompt2: .asciiz "Sorted array:"  
space: .asciiz " "
enter: .asciiz "\n"


.text
main:	
	# $s0 is n - size of the array
	# $s1 is xs - array allocated on heap 
	# $s2 is ys - array to return
	# $s3 is ii to move through the array 
	# $s4 is tmp
	# $s5 is x - element of the array
	
	li $v0, 4
	la $a0, program_prompt
	syscall
	
	# print count_prompt
	li $v0 4
	la $a0, count_prompt
	syscall
	# read integer n - the size of the array 
	li $v0, 5
	syscall
	move $s0, $v0
	
	# set temporary register $t4 to be 4 - size of the integer in bytes 
	li $t4, 4
	
	# set temporary register $t0 to be the size of the array in bytes
	mul $t0, $s0, $t4 
	
	# allocate heap memory for the array
	li $v0, 9 
	move $a0, $t0
	syscall
	move $s1, $v0
	
	li $s3, 0  
	
	# loop to reed n integers
input_loop:

	addi $t0, $s3, 1
	# print prompt
	li $v0, 4
	la $a0, input_prompt
	syscall
	
	# print the number of element
	li $v0, 1
	move $a0, $t0
	syscall
	
	# print prompt
	li $v0, 4
	la $a0, item_prompt
	syscall

	# read item
	li $v0, 5
	syscall
	move $s5, $v0

	# calculate address of $sp1 + 4 * ii
	mul $s4, $s3, $t4
	add $s4, $s1, $s4

	# xs[ii] = x
	sw $s5, 0($s4)

	# increment ii and check whether to keep looping
	addi $s3, $s3, 1
	blt $s3, $s0, input_loop

	# call the sort function
	move $a0 $s0
	move $a1 $s1
	jal sort	
	move $s2, $v0
	
	# call print arrray function to print original array
	move $a0, $s0
	move $a1, $s1
	la $a2, output_prompt1 
	jal output
	
	# print enter
	li $v0, 4
	la $a0, enter
	syscall
	
	# call print array function to print sorted array
	move $a0, $s0
	move $a1, $s2
	la $a2, output_prompt2 
	jal output
	
	#exit 
	li $v0, 10
	syscall 
	

output:
	# function to print an array
	subi $sp, $sp, 24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2 
	
	# set temporary $t4 to 4
	li $t4, 4
	
	# print an output_prompt
	li $v0, 4
	move $a0, $s2
	syscall

	li $s3, 0  

output_loop: 
	# calculate address of $sp + 4 * ii
	mul $s4, $s3, $t4
	add $s4, $s1, $s4
	
	# print space
	li $v0, 4
	la $a0, space
	syscall
	
	# print item
	li $v0, 1
	lw $a0, 0($s4)
	syscall
	
	# check loop condition 
	addi $s3, $s3, 1
	blt $s3, $s0, output_loop
	
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $ra	
	
	# stooge_sort(int* xs, int nn)
	# {
    	# int* ys = malloc(nn * sizeof(int));
    	# for (int ii = 0; ii < nn; ++ii) {
        # ys[ii] = xs[ii];
    	# }
	
    	# stooge_helper(ys, 0, nn - 1);
    	# return ys;
	# }
sort: 	
	# $s0 is n
	# $s1 is xs 
	# $s2 is ys 
	# $s3 is ii
	# $s4 is tmp
	subi $sp, $sp, 28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)			
	
	move $s0 $a0 
	move $s1 $a1
		
	# set temporary register $t4 to be 4 - size of the integer in bytes 
	li $t4, 4
	
	# set temporary register $t0 to be the size of the array in bytes
	mul $t0, $s0, $t4 
	
	# allocate memory on the heap for the array to return
	li $v0, 9 
	move $a0, $t0
	syscall
	
	move $s2, $v0
	
	li $s3, 0  
	
copy_loop:
	# calculate address of $sp1 + 4 * ii
	mul $s4, $s3, $t4
	add $s4, $s1, $s4
	
	# calculate address of $sp2 + 4 * ii
	mul $s5, $s3, $t4
	add $s5, $s2, $s5

	# ys[ii] = x[ii]
	lw $t0, 0($s4)
	sw $t0, 0($s5)

	addi $s3, $s3, 1
	blt $s3, $s0, copy_loop
	
	# temorary register $t1 to store 1
	li $t1, 1
	
	# nn - 1
	sub $s4, $s0, $t1
	
	# call helper function
	move $a0, $s2
	move $a1, $zero
	move $a2 $s4
	jal sort_helper
	
sort_return: 
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	jr $ra
	
	# stooge_helper(int* xs, int ii, int jj) 
	# {
	#     if (xs[ii] > xs[jj]) {
        # int tt = xs[ii];
        # xs[ii] = xs[jj];
        # xs[jj] = tt;
        # }
        # if (jj - ii + 1 > 2) {
        # int kk = (jj - ii + 1) / 3;
        # stooge_helper(xs, ii, jj - kk);
        # stooge_helper(xs, ii + kk, jj);
        # stooge_helper(xs, ii, jj - kk);
        # }
        # }
        
sort_helper: 	
        # $s0 is xs
	# $s1 is tmp1 
	# $s2 is jj 
	# $s3 is ii
	# $s4 is tmp2
	# $s5 is xs[ii]
	# $s6 is xs[jj]
	# $s7 is tmp3

	subi $sp, $sp, 36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)	
	sw $s6, 28($sp)
	sw $s7, 32($sp)		
	
	move $s0 $a0
	move $s3 $a1
	move $s2 $a2

	li $t4, 4 
	# calculate address of $sp1 + 4 * ii
	mul $s4, $s3, $t4
	add $s4, $s0, $s4
	
	# xs[ii]
	lw $s5, 0($s4) 
	
	# calculate address of $sp1 + 4 * jj
	mul $s7, $s2, $t4
	add $s7, $s0, $s7
	
	# xs[jj]
	lw $s6, 0($s7)

	# jj-ii + 1
	move $s1, $s2
	sub $s1, $s1, $s3
	addi $s1, $s1, 1
			
	# first condition		
	bge $s3, $s2, sort_helper_return
	
	# second condition
	ble $s5, $s6, skip	

	sw $s6, 0($s4)
	sw $s5, 0($s7)
	
skip:
	#third condition
	ble $s1, 2, sort_helper_return 
	
	## alculate kk
	div $s1, $s1, 3
	
	# jj - kk
	sub $s5, $s2, $s1
	
	# ii + kk
	add $s6, $s3, $s1
	
	# call sort_helper on the frst 2/3 of array 
	move $a0, $s0
	move $a1, $s3
	move $a2, $s5
	jal sort_helper 
	
	# call sort_helper on the second 2/3 of array 
	move $a0, $s0
	move $a1, $s6
	move $a2, $s2
	jal sort_helper
	
	# call sort_helper on the frst 2/3 of array 
	move $a0, $s0
	move $a1, $s3
	move $a2, $s5
	jal sort_helper
			
sort_helper_return:
	move $v0, $s0
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 36
	jr $ra
	
		
	
