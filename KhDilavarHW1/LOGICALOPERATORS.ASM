format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        resStr db 'Result: %d ', 0

        A dw ?
        B dw ?
        C dw ?

        NULL = 0

section '.code' code readable executable

        start:
                mov eax, 100b
                and ecx, 101b

                push eax
                push resStr
                call[printf]

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