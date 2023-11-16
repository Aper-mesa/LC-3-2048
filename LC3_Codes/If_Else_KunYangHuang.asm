; If - else statement
; Assume we try to evaluate whether the number in R1 is 1
.ORIG x3000 ; Start of the program
LD R1, CONDITION
ADD R1, R1, #-1 ; Check whether the value in R1 is 1(By adding with -1)
BRz IF ; R1 = 1 -> To IF symbol
BRnp ELSE   ; Otherwise -> To ELSE symbol
RESULT:  .FILL x0000    ; Init the value of RESULT (value 0)
NUMA:  .FILL x0001  ; Init value for if statement
NUMB:  .FILL x0002  ; Init value for else statement
CONDITION:  .FILL x0010
IF: LD R0, NUMA ; Set the value of R0 to 0
    BR DONE  ; To the end of the program
ELSE: LD R0, NUMB ; Set the value of R0 to 1
    BR DONE  ; To the end of the program
    
; End of the program
DONE:  ST R0, RESULT ; Store the result of R0 to the Memory
       HALT ; Halt the program
       .END  ; End the program