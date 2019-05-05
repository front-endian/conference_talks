; Copyright (c) 2019, Colin Fulton
; All rights reserved.

                  ; $2000 to $5FFF is normally hi-res graphics.
                  ; It's unused by the Monitor and Basic.
                  ORG   $2000

                  ; Import the presentation tool
                  PUT   fruity_asm_presenter



;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     ;;
;;  Additional Macros  ;;
;;                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;



; Contact info that is inserted in a couple places
CONTACT_INFO      MAC
                  _
                  _
                  ___   "COLIN FULTON                "
                  _
                  ___   "TWITTER: @PETERQUINES       "
                  ___   "GITHUB:  JUSTCOLIN          "
                  ___   "EMAIL:   JUSTCOLIN@GMAIL.COM"
                  <<<



;;;;;;;;;;;;;;
;;          ;;
;;  Slides  ;;
;;          ;;
;;;;;;;;;;;;;;



slide_data_start  START_OF_SHOW
                  _
                  _
                  TITLE "RUNNING RUBY ON THE APPLE ]["
                  CONTACT_INFO



                  SLIDE
                  TITLE "FIRST, A MEA CULPA"
                  ; NOTES:
                  ;   A working version of Ruby on the Apple ][
                  ;   is coming soon, but there are a couple
                  ;   implementation details that have to be
                  ;   sorted first.
                  PAUSE
                  ___   '"COME SEE RUBY RUNNING WHERE'
                  ___   'IT HAS NEVER RUN BEFORE ..."'
                  PAUSE
                  _
                  _
                  _     "RUBY ISN'T RUNNING ON THE APPLE ][ YET."
                  PAUSE
                  _     "I'M SORRY."
                  _
                  _
                  PAUSE
                  ___   '"... LEARN HOW SUCH A RICH LANGUAGE'
                  ___   'CAN BE SQUEEZED DOWN TO FIT'
                  ___   'ON THE HUMBLE APPLE ][."'
                  PAUSE
                  _
                  _
                  _     "THIS YOU WILL SEE."



                  SLIDE
                  _
                  _
                  _
                  _
                  TITLE "PROGRAM LIKE IT'S 1977 ON THE APPLE ]["
                  ___   "WOZ STYLE"



                  SLIDE
                  TITLE "RUBY WOULD BE SO MUCH BETTER"
                  ; NOTES:
                  ;   Theoretically mRuby could be stripped down
                  ;   to fit on an Apple ][, especially one of
                  ;   the models with "a lot" of memory. However,
                  ;   many important feature would have to be
                  ;   removed. Maybe one day mRuby will get small
                  ;   enough that it can run on this kind of
                  ;   vintage hardware!
                  PAUSE
                  _     "LET'S COMPILE AND RUN CRUBY!"
                  PAUSE
                  _     "  - CRUBY EXPECTS THINGS..."
                  PAUSE
                  _     "    LIKE A FILE SYSTEM"
                  PAUSE
                  _     "    AND UNICODE"
                  PAUSE
                  _     "    ... AND ASCII"
                  PAUSE
                  _     "  - CRUBY BINARY IS OVER 3MB IN SIZE!"
                  PAUSE
                  _     "    WOULD BE LARGER EVEN ON THE 6502"
                  PAUSE
                  _
                  _     "MRUBY TO THE RESCUE!"
                  PAUSE
                  _     "  - STILL TOO BIG"
                  PAUSE
                  _     "  - NOT WELL OPTIMIZED FOR 8-BIT CPU'S"
                  PAUSE
                  _     "  - C IS TOO HIGH LEVEL"
                  PAUSE
                  _
                  _     "ALL HOPE IS LOST?"


                  SLIDE
                  _
                  _
                  _
                  ___   "    ___     __           "
                  ___   "   /! /!    ! \    !     "
                  ___   "  /_!/ ! __ !_/    !_    "
                  ___   " /! /  ! ! \! \ ! !! !! !"
                  ___   "/_!/   ! ! !!  \!_!!_!!_!"
                  ___   "! /    !                !"
                  ___   "!/_____!    FOR THE   \_!"
                  ___   "           APPLE  ][     "
                  PAUSE
                  _
                  _
                  ___   "THE JOY OF RUBY, BUT REALLY SMALL"
                  ___   "REALLY REALLY SMALL"
                  PAUSE
                  _
                  ___   "WRITTEN IN ASSEMBLY"
                  PAUSE
                  _
                  ___   "NANO-RUBY?"
                  PAUSE
                  _
                  ___   'AN "N" IS HALF AN "M"'



                  SLIDE
                  TITLE "NRUBY DESIGN"
                  PAUSE
                  _     "  - FLEXIBLE RUBY SYNTAX"
                  PAUSE
                  _     "  - PURE OBJECT ORIENTED"
                  PAUSE
                  _     "  - FEATURES WE ALL LOVE:"
                  PAUSE
                  _     "    - MODULES"
                  PAUSE
                  _     "    - BLOCKS"
                  PAUSE
                  _     "    - IRB"
                  PAUSE
                  _     "    - ENUMERABLES"
                  PAUSE
                  _     "    - EVAL"
                  PAUSE
                  _     "  - MORE DYNAMIC THAN ANYONE NEEDS"
                  PAUSE
                  _     "  - DYNAMIC MEMORY ALLOCATION AND GC"
                  PAUSE
                  _     "  - MAKE AS MANY OBJECTS AS YOU WANT!"
                  PAUSE
                  _     "    AS LONG AS YOU WANT 256, OR FEWER"
                  PAUSE
                  _     "    256 OBJECTS IS ENOUGH, RIGHT?"



                  SLIDE
                  TITLE "ASSEMBLY?!"
                  PAUSE
                  _     "LESS SCARY THAN YOU MAY THINK:"
                  _
                  PAUSE
                  _     "YOU CAN DO A THING TO A REGISTER"
                  PAUSE
                  _     "YOU CAN DO A THING TO A BYTE IN MEMORY"
                  PAUSE
                  _     "YOU CAN JUMP TO ANOTHER PART OF THE CODE"
                  PAUSE
                  _
                  ___   "LABEL      MNEMONIC    ARGUMENT"
                  ___   "-------------------------------"
                  PAUSE
                  ; Load the a register (LDA) with a literal
                  ; value (#) of hexidecimal ($) 0.
                  ___   "           LDA         #$00    "
                  PAUSE

                  ; Clear the carry bit (CLC) so we can safely
                  ; add without worry about what code ran before.
                  ___   "           CLC                 "
                  PAUSE

                  ; "Loop" just adds a label that we can use
                  ; elswhere to refer to the address of the next
                  ; opcode. Add a value to the A register (ADC).
                  ; We have to call "ADC #$01" becaue the 6502
                  ; assembler didn't have an increment operation
                  ; for the A register.
                  ___   "LOOP       ADC         #$01    "
                  PAUSE

                  ; Compare the value in the A register (CMP)
                  ; with the value at the given address (COUNT
                  ; could be any address on the zero page).
                  ; If they are equal, set the zero flag. Unset
                  ; the flag if they are not equal.
                  ___   "           CMP         COUNT   "
                  PAUSE

                  ; Branch if the zero flag is not set (BNE
                  ; stands for "Branch if Not Equal"). If it
                  ; isn't set, offset the program counter so it
                  ; is at th given address (LOOP).
                  ___   "           BNE         LOOP    "
                  PAUSE

                  ; Halt execution (BRK stands for "BReaK").
                  ___   "           BRK                 "



                  SLIDE
                  TITLE "QUICK INTRO TO THE 6502"
                  ; NOTES:
                  ;   If you want to learn more about how the
                  ;   6502 CPU works, 6502.org is a great
                  ;   resource. There are many good books that
                  ;   were written in the 80's about 6502
                  ;   programming. Many are available for free
                  ;   from Archive.org.
                  PAUSE
                  _     "  - 8-BIT PROCESSOR"
                  PAUSE
                  _     '  - "A" REGISTER IS YOUR ACCUMULATOR'
                  PAUSE
                  _     '  - "X" AND "Y" REGISTERS ARE INDEXES'
                  PAUSE
                  _     '  - "FLAG" REGISTER'
                  PAUSE
                  _     '  - "STACK POINTER" REGISTER'
                  PAUSE
                  _     "  - PROGRAM COUNTER"
                  PAUSE
                  _     "  - INSTRUCTIONS ARE 1 TO 3 BYTES"
                  PAUSE
                  _     "  - 56 MNEMONICS FOR INSTRUCTIONS"
                  PAUSE
                  _     "  - 16-BIT ADDRESS SPACE"
                  _     "    ... HOW DOES THAT WORK?"
                  PAUSE
                  _     "  - PAGES ARE 256 BYTES LONG"
                  PAUSE
                  _     "  - PAGE 1 HAS THE STACK"
                  PAUSE
                  _     "  - PAGE 0 IS SPECIAL"



                  SLIDE
                  TITLE "MEMORY MANAGEMENT: GARBAGE COLLECTION"
                  ; NOTES:
                  ;   See my RubyConf 2019 talk for a friendly
                  ;   introduction to CRuby's GC:
                  ;     "Trash Talk: A Garbage Collection Choose
                  ;      Your Own Adventure"
                  PAUSE
                  _     "  - CRUBY USES A MARK AND SWEEP GC"
                  PAUSE
                  _     "  - THIS HAS MANY ADVANTAGES,"
                  _     "    BUT IT IS VERY COMPLICATED"
                  PAUSE
                  _
                  _     "  - REFERENCE COUNTING IS MUCH SIMPLER"
                  PAUSE
                  _     "  - HOWEVER, IT HAS SOME SERIOUS ISSUES"



                  SLIDE
                  TITLE "MEMORY MANAGEMENT: DYNAMIC MEMORY"
                  ; NOTES:
                  ;   nRuby uses a static 4KB of memory to store
                  ;   object data. It consists of 16 pages of
                  ;   memory, each with 16 slots taking up 16KB
                  ;   each. An object can span more than one slot
                  ;   if it needs more than 16KB to store its
                  ;   data. An object's slots don't have to be
                  ;   contiguous.
                  ___   "  PAGE 0    PAGE 1    PAGE 2   ..."
                  ___   " ---------------------------------"
                  ___   " [SLOT 0]  [SLOT 16] [SLOT 32] ..."
                  ___   " [SLOT 1]  [SLOT 17] [SLOT 33] ..."
                  ___   " [SLOT 2]  [SLOT 18] [SLOT 34] ..."
                  ___   " [SLOT 3]  [SLOT 19] [SLOT 35] ..."
                  ___   " [SLOT 4]  [SLOT 20] [SLOT 36] ..."
                  ___   " [SLOT 5]  [SLOT 21] [SLOT 37] ..."
                  ___   " [SLOT 6]  [SLOT 22] [SLOT 38] ..."
                  ___   " [SLOT 7]  [SLOT 23] [SLOT 39] ..."
                  ___   " [SLOT 8]  [SLOT 24] [SLOT 40] ..."
                  ___   " [SLOT 9]  [SLOT 25] [SLOT 41] ..."
                  ___   " [SLOT 10] [SLOT 26] [SLOT 42] ..."
                  ___   " [SLOT 11] [SLOT 27] [SLOT 43] ..."
                  ___   " [SLOT 12] [SLOT 28] [SLOT 44] ..."
                  ___   " [SLOT 13] [SLOT 29] [SLOT 45] ..."
                  ___   " [SLOT 14] [SLOT 30] [SLOT 46] ..."
                  ___   " [SLOT 15] [SLOT 31] [SLOT 47] ..."



                  SLIDE
                  TITLE "SLOT MEMORY LAYOUT"
                  ; NOTES:
                  ;   The first slot for an object stores the
                  ;   following data on each byte.
                  _     " 0  REFERENCE COUNT"
                  _     " 1  CLASS ID"
                  _     " 2  OBJECT SIZE"
                  _     " 3  DATA"
                  _     " 4  DATA"
                  _     " 5  DATA"
                  _     " 6  DATA"
                  _     " 7  DATA"
                  _     " 8  DATA"
                  _     " 9  DATA"
                  _     "10  DATA"
                  _     "11  DATA"
                  _     "12  DATA"
                  _     "13  DATA"
                  _     "14  DATA"
                  _     "15  NEXT SLOT ID"



                  SLIDE
                  TITLE "NEXT SLOTS MEMORY LAYOUT"
                  ; NOTES:
                  ;   If an object needs additional slots they
                  ;   will be laid out like this.
                  _     " 0  REFERENCE COUNT"
                  _     " 1  DATA"
                  _     " 2  DATA"
                  _     " 3  DATA"
                  _     " 4  DATA"
                  _     " 5  DATA"
                  _     " 6  DATA"
                  _     " 7  DATA"
                  _     " 8  DATA"
                  _     " 9  DATA"
                  _     "10  DATA"
                  _     "11  DATA"
                  _     "12  DATA"
                  _     "13  DATA"
                  _     "14  DATA"
                  _     "15  NEXT SLOT ID"



                  SLIDE
                  TITLE "CALCULATING OBJECT ID"
                  ; NOTES:
                  ;   Each slot has a unique single byte ID. At
                  ;   first slots were laid out in ascending
                  ;   order as show here.
                  ___   "  PAGE 0    PAGE 1    PAGE 2   ..."
                  ___   " ---------------------------------"
                  ___   " [SLOT 0]  [SLOT 16] [SLOT 32] ..."
                  ___   " [SLOT 1]  [SLOT 17] [SLOT 33] ..."
                  ___   " [SLOT 2]  [SLOT 18] [SLOT 34] ..."
                  ___   " [SLOT 3]  [SLOT 19] [SLOT 35] ..."
                  ___   " [SLOT 4]  [SLOT 20] [SLOT 36] ..."
                  ___   " [SLOT 5]  [SLOT 21] [SLOT 37] ..."
                  ___   " [SLOT 6]  [SLOT 22] [SLOT 38] ..."
                  ___   " [SLOT 7]  [SLOT 23] [SLOT 39] ..."
                  ___   " [SLOT 8]  [SLOT 24] [SLOT 40] ..."
                  ___   " [SLOT 9]  [SLOT 25] [SLOT 41] ..."
                  ___   " [SLOT 10] [SLOT 26] [SLOT 42] ..."
                  ___   " [SLOT 11] [SLOT 27] [SLOT 43] ..."
                  ___   " [SLOT 12] [SLOT 28] [SLOT 44] ..."
                  ___   " [SLOT 13] [SLOT 29] [SLOT 45] ..."
                  ___   " [SLOT 14] [SLOT 30] [SLOT 46] ..."
                  ___   " [SLOT 15] [SLOT 31] [SLOT 47] ..."



                  SLIDE
                  ; NOTES:
                  ;   Here was the code to calculate the address
                  ;   of a slot from it's ID. Note all of the
                  ;   shift operations needed because the first
                  ;   nibble of the ID represents the position in
                  ;   the page and the second nibble represents
                  ;   the page the slot is on.
                  TITLE "CALCULATING OBJECT ID"
                  _     "LET'S SAY WE HAVE AN OBJECT ID OF $CF"
                  PAUSE
                  _     "$CF == BYTE 240 ($F0) OF PAGE 12 ($0C)"
                  _
                  PAUSE
                  _     "OBJ_ID_TO_ADDR TAX"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               STA   OBJ_ADDR_BYTE"
                  _     "               TXA"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               CLC"
                  _     "               ADC   #>OBJ_SPACE"
                  _     "               STA   OBJ_ADDR_PAGE"
                  _     "               RTS"



                  SLIDE
                  TITLE "WE CAN GET CLEVER:"
                  ; NOTES:
                  ;   That code can be made faster and smaller
                  ;   by reconsidering the slot layout.
                  ___   "  PAGE 0    PAGE 1    PAGE 2   ..."
                  ___   " ---------------------------------"
                  ___   " [SLOT 0]  [SLOT 16] [SLOT 32] ..."
                  ___   " [SLOT 1]  [SLOT 17] [SLOT 33] ..."
                  ___   " [SLOT 2]  [SLOT 18] [SLOT 34] ..."
                  ___   " [SLOT 3]  [SLOT 19] [SLOT 35] ..."
                  ___   " [SLOT 4]  [SLOT 20] [SLOT 36] ..."
                  ___   " [SLOT 5]  [SLOT 21] [SLOT 37] ..."
                  ___   " [SLOT 6]  [SLOT 22] [SLOT 38] ..."
                  ___   " [SLOT 7]  [SLOT 23] [SLOT 39] ..."
                  ___   " [SLOT 8]  [SLOT 24] [SLOT 40] ..."
                  ___   " [SLOT 9]  [SLOT 25] [SLOT 41] ..."
                  ___   " [SLOT 10] [SLOT 26] [SLOT 42] ..."
                  ___   " [SLOT 11] [SLOT 27] [SLOT 43] ..."
                  ___   " [SLOT 12] [SLOT 28] [SLOT 44] ..."
                  ___   " [SLOT 13] [SLOT 29] [SLOT 45] ..."
                  ___   " [SLOT 14] [SLOT 30] [SLOT 46] ..."
                  ___   " [SLOT 15] [SLOT 31] [SLOT 47] ..."



                  SLIDE
                  TITLE "WE CAN GET CLEVER:"
                  ; NOTES:
                  ;   By changing it so the slots first fill up
                  ;   the first slot of each page, then the
                  ;   second slot on each page, etc, instead of
                  ;   being in sequential order our code can be
                  ;   faster and smaller.
                  ___   "  PAGE 0     PAGE 1     PAGE 2    ..."
                  ___   " ------------------------------------"
                  ___   " [SLOT 0]   [SLOT 1]   [SLOT 2]   ..."
                  ___   " [SLOT 16]  [SLOT 17]  [SLOT 18]  ..."
                  ___   " [SLOT 32]  [SLOT 33]  [SLOT 34]  ..."
                  ___   " [SLOT 48]  [SLOT 49]  [SLOT 50]  ..."
                  ___   " [SLOT 64]  [SLOT 65]  [SLOT 66]  ..."
                  ___   " [SLOT 80]  [SLOT 81]  [SLOT 82]  ..."
                  ___   " [SLOT 96]  [SLOT 97]  [SLOT 98]  ..."
                  ___   " [SLOT 112] [SLOT 113] [SLOT 114] ..."
                  ___   " [SLOT 128] [SLOT 129] [SLOT 130] ..."
                  ___   " [SLOT 144] [SLOT 145] [SLOT 146] ..."
                  ___   " [SLOT 160] [SLOT 161] [SLOT 162] ..."
                  ___   " [SLOT 176] [SLOT 177] [SLOT 178] ..."
                  ___   " [SLOT 192] [SLOT 193] [SLOT 194] ..."
                  ___   " [SLOT 208] [SLOT 209] [SLOT 210] ..."
                  ___   " [SLOT 224] [SLOT 225] [SLOT 226] ..."
                  ___   " [SLOT 240] [SLOT 241] [SLOT 242] ..."



                  SLIDE
                  ; NOTES:
                  ;   Here is the new version of the subroutine
                  ;   that calculates the address from a given
                  ;   slot ID. Note that because we flipped which
                  ;   nibble does what we can remove all those
                  ;   shift operations and replace them with
                  ;   simple bit masks. It is faster and cleaner.
                  ;   This is the kind of hand optimization that
                  ;   one can spend months and months adding to
                  ;   an assembly program.
                  TITLE "CALCULATING OBJECT ID"
                  _     "$CF == BYTE 192 ($C0) OF 15 PAGE ($0F)"
                  _     "       ($0FC0 INSTEAD OF $0CF0)"
                  _
                  PAUSE
                  _     "OBJ_ID_TO_ADDR TAX"
                  _     "               AND   #$F0"
                  _     "               STA   OBJ_ADDR_BYTE"
                  _     "               TXA"
                  _     "               AND   #$0F"
                  _     "               CLC"
                  _     "               ADC   #>OBJ_SPACE"
                  _     "               STA   OBJ_ADDR_PAGE"
                  _     "               RTS"



                  SLIDE
                  ; NOTES:
                  ;   Before...
                  _
                  _
                  _
                  _     "OBJ_ID_TO_ADDR TAX"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               ASL"
                  _     "               STA   OBJ_ADDR_BYTE"
                  _     "               TXA"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               LSR"
                  _     "               CLC"
                  _     "               ADC   #>OBJ_SPACE"
                  _     "               STA   OBJ_ADDR_PAGE"
                  _     "               RTS"



                  SLIDE
                  ; NOTES:
                  ;   After!
                  _
                  _
                  _
                  _     "OBJ_ID_TO_ADDR TAX"
                  _     "               AND   #$F0"
                  _     "               STA   OBJ_ADDR_BYTE"
                  _     "               TXA"
                  _     "               AND   #$0F"
                  _     "               CLC"
                  _     "               ADC   #>OBJ_SPACE"
                  _     "               STA   OBJ_ADDR_PAGE"
                  _     "               RTS"



                  SLIDE
                  _
                  _
                  ___   "PARSING RUBY SYNTAX USING ASSEMBLY"
                  ___   "MUST BE REALLY HARD, RIGHT?"
                  _
                  PAUSE
                  _     "LET'S WALK THROUGH TURNING RUBY CODE"
                  _     "INTO NRUBY'S VM BYTE CODE."



                  SLIDE
                  ; NOTES:
                  ;   Instead of a full parser, nRuby has a hand
                  ;   written parser done in assembly that reads
                  ;   the source code byte by byte, going though
                  ;   a state machine to figure out what opcode
                  ;   to write next. Parsing into opcodes then
                  ;   interpreting those ended up being easier
                  ;   to deal with and more memory efficient than
                  ;   writing a straight interpretor. When the
                  ;   nRuby parser encounters a word it gives it
                  ;   a unique ID by storing every word it hasn't
                  ;   seen before in a table. This was easier
                  ;   than a hashing algorithm, and because each
                  ;   ID is only one byte, avoiding hash
                  ;   collisions was going to be too hard.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "SYMBOLS:"
                  _
                  PAUSE
                  _     "FIRST WE NEED A WAY TO TURN SYMBOLS"
                  _     "(TOKENS OR ATOMS) INTO A UNIQUE INTEGER"
                  PAUSE
                  _
                  _     '    TABLE IN MEMORY:   "PUTS DONE DEF"'
                  PAUSE
                  _
                  _     "    DEF DO_THING(ARG_1, ARG_2)"



                  SLIDE
                  ; NOTES:
                  ;   Assignment expressions are easy to parse.
                  ;   Get the name of the value, see that there
                  ;   is an equal sign, write out the opcodes to
                  ;   push the value onto the stack, then add a
                  ;   OP_SET_LOCAL opcode to do the assignment.
                  ;   $4C is the ID of X in this program.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "ASSIGNMENT:"
                  _
                  _     "X = 10"
                  PAUSE
                  _
                  _     "    OP_LITERAL_INT"
                  _     "    $0A"
                  _     "    $00"
                  PAUSE
                  _     "    OP_SET_LOCAL"
                  PAUSE
                  _     "    $4C  (X'S ID)"



                  SLIDE
                  ; NOTES:
                  ;   A bare word in Ruby could be a method call
                  ;   on self or getting a local. We use a
                  ;   special opcode for this case because the
                  ;   parser can't know which kind of call this
                  ;   is.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "AMBIGUOUS SYNTAX:"
                  _
                  _     "SMORP"
                  PAUSE
                  _
                  _     "    OP_CALL_OR_LOCAL"
                  PAUSE
                  _     "    $E7  (SMORP'S ID)"



                  SLIDE
                  ; NOTES:
                  ;   The dot syntax for doing method calls is
                  ;   easy to recognize for the state machine and
                  ;   translates into some simple stack
                  ;   operations. OP_DOT_CALL calls the method
                  ;   with the given name on the object on the
                  ;   top of the stack.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "DOT METHOD:"
                  _
                  _     "FOO.BAR(BAZ)"
                  PAUSE
                  _
                  _     "    OP_CALL_OR_LOCAL"
                  _     "    $DE  FOO"
                  PAUSE
                  _     "    OP_DOT_CALL"
                  PAUSE
                  _     "    $6A  BAR"
                  PAUSE
                  _     "    OP_CALL_OR_LOCAL"
                  PAUSE
                  _     "    $08  BAZ"
                  PAUSE
                  _     "    OP_ARG_APPEND"
                  PAUSE
                  _     "    OP_ARG_END"



                  SLIDE
                  ; NOTES:
                  ;   Interpolated strings can easily be
                  ;   decomposed by the parser into string
                  ;   literals and calls to the + method. The
                  ;   original Apple ][ lacked curly brackets, so
                  ;   we have to use square brackets for the
                  ;   interpolation syntax.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "INTERPOLATED STRINGS:"
                  _     '"HI #[NAME]!"'
                  _
                  PAUSE
                  _     "    OP_LITERAL_STRING"
                  _     "    $C8  H"
                  _     "    $C9  I"
                  _     "    $A0"
                  PAUSE
                  _     "    $A7  '"
                  PAUSE
                  _     "    OP_DOT_CALL"
                  _     "    $03  +"
                  PAUSE
                  _     "    OP_CALL_OR_LOCAL"
                  _     "    $77  NAME"
                  PAUSE
                  _     "    OP_DOT_CALL"
                  _     "    $03  +"
                  _     "    OP_LITERAL_STRING"
                  _     "    $A1  !"
                  _     "    $A0  '"



                  SLIDE
                  ; NOTES:
                  ;   While the most common/loved Ruby syntax is
                  ;   pretty easy to parse using a state machine
                  ;   in assembly, literal integers are
                  ;   surprisingly hard to parse. Here is the
                  ;   algorithm I use. There are faster/smaller
                  ;   ones for the 6502, but amazingly enough
                  ;   this is one of the easier to understand
                  ;   algorithms for parsing integers on a 6502.
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "INTEGERS:"
                  _
                  _     "1977"
                  PAUSE
                  _
                  _     "0. SET RUNNING TOTAL TO $0000"
                  PAUSE
                  _     "1. MULTIPLY RUNNING TOTAL BY 10"
                  PAUSE
                  _     "   1A. COPY RUNNING TOTAL"
                  PAUSE
                  _     "   1B. SHIFT RUNNING TOTAL LEFT"
                  PAUSE
                  _     "   1C. SHIFT RUNNING TOTAL LEFT AGAIN"
                  PAUSE
                  _     "   1D. ADD COPY OF RUNNING TOTAL"
                  PAUSE
                  _     "   1E. SHIFT RUNNING TOTAL LEFT AGAIN"
                  PAUSE
                  _     "   X * 10 = ((X * 2 * 2) + X) * 2"
                  PAUSE
                  _     "2. CONVERT CHARACTER TO INTEGER BYTE"
                  PAUSE
                  _     '   "1" == $B1, SO JUST SUBTRACT $B0'
                  PAUSE
                  _     "3. ADD NEW DIGIT TO RUNNING TOTAL"
                  PAUSE
                  _     "4. MOVE TO NEXT DIGIT"
                  PAUSE
                  _     "5. REPEAT!"
                  PAUSE
                  _     "... AND DO OVERFLOW CHECKS AT EVERY STEP"



                  SLIDE
                  TITLE "PARSING RUBY SYNTAX USING ASSEMBLY"
                  _     "INTEGERS:"
                  _
                  _     "1977"
                  _
                  _     "    OP_LITERAL_INT"
                  PAUSE
                  _     "    $B9"
                  _     "    $07"




                  SLIDE
                  TITLE "ASSEMBLING, RUNNING, AND TESTING CODE"
                  ; NOTES:
                  ;   I found that writing a simple test
                  ;   framework in assembly then doing TDD took
                  ;   away a lot of the pain of hand writing
                  ;   assembly.
                  ;   "Modern" assemblers and compilers have been
                  ;   written for the 6502 and the Apple ][, so
                  ;   development on your modern laptop is pretty
                  ;   easy, and there are many choices.
                  PAUSE
                  _     "  - YOU CAN DO TDD IN ASSEMBLY!"
                  PAUSE
                  _     "  - DEVELOPING ON VINTAGE HARDWARE IS"
                  _     "    NOT A GREAT IDEA"
                  PAUSE
                  _     "  - VIRTUAL ][ EMULATOR"
                  PAUSE
                  _     "  - MERLIN32 ASSEMBLER"
                  PAUSE
                  _     "    BASED ON VINTAGE APPLE ][ ASSEMBLER"
                  PAUSE
                  _     "    CC65 IS ANOTHER OPTION"
                  PAUSE
                  _     "  - APPLECOMMANDER TO CREATE DSK IMAGES"
                  PAUSE
                  _     "  - ADTPRO TO TRANSFER DISK IMAGES TO"
                  _     "    A REAL APPLE ][ USING A SERIAL CABLE"



                  SLIDE
                  TITLE "WHAT'S NEXT?"
                  PAUSE
                  _     "  - FINISH NRUBY V0.1"
                  PAUSE
                  _     "  - OTHER PROCESSORS, LIKE THE MSP430"
                  PAUSE
                  _     "  - OTHER COMPUTERS RUNNING THE 6502..."
                  PAUSE
                  _     "    LIKE THE NES"
                  _     "    (2KB OF RAM AND 40KB ROM)"



                  SLIDE
                  TITLE "QUESTIONS?"
                  CONTACT_INFO



                  SLIDE
                  TITLE   "THANK YOU!"
                  CONTACT_INFO

                  END_OF_SHOW
