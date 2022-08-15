*-----------------------------------------------------------
* Demo vidoe :  https://youtu.be/1-Eppaii8_s
* Title      :  String Searcher
* Written by :  Hashem Al-Radaideh
* Date       :  Saturday, 12th August 2022
* Site       :  https://github.com/HashemRadaideh/m68k-project
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

    ORG    $420
str  ds.b  100          ; same as in c/c++ (char str[100];)
len  dc    len-str
pr1  dc.b  'Enter a string to search in: ',0
ps1  dc    ps1-pr1
pr2  dc.b  'Enter a character to search for: ',0
ps2  dc    ps2-pr2
pr3  dc.b  CR,LF,'Found: ',0
ps3  dc    ps3-pr3
pre  dc.b  CR,LF,'do you wish to exit: [y|N]',0
pse  dc    pse-pre
crlf dc.b  CR,LF,' ',0  ; HACK: easy way to print newline
nl   dc.b  nl-crlf      ; find string size automatically
CR   equ   $0D
LF   equ   $0A

    ORG    $1000
main:
    lea     pr1,a1      ; load 1st prompt into A1
    move.w  ps1,d1      ; D1 = prompt size
    clr.l   d0          ; empty d0 for use with trap #15
    trap    #15         ; display prompt
    
    lea     str,a1      ; store user entered string in str
    move.w  len,d1      ; store str size   
    moveQ.l #2,d0       ; move literal 2 to d0
    trap    #15         ; read a string from console
    
    lea     (a1),a2     ; move string to a2 for comparison
    move.b  d1,d4       ; move string size to d4 for the number of loops
    
    lea     pr2,A1      ; load 2nd prompt
    move.w  ps2,D1
    clr.l   d0
    trap    #15
    
    moveQ.l #5,d0       ; move literal 5 to d0
    trap    #15         ; read a single character from console
    
    clr.l   d5          ; D5 used for as a sum counter (sum = 0)
loop:   
	cmp.b   (A2)+,d1    ; if equal add 1 to sum
    bne     neq         ; else exit if statment
    addQ.l  #1,d5       ; character was found
neq subQ.b  #1,d4       ; subtract one from d4 (string size)       
    bne     loop        ; loop back if not equal
 
    lea     pr3,a1      ; print result prompt
    move.w  ps3,d1
    clr.l   d0
    trap    #15
    
    move.w  d5,d1       ; print number of occurrences
    moveQ.l #3,d0
    trap    #15    

    lea     pre,a1  `   ; print exit prompt
    move.w  pse,d1
    clr.l   d0
    trap    #15

    moveQ.l #5,d0       ; capture a single character
    trap    #15
    
    move    d1,d6       ; move user entered character to d6 for later use
    
    lea     crlf,a1     ; print new line
    move.w  nl,d1
    clr.l   d0
    trap    #15
    
    moveQ.l #'y',d7     ; move 'y' to d7
    cmp.b   d6,d7       ; compare 'y' to captured character
    bne     main        ; if answer == 'y' exit main loop else loop again

    stop    #2700       ; end of program (return 0)
    SIMHALT  
    END     main
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
