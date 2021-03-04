#--------------------------------------
# Test a search algorithm
#--------------------------------------
  org   0x0000
  ori   $sp, $zero, 0x80
start:
  ori   $1, $zero, 0x01
  ori   $2, $zero, 0x04

  sw    $0, 0($sp)            # set result to 0
  lw    $3, 4($sp)            # load search variable into $3
  lw    $4, 8($sp)            # load search length into $4
  addiu $5, $sp, 12           # search pointer is in $5

loop:
  lw    $6, 0($5)             # load element at pointer $5
  subu  $7, $6, $3            # compare loaded element with search var
  beq   $7, $zero, found      # if matches, go to found
  addu  $5, $5, $2            # increment pointer
  subu  $4, $4, $1            # subutract search length
  beq   $4, $zero, notfound   # if end of list, go to not found
  beq   $0, $zero, loop       # do loop again
found:
  sw    $5, 0($sp)            # store into 0x80
notfound:
  halt


  org 0x80
item_position:
  cfw 0                       # should be found at 0x0124
search_item:
  cfw 0x5c6f
list_length:
  cfw 2
search_list:
  #cfw 0x087d
  #cfw 0x5fcb
  #cfw 0xa41a
  #cfw 0x4109
  #cfw 0x4522
  #cfw 0x700f
  cfw 0x766d
  cfw 0x5c6f
