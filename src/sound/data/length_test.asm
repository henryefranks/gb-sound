include "data/notes.inc"

Section "LENGTH TEST", ROM0
LENGTH_TEST::
    dw .ch1_data                ; r16 - pointer to channel 1 data start
    db (.ch2_data - .ch1_data)  ;  u8 - offset of ch2 data from ch1
    db (.ch3_data - .ch1_data)  ;  u8 - offset of ch3 data from ch1
    db (.ch4_data - .ch1_data)  ;  u8 - offset of ch4 data from ch1

.ch1_data:
    db ($80 | $10)

    db NOTE_C3, NOTE_E3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_E3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_E3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_E3, NOTE_C3, NOTE_G3

    db NOTE_C3, NOTE_D3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_D3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_D3, NOTE_C3, NOTE_G3
    db NOTE_C3, NOTE_D3, NOTE_C3, NOTE_G3

    db NOTE_D3, NOTE_F3, NOTE_C3, NOTE_D3
    db NOTE_D3, NOTE_F3, NOTE_C3, NOTE_D3
    db NOTE_D3, NOTE_F3, NOTE_C3, NOTE_D3
    db NOTE_D3, NOTE_F3, NOTE_C3, NOTE_D3
    
.ch2_data:
    db ($80 | $00)

    db NOTE_C2, NOTE_C3
    db NOTE_C2, NOTE_C3
    db NOTE_C2, NOTE_C3
    db NOTE_C2, NOTE_C3

    db NOTE_D2, NOTE_C3
    db NOTE_C2, NOTE_G3
    db NOTE_D2, NOTE_C3
    db NOTE_C2, NOTE_G3

    db NOTE_C3, NOTE_D3
    db NOTE_E3, NOTE_C2
    db NOTE_D2, NOTE_E2
    db NOTE_F2, NOTE_G2

.ch3_data:
nop

.ch4_data:
nop
