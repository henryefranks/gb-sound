; hex character tilemap
Section "HEX TILES", ROM0
HEX_TILES::
.space
  dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; space (0x00)
.CH
  dw $eaea, $8a8a, $8a8a, $8e8e, $8a8a, $8a8a, $eaea, $0000 ; CH (0x01)
.arrow
  dw $0000, $1818, $0c0c, $fefe, $0c0c, $1818, $0000, $0000 ; arrow (0x02)
.hex
  dw $3838, $6464, $cece, $d6d6, $e6e6, $4c4c, $3838, $0000 ; 0 (0x03)
  dw $1818, $3838, $1818, $1818, $1818, $1818, $7e7e, $0000 ; 1 (0x04)
  dw $7c7c, $c6c6, $0606, $1c1c, $7070, $e0e0, $fefe, $0000 ; 2 (0x05)
  dw $7c7c, $c6c6, $0606, $1c1c, $0606, $c6c6, $7c7c, $0000 ; 3 (0x06)
  dw $0c0c, $1c1c, $3c3c, $6c6c, $cccc, $fefe, $0c0c, $0000 ; 4 (0x07)
  dw $fefe, $8080, $fcfc, $0606, $0606, $c6c6, $7c7c, $0000 ; 5 (0x08)
  dw $7c7c, $c6c6, $c0c0, $fcfc, $c6c6, $c6c6, $7c7c, $0000 ; 6 (0x09)
  dw $7e7e, $c6c6, $0606, $0c0c, $1818, $3030, $3030, $0000 ; 7 (0x0a)
  dw $7c7c, $c6c6, $c6c6, $7c7c, $c6c6, $c6c6, $7c7c, $0000 ; 8 (0x0b)
  dw $7c7c, $c6c6, $c6c6, $7e7e, $0606, $0c0c, $3838, $0000 ; 9 (0x0c)
  dw $3838, $6c6c, $c6c6, $c6c6, $fefe, $c6c6, $c6c6, $0000 ; A (0x0d)
  dw $fcfc, $c6c6, $c6c6, $fcfc, $c6c6, $c6c6, $fcfc, $0000 ; B (0x0e)
  dw $7c7c, $c6c6, $c0c0, $c0c0, $c0c0, $c6c6, $7c7c, $0000 ; C (0x0f)
  dw $fcfc, $c6c6, $c6c6, $c6c6, $c6c6, $c6c6, $fcfc, $0000 ; D (0x10)
  dw $fefe, $c0c0, $c0c0, $fcfc, $c0c0, $c0c0, $fefe, $0000 ; E (0x11)
  dw $fefe, $c0c0, $c0c0, $f8f8, $c0c0, $c0c0, $c0c0, $0000 ; F (0x12)
