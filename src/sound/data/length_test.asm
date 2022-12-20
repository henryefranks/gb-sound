include "data/notes.inc"

Section "LENGTH TEST", ROM0
LENGTH_TEST::
    dw .ch1_data                ; r16 - pointer to channel 1 data start
    db (.ch2_data - .ch1_data)  ;  u8 - offset of ch2 data from ch1
    db (.ch3_data - .ch1_data)  ;  u8 - offset of ch3 data from ch1
    db (.ch4_data - .ch1_data)  ;  u8 - offset of ch4 data from ch1

.ch1_data:
    db ($80 | $20)
    
    REPT 3 * 4
        db NOTE_C2, NOTE_D2, NOTE_E2, NOTE_F2
        db NOTE_G2, NOTE_F2, NOTE_E2, NOTE_D2
    ENDR

.ch2_data:
    db ($80 | $38)

    REPT 3
        db NOTE_C5, NOTE_C6, NOTE_C3, NOTE_C4,
        db NOTE_D5, NOTE_D6, NOTE_D3, NOTE_D4,
        db NOTE_E5, NOTE_E6, NOTE_E3, NOTE_E4,
        db NOTE_F5, NOTE_F6, NOTE_F3, NOTE_F4,
        db NOTE_G5, NOTE_G6, NOTE_G3, NOTE_G4,
        db NOTE_F5, NOTE_F6, NOTE_F3, NOTE_F4,
        db NOTE_E5, NOTE_E6, NOTE_E3, NOTE_E4,
        db NOTE_D5, NOTE_D6, NOTE_D3, NOTE_D4,
    ENDR

.ch3_data:
nop

.ch4_data:
nop
