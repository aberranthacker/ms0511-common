; key codes #-----------------------------------------------------{{{
; | oct | hex|  key    | note     | oct | hex|  key  |  note     |
; |-----+----+---------+----------+-----+----+-------+-----------|
; |   5 | 05 | ,       | numpad   | 106 | 46 | АЛФ   | 🌐Language|
; |   6 | 06 | АР2     | Esc      | 107 | 47 | ФИКС  | Lock      |
; |   7 | 07 | ; / +   |          | 110 | 48 | Ч / ^ |           |
; |  10 | 08 | К1 / К6 | F1 / F6  | 111 | 49 | С / S |           |
; |  11 | 09 | К2 / К7 | F2 / F7  | 112 | 4A | М / M |           |
; |  12 | 0A | КЗ / К8 | F3 / F8  | 113 | 4B | SPACE |           |
; |  13 | 0B | 4 / ¤   |          | 114 | 4C | Т / T |           |
; |  14 | 0C | К4 / К9 | F4 / F9  | 115 | 4D | Ь / X |           |
; |  15 | 0D | К5 / К10| F5 / F10 | 116 | 4E | ←     |           |
; |  16 | 0E | 7 / '   |          | 117 | 4F | , / < |           |
; |  17 | 0F | 8 / (   |          | 125 | 55 | 7     | numpad    |
; |  25 | 15 | -       | numPad   | 126 | 56 | 0     | numpad    |
; |  26 | 16 | ТАБ     | Tab      | 127 | 57 | 1     | numpad    |
; |  27 | 17 | Й / J   |          | 130 | 58 | 4     | numpad    |
; |  30 | 18 | 1 / !   |          | 131 | 59 | +     | numpad    |
; |  31 | 19 | 2 / "   |          | 132 | 5A | <=|   | Backspace |
; |  32 | 1A | 3 / #   |          | 133 | 5B | →     |           |
; |  33 | 1B | Е / E   |          | 134 | 5C | ↓     |           |
; |  34 | 1C | 5 / %   |          | 135 | 5D | . / > |           |
; |  35 | 1D | 6 / &   |          | 136 | 5E | Э / \ |           |
; |  36 | 1E | Ш / [   |          | 137 | 5F | Ж / V |           |
; |  37 | 1F | Щ / ]   |          | 145 | 65 | 8     | numpad    |
; |  46 | 26 | УПР     | Ctrl     | 146 | 66 | .     | numpad    |
; |  47 | 27 | Ф / F   |          | 147 | 67 | 2     | numpad    |
; |  50 | 28 | Ц / C   |          | 150 | 68 | 5     | numpad    |
; |  51 | 29 | У / U   |          | 151 | 69 | ИСП   | Exec      |
; |  52 | 2A | К / K   |          | 152 | 6A | УСТ   | Set       |
; |  53 | 2B | П / P   |          | 153 | 6B | ↵     | Return    |
; |  54 | 2C | H / N   |          | 154 | 6C | ↑     |           |
; |  55 | 2D | Г / G   |          | 155 | 6D | : / * |           |
; |  56 | 2E | Л / L   |          | 156 | 6E | Х / H |           |
; |  57 | 2F | Д / D   |          | 157 | 6F | З / Z |           |
; |  66 | 36 | ГРАФ    | Graph    | 165 | 75 | 9     | numpad    |
; |  67 | 37 | Я / Q   |          | 166 | 76 | ВВОД  | Enter     |
; |  70 | 38 | Ы / Y   |          | 167 | 77 | 3     | numpad    |
; |  71 | 39 | В / W   |          | 170 | 78 | 7     | numpad    |
; |  72 | 3A | А / A   |          | 171 | 79 | СБРОС | Reset     |
; |  73 | 3B | И / I   |          | 172 | 7A | ПОМ   | Help      |
; |  74 | 3C | Р / R   |          | 173 | 7B | / / ? |           |
; |  75 | 3D | О / O   |          | 174 | 7C | Ъ / } |           |
; |  76 | 3E | Б / B   |          | 175 | 7D | - / = |           |
; |  77 | 3F | Ю / @   |          | 176 | 7E | О / } |           |
; | 105 | 45 | ⇕ HP    | Shift    | 177 | 7F | 9 / ) |           |
;-----------------------------------------------------------------}}}

; JCU ; QWE
; FYW ; ASD

.equiv A_PRESSED, 072
.equiv A_RELEASED, A_PRESSED & 0x0F | 0x80

.equiv C_PRESSED, 050
.equiv C_RELEASED, C_PRESSED & 0x0F | 0x80

.equiv D_PRESSED, 057
.equiv D_RELEASED, D_PRESSED & 0x0F | 0x80

.equiv E_PRESSED, 033
.equiv E_RELEASED, E_PRESSED & 0x0F | 0x80

.equiv F_PRESSED, 047
.equiv F_RELEASED, F_PRESSED & 0x0F | 0x80

.equiv J_PRESSED, 027
.equiv J_RELEASED, J_PRESSED & 0x0F | 0x80

.equiv Q_PRESSED, 067
.equiv Q_RELEASED, Q_PRESSED & 0x0F | 0x80

.equiv S_PRESSED, 0111
.equiv S_RELEASED, S_PRESSED & 0x0F | 0x80

.equiv U_PRESSED, 051
.equiv U_RELEASED, U_PRESSED & 0x0F | 0x80

.equiv W_PRESSED, 071
.equiv W_RELEASED, W_PRESSED & 0x0F | 0x80

.equiv Y_PRESSED, 070
.equiv Y_RELEASED, Y_PRESSED & 0x0F | 0x80

.equiv RETURN_PRESSED,  0153
.equiv RETURN_RELEASED, RETURN_PRESSED & 0x0F | 0x80

.equiv KEYPAD_RETURN_PRESSED,  0166
.equiv KEYPAD_RETURN_RELEASED, KEYPAD_RETURN_PRESSED & 0x0F | 0x80

.equiv UP_PRESSED, 0154
.equiv UP_RELEASED, UP_PRESSED & 0x0F | 0x80

.equiv DOWN_PRESSED, 0134
.equiv DOWN_RELEASED, DOWN_PRESSED & 0x0F | 0x80

.equiv LEFT_PRESSED, 0116
.equiv LEFT_RELEASED, LEFT_PRESSED & 0x0F | 0x80

.equiv RIGHT_PRESSED, 0133
.equiv RIGHT_RELEASED, RIGHT_PRESSED & 0x0F | 0x80
