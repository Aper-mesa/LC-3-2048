.ORIG x3000
;Structure:
;Loop1
;   Loop2
;       Loop3
;
; Conditions
CONDITION1: .FILL x0003 ; Condition for loop1
CONDITION2: .FILL x0004 ; Condition for loop2
CONDITION3: .FILL x0005 ; Condition for loop3
ZERO: .FILL x0000 ; Zero value
RESULT: .FILL x0000 ; Init result = 0
LD R0, ZERO ; Init the counter R0 = 0
LD R3, CONDITION3 ; Set R3 = CONDITION3
LD R2, CONDITION2 ; Set R2 = CONDITION2
LD R1, CONDITION1 ; Set R1 = CONDITION1
LOOP1: ADD R1, R1, #0 ; Use the value of R1 as the condition of loop1
       ; If matches
       BRz DONE ; Go to the end of the program
       ; If not matches
       ADD R1, R1, #-1 ; Decrease the value of R1
       ADD R0, R0, #1 ; Increase the value of R0
       ; Start loop2
       LD R2, CONDITION2 ; Reset the value of R2
       BR LOOP2 ; Start the loop
LOOP2: ADD R2, R2, #0 ; Use the value of R2 as the condition of loop2
       ; If matches
       BRz LOOP1    ; Back to loop1
       ; If not matches
       ADD R2, R2, #-1 ; Decrease the value of R2
       ADD R0, R0, #1 ; Increase the value of R0
       ; Start loop3
       LD R3, CONDITION3 ; Reset the value of R3
       BR LOOP3 ; Start the loop
LOOP3: ADD R3, R3, #0 ; Use the value of R3 as the condition of loop3
       ; If matches
       BRz LOOP2    ; Back to loop2
       ; If not matches
       ADD R3, R3, #-1 ; Decrease the value of R3
       ADD R0, R0, #1 ; Increase the value of R0
       BR LOOP3 ; Recheck the condition
; End of the program
DONE: ST R0, RESULT ; Store the value of R0 to the RESULT
      HALT ; Halt the program
      .END ; End of the program