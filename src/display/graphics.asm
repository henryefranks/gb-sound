INCLUDE "display.inc"

SECTION "GRAPHICS",ROM0
WAIT_VBLANK::
    ldh a,[$FF44]		  ; get current scanline
    cp $91			      ; check if v-blank
    jr nz, WAIT_VBLANK
    ret

SET_LDC_CFG::
    ldh [LCDC],a
    ret

SET_BACKGROUND_PALLETTE::
    ldh [BGP], a
    ret

CLEAR_OAM::
    ; clearing the OAM RAM
    ld hl, _OAMRAM  ; load OAM address ($FE00)
    ld c, $A0       ; counter

.loop:
    ld a, $00
    ld [hli], a
    dec c
    jr nz, .loop

    ret
  

CLEAR_MAP::
    ld hl, _SCRN0    ; load bg map address ($9800)
    ld bc, 32*32    ; 16 bit counter

.loop:
    ld [hl], $00
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop

    ret


LOAD_TILES::
    ; assumes tiles start address is stored in hl
    ; assumes number of items to store are in c
    ld de, _VRAM

    ; shift left four times to multiply by 12 (16 bytes per tile)
    REPT 4
        sla c       ; shifts msb into carry
        rl b        ; rotate shifts carry into lsb of b
    ENDR

.loop:
    ld a, [hli]
    ld [de], a
    inc de
    dec bc
    ld a,b
    or c
    jr nz, .loop

    ret
  

LOAD_MAP::
    ; assumes address of copy is in hl
    ; assumes number of items to copy are in c
    ld de, _SCRN0

.loop:
    ld a, [hli]
    ld [de], a
    inc de
    dec c
    jr nz, .loop

    ret

DISPLAY_TILE::
    ; get screen coord
    ld hl, _SCRN0
    add hl, de
    ld [hl], a

    ret

DISPLAY_CHAR::
    ; takes the 8-bit value in a and displays
    ; it in hex at the display coord de

    ld b, a ; keep a copy
    and $F0
    REPT 4
        rr a
    ENDR
    call DISPLAY_NIBBLE

    inc de

    ld a, b ; retrieve saved copy
    and $0F
    call DISPLAY_NIBBLE

    ret

DISPLAY_NIBBLE::
    ; account for offset of 0 character
    add a, (HEX_TILES.hex - HEX_TILES) >> 4
    call DISPLAY_TILE
    ret
