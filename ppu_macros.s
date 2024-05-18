.macro .ppudo_enqueue cmd:req, arg=0
  .if \arg != 0
    MOV #\arg, @#PPUCommandArg
  .endif
    MOV #\cmd, @#CCH0OD
.endm

.macro _ppu_enqueue cmd:req, arg=0
    .ppudo_enqueue \cmd, \arg
.endm

.macro .ppudo_enqueue_ensure cmd:req, arg=0
    TSTB @#CCH0OS
    BPL .-4
   .ppudo_enqueue \cmd, \arg
.endm

.macro _ppu_enqueue_ensure cmd:req, arg=0
    .ppudo_enqueue_ensure \cmd, \arg
.endm

.macro .ppudo cmd:req
    MOV \cmd, @#CCH2OD
.endm

.macro .ppudo_ensure cmd:req
    TSTB @#CCH2OS
    BPL .-4
    .ppudo \cmd
.endm

.macro .inform_and_hang str
   .ppudo_enqueue_ensure PPU_DebugPrintAt, inform_and_hang_string\@
    BR  .
inform_and_hang_string\@:
   .byte 0, 1
   .asciz "\str"
   .even
.endm

.macro .inform_and_hang2 str
   .ppudo_enqueue_ensure PPU_DebugPrintAt, inform_and_hang2_string\@
    BR  .
inform_and_hang2_string\@:
   .byte 0, 2
   .asciz "\str"
   .even
.endm

.macro .inform_and_hang3 str
   .ppudo_enqueue_ensure PPU_DebugPrintAt, inform_and_hang3_string\@
    BR  .
inform_and_hang3_string\@:
   .byte 0, 3
   .asciz "\str"
   .even
.endm

.macro .check_for_loading_error file_name
    BCC no_loading_error\@
   .inform_and_hang2 "\file_name loading error"

no_loading_error\@:
.endm
