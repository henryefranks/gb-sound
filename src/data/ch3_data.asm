include "sound.inc"

Section "CH3 Data", ROM0[SOUNDROM]
  ; CH3 data structure
  ; length - 8b
  ; frequency - 11b (lsb of 16b word)
  db $70
  dw $0706

  db $70
  dw $0721

  db $73
  dw $0739

  db $70
  dw $0744

  db $70
  dw $0759

  db $70
  dw $0768

  db $70
  dw $0778

  db $70
  dw $0783