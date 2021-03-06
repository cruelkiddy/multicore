#-----------------------------------------------------------------
#First Proceesor
#-----------------------------------------------------------------
  org 0x0000

  ori $a0, $0, 7              
  ori $t9, $0, 0x1000   
  ori $sp, $0, 0x3ffc         
  ori $s4, $0, 0x0500  
  ori $t8, $0, 0              

  ori $t7, $0, 255

  jal crc32
  jal lock
  lw  $s5, 0($s4)
  addiu $s5, $s5, 4
  sw  $v0, 0($s5)
  ori $t8, $v0, 0
  sw  $s5, 0($s4)
  jal unlock

PUSH_LOOP:
  ori $a0, $t8, 0
  jal crc32

  jal lock
  lw  $s5, 0($s4)
  addiu $s5, $s5, 4
  sw  $v0, 0($s5)
  ori $t8, $v0, 0 
  sw  $s5, 0($s4)
  jal unlock

  addiu $t7, $t7, -1
  beq $t7, $0, EXIT0
  j   PUSH_LOOP

EXIT0:
  halt


#------------------------------------------------------
#Lock
lock:
aquire:
  ll    $t0, 0($t9)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($t9)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra
#------------------------------------------------------

#------------------------------------------------------
unlock:
  sw    $0, 0($t9)
  jr    $ra
#------------------------------------------------------


#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------


#----------------------------------------------------
#Second Processor
#----------------------------------------------------
  org 0x200

  ori $sp, $0, 0x3ffc      

  ori $t9, $0, 0x1000      # Lock
  ori $k1, $0, 0           # SUM
  ori $s0, $0, 0           # MAX
  ori $s1, $0, 0xFFFF      # MIN
  ori $s2, $0, 0           # AVE

  ori $s4, $0, 0x0500       

  ori $s3, $0, 256

  j POP_LOOP

EMPTY:
  jal unlock
POP_LOOP:
  jal lock
  lw $s5, 0($s4)
  beq $s5, $s4, EMPTY

  lw $t7, 0($s5)
  addiu $s5, $s5, -4
  sw $s5, 0($s4) 
  jal unlock
  
  andi $t8, $t7, 0xffff
  jal max
  ori $s0, $v0, 0
  jal min
  ori $s1, $v0, 0
  jal sum
  ori $k1, $v0, 0
  
  addiu $s3, $s3, -1
  beq $s3, $0, EXIT1
  j   POP_LOOP

EXIT1:
  ori $a0, $k1, 0
  ori $a1, $0, 256
  jal divide
  or  $s2, $0, $v0
  halt




#-max (t8=a,s0=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $t8
  push  $s0
  or    $v0, $0, $t8
  slt   $t0, $t8, $s0
  beq   $t0, $0, maxrtn
  or    $v0, $0, $s0
maxrtn:
  pop   $s0
  pop   $t8
  pop   $ra
  jr    $ra
#--------------------------------------------------


#-min (t8=a,s1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $t8
  push  $s1
  or    $v0, $0, $t8
  slt   $t0, $s1, $t8
  beq   $t0, $0, minrtn
  or    $v0, $0, $s1
minrtn:
  pop   $s1
  pop   $t8
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-sum (t8 = a, k1 = b) returns v0 = a + b--------
sum:
  push $ra
  push $t8
  push $k1
  addu $v0, $t8, $k1
  pop  $k1
  pop  $t8
  pop  $ra
  jr   $ra
#--------------------------------------------------

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------

org 0x0500
cfw 0x0500

org 0x1110
cfw 0
