.ORIG x3000
ORIGVAL: .FILL x0004  ; Starting value of the loop
ZERO: .FILL x0000  ; Zero value
LD R0, ZERO  ; Init the value of R0 to zero
LD R1, ORIGVAL  ; Init the value of R1 to 4
LOOP: BRz DONE  ; If the value of R1 = 0, quit the loop
      ADD R0, R0, #1  ; Increase the value of R0
      ADD R1, R1, #-1  ; Decrease the value of R1
      BR LOOP  ; Recheck the condition

RESULT: .FILL x0000  ; The result of the loop
; End of the program
DONE: ST R0, RESULT  ; Store the result of R0 to RESULT
      HALT ; Halt the program
      .END ; End of the program