; ZX0 v2.2 standart unpacker
; original ZX0 encoder/decoder (c) Einar Saukas & Urusergi
; https://github.com/einar-saukas/ZX0
;
; PDP11 version by reddie, 02-may-2024 (upd)
; PDP11 version takes 92 bytes
;
; input: R0 - source data addr (compressed)
;        R1 - addr for decompressing data
; output: R0 - next byte after the source data
;         R1 - next byte after the decompressed data
; corrupts: R2, R3, R4, R5

unZX0:

DZX0:
    CLR R2
    MOVB #0200,R3
    SXT R5

DZX0_LITERALS:

    CALL DZX0_ELIAS
    10$:
        MOVB (R0)+,(R1)+
    SOB R2,10$
    ASLB R3
    BCS DZX0_NEW_OFFSET
    CALL DZX0_ELIAS

DZX0_COPY:

    MOV R1,R4
    ADD R5,R4
    10$:
        MOVB (R4)+,(R1)+
    SOB R2,10$
    ASLB R3
    BCC DZX0_LITERALS

DZX0_NEW_OFFSET:

    MOV #-2,R2
    CALL DZX0_ELIAS_LOOP
    INCB R2
    BZE 1237$

    SWAB R2
    MOV R2,R5
    CLRB R5
    BISB (R0)+,R5
    ASR R5

    MOV #1,R2
    _call CC, DZX0_ELIAS_BACKTRACK
    INC R2
    BR DZX0_COPY

DZX0_ELIAS:

    INCB R2

DZX0_ELIAS_LOOP:

    ASLB R3
    BNZ DZX0_ELIAS_SKIP
    MOVB (R0)+,R3
    ROLB R3

DZX0_ELIAS_SKIP:

    BCS 1237$

DZX0_ELIAS_BACKTRACK:

    ASLB R3
    ROL R2
    BR  DZX0_ELIAS_LOOP

1237$:RETURN
