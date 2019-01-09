LD    R0, #63           
BRnz  #24               
LD    R1, #62           
BRnz  #22               
LD    R2, #61           
BRnz  #20               
ADD   R3, R0, R1        
ADD   R4, R1, R2        
ADD   R5, R0, R2        
NOT   R6, R2            
ADD   R6, R6, #1        
ADD   R6, R6, R3        
BRnz  #13               
NOT   R6, R0            
ADD   R6, R6, #1        
ADD   R6, R6, R4        
BRnz  #9                
NOT   R6, R1            
ADD   R6, R6, #1        
ADD   R6, R6, R5        
BRnz  #5                
AND   R0, R0, #0        
ADD   R0, R0, #1        
ST    R0, #38           
LEA   R0, #4            
JMP   R0
AND   R0, R0, #0        
ADD   R0, R0, #-1       
ST    R0, #33           
AND   R3, R3, #0        
AND   R4, R4, #0        
AND   R5, R5, #0        
LEA   R3, #34           
LDR   R0, R3, #0        
BRnz  #23               
LDR   R1, R3, #1        
BRnz  #21               
LDR   R2, R3, #2        
BRnz  #19               
ADD   R3, R0, R1        
ADD   R4, R1, R2        
ADD   R5, R0, R2        
NOT   R6, R2            
ADD   R6, R6, #1        
ADD   R6, R6, R3        
BRnz  #12               
NOT   R6, R0            
ADD   R6, R6, #1        
ADD   R6, R6, R4        
BRnz  #8                
NOT   R6, R1            
ADD   R6, R6, #1        
ADD   R6, R6, R5        
BRnz  #4                
AND   R0, R0, #0        
ADD   R0, R0, #1        
ST    R0, #6            
HALT
AND   R0, R0, #0        
ADD   R0, R0, #-1       
ST    R0, #2            
HALT
0000                    
0000                    
0003                    
0004                    
0001                    
0005                    
0008                    
000C