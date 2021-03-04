org 0x0000

MAIN:   ori $29,$0, 0xFFFC
	ori $28,$0, 0xFFF8
	ori $2, $0, 2
	ori $3, $0, 3
	ori $4, $0, 4
	ori $5, $0, 5
	push $2
	push $3
	push $4
	push $5
	jal MULTIP
	halt
MULTIP:	
	beq $29, $28, END
	pop $6
	pop $7
	ori $8, $0, 0
	ori $9, $0, 0
        j LOOP
LOOP:	
	beq $8, $7,LOOP_END
	add $9, $9, $6
	addi $8, $8, 1
	j LOOP

	
LOOP_END: push $9
	  j MULTIP
END:	jr $31
