; Init variables
    ; Seed for the random number
    LD  R0, SEED   
    ; Args for the formulate
    LD  R1, MULTIPLIER
    LD  R2, INCREMENT
    LD  R3, MODULUS
    ; The range of the random number
    LD  R4, RANGE_MIN
    LD  R5, RANGE_MAX
    
; Generate random numbers within the specified range
