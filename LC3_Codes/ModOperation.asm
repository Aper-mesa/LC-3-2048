.ORIG x3000
RESULT: .FILL x0000
DIVIDEND: .FILL x0004
DIVISOR: .FILL x0002
QUOTIENT: .FILL x0000
REMAINDER: .FILL x0000
MOD_SR2: .FILL x0000
MOD_SR3: .FILL x0000
MOD_SR4: .FILL x0000
ASCIITEMP: .FILL x0030
JSR MOD
BR ENDPROGRAM

MOD: ST R2, MOD_SR2
     ST R3, MOD_SR3
     ST R4, MOD_SR4
     LD R1, DIVIDEND 
     LD R2, DIVISOR 
     AND R3, R3, #0  
     NOT R2, R2  
     ADD R2, R2, 1   
     ADD R4, R1, R2  
     BRn DONE
LOOP: ADD R1, R1, R2
      ADD R3, R3, #1
      ADD R4, R1, R2
      BRzp LOOP
DONE: ST R1, REMAINDER 
      LD R2, MOD_SR2
      LD R3, MOD_SR3
      LD R4, MOD_SR4
      RET
ENDPROGRAM: 
           LD R0, REMAINDER
           LD R1, ASCIITEMP
           ADD R0, R0, R1
           TRAP x21
           .END
      