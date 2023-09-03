# initialize our scanlines parameters table (SLTAB):
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
312 (1..312) lines is SECAM half-frame
309 (1..309) SLTAB records in total (lines 4..312 of SECAM's half-frame)
  scanlines   1..19  are not visible due to the vertical blanking interval
  scanlines  20..307 are visible (lines 23-310 of SECAM's half-frame)
  scanlines 308..309 are not visible due to the vertical blanking interval

| 2-word records | 4-word records |
| 0 address      | 0 data         | data - words that will be loaded into
| 2 next record  | 2 data         |        control registers
|                | 4 address      | address - address of the line to display
|                | 6 next record  | next record - address of the next record of
                                                  the SLTAB
Very first record of the table is 2-word and has fixed address 0270
--------------------------------------------------------------------------------
"next record" word description: ---------------------------------------------{{{

+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+
|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3|   2 |   1 |    0 |
+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+
|     address of the next record       | sel |2W/4W|cursor|
+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+

bit 0: cursor switching control
       1 - switch cursor state (on/off)
       0 - save cursor state
       Hardware draws cursor in a range of sequential lines.
       The cursor has to be switched "on" on the first line of the sequence,
       saved in between, and turned "off" on the last line of the sequence.

bit 1: size of the next record
       1 - next is a 4-word record
       0 - next is a 2-word record

bit 2: 1) for 2-word record - bit 2 of address of the next element of the table
       2) for 4-word record - selects register to which data will be loaded:
          0 - cursor, pallete, and horizontal scale control register
          1 - colors control register
-----------------------------------------------------------------------------}}}
cursor, pallete and horizontal scale control registers desription: ----------{{{

1st word
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+
| 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |  7 |  6 |  5 |  4 | 3 | 2 | 1 | 0 |
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+
| X  | cursor position within a line    |graph curs pos|type| Y | R | G | B |
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+

bits 0-3:  cursor color and brightness
bit 4:     cursor type
           1 - graphic cursor
           0 - character cursor
bits 5-7:  graphic cursor position within pixels octet
           0 - least significant bit (on the left side of the octet)
           7 - most significant bit (on the right side of the octet)
bits 8-14: cursor position within a text line
           from 0 to 79

2nd word
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+
| 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 |  2 |  1 |  0 |
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+
|                     unused                  | scale | X | PB | PG | PR |
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+

bits 0-2:  brightness of RGB components on the whole line
           1 - full brightness
           0 - 50% of the full brightness
bit 3:     unused
bits 4,5:  horizontal scale
           | 5 | 4 | width px | width chars | last char pos |
           +---+---+----------+-------------+---------------+
           | 0 | 0 |   640    |     80      |     0117      |
           | 0 | 1 |   320    |     40      |      047      |
           | 1 | 0 |   160    |     20      |      023      |
           | 1 | 1 |    80    |     10      |      011      |
bits 6-15: unused
-----------------------------------------------------------------------------}}}
colors control registers description:----------------------------------------{{{

1st word
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           |15 |14 |13 |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           | Y | R | G | B | Y | R | G | B | Y | R | G | B | Y | R | G | B |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
bitplanes  |      011      |      010      |      001      |      000      |
bit 2,1,0

2nd word
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           |15 |14 |13 |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           | Y | R | G | B | Y | R | G | B | Y | R | G | B | Y | R | G | B |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
bitplanes  |      111      |      110      |      101      |      100      |
bits 2,1,0
-----------------------------------------------------------------------------}}}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
SLTABInit:
        MOV  $SLTAB,R0       # set R0 to beginning of SLTAB
        MOV  R0,R1           # R0 address of current record (2)

        MOV  $15,R2          #  records 2..16 are same
        1$:
            CLR  (R0)+       #--addresses of lines 2..16
            ADD  $4,R1       #  calc address of next record of SLTAB
            MOV  R1,(R0)+    #--address of records 3..17
        SOB  R2,1$

      # we are switching from 2-word records to 4-word records
      # so we have to align at 4 words (8 bytes)
        CLR  (R0)+           #--address of line 17
        ADD  $0b1000,R1      #  align

        BIS  $0b0010,R1      #  next record is 4-word
        BIC  $0b0100,R1      #  set cursor/scale/palette
        MOV  R1,(R0)+        #--address of the record 18
        ADD  $0b100,R0       #  correct R0 due to alignment
        BIC  $0b100,R0

        MOV  $0b10000,(R0)+  #--cursor settings, graphical cursor
        MOV  $0b10111,(R0)+  #  320 dots per line, palette 7
        CLR  (R0)+           #  address of line 18
        BIS  $0b110,R1       #  next record is 4-word, color settings
        ADD  $8,R1           #  calculate address to next record
        MOV  R1,(R0)+        #--pointer to record 19

        MOV  R0,@$TopAreaColors # store the address for future use
        MOV  $0xBA90,(R0)+   # colors  011  010  001  000 (YRGB)
        MOV  $0xFEDC,(R0)+   # colors  111  110  101  100 (YRGB)
        CLR  (R0)+           #--address of line 19
        BIC  $0b110,R1       #  next record is 2-word
        ADD  $8,R1           #  calculate pointer to next record
        MOV  R1,(R0)+        #--pointer to the record 20
#------------------------------------- top region, header
        MOV  $AUX_SCREEN_ADDR,R2 # scanlines 20..307 are visible
        MOV  $AUX_SCREEN_LINES_COUNT >> 1 - 1,R3       #
        2$:
            MOV  R2,(R0)+    #--address of screenline
            ADD  $4,R1       #  calc address of next record of SLTAB
            MOV  R1,(R0)+    #--set address of next record of SLTAB
            ADD  $40,R2      #  calculate address of next screenline
        SOB  R3,2$           #

      # we are switching from 2-word records to 4-word records
      # so we have to align at 8 bytes
        MOV  R2,(R0)+        #--address of a screenline
        BIS  $0b0010,R1      #  next record is 4-word
        BIC  $0b0100,R1      #  display settings
        ADD  $0b1000,R1      #  calc address of next record of SLTAB
                             #  taking alignment into account
        MOV  R1,(R0)+        #--pointer to record 63
        ADD  $0b100,R0       #  correct R0
        BIC  $0b100,R0       #  due to alignment
        ADD  $40,R2          #  calculate address of next screenline

        MOV  R0,@$MainScreenLinesTable   #
        SUB  $2,@$MainScreenLinesTable   #

        MOV  $0b10000,(R0)+  #--cursor settings: graphical cursor
        MOV  $0b10111,(R0)+  #  320 dots per line, pallete 7
        MOV  R2,(R0)+        #--address of a screenline
        ADD  $8,R1           #  calc address of next record of SLTAB
        BIS  $0b110,R1       #  next record is 4-word, color settings
        MOV  R0,@$MainScreenFirstRecAddr
        MOV  R1,(R0)+        #--pointer to record 64

        MOV  R0,@$FB0_FirstRecAddr
#----------------------------- main screen area
        MOV  $FB0 - 4, R2 # address of second frame-buffer
        MOV  $MAIN_SCREEN_LINES_COUNT, R3 # number of lines on main screen area

        3$:                    #
           .ifdef DEBUG
            MOV  $0x3300,(R0)+ #  colors  011  010  001  000 (YRGB)
            MOV  $0xFFDD,(R0)+ #  colors  111  110  101  100 (YRGB)
           .else
            MOV  $0x0000,(R0)+ #  colors  011  010  001  000 (YRGB)
            MOV  $0x0000,(R0)+ #  colors  111  110  101  100 (YRGB)
           .endif
            MOV  R2,(R0)+      #--main RAM address of a scanline
           #ADD  $40,R2        #  calculate address of next screenline
            ADD  $36,R2        #  calculate address of next screenline
            ADD  $8,R1         #  calc address of next record of SLTAB
            MOV  R1,(R0)+      #--pointer to the next record of SLTAB
        SOB  R3,3$             #
        MOV  R1,BottomAreaFirstRec
#------------------------------------- bottom region, footer
        MOV  R0,@$BottomAreaColors # store the address for future use
        MOV  $0xBA90,(R0)+   # colors  011  010  001  000 (YRGB)
        MOV  $0xFEDC,(R0)+   # colors  111  110  101  100 (YRGB)
       .equiv BOTTOM_AREA_OFFSET, (AUX_SCREEN_LINES_COUNT >> 1) * 40 + 40
        MOV  $AUX_SCREEN_ADDR + BOTTOM_AREA_OFFSET, R2  #
        MOV  R2,(R0)+        #
        ADD  $40,R2          # calculate address of next screenline
        ADD  $8,R1           # calculate pointer to next record
        BIC  $0b110,R1       # next record consists of 2 words
        MOV  R1,(R0)+        #--set address of record 265

        MOV  $AUX_SCREEN_LINES_COUNT >> 1 - 2,R3          #
        4$:
            MOV  R2,(R0)+    #--address of a screenline
            ADD  $4,R1       #  calc address of next record of SLTAB
            MOV  R1,(R0)+    #--pointer to the next record of SLTAB
            ADD  $40,R2      # calculate address of next screenline
        SOB  R3,4$           #
                             #
        CLR  (R0)+           #--address of line 308
        MOV  R1,(R0)+        #--pointer back to record 308

        ADD  $0b111,R0      #  correct R0
        BIC  $0b111,R0      #  due to alignment
        MOV  R0, @$FB1_FirstRecAddr
        MOV  R0, R1
        BIS  $0b110,R1
        MOV  $(FB1 - 8) >> 1,R2    # address of second frame-buffer

        MOV  $MAIN_SCREEN_LINES_COUNT,R3 # number of lines on main screen area
        5$:
            MOV  $0x3300,(R0)+
            MOV  $0xFFDD,(R0)+

            MOV  R2,(R0)+
            ADD  $36,R2

            ADD  $8,R1
            MOV  R1,(R0)+
        SOB  R3,5$

       .equiv BottomAreaFirstRec, .+2
        MOV  $0,-(R0)
