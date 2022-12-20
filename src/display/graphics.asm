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

DISPLAY_NIBBLE:
    ; get screen coord
    ld hl, _SCRN0
    add hl, de

    ; get tile
    inc a ; our tiles are offset by 1 in VRAM
    ld [hl], a

    ret

DEAD_BEEF::
    ld de, $00
    ld a,  $DE
    call DISPLAY_CHAR

    ld de, $02
    ld a,  $AD
    call DISPLAY_CHAR

    ld de, $05
    ld a,  $BE
    call DISPLAY_CHAR

    ld de, $07
    ld a,  $EF
    call DISPLAY_CHAR

    ret
