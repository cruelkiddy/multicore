org 0x0000
MAIN:
	ori $29, $0, 0xFFFC
	ori $3, $0, 0x0003
	ori $4, $0, 0x0004
	push $3
	push $4
        jal MULTI
	halt        
MULTI:
	pop $5
	pop $6
        ori $7, $0, 0
	ori $8, $0, 0

LOOP:	beq $7, $5, END
	add $8, $8, $6
	addi $7, $7, 1
	j LOOP

END:	jr $31



	
