include "data/demo_music.inc"

;  Demo sound file for audio engine
; ==================================
;
; We structure our sound files in the following way:
;
; HEADER
; | The header holds four pointers, one for each audio channel.
; |
; | Each pointer points to the location of the
; | start of that channel's audio data.
; |
; | In the future additional information relating to the required
; | configuration may be added to this header. Using pointers in this
; | way (alongside labels) allows us to allocate as much space as we
; | need for the header.
; +
;
; AUDIO DATA (x4)
; | Each channel's audio data is structured as an array of structures,
; | defined as follows:
; |
; | {
; |   command - 8b
; |   additional data - 32b
; | }
; |
; | The command is one of a number of different operators. We define
; | the operational function of each and the use of the additional 32b
; | data space as follows:
; |
; | COMMAND 0x00 - NOP
; | Play no sound for the desired duration.
; |
; | Uses the following data allocation:
; | {
; |   command - 0x00
; |   length  - 8b
; |   --------------
; |   unused  - 24b
; | }
; |
; | COMMAND 0x01 - PLAY NOTE
; | Play a note with the provided 'wavelength' for a given duration.
; |
; | Uses the following data allocation:
; | {
; |   command    - 0x01
; |   length     - 8b
; |   wavelength - 16b
; |   -----------------
; |   unused     - 8b
; | }
; |
; | COMMAND 0x02 - GOTO
; | Jump to another memory location.
; |
; | Uses the following data allocation:
; | {
; |   command - 0x02
; |   address - 16b
; |   --------------
; |   unused  - 16b
; | }
; |
; +

Section "C Major Scale", ROM0[_DEMO_DATA_START]
DEMO_DATA::
  dw .ch1_data ; r16 - pointer to channel 1 data start
  dw .ch2_data ; r16 - pointer to channel 2 data start
  dw .ch3_data ; r16 - pointer to channel 3 data start
  dw .ch4_data ; r16 - pointer to channel 4 data start

.ch1_data:
  nop

.ch2_data:
  nop

.ch3_data:
  db $01
  db $70
  dw $0706
  db $00
  
  db $01
  db $70
  dw $0721
  db $00
  
  db $01
  db $70
  dw $0739
  db $00
  
  db $01
  db $70
  dw $0744
  db $00
  
  db $01
  db $70
  dw $0759
  db $00
  
  db $01
  db $70
  dw $0768
  db $00
  
  db $01
  db $70
  dw $0778
  db $00
  
  db $01
  db $70
  dw $0783
  db $00
  
  db $02
  dw .ch3_data
  dw $0000

.ch4_data:
  nop
  