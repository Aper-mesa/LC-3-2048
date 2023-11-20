.ORIG x3000
CONDITION1: .FILL x0004  ; Condition for outer loop
CONDITION2: .FILL x0004  ; Condition for inner loop
ZERO: .FILL x0000   ; Zero value
RESULT: .FILL x0000 ; Result (Init with zero)
LD R0, ZERO ; Init R0 = 0
; Init result adder(result = R3 + R4)
LD R3, ZERO ; Init R3 = 0
LD R4, ZERO ; Init R4 = 0
; Init condition checker(Outer -> R1, Inner R2)
LD R2, CONDITION2 ; Init R2 = CONDITION2
LD R1, CONDITION1 ; Init R1 = CONDITION1
OUTER: ADD R1, R1, #0   ; Let the BR condition check the value of R1
       ; If matches
       BRz DONE  ; Go to the end of the program
       ; If not matches
       ADD R1, R1, #-1 ; Decrease the value of R1
       ADD R3, R3, #1 ; Increase the value of R3
       ; Start the inner loop
       LD R2, CONDITION2 ; Reset the value of R2
       BR INNER ; Start loop
INNER: ADD R2, R2, #0   ; Let the BR condition check the value of R2
       ; If matches
       BRz OUTER  ; Go to the outter loop
       ; If not matches
       ADD R2, R2, #-1 ; Decrease the value of R2
       ADD R4, R4, #1 ; Increase the value of R4
       BR INNER  ; Recheck the condition
DONE: ADD R0, R3, R4    ; Add the value of R3 and R4 and store to R0
      ST R0, RESULT ; Save the result in R0 to RESULT
      HALT  ; Halt the program
      .END  ; End of the program