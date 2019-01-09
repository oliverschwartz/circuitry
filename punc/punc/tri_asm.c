// INITIAL BLOCK 1:
LD    R0, #63           // R0 <- a
BRnz  #24               // if (a <= 0) goto LOAD_INVALID_1
LD    R1, #62           // R1 <- b
BRnz  #22               // if (c <= 0) goto LOAD_INVALID_1
LD    R2, #61           // R2 <- c
BRnz  #20               // if (c <= 0) goto LOAD_INVALID_1
ADD   R3, R0, R1        // R3  <- a + b
ADD   R4, R1, R2        // R4  <- b + c
ADD   R5, R0, R2        // R5  <- a + c

// a + b GREATER THAN c
NOT   R6, R2            // R6 <- -c (invert all bits and add 1)
ADD   R6, R6, #1        // R6 <- -c
ADD   R6, R6, R3        // R6 <- a + b - c
BRnz  #13               // if (R6 <= 0) goto LOAD_INVALID_1

// b + c GREATER THAN a
NOT   R6, R0            
ADD   R6, R6, #1        // R6 <- -a
ADD   R6, R6, R4        // R6 <- b + c - a
BRnz  #9                // if (R6 <= 0) goto LOAD_INVALID_1

// a + c GREATER THAN b
NOT   R6, R1            // R6 <- -b (invert all bits and add 1)
ADD   R6, R6, #1        // R6 <- -b
ADD   R6, R6, R5        // R6 <- a + c - b
BRnz  #5                // if (R6 <= 0) goto LOAD_INVALID_1

// LOAD_VALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #1        // R0 <- 1 
ST    R0, #38           // valid_1 <- 1
LEA   R0, #4            // R0 <- address of INITIAL BLOCK 2
JMP   R0

// LOAD_INVALID_1
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #-1       // R0 <- -1
ST    R0, #33           // valid_1 <- (-1)

// INITIAL BLOCK 2 
AND   R3, R3, #0        // R3 <- 0 (zero out Register 3)
AND   R4, R4, #0        // R4 <- 0 (zero out Register 4)
AND   R5, R5, #0        // R5 <- 0 (zero out Register 5)
LEA   R3, #34           // R0 <- &d
LDR   R0, R3, #0        // R0 <- d
BRnz  #23               // if (d <= 0) goto LOAD_INVALID_2
LDR   R1, R3, #1        // R1 <- e
BRnz  #21               // if (e <= 0) goto LOAD_INVALID_2
LDR   R2, R3, #2        // R2 <- f
BRnz  #19               // if (f <= 0) goto LOAD_INVALID_2
ADD   R3, R0, R1        // R3  <- d + e
ADD   R4, R1, R2        // R4  <- e + f
ADD   R5, R0, R2        // R5  <- d + f

// d + e GREATER THAN f
NOT   R6, R2            // R6 <- -f (invert all bits and add 1)
ADD   R6, R6, #1        // R6 <- -f
ADD   R6, R6, R3        // R6 <- d + e - f
BRnz  #12               // if (R6 <= 0) goto LOAD_INVALID_2

// e + f GREATER THAN d
NOT   R6, R0            // R6 <- -d (invert all bits and add 1)
ADD   R6, R6, #1        // R6 <- -d
ADD   R6, R6, R4        // R6 <- e + f - d
BRnz  #8                // if (R6 <= 0) goto LOAD_INVALID_2

// d + f GREATER THAN e
NOT   R6, R1            // R6 <- -e (invert all bits and add 1) 
ADD   R6, R6, #1        // R6 <- -e
ADD   R6, R6, R5        // R6 <- d + f - e
BRnz  #4                // if (R6 <= 0) goto LOAD_INVALID_2 

// LOAD_VALID_2
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #1        // R0 <- 1 
ST    R0, #6            // valid_2 <- 1 
HALT

// LOAD_INVALID_2
AND   R0, R0, #0        // R0 <- 0 (zero out Register 0)
ADD   R0, R0, #-1       // R0 <- -1
ST    R0, #2            // valid_2 <- (-1) 
HALT


0000                    
0000                    
0003                    
0004                    
0001                    
0005                    
0008                    
000C                    



