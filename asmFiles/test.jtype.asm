org 0x0000
MAIN:
	ori $3, $0, 0x0003
	ori $4, $0, 0x0004
        jal MULTI
	halt
MULTI:
        ori $7, $0, 0
	ori $8, $0, 0

LOOP:	beq $7, $4, END
	add $8, $8, $3
	addi $7, $7, 1
	j LOOP

END:	jr $31
