format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable
                              resStr db 'Result: %d ', 0
        A dd ?
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable

        start:
                mov [A], 150
                mov [B], 10

                        mov ecx, [A]
                        add ecx, [B]

                        push ecx
                         push resStr
                        call [printf]

                call[getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable


        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'


        import kernel,\
               ExitProcess, 'ExitProcess'


        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'