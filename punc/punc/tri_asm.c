// INITIAL BLOCK 1:
LD    R0, #LOCATION OF a // R0 <- a
BRnz  #jmp to invalid load
LD    R1, #LOCATION OF b // R1 <- b
BRnz  #jmp to invalid load
LD    R2, #LOCATION OF c // R2 <- c
BRnz  #jmp to invalid load
ADD   R3, R0, R1        // R3  <- a + b
ADD   R4, R1, R2        // R4  <- b + c
ADD   R5, R0, R2        // R5  <- a + c

// a + b GREATER THAN c
NOT   R6, R2            // R6 <- -c
ADD   R6, R6, R3        // R6 <- a + b - c
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_1

// b + c GREATER THAN a
NOT   R6, R0            // R6 <- -a
ADD   R6, R6, R4        // R6 <- b + c - a
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_1

// a + c GREATER THAN b
NOT   R6, R1            // R6 <- -b
ADD   R6, R6, R5        // R6 <- a + c - b
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_1

// LOAD_VALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #1        // R0 <- 1 
ST    R0, #location of valid_1 // valid_1 <- 1
LEA   R0, #location of INTIAL BLOCK 2 (offset)
JMP   R0

// LOAD_INVALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #-1       // R0 <- -1
ST    R0, #location of valid_2 // valid_2 <- (-1)

// INITIAL BLOCK 2
LD    R3, #address of d // R0 <- &d
LDR   R0, R3, #0        // R0 <- d
BRnz  #jmp to invalid load
LDR   R1, R3, #1        // R1 <- e
BRnz  #jmp to invalid load
LDR   R2, R3, #2        // R2 <- f
BRnz  #jmp to invalid load
AND   R3, R3, #0        // R3 <- 0 (zero out Register 3)
AND   R4, R4, #0        // R4 <- 0 (zero out Register 4)
AND   R5, R5, #0        // R5 <- 0 (zero out Register 5)
ADD   R3, R0, R1        // R3  <- d + e
ADD   R4, R1, R2        // R4  <- e + f
ADD   R5, R0, R2        // R5  <- d + f

// d + e GREATER THAN f
NOT   R6, R2            // R6 <- -f
ADD   R6, R6, R3        // R6 <- d + e - f
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_2

// e + f GREATER THAN d
NOT   R6, R0            // R6 <- -d
ADD   R6, R6, R4        // R6 <- e + f - d
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_2

// d + f GREATER THAN e
NOT   R6, R1            // R6 <- -e
ADD   R6, R6, R5        // R6 <- d + f - e
BRnz  #LOCATION OF LD -1 into valid_1 // if (R6 <= 0) goto LOAD_INVALID_2

// LOAD_VALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #1        // R0 <- 1 
ST    R0, #location of valid_2 // valid_2 <- 1
HALT

// LOAD_INVALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #-1       // R0 <- -1
ST    R0, #location of valid_2 // valid_2 <- (-1)



