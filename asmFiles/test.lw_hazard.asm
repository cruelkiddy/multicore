 org 0x0000

  ori   $2, $0, 5
 
  ori   $6, $6, 0x0F00
  ori   $1, $0, 3
  sw    $2 , 0($6)
  nop
  lw    $3, 0($6) 
  
  addu  $5, $3, $1
  NOP
  NOP
  NOP
  NOP
  halt


