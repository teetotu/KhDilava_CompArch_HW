format PE console
entry start

include 'win32a.inc'
;--------------------------------------------------------------------------------------------------------------------------------
; Х. Дилавар Позиция 26 Вариант 6
; Задание: массив В должен состоять из элементов массива A, значение которых кратно введённому числу x
;--------------------------------------------------------------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize     db 'Size? ', 0
        strEnterX      db 'x? ', 0
        strIncorSize   db 'Incorrect input %d', 10, 0
        strVecElemI    db '[%d]? ', 0
        strScanInt     db '%d', 0
        nextStr        db '',13,10, 0
        previousArray  db 'Array A: ', 13, 10 ,0
        modifiedArray  db 'Array B: ', 13, 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strNone        db 'Nothing here...',0
        strDivZeroError db 'Cannot divide by zero! Press any button to close this window...'

        vec_size       dd 0
        ost            dd 0
        x              dd ?
        i              dd ?
        tmp            dd ?
        tmp_var        dd ?
        last           dd 0
        first          dd 0
        newArraySize   dd 0
        tmpStack       dd ?
        vec            rd 100
        vecb           rd 100
;--------------------------------------------------------------------------------------------------------------------------------
section '.code' code readable executable
start:
        call GetX

        call VectorInput

        call CreateNewVector

        push previousArray
        call [printf]
        add esp, 4

        call VectorOut

        push nextStr
        call[printf]
        add esp, 4

        push modifiedArray
        call [printf]
        add esp, 4

        call SecondVectorOut
finish:

        call [getch]
        push 0
        call [ExitProcess]
;--------------------------------------------------------------------------------------------------------------------------------
GetX:
        push strEnterX
        call [printf]
        add esp, 4

        push x
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [x]
        cmp eax, 0
        je divZeroErrorFinish

        ret

divZeroErrorFinish:
        push strDivZeroError
        call [printf]
        add esp, 4

        jmp finish

VectorInput:
        push strVecSize 
        call [printf]   
        add esp, 4      

        push vec_size   
        push strScanInt 
        call [scanf]    
        add esp, 8      

        mov eax, [vec_size] 
        cmp eax, 0          
        jg  getVector

        push [vec_size]  
        push strIncorSize
        call [printf]
        jmp finish
getVector:
        xor ecx, ecx
        mov ebx, vec
getVecLoop:
        cmp ecx, [vec_size]        
        jge endInputVector         

        mov [i], ecx               

        push ecx
        push strVecElemI
        call [printf]

        add esp, 8                 

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i] 
        inc ecx        

        cmp ecx, [vec_size]        
        jge endInputVector

        add ebx, 4                  
        jmp getVecLoop              

endInputVector:
        
        mov ecx, [ebx]             
        mov [last], ecx            

        ret
;--------------------------------------------------------------------------------------------------------------------------------
CreateNewVector:
        xor ecx, ecx               
        mov ebx, vec               
        mov edx, vecb

iteration:
        cmp ecx, [vec_size]        
        je endCreateNewVector

        mov [tmp], edx
        mov eax, [ebx]
        mov [tmp_var], eax

        mov [i], ecx               

        mov eax, [ebx]             
        mov ecx, [x]
        xor edx, edx
        div ecx
        mov ecx, edx
        mov edx, [tmp]

        cmp ecx, 0
        jne continue


        mov eax, [tmp_var]
        mov [edx], eax              
        add edx, 4                  

        mov ecx, [newArraySize]
        inc ecx
        mov [newArraySize], ecx

continue:
        mov ecx, [i]
        inc ecx

        add ebx, 4
        jmp iteration


endCreateNewVector:
        ret
;--------------------------------------------------------------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec
outVecLoop:
        cmp ecx, [vec_size]
        je endOutputVector
        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        add ebx, 4

        jmp outVecLoop
endOutputVector:

        mov esp, [tmpStack]
        ret

;--------------------------------------------------------------------------------------------------------------------------------
SecondVectorOut:
        mov [tmpStack], esp ;
        xor ecx, ecx
        mov ebx, vecb

        cmp [newArraySize], 0
        je caseEmptyVector

SecondVectorOutLoop:
        cmp ecx, [newArraySize]
        je endSecondVectorOut

        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        add ebx, 4

        jmp SecondVectorOutLoop
caseEmptyVector:
        push strNone
        call [printf]
        add esp, 4
        jmp endSecondVectorOut

endSecondVectorOut:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------------------------------------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'