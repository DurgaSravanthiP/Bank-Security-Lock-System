INCLUDE emu8086.inc
.MODEL SMALL
.STACK 100h

MAX_EMP EQU 20
MAX_ATTEMPTS EQU 3

.DATA

TitleMsg   DB 13,10,'=== BANK SECURITY LOCK SYSTEM ===$'
AskIDMsg   DB 13,10,'Enter Employee ID: $'
AskPassMsg DB 13,10,'Enter Password (0-15): $'
IDNotFound DB 13,10,'ID not found.$'
LockedMsg  DB 13,10,'Account locked!$'
WrongMsg   DB 13,10,'Wrong password.$'
OKMsg      DB 13,10,'Access Granted.$'

AskChange DB 13,10,'Change password? (Y/N): $'
AskNew    DB 13,10,'Enter new password (0-15): $'
Changed   DB 13,10,'Password Updated.$'

CurrentIndex DB ?

; IDs (20 employees)
EmpTable DW 1001,1002,1003,1004,1005,1010,1011,1012,1013,1014
         DW 2001,2002,2003,2004,2005,3001,3002,3003,3004,3005

; Passwords
PassTable DB 4,7,3,0,6,5,8,1,9,10,11,12,2,14,15,2,5,7,9,13

Attempts DB 20 DUP(0)

.CODE
MAIN PROC
    mov ax, @data
    mov ds, ax

MAIN_LOOP:
    lea dx, TitleMsg
    mov ah, 09h
    int 21h

; -------- ID INPUT --------
GetID:
    lea dx, AskIDMsg
    mov ah, 09h
    int 21h

    call SCAN_NUM     ; CX = entered ID
    call FindEmp
    jz Found
    lea dx, IDNotFound
    mov ah, 09h
    int 21h
    jmp GetID

Found:
    mov CurrentIndex, bl

    mov bl, CurrentIndex
    mov al, Attempts[bx]
    cmp al, MAX_ATTEMPTS
    jb AskPass
    lea dx, LockedMsg
    mov ah, 09h
    int 21h
    jmp MAIN_LOOP

; -------- PASSWORD INPUT --------
AskPass:
    lea dx, AskPassMsg
    mov ah, 09h
    int 21h

    call SCAN_NUM
    mov al, cl

    mov bl, CurrentIndex
    cmp al, PassTable[bx]
    je Correct

; wrong password
    mov bl, CurrentIndex
    inc Attempts[bx]

    mov al, Attempts[bx]
    cmp al, MAX_ATTEMPTS
    jae LockNow

    lea dx, WrongMsg
    mov ah, 09h
    int 21h

    jmp MAIN_LOOP

LockNow:
    lea dx, LockedMsg
    mov ah, 09h
    int 21h
    jmp MAIN_LOOP

; -------- CORRECT PASSWORD --------
Correct:
    mov bl, CurrentIndex
    mov Attempts[bx], 0

    lea dx, OKMsg
    mov ah, 09h
    int 21h

    ; ------------ TIME REMOVED ------------
    ; (No ShowTime call)
    ; --------------------------------------

    ; change password?
    lea dx, AskChange
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, 'Y'
    je ChangePass
    cmp al, 'y'
    je ChangePass
    jmp MAIN_LOOP

; -------- CHANGE PASSWORD --------
ChangePass:
    lea dx, AskNew
    mov ah, 09h
    int 21h

    call SCAN_NUM
    mov al, cl
    mov bl, CurrentIndex
    mov PassTable[bx], al

    lea dx, Changed
    mov ah, 09h
    int 21h

    jmp MAIN_LOOP

MAIN ENDP

; ---------- FIND EMPLOYEE ----------
FindEmp PROC
    xor bx, bx
FLoop:
    cmp bx, MAX_EMP
    jge NotFound
    mov si, bx
    shl si, 1
    mov ax, EmpTable[si]
    cmp ax, cx
    je FoundEmp
    inc bx
    jmp FLoop

FoundEmp:
    cmp bx, bx
    ret

NotFound:
    mov bx,1
    cmp bx,0
    ret
FindEmp ENDP

DEFINE_SCAN_NUM
END MAIN
