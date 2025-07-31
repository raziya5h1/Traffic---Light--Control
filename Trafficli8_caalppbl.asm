ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    PROMPT          DB  'Choose state (1-GREEN, 2-YELLOW, 3-RED): $'
    GREEN           DB  'GREEN', 0AH, 0DH, '$'    ; Message for green light
    YELLOW          DB  'YELLOW', 0AH, 0DH, '$'   ; Message for yellow light
    RED             DB  'RED', 0AH, 0DH, '$'      ; Message for red light
    GO_MESSAGE      DB  'GO', 0AH, 0DH, '$'       ; Message for GO
    WAIT_MESSAGE    DB  'WAIT', 0AH, 0DH, '$'     ; Message for WAIT
    STOP_MESSAGE    DB  'STOP', 0AH, 0DH, '$'     ; Message for STOP
    COLOR_SELECTED  DB  '0'                       ; Variable to store user choice
    CURRENT_COLOR   DB  '0'                       ; Variable to store current color
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA        ; Load the data segment address into AX
    MOV DS, AX          ; Set the data segment register to point to the data segment

    CALL CLEAR_SCREEN   ; Clear the screen initially

MAIN_LOOP:
    CALL DISPLAY_PROMPT ; Display the prompt message
    CALL GET_USER_INPUT ; Get the user input

    CMP AL, '1'
    JE SET_GREEN

    CMP AL, '2'
    JE SET_YELLOW

    CMP AL, '3'
    JE SET_RED

    JMP MAIN_LOOP        ; If invalid input, loop back

SET_GREEN:
    MOV BYTE PTR COLOR_SELECTED, '1'
    CMP BYTE PTR CURRENT_COLOR, '1'
    JE SKIP_COLOR_CHANGE  ; If already green, skip changing color
    CALL SET_BACKGROUND_GREEN
    MOV BYTE PTR CURRENT_COLOR, '1'
    JMP DISPLAY_MESSAGE

SET_YELLOW:
    MOV BYTE PTR COLOR_SELECTED, '2'
    CMP BYTE PTR CURRENT_COLOR, '2'
    JE SKIP_COLOR_CHANGE  ; If already yellow, skip changing color
    CALL SET_BACKGROUND_YELLOW
    MOV BYTE PTR CURRENT_COLOR, '2'
    JMP DISPLAY_MESSAGE

SET_RED:
    MOV BYTE PTR COLOR_SELECTED, '3'
    CMP BYTE PTR CURRENT_COLOR, '3'
    JE SKIP_COLOR_CHANGE  ; If already red, skip changing color
    CALL SET_BACKGROUND_RED
    MOV BYTE PTR CURRENT_COLOR, '3'
    JMP DISPLAY_MESSAGE

SKIP_COLOR_CHANGE:
    JMP MAIN_LOOP   ; Skip displaying message if color didn't change

DISPLAY_MESSAGE:
    CALL PRINT_MESSAGE   ; Print the selected color message
    JMP MAIN_LOOP        ; Jump back to the main loop to repeat

DISPLAY_PROMPT PROC
    MOV DX, OFFSET PROMPT
    MOV AH, 09H
    INT 21H
    RET
DISPLAY_PROMPT ENDP

GET_USER_INPUT PROC
    MOV AH, 01H
    INT 21H
    RET
GET_USER_INPUT ENDP

PRINT_MESSAGE PROC
    MOV AH, 09H           ; Display the selected color message
    CMP COLOR_SELECTED, '1'
    JE PRINT_GREEN

    CMP COLOR_SELECTED, '2'
    JE PRINT_YELLOW

    CMP COLOR_SELECTED, '3'
    JE PRINT_RED
    RET

PRINT_GREEN:
    MOV DX, OFFSET GREEN
    INT 21H
    MOV DX, OFFSET GO_MESSAGE  ; Display "GO" message for green color
    INT 21H
    RET

PRINT_YELLOW:
    MOV DX, OFFSET YELLOW
    INT 21H
    MOV DX, OFFSET WAIT_MESSAGE  ; Display "WAIT" message for yellow color
    INT 21H
    RET

PRINT_RED:
    MOV DX, OFFSET RED
    INT 21H
    MOV DX, OFFSET STOP_MESSAGE  ; Display "STOP" message for red color
    INT 21H
    RET
PRINT_MESSAGE ENDP

SET_BACKGROUND_GREEN PROC
    MOV AX, 0B800H       ; Video memory segment
    MOV ES, AX
    XOR DI, DI           ; Start at the beginning of video memory
    MOV CX, 4000         ; Total words in video memory (80 columns * 25 rows)
    MOV AL, ' '          ; Space character
    MOV AH, 2Eh          ; Attribute for green background ('2' for green)
    REP STOSW            ; Store AX (character and attribute) in ES:DI and increment DI
    RET
SET_BACKGROUND_GREEN ENDP

SET_BACKGROUND_YELLOW PROC
    MOV AX, 0B800H       ; Video memory segment
    MOV ES, AX
    XOR DI, DI           ; Start at the beginning of video memory
    MOV CX, 4000         ; Total words in video memory (80 columns * 25 rows)
    MOV AL, ' '          ; Space character
    MOV AH, 6Eh          ; Attribute for yellow background ('6' for yellow)
    REP STOSW            ; Store AX (character and attribute) in ES:DI and increment DI
    RET
SET_BACKGROUND_YELLOW ENDP

SET_BACKGROUND_RED PROC
    MOV AX, 0B800H       ; Video memory segment
    MOV ES, AX
    XOR DI, DI           ; Start at the beginning of video memory
    MOV CX, 4000         ; Total words in video memory (80 columns * 25 rows)
    MOV AL, ' '          ; Space character
    MOV AH, 4Eh          ; Attribute for red background ('4' for red)
    REP STOSW            ; Store AX (character and attribute) in ES:DI and increment DI
    RET
SET_BACKGROUND_RED ENDP

CLEAR_SCREEN PROC
    MOV AH, 06h        ; Function to scroll up window (clear screen)
    MOV AL, 00h        ; Clear entire screen
    MOV BH, 07h        ; Attribute for blank (black background, white text)
    MOV CX, 0000h      ; Top-left corner of the window
    MOV DX, 184Fh      ; Bottom-right corner of the window (80x25 text mode)
    INT 10h            ; BIOS video interrupt
    RET
CLEAR_SCREEN ENDP

CODE ENDS
END START