; kernal routines
CHROUT = $ffd2
GETIN  = $ffe4
PLOT   = $fff0
READST = $ff8a

; char codes
CHR_CLR_HOME = 147

; color codes
COLOR_BLACK  = 0
COLOR_WHITE  = 1
COLOR_RED    = 2
COLOR_CYAN   = 3
COLOR_PURPLE = 4
COLOR_GREEN  = 5
COLOR_BLUE   = 6
COLOR_YELLOW = 7

; zero page variables

cur_color   = $0286  ; color for CHROUT

;*****************************************************************
; start prg
;*****************************************************************

  .byt $01,$10 ; PRG file header (starting address of the program)

  .org $1001   ; start of basic program

;*****************************************************************
; basic stub
;*****************************************************************

  ; stub basic program
  ;
  ; 2015 SYS4109
  ;
  .word bend            ; next line link
  .word 2015            ; line number
  .byte $9e,52,49,48,57 ; sys4109 (4096+13 = bytes of basic program)
  .byte 0               ; end of line
bend:  .word 0          ; end of program

;*****************************************************************
; main program
;*****************************************************************

start:
  jsr clear_screen  ; jump save retourn -> clear_screen
  
  ldy #COLOR_YELLOW ; init y = COLOR_YELLOW
@mloop:
  tya               ; Transfer y register to accumulator (a)
  sta cur_color     ; Store accumulator (a) -> cur_color (set color CHROUT)
  jsr print_message ; jump save return -> print_message
  dey               ; y = y - 1
  bne @mloop        ; Branch if not equal (Z=0) (if y == 0 goto @mloop)
  
                    ; Restore default color
  lda #COLOR_BLUE   ; Load a = COLOR_BLUE (default color)
  sta cur_color     ; Store accumulator (a) -> cur_color (set color CHROUT)
  rts               ; exit (Return from subroutine)

clear_screen:
  lda #CHR_CLR_HOME ; Load a = CHR_CLR_HOME (147)
  jsr CHROUT        ; jump save return -> CHROUT (print a)
  rts               ; Return from subroutine

print_message:
  ldx #0            ; init x = 0
@pmloop:
  lda message,x     ; Load a = message + x
  beq exit          ; Branch if the Zero flag is set (Z=1) (if a == 0 goto exit)
  jsr CHROUT        ; jump save return -> CHROUT (print a)
  inx               ; x = x + 1
  bne @pmloop       ; Branch if not equal (Z=0) goto @pmloop
exit:
  lda #13           ; Load a = 13 (Carriage Return)
  jsr CHROUT        ; jump save return -> CHROUT (print a)
  lda #10           ; Load a = 10 (Line Feed)
  jsr CHROUT        ; jump save return -> CHROUT (print a)
  rts               ; Return from subroutine

;*****************************************************************
; data
;*****************************************************************

;              H  E  L  L  O     V  I  C  2  0   .
message: .byte 72,69,76,76,79,32,86,73,67,50,48,46,$00
