Port
input   
portA, portB(word size 32bit), ALUOP(opcode)

output  
portOut(result), neg_flag,zero_flag,of_flag

big small endian
[31:0], 32bit size

neg_flag: result < 0 
of_flag: overflow flag
zero_flag: result == 0

---

Test bench

nothing
