.include "rt11_macros.s"
.include "ppu_macros.s"

; generic macros
.macro call addr
    JSR PC,\addr
.endm

.macro _call cond=none, dst:req ; CALL cc,nn
  .if \cond == "EQ" ; equal (z)
    BNE .+6
  .elseif \cond == "ZE" ; zero
    BNE .+6
  .elseif \cond == "NE" ; not equal (nz)
    BEQ .+6
  .elseif \cond == "NZ" ; not zero
    BEQ .+6
  .elseif \cond == "CS" ; carry set
    BCC .+6
  .elseif \cond == "CC" ; not zero
    BCS .+6
  .else
    .error "Unknown condition for conditional call"
  .endif
    JSR PC,\dst
.endm
.macro .call cond=none, dst:req ; CALL cc,nn
    _call \cond, \dst
.endm

.macro _jmp cond=none, dst:req ; JP cc,nn
  .if \cond == "EQ" ; equal (z)
    BNE .+6
  .elseif \cond == "ZE" ; zero
    BNE .+6
  .elseif \cond == "NE" ; not equal (nz)
    BEQ .+6
  .elseif \cond == "NZ" ; not zero
    BEQ .+6
  .elseif \cond == "CC" ; carry clear
    BCS .+6
  .elseif \cond == "CS" ; carry set
    BCC .+6
  .else
    .error "Unknown condition for conditional jump"
  .endif
    JMP \dst
.endm
.macro .jmp cond=none, dst:req ; JP cc,nn
    _jmp \cond, \dst
.endm

.macro return
    RTS PC
.endm

.macro push args:vararg
    .irp arg, \args
        MOV \arg, -(SP)
    .endr
.endm

.macro pop args:vararg
    .irp arg, \args
        MOV (SP)+, \arg
    .endr
.endm

.macro bze dst
    BEQ \dst
.endm

.macro bnz dst
    BNE \dst
.endm

.macro ex reg0, reg1
    XOR \reg1,\reg0
    XOR \reg0,\reg1
    XOR \reg1,\reg0
.endm

; corrupts: R3, R4, and R5
.macro _clearFB FB:req, rept_times=8
    words_loop_times = LINE_WIDTHW / \rept_times

    MOV #\FB, r5

    MOV #MAIN_SCREEN_LINES_COUNT, r4
    lines_loop\@:
        MOV #words_loop_times, r3
        words_loop\@:
            .rept \rept_times
                CLR (R5)+
            .endr
        SOB R3, words_loop\@
    SOB R4, lines_loop\@
.endm

.macro _clearFB0 rept_times=8
    _clearFB FB0, \rept_times
.endm

.macro _clearFB1 rept_times=8
    _clearFB FB1, \rept_times
.endm

; screen lines lookup table
.macro _screen_lines_lut base_addr:req, lines_count=MAIN_SCREEN_LINES_COUNT, start_line=0, step=1
    current_line = \start_line

    .rept \lines_count
        .word \base_addr + current_line * LINE_WIDTHB

        current_line = current_line + \step
    .endr
.endm

; even screen lines lookup table
.macro _even_screen_lines_lut base_addr:req, lines_count=MAIN_SCREEN_LINES_COUNT, start_line=0
    _screen_lines_lut \base_addr, \lines_count / 2, \start_line, 2
.endm

.macro _screen_char_lut base_addr:req, rows_count=24, start_row=0, char_height=8
    _screen_lines_lut \base_addr, \rows_count, \start_row, \char_height
.endm
