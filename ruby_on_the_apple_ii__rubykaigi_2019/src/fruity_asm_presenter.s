;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        ;;
;;  Fruity ASM Presenter  ;;
;;     by Colin Fulton    ;;
;;                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; See GitHub.com/JustColin/Fruity_ASM_Presenter for details.



;;;;;;;;;;;;;;;
;;           ;;
;;  LICENSE  ;;
;;           ;;
;;;;;;;;;;;;;;;



; Copyright (c) 2019, Colin Fulton
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or
; without modification, are permitted provided that the
; following conditions are met:
;
;   1. Redistributions of source code must retain the above
;      copyright notice, this list of conditions and the
;      following disclaimer.
;
;   2. Redistributions in binary form must reproduce the
;      above copyright notice, this list of conditions and
;      the following disclaimer in the documentation and/or
;      other materials provided with the distribution.
;
;   3. Neither the name of the copyright holder nor the
;      names of its contributors may be used to endorse or
;      promote products derived from this software without
;      specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
; CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
; INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
; CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
; OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



;;;;;;;;;;;;;;;;;;
;;              ;;
;;  CONTSTANTS  ;;
;;              ;;
;;;;;;;;;;;;;;;;;;



slide_start_byte  EQU   $FF
slide_pause_byte  EQU   $FE
end_show_byte     EQU   $FD
start_show_byte   EQU   $FC
center_line_byte  EQU   $FB



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       ;;
;;  ZERO PAGE ADDRESSES  ;;
;;                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;



char_addr         EQU   $EC
char_addr_page    EQU   $ED
line_length       EQU   $EE
stack_pointer     EQU   $EF



;;;;;;;;;;;;;;;;;;;;;;;;
;;                    ;;
;;  MONITOR ROUTINES  ;;
;;                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;



clear_screen      EQU   $FC58             ; Clear screen and reset the cursor
print_a_register  EQU   $FDED             ; Monitor routine to print
next_line         EQU   $FD8E             ; Monitor routine to print a new line
monitor_start     EQU   $FF69             ; Enter into the Apple monitor
monitor_shortcut  EQU   $03F8             ; Jumped to from monitor on control-Y



;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     ;;
;;  Initialize Memory  ;;
;;                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;



                  ORG   $2000             ; $2000 to $5FFF is normally hi-res
                                          ; graphics. It's unused by the Monitor
                                          ; and Basic.
                  LDA   #>slide_data_start
                  STA   char_addr_page
                  LDA   #<slide_data_start
                  STA   char_addr
                  LDA   #$4C              ; Store jump for the monitor shortcut
                  STA   monitor_shortcut
                  LDA   #<resume_slides
                  STA   monitor_shortcut+1
                  LDA   #>resume_slides
                  STA   monitor_shortcut+2



; Show slide that starts at the address stored in char_addr and char_addr_page
print_slide       JSR   clear_screen
parse_next_char   JSR   inc_slide_char

                  LDY   #0                ; Get the next byte
                  LDA   (char_addr), Y

                  CMP   #end_show_byte    ; Is this the end of the slide show?
                  BNE   check_slide_done  ; If no, carry on
end_of_show       JSR   run_command       ; If yes, run the next user command
                  JMP   end_of_show       ; Loop forever

check_slide_done  CMP   #slide_start_byte ; Is this the start of the next slide?
                  BNE   check_for_pause   ; If no, carry on
                  JSR   run_command       ; If yes, run the next user command
                  JMP   print_slide       ; Advance to the next slide

check_for_pause   CMP   #slide_pause_byte ; Is this a pause?
                  BNE   check_for_center  ; If no, carry on
                  JSR   run_command       ; If yes, give a chance to go back
                  JMP   parse_next_char   ; Skip pause byte and carry on

check_for_center  CMP   #center_line_byte ; Is the next line centered?
                  BNE   prep_print_line   ; If no, carry on
                  JSR   inc_slide_char    ; If yes, get the line length
                  LDY   #0
                  LDA   (char_addr), Y
                  STA   line_length
                  LDA   #40               ; Calculate the offset
                  SEC
                  SBC   line_length
                  LSR
                  TAX                     ; Print that many spaces
                  LDA   #" "
_center_next_line JSR   print_a_register
                  DEX
                  BNE   _center_next_line

prep_print_line   LDY   #0                ; Get the length of the line
                  LDA   (char_addr), Y
                  TAX

print_line        BNE   print_next_char   ; If there is more, continue printing
                  JSR   next_line         ; Else, print a new line
                  JMP   parse_next_char

print_next_char   JSR   inc_slide_char    ; Print the next char in the line
                  LDA   (char_addr), Y
                  ORA   #%10000000        ; Make sure the high bit is set so we
                                          ; can use Merlin32's single quote STR
                  JSR   print_a_register
                  DEX                     ; Decrement the char counter
                  JMP   print_line        ; Loop



;;;;;;;;;;;;;;;;;;;
;;               ;;
;;  Subroutines  ;;
;;               ;;
;;;;;;;;;;;;;;;;;;;



run_command       LDA   $C000             ; Read the last key typed
                  BPL   run_command       ; If nothing was typed, loop
                  STA   $C010             ; Reset the keyboard strobe

                  CMP   #" "              ; On space, carry on
                  BEQ   return

                  CMP   #"M"              ; On "M", jump to the monitor
                  BNE   _check_for_back

                  JSR   clear_screen
                  JSR   back_one_slide    ; Reset to start of current slide
                  TSX                     ; Stash the current stack pointer
                  STX   stack_pointer
                  JMP   monitor_start

_check_for_back   CMP   #$88              ; On anything except "LEFT", try again
                  BNE   run_command

                  PLA                     ; Pop the return address off the stack
                  PLA
                  JSR   back_one_slide    ; Go to start of this slide
                  JSR   back_one_slide    ; Go to start of the previous slide
                  JMP   print_slide       ; Jump to printing the slide



back_one_slide    CMP   #start_show_byte  ; Are we at the start?
                  BEQ   return            ; If yes, return
                  LDA   char_addr         ; Check if we will underflow
                  BNE   _dec_char_addr    ; If we won't, carry on
                  DEC   char_addr_page    ; If we will, decrement the page
_dec_char_addr    DEC   char_addr         ; Decrement the character address
                  LDY   #0                ; Load the current character
                  LDA   (char_addr), Y
                  CMP   #start_show_byte  ; Are we back at the start?
                  BEQ   return            ; If yes, return
                  CMP   #slide_start_byte ; Are we at the start of a slide?
                  BEQ   return            ; If yes, return
                  JMP   back_one_slide    ; Else, continue going backwards

inc_slide_char    INC   char_addr         ; Increment to the next character
                  BNE   return            ; If we didn't overflow, return
                  INC   char_addr_page    ; Else, increment the page too

return            RTS



resume_slides     LDX   stack_pointer     ; Restore the stack pointer
                  TXS
                  JMP   print_slide       ; Reprint the current slide



;;;;;;;;;;;;;;
;;          ;;
;:  Macros  ;;
;;          ;;
;;;;;;;;;;;;;;



; Set where the slide show starts
START_OF_SHOW     MAC
                  DFB   start_show_byte
                  <<<

; Set where a new slide starts
SLIDE             MAC
                  DFB   slide_start_byte
                  <<<

 ; Pause before continuing to print the rest of a slide
PAUSE             MAC
                  DFB   slide_pause_byte
                  <<<

; Set where the slide show ends
END_OF_SHOW       MAC
                  DFB   end_show_byte
                  <<<

; A single line of text in a slide
_                 MAC
                  DO ]0
                  STR   ]1
                  ELSE
                  STR   ""
                  FIN
                  <<<

; A centered line of text in a slide
___               MAC
                  DFB   center_line_byte
                  _     ]1
                  <<<

; The title at the start of a slide
TITLE             MAC
                  _
                  _
                  ___   ]1
                  _
                  _
                  <<<
