org 0x0000
	
MAIN:   ori $29,$0, 0xFFFC
       	ori $2, $0, 19 #current day
	ori $3, $0, 8 #current month
	ori $4, $0, 2016 #current year

	ori $10, $0, 2000 #2000
	ori $11, $0, 365 #365
	ori $12, $0, 30 #30
	ori $13, $0, 1 #1
	
	subu $5, $4, $10 #(current year - 2000)
	subu $6, $3, $13 #(current month - 1)

	push $5
	push $11
	push $6
	push $12
	jal MULT_1
	add $20, $9, $2
        ori $9, $0, 0
        jal MULT_1
	add $20, $20, $9
	halt

MULT_1:
	pop $15
	pop $16
	ori $7, $0, 0
	
MULTIP:	
	beq $15, $7, END
	add $9, $9, $16
	addi $7, $7, 1
	j MULTIP

	
END: jr $31


