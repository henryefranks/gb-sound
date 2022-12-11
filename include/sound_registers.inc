; General Sound Control Registers
SOUND_VOL_CTRL  EQU $FF24
SOUND_PAN_CTRL  EQU $FF25
SOUND_ON_OFF    EQU $FF26

; Individual Channel Control Registers
SOUND_CH1_SWEEP             EQU $FF10
SOUND_CH1_LEN_DUTY          EQU $FF11
SOUND_CH1_VOL_ENV           EQU $FF12
SOUND_CH1_WAVELEN_L         EQU $FF13
SOUND_CH1_WAVELEN_H_CTRL    EQU $FF14

SOUND_CH2_LEN_DUTY          EQU $FF16
SOUND_CH2_VOL_ENV           EQU $FF17
SOUND_CH2_WAVELEN_L         EQU $FF18
SOUND_CH2_WAVELEN_H_CTRL    EQU $FF19

SOUND_CH3_DAC_EN            EQU $FF1A
SOUND_CH3_LEN               EQU $FF1B
SOUND_CH3_VOL               EQU $FF1C
SOUND_CH3_WAVELEN_L         EQU $FF1D
SOUND_CH3_WAVELEN_H_CTRL    EQU $FF1E
SOUND_CH3_WAVERAM_START     EQU $FF30

SOUND_CH4_LEN               EQU $FF20
SOUND_CH4_VOL               EQU $FF21
SOUND_CH4_FREQ_RAND         EQU $FF22
SOUND_CH4_CTRL              EQU $FF23