*-----------------------------------------------------------
* Title      :  String Searcher
* Written by :  Hashem Al-Radaideh
* Date       :  Saturday, 12th August 2022
* Description:  
* Write a 68000 assembly code that searches for a certain character in a 
* null-terminated text stored in the memory and counts its occurrences in
* that text.
*
* The code should use TRAP instruction to prompt the user to enter the
* character he/she wants to search for.
*
* Then it calls a subroutine to find how many times the character occurs
* in the text, and then it prints a message with the result on the screen.
*
* The code should also give the user the choice to enter another character
* if he/she wants or exit the search.
*-----------------------------------------------------------

    ORG     $600
data:
CR   equ   $0D
LF   equ   $0A
crlf dc.b  CR,LF,' ',0
nl   dc.b  nl-crlf
str  ds.b  100
len  dc    len-str
pr1  dc.b  'Enter a string to search in: ',0
ps1  dc    ps1-pr1
pr2  dc.b  'Enter a character to search for: ',0
ps2  dc    ps2-pr2
pr3  dc.b  CR,LF,'found: ',0
ps3  dc    ps3-pr3
pre  dc.b  CR,LF,'do you wish to exit: [y|N]',0
pse  dc    pse-pre

    ORG    $1000
main:  ; main entry point of the program
    lea     pr1,a1          ; load 1st prompt into A1
    move.w  ps1,d1          ; D1 = prompt size
    moveQ.l #0,d0           ; move literal zero to d0
    trap    #15             ; display prompt
    
; read string from user
    lea     str,a1          ; use a termporary string to not write over pr1
    move.w  len,d1          ; use temp string length    
    moveQ.l #2,d0           ; move literal 2 to d0
    trap    #15             ; read string from console
    
    lea     (a1),a2
    move.b  d1,d4
    
; load 2nd prompt
    lea     pr2,A1          
    move.w  ps2,D1
    moveQ.l #0,d0  
    trap    #15
    
; read a single character from console
    moveQ.l #5,d0           ; move literal 5 to d0
    trap    #15             ; read a character
    
; for loop with if statement
    moveQ.l #0,d5           ; D2 used for sum (sum = 0)
loop:
; if found go to equal
	cmp.b   (A2)+,d1        ; beginning of if
    beq     equal           

; else continue
ret subQ.b  #1,d4           ; subtract one from d4 (string size)       
    bne     loop            ; loop back
    jmp     exit
    
; character was found
equal:
    addQ.l  #1,d5
    jmp     ret
; end of if

exit:  ; exit main loop
; print result prompt
    lea     pr3,A1
    move.w  ps3,D1
    moveQ.l #0,d0
    trap    #15
    
    move.w  d5,d1           ; print number of occurrences
    moveQ.l #3,d0
    trap    #15    

; print exit prompt
    lea     pre,A1
    move.w  pse,D1
    moveQ.l #0,d0
    trap    #15

; capture a single character
    moveQ.l #5,d0
    trap    #15
    
    moveQ.l #'y',d7         ; move 'y' to d7
    cmp.b   d1,d7           ; compare 'y' to captured character
    bne     again           ; if answer = 'y' exit main loop else start again

; end of program (return 0)
    stop    #2700
    SIMHALT
        
again:
    lea     crlf,A1
    move.w  nl,D1
    moveQ.l #0,d0
    trap    #15
    jmp     main       
    
    END     main
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
