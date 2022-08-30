*-----------------------------------------------------------
* Demo vidoe :  https://youtu.be/1-Eppaii8_s
* Title      :  Login system
* Written by :  Hashem Al-Radaideh
* Date       :  Saturday, 25th August 2022
* Site       :  https://github.com/HashemRadaideh/m68k-project
* Description:  
* Write a 68000 assembly code that does the following:
* 
* If a hardware RESET happens, it:
* 
* a. Prints some start-up/welcome message
*    indicating a hardware reset has happened.
* b. Then, prompts the user to enter a login and a password.
*    The login name is "admin" and the password can be any string of your choice.
* c. After verifying correct login and password, it prints a message to welcome
*    the user and then flashes the LEDs ON/OFF with some delay in between 
*    a few times then it goes back to the main program.
* d. If the login information is wrong then it prints invalid login or password message and lets the user try again.
* And if a level-7 interrupt comes, it does the following:
* 
* a. Prints some message indicating that a level-7 interrupt has happened.
* b. Then, prints: 0 ... 1 ... 2 ... 3 ... 4 ... 5 ... 6 ... 7 on the screen with some delay in between.
* c. Then, displays a scrolling (moving) message on the seven-segment display. The message can be long with multiple words like this one for example:
* HELLO HASSAn PIn 5683
* 
* Then it goes back to the main program.
* 
* The main program can be a very simple code simply incrementing some register with some delay in between and infinitely looping.
*-----------------------------------------------------------


	ORG	$1000
dly:	move.l	#400000,d7	; create a delay approximately 2.5s
lp:	subQ.l	#1,d7	; if the cpu ran on 16mhz frequency
	bne	lp
	rts

    
cntr:	add.l   #1,d2
	move.l  d2,d1
	move    #3,d0
	trap    #15

	lea     dots,a1
	move    #14,d0
	trap    #15
	rts


wUsr:	move    #0,d7    
	lea     wName,a1       	; print "Enter username: "
	move.w  wns,d1     
	clr.l   d0          
	trap    #15 
	jmp     main


wPswd:	move    #0,d6    
	lea     wPass,a1       	; print "Enter username: "
	move.w  wps,d1     
	clr.l   d0          
	trap    #15 
	jmp     main


main:	lea     pr1,a1       	; print "Enter username: "
	move.w  ps1,d1     
	clr.l   d0          
	trap    #15        

	lea     name,a1	; input username
	move.w  ns,d1       
	moveQ.l #2,d0       
	trap    #15         

	lea     (a1),a2	; save username in a2 for comparison
	move.b  d1,d2            

	bsr     dly

	lea     pr2,a1	; print "Enter password: "
	move.w  ps2,d1     
	clr.l   d0
	trap    #15

	lea     pswd,a1	; input password
	move.w  pws,d1       
	moveQ.l #2,d0       
	trap    #15      

	lea     (a1),a3	; save password in a3 for comparison
	move.b  d1,d3

	bsr     dly

; to check if two strings are equal
; compare the sizes of the strings first
; and start with the assumption of true
; setting d7 to 1 if true and 0 otherwise false
; the second it set to 0 exit the loop
; no need to continue

	move.b  uns,d4
	cmp.b   d2,d4
	bne     wUsr

	lea     user,a4
	move    #1,d7	; set d7 to true
lp1:	cmp.b   (a2)+,(a4)+
	bne     wUsr
	subQ.b  #1,d2
	bne     lp1

	move.b  ps,d4
	cmp     d3,d4
	bne     wPswd

	lea     pass,a4
	move    #1,d6	; set d6 to true
lp2:	cmp.b   (a3)+,(a4)+
	bne     wPswd
	subQ.b  #1,d3
	bne     lp2

	move	#7,d5
	clr	d2
lp3:	bsr 	cntr
	bsr	dly
	subQ.b  #1,d5
	bne     lp3

	stop 	#2700
	SIMHALT
	
dots	dc.b	' ... ',0
dts	dc	dts-dots

wName	dc.b	'Invalid username try again.',0
wns	dc	wns-wName

wPass	dc.b	'Invalid password try again.',0
wps	dc	wps-wPass

pr1	dc.b	'Enter username: ',0
ps1	dc	ps1-pr1

pr2	dc.b	'Enter password: ',0
ps2	dc	ps2-pr2

user	dc.b	'admin',0
uns	dc.b	5

name	ds.b	100
ns	dc	ns-name

pass	dc.b	'hi12',0
ps	dc.b	4

pswd	ds.b	100
pws	dc	pws-pswd

crlf	dc.b	CR,LF,0
nl	dc.b	nl-crlf
CR	equ	$0D
LF	equ	$0A

	END	main
*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
