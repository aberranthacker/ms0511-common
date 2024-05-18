; RT-11 dependent macros
.macro .exit
    EMT 0350
.endm

.macro .tty_print addr
    MOV \addr,R0
    EMT 0351
.endm
