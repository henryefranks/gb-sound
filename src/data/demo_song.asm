include "data/notes.inc"

;  Demo sound file for audio engine
; ==================================
;  "Mary had a little lamb."

NOTE_SHORT EQU $10
NOTE_LONG  EQU $02
NOTE_FINAL EQU $00

Section "MUSIC", ROM0
DEMO_SONG::
  dw .ch1_data                ; r16 - pointer to channel 1 data start
  db (.ch2_data - .ch1_data)  ;  u8 - offset of ch2 data from ch1
  db (.ch3_data - .ch1_data)  ;  u8 - offset of ch3 data from ch1
  db (.ch4_data - .ch1_data)  ;  u8 - offset of ch4 data from ch1

.ch1_data:
  db ($80 | NOTE_SHORT)
  db NOTE_E4, NOTE_D4, NOTE_C4, NOTE_D4, NOTE_E4, NOTE_E4
  
  db ($80 | NOTE_LONG)
  db NOTE_E4
  
  db ($80 | NOTE_SHORT)
  db NOTE_D4, NOTE_D4
  
  db ($80 | NOTE_LONG)
  db NOTE_D4
  
  db ($80 | NOTE_SHORT)
  db NOTE_E4, NOTE_G4
  
  db ($80 | NOTE_LONG)
  db NOTE_G4
  
  db ($80 | NOTE_SHORT)
  db NOTE_E4, NOTE_D4, NOTE_C4, NOTE_D4, NOTE_E4, NOTE_E4,
  db NOTE_E4, NOTE_E4, NOTE_D4, NOTE_D4, NOTE_E4, NOTE_D4
  
  db ($80 | NOTE_FINAL)
  db NOTE_C4
  
  .ch2_data:
  nop
  
.ch3_data:
  nop

.ch4_data:
  nop
  