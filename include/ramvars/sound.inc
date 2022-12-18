INCLUDE "ramvars/common.inc"

; each pointer is 2 words: low and high
RSSET _AUDIO_PTRS
DEF CH1_DATA_START RW 1
DEF CH1_OFFSET     RB 1
DEF CH1_LEN        RB 1
DEF CH2_OFFSET     RB 1
DEF CH2_LEN        RB 1
DEF CH3_OFFSET     RB 1
DEF CH3_LEN        RB 1
DEF CH4_OFFSET     RB 1
DEF CH4_LEN        RB 1
