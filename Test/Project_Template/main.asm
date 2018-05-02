INCLUDE Irvine32.inc
BUFFER_SIZE = 97
Array_Size = 200
.data
str1 Byte "Soduko !!! =))" , 0
str2 Byte "Enter 1  To start a new game " , 0
str3 Byte "Enter 2  To continue a saved borad " , 0
str4 Byte "Choose a Level : " , 0
str5 Byte "Enter 1 for Easy " , 0
Str6 Byte "Enter 2 for Meduim"  , 0
Str7 Byte "Enter 3 for Hard " , 0
str8 Byte "Choose a number : " , 0
str9 Byte "1.Change a cell   2.Clear the board    3.Save   4.Print the Finished Board ", 0
str10 Byte "Enter the row first then the column then value : " , 0
str11 Byte "The game has been saved !" , 0
str12 Byte "Number of correct answers : " , 0
str13 Byte "Number of missed : " , 0
str14 Byte "Time taken : ", 0
str15 Byte "Number of steps left : ",0
left Byte 0
Val Byte ?
Row Byte ?
Col Byte ?
StartTime Dword ?
EndTime Dword ?
min Dword ?
seconds Dword ?
ErrorMessage Byte "Wrong Answer" , 0
CorrectAnswer Byte"Got it Right !!" ,0
Ccount Byte 0
Wcount Byte 0
randBoardNumber DWORD ?
unsolved Byte BUFFER_SIZE DUP(?) ,0
solved Byte BUFFER_SIZE DUP(?) ,0
userunsolved Byte Array_Size DUP(?) ,0
num dword ?
SolvedBoard Byte "diff_1_1_solved.txt" , 0
UnSolvedBoard Byte "diff_1_1.txt" , 0
OutPut Byte "SavedBoard.txt", 0
fileHandle Handle ?
number Dword ?
.code

;--------------------------------------------------------------------
;Gets the level from the user and fills the usolved buffer with it 
; gets the name of the unsolved file in edx and the solved file in ebx
;--------------------------------------------------------------------
ReadRandomFile PROC uses edx eax ecx ,level:DWORD , RandNumber:DWORD , Buffer:PTR Byte

       cmp level , 1  ; level 1   ; Easy level board number 1
       jne NotEqual
       cmp RandNumber , 0
       Jne NotOne
       JMP ReadBoard

       NotOne:
       cmp RandNumber , 1         ; Easy level board number 2
       jne NotTwo
       mov Byte ptr [edx+7] , '2' 
       mov byte ptr [ebx +7] , '2' 
       JMP ReadBoard
       NotTwo:                    ;Easy level board number 3
       mov byte ptr [edx +7] , '3' 
       mov byte ptr [ebx+7] , '3' 
       JMP ReadBoard

       NotEqual:                  ;Meduim level
       cmp level , 2  ; level 2   ;Meduim level board number 1
       jne notEqualTwo
       cmp RandNumber , 0
       Jne NotOne2
       mov byte ptr [edx + 5] , '2' 
       mov byte ptr [ebx +5] , '2' 
       JMP ReadBoard
       NotOne2:                   ;Meduim level board number 2
       cmp RandNumber , 1
       jne NotTwo2
       mov byte ptr [edx +7] , '2' 
       mov byte ptr [ebx +7] , '2' 
       mov byte ptr [edx +5] , '2' 
       mov byte ptr [ebx +5] , '2' 
       JMP ReadBoard 
       NotTwo2:                   ;Meduim level board number 3
       mov byte ptr [edx +7] , '2' 
       mov byte ptr [ebx +7] , '2' 
       mov byte ptr [edx +5] , '2' 
       mov byte ptr [ebx +5] , '2' 
       JMP ReadBoard

       notEqualTwo:               ;Hard level
       cmp RandNumber , 0         ;Hard level board number 1
       Jne NotOne3
       mov byte ptr [edx +5] , '3' 
       mov byte ptr [ebx +5] , '3' 
       JMP ReadBoard
       NotOne3:                   ;Hard level board number 2
       cmp RandNumber , 1
       jne NotTwo3
       mov byte ptr [edx +7] , '2' 
       mov byte ptr [ebx +7] , '2' 
       mov byte ptr [edx +5] , '3' 
       mov byte ptr [ebx +5] , '3' 
       JMP ReadBoard
       NotTwo3:                    ;Hard level board number 3 
       mov byte ptr [edx+7] , '3' 
       mov byte ptr [ebx +7] , '3' 
       mov byte ptr [edx +5] , '3' 
       mov byte ptr [ebx +5] , '3' 

       ReadBoard :                 ;Read the unsolved board

       
       call OpenInputFile
       mov fileHandle,eax
                                                    ; Check for errors
       cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
       jne file_ok                                  ; no: skip
       jmp quit                                     ; and quit
       file_ok:
                                             ; Read the file into a buffer.
       mov edx, Buffer
       mov ecx,BUFFER_SIZE
       call ReadFromFile
       jnc check_buffer_size                        ; error reading?

       call WriteWindowsMsg
       jmp close_file
       check_buffer_size:
       cmp eax,BUFFER_SIZE                          ; buffer large enough?
       jb buf_size_ok ; yes
       jmp quit                                     ; and quit
       buf_size_ok:
       mov Buffer[eax],0                            ; insert null terminator
	   
       close_file:                            
       mov eax,fileHandle
       call CloseFile
       quit:
       RET

ReadRandomFile ENDP

;------------------------------------------------------------------------
;Generating a random number for the specific level that the user chooses 
; Returns the random number in eax 
;------------------------------------------------------------------------
RandomNumber PROC uses ecx edx 

      invoke GetTickCount      ; generating a random number by the time counter 
      mov edx , 0
      mov ecx , 3  
      div ecx                  ; placing it in from 0-2 range
      mov eax ,edx

	  RET
RandomNumber ENDP

;----------------------------------------------
;Read the solved board to check the user input 
; Takes the file name in edx 
;----------------------------------------------
ReadSolvedFile PROC uses edx ecx eax  , Buffer:PTR Byte 

      
      call OpenInputFile
      mov fileHandle,eax
                                             ; Check for errors
      cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
      jne file_ok                                  ; no: skip
      jmp quit                                     ; and quit
      file_ok:
                                             ; Read the file into a buffer.
      mov edx, Buffer
      mov ecx, BUFFER_SIZE
      call ReadFromFile
      jnc check_buffer_size                        ; error reading?

      call WriteWindowsMsg
      jmp close_file
      check_buffer_size:
      cmp eax,BUFFER_SIZE                          ; buffer large enough?
      jb buf_size_ok ; yes
      jmp quit                                     ; and quit
      buf_size_ok:
      mov Buffer[eax],0                            ; insert null terminator

      close_file:                            
      mov eax,fileHandle
      call CloseFile
      quit:
      RET
ReadSolvedFile ENDP

;---------------------------------------------------------------
;Read the unsolved board to add in it the user input 
; gets the file name from edx 
;---------------------------------------------------------------
ReadUnSolvedFile PROC uses edx ecx eax  , Buffer:PTR Byte 

     
      call OpenInputFile
      mov fileHandle,eax
                                             ; Check for errors
      cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
      jne file_ok                                  ; no: skip
      jmp quit                                     ; and quit
      file_ok:
                                             ; Read the file into a buffer.
      mov edx, Buffer
      mov ecx,BUFFER_SIZE
      call ReadFromFile
      jnc check_buffer_size                        ; error reading?

      call WriteWindowsMsg
      jmp close_file
      check_buffer_size:
      cmp eax,BUFFER_SIZE                          ; buffer large enough?
      jb buf_size_ok ; yes
      jmp quit                                     ; and quit
      buf_size_ok:
      mov Buffer[eax],0                            ; insert null terminator

      close_file:                            
      mov eax,fileHandle
      call CloseFile
      quit:
      RET

ReadUnSolvedFile ENDP

;------------------------------
;Change every zero to dash 
;------------------------------
Dash PROC uses edx ecx , Buffer:PTR Byte
     
	 mov edx, Buffer 
     mov bl , '_'  
     mov ecx , 97  
     p:
     cmp byte ptr[edx] ,'0' ; if the value equals 0 it changes it to _
     jz en                                        
     jmp k                                     
     en:
     mov [edx] , bl
	 inc left
     k:
     add edx , 1
     loop p
	 RET
Dash ENDP

;--------------------------------------------------------------------
; Display the choosen board for the user 
; gets the offset of the buffers in esi and edi
;-------------------------------------------------------------------
Display proc uses edx eax  ecx ebx esi edi 

   
   mov ecx , 3

   Final:
   push ecx
   mov ecx ,3

   Dis:   
   push ecx 
   mov al, 15
   call SetTextColor  
   mov al , '|'
   call writechar
   mov ecx , 3
   L2:
   mov al ,' '
   call writechar
   push ecx
   mov ecx , 3
   L1:
   mov bl ,[edi]   ; This loop displays each block
   cmp bl , '_'    ;changes the the color of the dash to green
   jne cll
   mov al, 10
   JMP nott
   cll :
   mov al, 15
   cmp  byte ptr[esi] , 'c' ; checks if there is an input the user added
   jne nott
   mov al , 10
   nott:
   call SetTextColor
   mov al , bl 
   call writechar
   mov al ,' '
   call writechar
   inc edi
   inc esi
   Loop L1
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   pop ecx 
   Loop L2
   call crlf
   pop ecx 
   add edi , 2
   add esi , 2
   Loop Dis
   call crlf
   pop ecx 
   Loop Final


ret
Display endp


;-----------------------------------------------------------------------------------------
;Checks if the user entered a correct input or not if yes it changes it in the board 
;and displayes a green message else it only displays an error red message and the correct
; inputs and wrong inputs of the user
;-----------------------------------------------------------------------------------------
Check PROC uses eax edx ecx ebx , Ro:Byte , Colm:Byte , Value:Byte
      
	  dec Ro
	  dec Colm
	  mov eax ,0
	  mov al , Ro
	  mov bl , 11
	  mul bl
	  add al , Colm  ; Calculates the index of the value entered

	  mov bl ,userunsolved[eax] 
	  cmp bl , '_'  ; checks if it is an empty cell
	  Jne WrongCell
	  mov bl, solved[eax]
	  cmp bl , Value
	  Jne WrongCell
	  inc Ccount
	  mov bl , Value
	  mov userunsolved[eax] , bl
	  mov unsolved[eax] , 'c'  ; marks the answers cell
	  dec left
	  mov al , 10 
	  mov edx , offset  CorrectAnswer
	  Call SetTextColor
	  Call WriteString
	  Call crlf
	  mov al , 15
	  Call SetTextColor
	  mov edi , offset userunsolved
      mov esi ,offset unsolved
	  Call Display 
	  JMP Quit
	  WrongCell :
	  inc Wcount
	  mov edx , offset ErrorMessage
	  mov al , 12
	  Call SetTextColor
	  Call WriteString
	  Call crlf
	  Quit :
	  Ret
Check ENDP
;---------------------------------------------------------------------
;Views the final Board 
; gets the unsolved in edi and user unsolved in esi and solved in edx 
;---------------------------------------------------------------------
View PROC uses eax ecx

   
   mov ecx , 3

   Final:  
   push ecx
   mov ecx ,3

   Dis:
   push ecx 
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   mov ecx , 3
   L2:
   mov al ,' '
   call writechar
   push ecx
   mov ecx , 3
   L1:
   mov bl ,[edi]
   cmp bl , '_'
   jne cll
   mov al, 9
   mov bl, [edx]
   JMP nott
   cll :
   mov al, 15
   cmp  byte ptr[esi] , 'c'   ;changes the color of the correct cells
   jne nott
   mov al , 10
   nott:
   call SetTextColor
   mov al , bl 
   call writechar
   mov al ,' '
   call writechar
   inc edi
   inc esi
   inc edx
   Loop L1
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   pop ecx 
   Loop L2
   call crlf
   pop ecx 
   add edi , 2
   add esi , 2
   add edx ,2
   Loop Dis
   call crlf
   pop ecx 
   Loop Final

   RET

View ENDP

;------------------------------------------
;Calculates time and displays it 
;-----------------------------------------
TimeFunction PROC uses edx , STime:Dword , ETime:Dword

    mov eax , ETime
	sub eax , STime
	mov edx ,0
	mov ebx , 1000
	div ebx
	mov edx ,0
	mov ebx,60
	div ebx 
	Call WriteDec
	mov al ,':'
	Call WriteChar
	mov eax , edx
	Call WriteDec
	Call crlf
	ret

TimeFunction ENDP
;--------------------------------------------------------------
;Clears the board to restart the game
; clears all counters 
; uses the display function to display the unsolved board again
;---------------------------------------------------------------
Clear PROC uses edx eax ecx edi esi
     
	 mov ecx ,97
	 mov ebx , esi 
	 mov edx , edi
	 l1:
	 cmp byte ptr [ebx] ,'c'  
	 Jne nt
	 mov byte ptr [ebx] , '_' ; removes the edited cells in both buffers
	 mov byte ptr [edx] , '_'
	 nt:
	 inc ebx
	 inc edx
	 Loop L1

	 Call Display                    ; Display the board for the user 

	 RET
Clear ENDP
;-------------------------------------------------------------------------------
;Saves the board in a file including the names of the solved and unsolved files
; and also the number of wrong and correct answers and the time taken
; takes the name of the unsolved file in eax and the solved in ebx
; the rest of the items taken in parameters
; the name of the file to save in the board taken in edi "heya bt7t kol 7aga f buffer w tktb el buffer de f el file "
;----------------------------------------------------------------------------------
Save PROC uses edx ecx esi , Canswers:Byte , Wanswers:Byte , Buffer:PTR Byte 

      mov esi , Buffer
	  add esi ,97
	  add Canswers , '0'
	  mov cl,Canswers
	  mov [esi] , cl  ; saving the correct answer counter
	  inc esi 
	  add Wanswers ,'0'
	  mov cl  , Wanswers
	  mov [esi] , cl  ; saving the wrong answer counter

	  mov ecx , 12
	  inc esi
	  mov eax , offset unsolvedboard
	  L1:
	  mov dl , [eax]
	  mov [esi] , dl
	  inc esi
	  inc eax 
	  Loop L1

	  mov ecx , 19
	  inc esi
	  L2:
	  mov dl , [ebx]
	  mov [esi] , dl
	  inc esi
	  inc ebx
	  Loop L2

	  mov edx , edi
	  call CreateOutputFile 
	  mov fileHandle,eax 
	  ; Check for errors. 
	  cmp eax, INVALID_HANDLE_VALUE  ; error found? 
	  jne file_ok                    ; no: skip 
	  jmp quit 
	  file_ok:            

                               ; Write the buffer to the output file. 
	  mov eax,fileHandle 
	  mov edx, Buffer          ; the buffer should include the name of the solved and the unsolved file
	  mov ecx,200
	  call WriteToFile 
	  call CloseFile                 ; Display the return value.
	  quit :
	  RET
Save ENDP   
;---------------------------------------------
;Reads the saved board 
; gets the filename in edx 
;---------------------------------------------------
ReadSavedBoard PROC uses eax ecx esi edi  , Buffer:PTR Byte , Canswers:Dword , Wanswers:Dword
       mov edx , offset output  
	   call OpenInputFile
       mov fileHandle,eax
                                                    ; Check for errors
       cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
       jne file_ok                                  ; no: skip
       jmp quit                                     ; and quit
       file_ok:
                                             ; Read the file into a buffer.
       mov edx, offset userunsolved 
       mov ecx,200
       call ReadFromFile
       jnc check_buffer_size                        ; error reading?

       call WriteWindowsMsg
       jmp close_file
       check_buffer_size:
	   call writedec
	   call crlf
       cmp eax, 200                     ; buffer large enough?
       jnb buf_size_ok ; yes
       jmp quit                                     ; and quit
	   
       buf_size_ok:
       mov userunsolved[eax],0                            ; insert null terminator
	   
       close_file:                            
       mov eax,fileHandle
       call CloseFile

	  mov ecx , 0
	  mov esi ,offset  userunsolved
	  add esi ,97
	  mov cl , [esi]
	  sub cl , '0'
	  mov Canswers , ecx
	  inc esi 
	                                 ; saving the correct answer counter
	  mov ecx , 0
	  mov cl , [esi]
	  sub cl , '0'
	  mov Wanswers , ecx ; saving the wrong answer counter

	  mov ecx , 12
	  inc esi
	  mov eax , offset unsolvedboard

	  L1:
	  mov dl , [esi]
	  mov [eax] , dl
	  inc esi
	  inc eax
	  Loop L1

	  mov ecx , 19
	  mov eax , offset solvedboard
	  inc esi
	  L2:
	  mov dl , [esi]
	  mov [eax] , dl
	  inc esi
	  inc eax
	  Loop L2

	  mov Buffer[97] , 0

      mov edx , offset SolvedBoard
	  Invoke ReadSolvedFile , ADDR Solved 
	  mov edx , offset UnsolvedBoard 
	  Invoke ReadUnSolvedFile , ADDR unsolved
	  
	  mov edi , offset userunsolved
      mov esi ,offset unsolved
      Call Display 
	  

       quit:
       RET
ReadSavedBoard ENDP
main PROC

      
      mov edx , offset str1
	  mov al , 15
	  Call SetTextColor

      Call WriteString 
      Call crlf

	  mov edx ,offset str2 
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str3
	  Call WriteString 
	  Call crlf

	  Call ReadDec
	  cmp eax , 1
	  jne Saved
	  
	  mov edx ,offset str4
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str5
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str6
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str7
	  Call WriteString 
	  Call crlf

	  Call ReadDec
	  mov number , eax 

	  Call RandomNumber
	  mov RandBoardNumber ,eax 

	  mov ebx , offset SolvedBoard
	  mov edx ,offset UnSolvedBoard
	  Invoke ReadRandomFile , number , RandBoardNumber, ADDR userunsolved  ; get the board for the specific level

	  mov edx, offset SolvedBoard
	  Invoke ReadSolvedFile  , ADDR solved

	  mov edx ,offset UnSolvedBoard
	  Invoke ReadUnSolvedFile  , ADDR unsolved

	  Invoke  Dash , ADDR userunsolved

	  mov edi , offset userunsolved
      mov esi ,offset unsolved
	  Call Display   ; Display the board for the user 

	  invoke GetTickCount
	  mov StartTime , eax  ; start timer 

	  Again:
	  mov al , 15
	  Call SetTextColor
	  mov edx ,offset str8
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str9
	  Call WriteString 
	  Call crlf

	  Call ReadDec

	  cmp al , 1
	  jne NotCell
	  mov edx ,offset str10  ; edit a cell in the board
	  Call WriteString 
	  Call crlf

	  Call ReadDec
	  mov Row,al
	  Call ReadDec
	  mov Col,al
	  Call ReadChar
	  mov Val,al
	  Call WriteChar
	  Call crlf

	  Invoke Check , Row , Col , Val  ; check the value 

	  JMP Again
	  NotCell:                ; Clear the board
	  cmp al , 2
	  jne NotClear
	  mov edi , offset userunsolved
      mov esi ,offset unsolved
	  Call Clear                      ; clears all counters 
	  mov Ccount , 0
	  mov WCount ,0
	  
	  invoke GetTickCount
	  mov StartTime , eax              ; start timer 
	  Jmp Again

	  NotClear:
	  cmp al , 3
	  Jne NotSave
	  mov eax , offset unSolvedBoard
	  mov ebx ,offset SolvedBoard
	  mov edi , offset OutPut
	  Invoke Save , Ccount , Wcount , ADDR userunsolved  ; save the board
	  mov edx ,offset str11
	  mov al , 9

	  Call SetTextColor
	  Call WriteString
	  Call Crlf
	  Jmp Quit
	  NotSave:
	  cmp al , 4
	  Jne Quit               ; view the answer and end the game
	  invoke GetTickCount
	  mov EndTime , eax
	  mov edi , offset userunsolved
      mov esi ,offset unsolved
      mov edx , offset solved
	  Call View
	  mov edx , offset str12
	  Call WriteString
	  mov eax ,0
	  mov al , Ccount
	  Call WriteDec
	  Call crlf
	  mov edx , offset str13
	  Call WriteString
	  mov al , Wcount
	  Call WriteDec
	  call crlf
	  mov edx , offset str15
	  call writestring 
	  mov al , left
	  call writedec
	  call crlf
	  mov edx , offset str14
	  Call writestring 
	  Invoke TimeFunction , StartTime , EndTime
	  Jmp Quit
	  Saved:
	  invoke GetTickCount
	  mov StartTime , eax
	  mov edx , offset Output
	  Invoke ReadSavedBoard ,ADDR userunsolved , Ccount , Wcount
	  Jmp Again
	  Quit:
	  mov al , 15
	  Call SetTextColor
	exit

main ENDP


END main