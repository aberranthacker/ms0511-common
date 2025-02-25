.include "romdefs.s"

; highest priority to the processor (VM2 ignores bits 5 and 6)
.equiv PR7, 0b11100000 ; MTPS #PR7 disables interrupts
; lowest priority to the processor
.equiv PR0, 0 ; MTPS #PR0 enables interrupts
; R   - read only
; W   - write only
; R/W - read/write
; SD  - set on power on
; RD  - reset on power on
; RIN - reset on power on and on RESET instruction
; SIN - set on power on and on RESET instruction

; CPU {{{
; CPU USER mode interrupt vectors and priorities
;     Vect  Prty  Source
;  oct dec
;   04   4     1  input/output RPLY timeout
;   04   4     2  illegal addressing mode
;  010   8     2  unknown instruction/HALT mode command in USER mode
;  014  12     3  T-bit
;  014  12     -  BPT instruction
;  020  16     -  IOT instruction
;  024  20     4  ACLO
;  030  24     -  EMT  instruction
;  034  28     -  TRAP instruction
;  060  48   7.1  TTY (channel 0) in, disabled by default
;  064  52   7.2  TTY (channel 0) out, disabled by default
; 0100  64     6  EVNT (Vsync)
; 0360 256   7.9  serial (СА) in, disabled by default
; 0364 260   7.10 serial (СА) out, disabled by default
; 0370 248   7.7  serial (C2) in, disabled by default
; 0374 252   7.8  serial (C2) out, disabled by default
; 0460 304   7.3  channel 1 in, disabled by default
; 0464 308   7.4  channel 1 out, disabled by default
; 0474 316   7.5  channel 2 out, disabled by default
; 0bxxxxxx00 7.6  address trap, disabled by default

; CPU: bitplanes registers
.equiv CBPADR, 0176640 ; CPU bitplanes address register
.equiv CBP1DT, 0176642 ; CPU bitplane 1 data register
.equiv CBP2DT, 0176643 ; CPU bitplane 2 data register
.equiv CBP12D, CBP1DT  ; CPU bitplanes 1 and 2 data register
                       ; alias for word access
; serial port С2 (RS-232)
.equiv S2IST, 0176570
.equiv S2IDT, 0176572
.equiv S2OST, 0176574
.equiv S2ODT, 0176576

; CPU: to PPU communication channels
; parallel port access channel
.equiv CCH1II, 0460    ; CPU channel 1 in  state interrupt
.equiv CCH1IS, 0176660 ; CPU channel 1 in  state register
.equiv CCH1ID, 0176662 ; CPU channel 1 in  data register
.equiv CCH1OI, 0464    ; CPU channel 1 out state interrput
.equiv CCH1OS, 0176664 ; CPU channel 1 out state register
.equiv CCH1OD, 0176666 ; CPU channel 1 out data register
; command channel
.equiv CCH2OI, 0474    ; CPU channel 2 out state interrupt
.equiv CCH2OS, 0176674 ; CPU channel 2 out state register
.equiv CCH2OD, 0176676 ; CPU channel 2 out data register
; terminal emulation channel
.equiv CCH0II, 060     ; CPU channel 0 in  state interrupt
.equiv CCH0IS, 0177560 ; CPU channel 0 in  state register
.equiv CCH0ID, 0177562 ; CPU channel 0 in  data register
.equiv CCH0OI, 064     ; CPU channel 0 out state interrupt
.equiv CCH0OS, 0177564 ; CPU channel 0 out state register
.equiv CCH0OD, 0177566 ; CPU channel 0 out data register
.equiv TTYIST, CCH0IS  ; TTY in state
.equiv TTYIDT, CCH0ID  ; TTY in data
.equiv TTYOST, CCH0OS  ; TTY out state
.equiv TTYODT, CCH0OD  ; TTY out data
.equiv TTY.Input.State, TTYIST
.equiv TTY.Input.Data,  TTYIDT
.equiv TTY.In.State, TTYIST
.equiv TTY.In.Data,  TTYIDT
.equiv TTY.Output.State, TTYOST
.equiv TTY.Output.Data,  TTYODT
.equiv TTY.Out.State, TTYOST
.equiv TTY.Out.Data,  TTYODT

; SRAM module register
.equiv WNDRGS, 0176000 ; windows registers
.equiv WNDRGA, 0176000 ; window a register
.equiv WNDRGB, 0176001 ; window b register
; }}}

; PPU {{{
; PPU USER mode interrupt vectors and priorities
;     Vect Prty  Handler   PSW  Source
;  oct dec
;   04   4    1  0173632  0600  input/output RPLY timeout
;   04   4    2                 illegal addressing mode
;  010   8    2  0160210  0600  unknown instruction/HALT mode command in USER mode
;  014  12    3  0000000  0000  T-bit
;  014  12    -                 BPT instruction
;  020  16    -  0000000  0000  IOT instruction
;  024  20    4  0160220  0600  ACLO
;  030  24    -  0174270  0000  EMT  instruction
;  034  28    -  0174334  0200  TRAP instruction
; 0100  64    6  0174612  0200  EVNT (Vsync)
; 0300 192  7.3  0175412  0200  keyboard
; 0304 196  7.2  0174612  0200  programmable timer reached 0
; 0310 200  7.1  0000000  0000  external event
; 0314 204  7.4  0176130  0200  RESET on CPU bus
; 0320 208  7.5  0175700  0200  channel 0 in  (TTY)
; 0324 212  7.6  0175540  0200  channel 0 out (TTY)
; 0330 216  7.7  0175754  0000  channel 1 in  (printer)
; 0334 220  7.8  0000000  0000  channel 1 out (printer)
; 0340 224  7.9  0175762  0200  channel 2 in  (command)

; PPU: bitplanes registers
.equiv PBPADR, 0177010 ; PPU bitplanes address register
.equiv PBP0DT, 0177012 ; PPU bitplane 0 data register
.equiv PBP1DT, 0177014 ; PPU bitplane 1 data register
.equiv PBP2DT, 0177015 ; PPU bitplane 2 data register
.equiv PBP12D, PBP1DT  ; alias for word access
.equiv DTSCOL, 0177016 ; PPU dots color
.equiv BP01BC, 0177020 ; PPU bitplanes 0/1 background color
.equiv BP12BC, 0177022 ; PPU bitplanes 1/2 background color
.equiv DTSOCT, 0177024 ; PPU dots octet
.equiv PBPMSK, 0177026 ; PPU bitplanes mask register

.equiv PPU.Bitplanes_AddressReg, PBPADR
.equiv PPU.BP0_DataReg, PBP0DT
.equiv PPU.BP1_DataReg, PBP1DT
.equiv PPU.BP2_DataReg, PBP2DT
.equiv PPU.BP12_DataReg, PBP12D
.equiv PPU.DotsColorReg, DTSCOL
.equiv PPU.BP01_BackgroundColorReg, BP01BC
.equiv PPU.BP12_BackgroundColorReg, BP12BC
.equiv PPU.DotsOctetReg, DTSOCT
.equiv PPU.BitplanesMaskReg, PBPMSK

.equiv PASWCR, 0177054 ; PPU address space window control register

; PPU: to CPU communication channels
; terminal emulation channel
.equiv PCH0II, 0320    ; PPU channel 0 in  data interrupt
.equiv PCH0ID, 0177060 ; PPU channel 0 in  data register
.equiv PCH0OI, 0324    ; PPU channel 0 out data interrupt
.equiv PCH0OD, 0177070 ; PPU channel 0 out data register
; parallel port access channel
.equiv PCH1II, 0330    ; PPU channel 1 in  data interrupt
.equiv PCH1ID, 0177062 ; PPU channel 1 in  data register
.equiv PCH1OI, 0334    ; PPU channel 1 out data interrupt
.equiv PCH1OD, 0177072 ; PPU channel 1 out data register
; command channel
.equiv PCH2II, 0340    ; PPU channel 2 in  data interrupt
.equiv PCH2ID, 0177064 ; PPU channel 2 in  data register

; 0177066 default value 0b01000111
.equiv PCHSIS, 0177066 ; PPU channels 0, 1, 2 in - state register
; 0177076 default value 0b00111110
.equiv PCHSOS, 0177076 ; PPU channels 0/1 out - state register

.equiv Ch0StateInInt,  0b00000001 ; channel 0 interrupt allowed
.equiv Ch1StateInInt,  0b00000010 ; channel 1 interrupt allowed
.equiv Ch2StateInInt,  0b00000100 ; channel 2 interrupt allowed
.equiv Ch0InReady,     0b00001000 ; channel 0 has data to read
.equiv Ch1InReady,     0b00010000 ; channel 1 has data to read
.equiv Ch2InReady,     0b00100000 ; channel 2 has data to read
.equiv IntOnCPU_RESET, 0b01000000 ; interrupt on RESET on CPU bus

.equiv RSTINT, 0314    ; RESET on CPU bus interrupt

; PPU: programmable parallel interface
.equiv PAR.A,  0177100 ; parallel port A data register
.equiv PAR.B,  0177101 ; parallel port B data register
.equiv PAR.C,  0177102 ; parallel port C data register
.equiv PARCTL, 0177103 ; parallel port control byte

; PPU: floppy disk controller
.equiv FDCST,  0177130 ; floppy disk controller state register
.equiv FDCDT,  0177132 ; floppy disk controller data register

; PPU: keyboard
.equiv KBINT,  0300    ; keyboard interrupt
.equiv KBSTAT, 0177700 ; keyboard state register
.equiv KBDATA, 0177702 ; keyboard data register

; PPU: Programmable timer
.equiv TMRST,  0177710 ; State register
.equiv TMREVN, 0310    ; External event interrupt
.equiv TMRINT, 0304    ; Programmable timer interrupt
.equiv TMRBRG, 0177712 ; Buffer register
.equiv TMRBUF, TMRBRG
.equiv TMRCST, 0177714 ; Current state register

.equiv CTRLRG, 0177716 ; system control register

.equiv PSG0, 0177360
.equiv PSG1, 0177362
.equiv PSG2, 0177364
.equiv OPL2, 0177374 ; 65276 0xFEFC
; register stub, responds with RPLY, returns 010000 (4096)
.equiv STUB_REGISTER, 0177704
; }}}
