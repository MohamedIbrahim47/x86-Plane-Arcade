;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GAME RULES AND HOW TO PLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   RULES:-
;;         # Player1 controls 'w','a','s','d' 
;;         # Player2 controls 'u','h','j','k'
;;         # Each player has 5 lives
;;         # There are a variety of different flying missiles that are generated all over the map that can bounce on the walls
;;         # If a player crashes into a missile he/she loses a life
;;         # A player loses the game when they have no more lives left
;;
;;           
;;   POWERUPS:-
;;
;;         1- "Boost" powerup that increases the player's velocity who picks it up (Increase the velocity in all possible direction even if they are reversed)       
;;         2- "Slow"  powerup that decreases the other player's velocity in all possible directions even if they are reversed
;;         3- "Rocket Launcher" If a player picks it up he/she can charge by holding "space" then release to shoot a missile (Can be re-used but 1 missile at a time)
;;         4- "reverse" if a player picks it up the other player's movement is reversed!
;;         5- "Shock wave" if a player picks it up he/she charge a devastating shock wave that causes chaos and disruption among flying missiles and it powers them up 
;;
;;   GAME MECHANICS:-
;;
;;         # I have built the game to support the "clicking concept" so the clicking genre fans would never find it boring (if you want to move effectively click FAST)
;;         # The 5 different powerups really synergises together. And because a player can pickup the 5 powerups in 120 different ways calculations were made to 
;;           insure that the arrangement of powerups is balanced and doenst break the game.
;;         # Because powerups synergise together if a player picks them up in a specific order they can make different powerful combos but as a game developer i will
;;           leave that for the gamers to explore!
;;         # Some combos are not available(nerf) to avoid breaking the game so expect not to pickup every powerup you attempt to pick (for the other player to pick)
;;         # hint-> a rocket launcher launches the rocket in the rockets velocity direction (initially up) in y-axis. It is intentionally made that way so the player
;;           can control the direction of the rocket.(if a player wants to shoot down, he/she shoots up then wait until the rocket goes down then recharge)
;;         # The game has an exciting learning curve perhaps more features would be added in the future.
;;         # Because shock wave is so cool we made it reset when a player picks up another powerup (limited 5 times)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CREDIT::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;;;;;;;;;
;;         This game is dedicated to a cmp project developed by
;;         # Mohamed ibrahim -> i.mohamedibrahim1313@gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; C O D E ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.MODEL SMALL
.386
.STACK 64

.DATA
    ;m's
        m1_x dw 9     ;x cords of m1
        m1_y dw 25    ;y cods of m1

        m2_x dw 200
        m2_y dw 46

        m3_x dw 100
        m3_y dw 67

        m4_x dw 250
        m4_y dw 88

        m5_x dw 50
        m5_y dw 109

        m6_x dw 30
        m6_y dw 130

        m7_x dw 70
        m7_y dw 151

        m8_x dw 170
        m8_y dw 172
        ;;;;;;;;;;9 to 16
        m9_x dw 309
        m9_y dw 36

        m10_x dw 120
        m10_y dw 55

        m11_x dw 220
        m11_y dw 72

        m12_x dw 270
        m12_y dw 100

        m13_x dw 80
        m13_y dw 120

        m14_x dw 180
        m14_y dw 140

        m15_x dw 40
        m15_y dw 160

        m16_x dw 80
        m16_y dw 60
   
    ;m velocity list
        m1_velocity_r dw 02h     ;m velocity in x axis to right
        m2_velocity_r dw 02h
        m3_velocity_r dw 02h
        m4_velocity_r dw 02h
        m5_velocity_r dw 02h
        m6_velocity_r dw 02h
        m7_velocity_r dw 02h
        m8_velocity_r dw 02h

        m9_velocity_l dw 02h     ;m velocity in x axis to left
        m10_velocity_l dw 02h
        m11_velocity_l dw 02h
        m12_velocity_l dw 02h
        m13_velocity_l dw 02h
        m14_velocity_l dw 02h
        m15_velocity_l dw 02h
        m16_velocity_l dw 02h

    
    time db 0               ;variable time used in checking
    window_h dw 0a8h        ;height of window(168 pixels)
    window_w dw 12d         ;width of window(301 pixels)

    window_bounds dw 6      ;variable used to check collisions early

    ;players data
        PLAYER1_X       DW 0AH
        PLAYER1_Y       DW 0afH     ;player1 initial position
        PLAYER2_X       DW 127H      ;player2 initial position
        PLAYER2_Y       DW 0afH

        PLAYER_WIDTH    DW 0FH
        PLAYER_HEIGHT   DW 05H

        PLAYER1_VELOCITY DW 05H
        PLAYER2_VELOCITY DW 05H




    ;strings
        mes_player1 db 'Player 1 Lives:'                            ; 15 characters
        mes_player2 db 'Player 2 Lives:'                            ; 15 characters
        mes_player1_lives db '5'                                    ; 1 character
        mes_player2_lives db '5'                                    ; 1 character
        
        mes_player1_win db 'Player 1 won the game!'                 ; 22 characters
        mes_player2_win db 'Player 2 won the game!'                 ; 22 characters

        mes_player1_slowed db 'Player 1 is slowed down!'            ; 24 characters
        mes_player2_slowed db 'Player 2 is slowed down!'            ; 24 characters

        mes_player1_reversed db 'Player 1 movement is reversed!'    ; 30 characters
        mes_player2_reversed db 'Player 2 movement is reversed!'    ; 30 characters

        mes_player1_hasgun db 'Player 1 has the rocket launcher!'   ; 33 characters
        mes_player2_hasgun db 'Player 2 has the rocket launcher!'   ; 33 characters

        mes_player1_boosted db 'Player 1 boosted!'                  ; 16 characters
        mes_player2_boosted db 'Player 2 boosted!'                  ; 16 characters

        mes_speed db 'SHOCK WAVE!'                                  ; 11 characters

    ;powerups data
        ;slow down data
            sd_x dw 160     ;160 almost the middle on x-axis
            sd_y dw 133     ;
            
            slowed_before db 0
            player1_isslowed db 0
            player2_isslowed db 0

        ;reverse data   
            r_x dw 160      ;160 almost the middle on x-axis
            r_y dw 59       ;25 almost the top of the map

            reversed_before db 0
            player1_isreversed db 0
            player2_isreversed db 0

            player1_itisreversed db 0
            player2_itisreversed db 0 

        ;boost data
            boost_x dw 160
            boost_y dw 175

            boost_before db 0
            player1_isboosted db 0
            player2_isboosted db 0


        ;speed data
            speed_x dw 160
            speed_y dw 22

            speed_before db 0
        
        ;bullet powerup
            b_x dw 160
            b_y dw 96

            bullet_before db 0
            player1_hasbullet db 0
            player2_hasbullet db 0

            player1_hasgun db 0
            player2_hasgun db 0

            bullet_x dw 0
            bullet_y dw 0
            bullet_velocity dw 06h

            shoot_player db 0

    
    
    
;data

    ;main menu data
        plane_arcade db 'P L A N E   A R C A D E' ; 23 characters
        made_by db 'made by gamers' ; 14 characters
        for db 'for gamers' ;10 characters
        mes_game db 'Press enter to play' ; 19 characters
        mes_chat db 'Press t to chat'     ; 15 characters

    ;pregame data
        ready db 'ARE YOU READY ??????'    ; 20 characters
        ready2 db '(ENTER)'               ; 7 characters


.CODE


    MAIN PROC far
        MOV AX,@DATA
        MOV DS,AX
    
        call CLEAR_SCREEN        ;refreshes screen + graphics mode "on"

        call MAIN_MENU           ;moves to pregame then checktime or moves to chat_mode

        CHECK_TIME:              ; Game code
            
            mov ah,2ch           ;get system time interrupt (DL = 1/100 seconds) ..note:- ch = hour, cl = minute, dh = second
            int 21h
            cmp dl,time
            je CHECK_TIME        ;keeps checking until dl != time

            mov time,dl          ;time is updated

            call CLEAR_SCREEN    ;refreshes screen

            call CHANGE_IN_M     ;chanegd m_x, m_y
            call DRAW_M          ;draws new m again and again.....

            call MOVE_PLAYERS   ;changes x,y of each player based on keyboard input
            call DRAW_PLAYERS   ;draws player again and again....

            call CHECK_COLLISION_PLAYERS    ;changes players score if they collide with m

            ;;powerups code بسم الله 
                ;slow down
                    call DRAW_SD                    ;draws sd as long as slowed_before = 0
                    call CHECK_COLLISION_SD         ;check collision of sd with player1 and player2 then apply changes
                    call DISPLAY_PLAYER_SLOWED      ;keeps drawing as long as player1_isslowed != 0 ||  player2_isslowed != 0
                ;reverse
                    call DRAW_R                     ;draws r as long as reversed_before = 0
                    call CHECK_COLLISION_R          ;check collision of r with player1 and player2 then apply changes
                    call DISPLAY_PLAYER_REVERSED    ;keeps drawing as long as player1_isreversed != 0 || player2_isreversed != 0
                ;bullet
                    call DRAW_B                     ;draws b as long as bullet_before = 0
                    call CHECK_COLLISION_B          ;check collision of b with player1 and player2 then apply changes
                    call DISPLAY_PLAYER_BULLET      ;keeps drawing as long as player1_hasbullet != 0 || player2_hasbullet != 0 
                    call CHECK_TRIGGER              ;checks key pressed to enable SHOOT_BULLET 
                    call SHOOT_BULLET               ;bullet main function
                ;boost
                    call DRAW_BOOST                 ;draws boost as long as boos_before = 0
                    call CHECK_COLLISION_BOOST      ;check collision of boost with player1 and player then apply changes
                    call DISPLAY_PLAYER_BOOST       ;keeps drawing as long as player1_isboosted !=0 || player2_isboosted != 0
                ;speed
                    call DRAW_SPEED                 ;draws speed as long as speed_before = 0
                    call CHECK_COLLISION_SPEED      
                    call DISPLAY_SPEED

            call DRAW_BOARDERS  
            call DRAW_STATUS_BAR
            call DRAW_SCORES
            
            
            ;;CHECK IF LOSE
                ;check for player1
                cmp mes_player1_lives,30h   ;30h is zero
                je GAME_OVER
                ;check for player2
                cmp mes_player2_lives,30h   ;30 is zero
                je GAME_OVER


            
            jmp CHECK_TIME       ;keeps checking

        GAME_OVER:
        call DISPLAY_GAMEOVER

        jmp $ ;instead of halt
        ret
    MAIN ENDP

    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN MENU CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        MAIN_MENU proc near

            call DRAW_MAIN_MENU             ;draws messages in main_menu

            rep_menu:

            MOV AH,00H                      ;waits for a key
            INT 16H
            ;;;;;;;
            CMP AL,0DH ;'Enter'             ;if user "enters" go to game_mode
            je game_mode


            ;check chat
            cmp al,74h ;'t'
            jne rep_menu                    ;keeps checking until "enter" or "t" are pressed
                    
            ;chat_mode:                     ;here it enters chat mode
            call CHAT_MENU                  ;note -> in chat_menu procedure u must add at the end jmp that skips the whole game code
            ret


            game_mode:
            call PRE_GAME

            ret
        MAIN_MENU endp

        DRAW_MAIN_MENU proc near        ;draws messages in main menu
            mov si,@DATA
            ;DRAW PLANE ARCADE
                
                ;plane_arcade db 'P L A N E   A R C A D E' ; 23 characters

                mov ah,13h          ;service to print string in graphics mode
                mov al,0            ;
                mov bh,0            ;
                mov bl,0ah          ;0000(black)background , 1111(white)foreground

                mov cx,23           ;length of string
                mov dl, 8          ;Column(0 to 39)-   x axis
                mov dh, 7          ;Row(0 to 24)-  y axis
                mov es,si           ;moves si to es
                mov bp,offset plane_arcade   
                int 10h
            
            ;DRAW LINES AROUND PLANE ARCADE
                ;top
                mov cx,60
                mov dx,50
                mov ax,0c09h 
                pa1: int 10h
                    inc cx
                    cmp cx,250
                    jnz pa1
                
                ;bot
                mov cx,60
                mov dx,67
                mov ax,0c09h 
                pa2: int 10h
                    inc cx
                    cmp cx,250
                    jnz pa2

                ;left
                mov cx,60
                mov dx,50
                mov ax,0c09h 
                pa3: int 10h
                    inc dx
                    cmp dx,67
                    jnz pa3

                ;right
                mov cx,250
                mov dx,50
                mov ax,0c09h 
                pa4: int 10h
                    inc dx
                    cmp dx,67
                    jnz pa4
                

            ;DRAW MADE BY GAMERS
                
                ;made_by db 'Made by gamers' ; 14 characters
                ;for db 'for gamers' ;10 characters

                mov ah,13h          ;service to print string in graphics mode
                mov al,0            ;
                mov bh,0            ;
                mov bl,0ch          ;0000(black)background , 1111(white)foreground

                mov cx,14           ;length of string
                mov dl,12          ;Column(0 to 39)-   x axis
                mov dh, 9         ;Row(0 to 24)-  y axis
                mov es,si           ;moves si to es
                mov bp,offset made_by   
                int 10h

                ;;for gamers xD
                mov ah,13h          ;service to print string in graphics mode
                mov al,0            ;
                mov bh,0            ;
                mov bl,0ch          ;0000(black)background , 1111(white)foreground

                mov cx,10           ;length of string
                mov dl,14          ;Column(0 to 39)-   x axis
                mov dh, 10         ;Row(0 to 24)-  y axis
                mov es,si           ;moves si to es
                mov bp,offset for   
                int 10h
            
            ;lines around made by gamers
                ;up
                mov cx,95
                mov dx,80
                mov ax,0c07h 
                pg: int 10h
                    inc cx
                    cmp cx,206
                    jnz pg

                ;down
                mov cx,111
                mov dx,88
                mov ax,0c07h 
                pa: int 10h
                    inc cx
                    cmp cx,190
                    jnz pa
            
            ;press things drawings

                ;mes_game db 'Press enter to play' ; 19 characters
                ;mes_chat db 'Press t to chat'     ; 15 characters
                
                mov ah,13h          ;service to print string in graphics mode
                mov al,0            ;
                mov bh,0            ;
                mov bl,01h          ;0000(black)background , 1111(white)foreground

                mov cx,19           ;length of string
                mov dl,10           ;Column(0 to 39)-   x axis
                mov dh, 19          ;Row(0 to 24)-  y axis
                mov es,si           ;moves si to es
                mov bp,offset mes_game   
                int 10h

                ;chat 
                mov ah,13h          ;service to print string in graphics mode
                mov al,0            ;
                mov bh,0            ;
                mov bl,01h          ;0000(black)background , 1111(white)foreground

                mov cx,15           ;length of string
                mov dl,12           ;Column(0 to 39)-   x axis
                mov dh, 21          ;Row(0 to 24)-  y axis
                mov es,si           ;moves si to es
                mov bp,offset mes_chat  
                int 10h

                
                
            ret
        DRAW_MAIN_MENU endp

        PRE_GAME proc near
            
            call CLEAR_SCREEN
            call DRAW_PRE_GAME
            
            rep_pregame:

            MOV AH,00H                      ;waits for a key
            INT 16H
            ;;;;;;;
            CMP AL,0DH ;'Enter'             ;moves when user presses 'enter' and starts  the game
            jne rep_pregame

            call CLEAR_SCREEN
            ret
        PRE_GAME endp

        DRAW_PRE_GAME proc near

            call DRAW_BOARDERS
            call DRAW_PLAYERS
            call DRAW_STATUS_BAR

            ;ready db 'ARE YOU READ ??????'    ; 19 characters
            ;ready2 db '(ENTER)'               ; 7 characters

            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,0dh          ;0000(black)background , 1111(white)foreground

            mov cx,20           ;length of string
            mov dl, 11           ;Column(0 to 39)-   x axis
            mov dh, 10           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset ready   
            int 10h

            ;;enter
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,0dh          ;0000(black)background , 1111(white)foreground

            mov cx,7           ;length of string
            mov dl, 17          ;Column(0 to 39)-   x axis
            mov dh, 12          ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset ready2   
            int 10h

            


            ret
        DRAW_PRE_GAME endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHAT CODE CALLED IN MAIN MINU;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        CHAT_MENU proc near
            call CLEAR_SCREEN
            mov ax,03              
            int 16

            jmp $
            ret 
        CHAT_MENU endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GAME CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DRAW_M PROC near
        mov cx,m1_x
        mov dx,m1_y
        mov ax,0c0fh
        int 10h

        mov cx,m2_x
        mov dx,m2_y
        mov ax,0c0fh
        int 10h

        mov cx,m3_x
        mov dx,m3_y
        mov ax,0c0fh
        int 10h

        mov cx,m4_x
        mov dx,m4_y
        mov ax,0c0fh
        int 10h

        mov cx,m5_x
        mov dx,m5_y
        mov ax,0c0fh
        int 10h

        mov cx,m6_x
        mov dx,m6_y
        mov ax,0c0fh
        int 10h

        mov cx,m7_x
        mov dx,m7_y
        mov ax,0c0fh
        int 10h

        mov cx,m8_x
        mov dx,m8_y
        mov ax,0c0fh
        int 10h
        ;;;;;;;;;;;
        mov cx,m9_x
        mov dx,m9_y
        mov ax,0c0fh
        int 10h

        mov cx,m10_x
        mov dx,m10_y
        mov ax,0c0fh
        int 10h

        mov cx,m11_x
        mov dx,m11_y
        mov ax,0c0fh
        int 10h

        mov cx,m12_x
        mov dx,m12_y
        mov ax,0c0fh
        int 10h

        mov cx,m13_x
        mov dx,m13_y
        mov ax,0c0fh
        int 10h

        mov cx,m14_x
        mov dx,m14_y
        mov ax,0c0fh
        int 10h

        mov cx,m15_x
        mov dx,m15_y
        mov ax,0c0fh
        int 10h

        ;mov cx,m16_x
        ;mov dx,m16_y
        ;mov ax,0c04h
        ;int 10h

        ret
    DRAW_M endp

    CLEAR_SCREEN PROC near
        mov ah,00h
        mov al,0dh      ;al = 0dh 320x200  , buffer address A0000 |||| al = 13h
        int 10h

        mov ah,0bh
        mov bh,00h
        mov bl,00h
        int 10h

        ret
    CLEAR_SCREEN endp

    INC_M proc near
        mov ax,m1_velocity_r
        add m1_x,ax

        mov ax,m2_velocity_r
        add m2_x,ax

        mov ax,m3_velocity_r
        add m3_x,ax

        mov ax,m4_velocity_r
        add m4_x,ax

        mov ax,m5_velocity_r
        add m5_x,ax

        mov ax,m6_velocity_r
        add m6_x,ax

        mov ax,m7_velocity_r
        add m7_x,ax

        mov ax,m8_velocity_r
        add m8_x,ax

        ret
    INC_M endp

    DEC_M proc near
        mov ax,m9_velocity_l
        sub m9_x,ax

        mov ax,m10_velocity_l
        sub m10_x,ax

        mov ax,m11_velocity_l
        sub m11_x,ax

        mov ax,m12_velocity_l
        sub m12_x,ax

        mov ax,m13_velocity_l
        sub m13_x,ax

        mov ax,m14_velocity_l
        sub m14_x,ax

        mov ax,m15_velocity_l
        sub m15_x,ax

        mov ax,m16_velocity_l
        sub m16_x,ax

        ret
    DEC_M endp

    CHANGE_IN_M proc near
        call INC_M               ;applying changing for all m's
        call DEC_M

        ;checking for rebound in all m's
        call CHECK_FIRST_HALF
        call CHECK_SECOND_HALF

        ret
    CHANGE_IN_M endp

    CHECK_FIRST_HALF proc near
        cmp m1_x,0ah
        jl NEG_X1  
        mov ax,135h
        cmp m1_x,ax
        jg NEG_X1

        cmp m2_x,0ah
        jl NEG_X2
        mov ax,135h
        cmp m2_x,ax
        jg NEG_X2

        cmp m3_x,0ah
        jl NEG_X3
        mov ax,135h
        cmp m3_x,ax
        jg NEG_X3

        cmp m4_x,0ah
        jl NEG_X4
        mov ax,135h
        cmp m4_x,ax
        jg NEG_X4

        cmp m5_x,0ah
        jl NEG_X5
        mov ax,135h
        cmp m5_x,ax
        jg NEG_X5

        cmp m6_x,0ah
        jl NEG_X6
        mov ax,135h
        cmp m6_x,ax
        jg NEG_X6

        cmp m7_x,0ah
        jl NEG_X7
        mov ax,135h
        cmp m7_x,ax
        jg NEG_X7

        cmp m8_x,0ah
        jl NEG_X8
        mov ax,135h
        cmp m8_x,ax
        jg NEG_X8
        ret
    CHECK_FIRST_HALF endp
    ;neg functions
        NEG_X1 proc near
            neg m1_velocity_r
            ret
        NEG_X1 endp

        NEG_X2 proc near
            neg m2_velocity_r
            ret
        NEG_X2 endp

        NEG_X3 proc near
            neg m3_velocity_r
            ret
        NEG_X3 endp

        NEG_X4 proc near
            neg m4_velocity_r
            ret
        NEG_X4 endp

        NEG_X5 proc near
            neg m5_velocity_r
            ret
        NEG_X5 endp

        NEG_X6 proc near
            neg m6_velocity_r
            ret
        NEG_X6 endp

        NEG_X7 proc near
            neg m7_velocity_r
            ret
        NEG_X7 endp

        NEG_X8 proc near
            neg m8_velocity_r
            ret
        NEG_X8 endp
        ;;;;;;;;;;;;;;;;;;
        NEG_X9 proc near
            neg m9_velocity_l
            ret
        NEG_X9 endp

        NEG_X10 proc near
            neg m10_velocity_l
            ret
        NEG_X10 endp

        NEG_X11 proc near
            neg m11_velocity_l
            ret
        NEG_X11 endp

        NEG_X12 proc near
            neg m12_velocity_l
            ret
        NEG_X12 endp

        NEG_X13 proc near
            neg m13_velocity_l
            ret
        NEG_X13 endp

        NEG_X14 proc near
            neg m14_velocity_l
            ret
        NEG_X14 endp

        NEG_X15 proc near
            neg m15_velocity_l
            ret
        NEG_X15 endp

        NEG_X16 proc near
            neg m16_velocity_l
            ret
        NEG_X16 endp
    
    CHECK_SECOND_HALF proc near
        cmp m9_x,0ah
        jl NEG_X9
        mov ax,135h
        cmp m9_x,ax
        jg NEG_X9

        cmp m10_x,0ah
        jl NEG_X10
        mov ax,135h
        cmp m10_x,ax
        jg NEG_X10

        cmp m11_x,0ah
        jl NEG_X11
        mov ax,135h
        cmp m11_x,ax
        jg NEG_X11

        cmp m12_x,0ah
        jl NEG_X12
        mov ax,135h
        cmp m12_x,ax
        jg NEG_X12

        cmp m13_x,0ah
        jl NEG_X13
        mov ax,135h
        cmp m13_x,ax
        jg NEG_X13

        cmp m14_x,0ah
        jl NEG_X14
        mov ax,135h
        cmp m14_x,ax
        jg NEG_X14

        cmp m15_x,0ah
        jl NEG_X15
        mov ax,135h
        cmp m15_x,ax
        jg NEG_X15

        ;cmp m16_x,0ah
        ;jl NEG_X16
        ;mov ax,135h
        ;cmp m16_x,ax
        ;jg NEG_X16

        ret
    CHECK_SECOND_HALF endp

    DRAW_BOARDERS PROC near
        
        ;upper line (9,19) to (310,19)
        mov cx,9
        mov dx,19
        mov ax,0c09h ;09 for blue
        a:  int 10h
            inc cx
            cmp cx,310
            jnz a

        ;Bottom line (9,180) to (310,180)
        mov cx,9
        mov dx,180
        mov ax,0c09h 
        b:  int 10h
            inc cx
            cmp cx,310
            jnz b
        
        ;left line (9,19) to (9,180)
        mov cx,9
        mov dx,19
        mov ax,0c09h
        c:  int 10h
            inc dx
            cmp dx,180
            jnz c

        ;right line (310,19) to (310,180)
        mov cx,310
        mov dx,19
        mov ax,0c09h    
        d:  int 10h
            inc dx
            cmp dx,180
            jnz d

        ret
    DRAW_BOARDERS ENDP

    DRAW_STATUS_BAR proc near

        ;top line (9,181) to (310,181)
        mov cx,9
        mov dx,181
        mov ax,0c07h
        e:  int 10h
            inc cx
            cmp cx,310
            jnz e

        ;bottom line () to ()
        mov cx,9
        mov dx,198
        mov ax,0c07h
        f:  int 10h
            inc cx
            cmp cx,310
            jnz f

        ;;left line
        mov cx,9
        mov dx,181
        mov ax,0c07h
        g:  int 10h
            inc dx
            cmp dx,199
            jnz g

        ;right line
        mov cx,310
        mov dx,181
        mov ax,0c07h
        h:  int 10h
            inc dx 
            cmp dx,199
            jnz h

        ret 
    DRAW_STATUS_BAR endp

    DRAW_PLAYERS proc near

        MOV     CX,PLAYER1_X
        MOV     DX,PLAYER1_Y
        DRAW_PLAYER1_HORIZONTAL:
            MOV AH,0CH
            MOV AL,0EH
            MOV BH,00H
            INT 10H

            INC CX
            MOV AX,CX
            SUB AX,PLAYER1_X
            CMP AX,PLAYER_WIDTH
        JNG DRAW_PLAYER1_HORIZONTAL

        MOV CX,PLAYER1_X
        INC DX

        MOV AX,DX
        SUB AX,PLAYER1_Y
        CMP AX,PLAYER_HEIGHT
        JNG DRAW_PLAYER1_HORIZONTAL


        MOV     CX,PLAYER2_X
        MOV     DX,PLAYER2_Y
        DRAW_PLAYER2_HORIZONTAL:
            MOV AH,0CH
            MOV AL,04H
            MOV BH,00H
            INT 10H

            INC CX
            MOV AX,CX
            SUB AX,PLAYER2_X
            CMP AX,PLAYER_WIDTH
            JNG DRAW_PLAYER2_HORIZONTAL

        MOV CX,PLAYER2_X
        INC DX

        MOV AX,DX
        SUB AX,PLAYER2_Y
        CMP AX,PLAYER_HEIGHT
        JNG DRAW_PLAYER2_HORIZONTAL




        ret
    DRAW_PLAYERS endp

    MOVE_PLAYERS proc near
        
        ;PLAYER_1 MOVEMENT 
        ;CHECK IF ANY KEY IS BEING PRESSED (IF NOT CHECK PLAYER_2)
        MOV AH,01H
        INT 16H                         ;if no click it jz
        JZ CHECK_PLAYER2_MOVEMENT

        ;CHECK WHICH KEY IS PRESSED
        MOV AH,00H
        INT 16H

        ;IF IT IS 'w' OR 'W' -- MOVE UP
        CMP AL,77H ;'w'
        JE  MOVE_PLAYER1_UP
        CMP AL,57H ;'W'
        JE MOVE_PLAYER1_UP

        ;IF IT IS 's' OR 'S' -- MOVE DOWN
        CMP AL,73H ;'s'
        JE  MOVE_PLAYER1_DOWN
        CMP AL,53H ;'S'
        JE MOVE_PLAYER1_DOWN

        ;IF IT IS 'd' OR 'D' -- MOVE RIIGHT
        CMP AL,64H ;'d'
        JE  MOVE_PLAYER1_RIGHT
        CMP AL,44H ;'D'
        JE MOVE_PLAYER1_RIGHT

        ;IF IT IS 'a' OR 'A' -- MOVE LEFT
        CMP AL,61H ;'a'
        JE  MOVE_PLAYER1_LEFT
        CMP AL,41H ;'A'
        JE  MOVE_PLAYER1_LEFT

        JMP CHECK_PLAYER2_MOVEMENT

        MOVE_PLAYER1_UP:
            MOV AX,PLAYER1_VELOCITY
            SUB PLAYER1_Y,AX
            
            MOV AX,19
            CMP PLAYER1_Y,AX
            JL  FIX_PLAYER1_TOP_POSITION
            
            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER1_TOP_POSITION:
                MOV PLAYER1_Y,AX
                JMP CHECK_PLAYER2_MOVEMENT

        MOVE_PLAYER1_DOWN:
            MOV AX,PLAYER1_VELOCITY
            ADD PLAYER1_Y,AX
            
            MOV AX,175
            CMP AX,PLAYER1_Y
            JL  FIX_PLAYER1_BOTTOM_POSITION
            
            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER1_BOTTOM_POSITION:
                MOV PLAYER1_Y,AX
                JMP CHECK_PLAYER2_MOVEMENT

        MOVE_PLAYER1_RIGHT:
            MOV AX,PLAYER1_VELOCITY
            ADD PLAYER1_X,AX

            MOV AX,295
            CMP AX,PLAYER1_X
            JL  FIX_PLAYER1_RIGHT_POSITION

            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER1_RIGHT_POSITION:
                MOV PLAYER1_X,AX
                JMP CHECK_PLAYER2_MOVEMENT

        MOVE_PLAYER1_LEFT:
            MOV AX,PLAYER1_VELOCITY
            SUB PLAYER1_X,AX
            
            MOV AX,9
            CMP PLAYER1_X,AX
            JL  FIX_PLAYER1_LEFT_POSITION
            
            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER1_LEFT_POSITION:
                MOV PLAYER1_X,AX
                JMP CHECK_PLAYER2_MOVEMENT

        ;;;;PLAYER 2
        CHECK_PLAYER2_MOVEMENT:

        ;IF IT IS 'u'
        CMP al,75h
        JE  MOVE_PLAYER2_UP
        

        ;IF IT IS 'j'
        CMP al,6ah 
        JE  MOVE_PLAYER2_DOWN
        

        ;IF IT IS 'k'
        CMP al,6bh
        JE  MOVE_PLAYER2_RIGHT
        

        ;IF IT IS 'h' 
        CMP AL,68H 
        JE  MOVE_PLAYER2_LEFT
        
        jmp EXIT_PLAYER_MOVEMENT

        MOVE_PLAYER2_UP:
            MOV AX,PLAYER2_VELOCITY
            SUB PLAYER2_Y,AX

            MOV AX,19
            CMP PLAYER2_Y,AX
            JL  FIX_PLAYER2_TOP_POSITION
            
            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER2_TOP_POSITION:
                MOV PLAYER2_Y,AX
                JMP EXIT_PLAYER_MOVEMENT

        MOVE_PLAYER2_DOWN:
            MOV AX,PLAYER2_VELOCITY
            ADD PLAYER2_Y,AX

            MOV AX,175
            CMP AX,PLAYER2_Y
            JL  FIX_PLAYER2_BOTTOM_POSITION
            
            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER2_BOTTOM_POSITION:
                MOV PLAYER2_Y,AX
                JMP EXIT_PLAYER_MOVEMENT

        MOVE_PLAYER2_RIGHT:
            MOV AX,PLAYER2_VELOCITY
            ADD PLAYER2_X,AX

            MOV AX,295
            CMP AX,PLAYER2_X
            JL  FIX_PLAYER2_RIGHT_POSITION

            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER2_RIGHT_POSITION:
                MOV PLAYER2_X,AX
                JMP EXIT_PLAYER_MOVEMENT

        MOVE_PLAYER2_LEFT:
            MOV AX,PLAYER2_VELOCITY
            SUB PLAYER2_X,AX

            MOV AX,9
            CMP PLAYER2_X,AX
            JL  FIX_PLAYER2_LEFT_POSITION

            JMP EXIT_PLAYER_MOVEMENT

            FIX_PLAYER2_LEFT_POSITION:
                MOV PLAYER2_X,AX
                JMP EXIT_PLAYER_MOVEMENT


        EXIT_PLAYER_MOVEMENT: 
        ret
    MOVE_PLAYERS endp

    CHECK_COLLISION_PLAYERS proc near
        call CHECK_COLLISION_PLAYERS_M1
        call CHECK_COLLISION_PLAYERS_M2
        call CHECK_COLLISION_PLAYERS_M3
        call CHECK_COLLISION_PLAYERS_M4
        call CHECK_COLLISION_PLAYERS_M5
        call CHECK_COLLISION_PLAYERS_M6
        call CHECK_COLLISION_PLAYERS_M7
        call CHECK_COLLISION_PLAYERS_M8
        call CHECK_COLLISION_PLAYERS_M9
        call CHECK_COLLISION_PLAYERS_M10
        call CHECK_COLLISION_PLAYERS_M11
        call CHECK_COLLISION_PLAYERS_M12
        call CHECK_COLLISION_PLAYERS_M13
        call CHECK_COLLISION_PLAYERS_M14
        call CHECK_COLLISION_PLAYERS_M15
        ret
    CHECK_COLLISION_PLAYERS endp

    ;;CHECK_COLLISION for all m's
        CHECK_COLLISION_PLAYERS_M1 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m1_x, ax
            jng M1_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m1_x,ax
            jnl M1_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m1_y,ax
            jng M1_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m1_y,ax
            jnl M1_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M1_PLAYER2:

            mov ax,PLAYER2_X
            cmp m1_x, ax
            jng M1_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m1_x,ax
            jnl M1_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m1_y,ax
            jng M1_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m1_y,ax
            jnl M1_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M1_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M1 endp

        CHECK_COLLISION_PLAYERS_M2 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m2_x, ax
            jng M2_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m2_x,ax
            jnl M2_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m2_y,ax
            jng M2_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m2_y,ax
            jnl M2_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M2_PLAYER2:

            mov ax,PLAYER2_X
            cmp m2_x, ax
            jng M2_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m2_x,ax
            jnl M2_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m2_y,ax
            jng M2_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m2_y,ax
            jnl M2_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M2_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M2 endp

        CHECK_COLLISION_PLAYERS_M3 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m3_x, ax
            jng M3_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m3_x,ax
            jnl M3_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m3_y,ax
            jng M3_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m3_y,ax
            jnl M3_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M3_PLAYER2:

            mov ax,PLAYER2_X
            cmp m3_x, ax
            jng M3_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m3_x,ax
            jnl M3_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m3_y,ax
            jng M3_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m3_y,ax
            jnl M3_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M3_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M3 endp        

        CHECK_COLLISION_PLAYERS_M4 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m4_x, ax
            jng M4_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m4_x,ax
            jnl M4_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m4_y,ax
            jng M4_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m4_y,ax
            jnl M4_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M4_PLAYER2:

            mov ax,PLAYER2_X
            cmp m4_x, ax
            jng M4_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m4_x,ax
            jnl M4_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m4_y,ax
            jng M4_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m4_y,ax
            jnl M4_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M4_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M4 endp

        CHECK_COLLISION_PLAYERS_M5 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m5_x, ax
            jng M5_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m5_x,ax
            jnl M5_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m5_y,ax
            jng M5_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m5_y,ax
            jnl M5_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M5_PLAYER2:

            mov ax,PLAYER2_X
            cmp m5_x, ax
            jng M5_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m5_x,ax
            jnl M5_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m5_y,ax
            jng M5_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m5_y,ax
            jnl M5_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M5_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M5 endp

        CHECK_COLLISION_PLAYERS_M6 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m6_x, ax
            jng M6_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m6_x,ax
            jnl M6_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m6_y,ax
            jng M6_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m6_y,ax
            jnl M6_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M6_PLAYER2:

            mov ax,PLAYER2_X
            cmp m6_x, ax
            jng M6_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m6_x,ax
            jnl M6_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m6_y,ax
            jng M6_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m6_y,ax
            jnl M6_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M6_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M6 endp

        CHECK_COLLISION_PLAYERS_M7 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m7_x, ax
            jng M7_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m7_x,ax
            jnl M7_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m7_y,ax
            jng M7_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m7_y,ax
            jnl M7_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M7_PLAYER2:

            mov ax,PLAYER2_X
            cmp m7_x, ax
            jng M7_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m7_x,ax
            jnl M7_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m7_y,ax
            jng M7_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m7_y,ax
            jnl M7_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M7_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M7 endp

        CHECK_COLLISION_PLAYERS_M8 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m8_x, ax
            jng M8_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m8_x,ax
            jnl M8_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m8_y,ax
            jng M8_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m8_y,ax
            jnl M8_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M8_PLAYER2:

            mov ax,PLAYER2_X
            cmp m8_x, ax
            jng M8_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m8_x,ax
            jnl M8_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m8_y,ax
            jng M8_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m8_y,ax
            jnl M8_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M8_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M8 endp

        CHECK_COLLISION_PLAYERS_M9 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m9_x, ax
            jng M9_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m9_x,ax
            jnl M9_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m9_y,ax
            jng M9_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m9_y,ax
            jnl M9_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M9_PLAYER2:

            mov ax,PLAYER2_X
            cmp m9_x, ax
            jng M9_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m9_x,ax
            jnl M9_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m9_y,ax
            jng M9_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m9_y,ax
            jnl M9_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M9_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M9 endp

        CHECK_COLLISION_PLAYERS_M10 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m10_x, ax
            jng M10_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m10_x,ax
            jnl M10_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m10_y,ax
            jng M10_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m10_y,ax
            jnl M10_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M10_PLAYER2:

            mov ax,PLAYER2_X
            cmp m10_x, ax
            jng M10_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m10_x,ax
            jnl M10_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m10_y,ax
            jng M10_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m10_y,ax
            jnl M10_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M10_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M10 endp

        CHECK_COLLISION_PLAYERS_M11 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m11_x, ax
            jng M11_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m11_x,ax
            jnl M11_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m11_y,ax
            jng M11_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m11_y,ax
            jnl M11_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M11_PLAYER2:

            mov ax,PLAYER2_X
            cmp m11_x, ax
            jng M11_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m11_x,ax
            jnl M11_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m11_y,ax
            jng M11_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m11_y,ax
            jnl M11_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M11_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M11 endp

        CHECK_COLLISION_PLAYERS_M12 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m12_x, ax
            jng M12_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m12_x,ax
            jnl M12_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m12_y,ax
            jng M12_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m12_y,ax
            jnl M12_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M12_PLAYER2:

            mov ax,PLAYER2_X
            cmp m12_x, ax
            jng M12_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m12_x,ax
            jnl M12_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m12_y,ax
            jng M12_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m12_y,ax
            jnl M12_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M12_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M12 endp

        CHECK_COLLISION_PLAYERS_M13 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m13_x, ax
            jng M13_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m13_x,ax
            jnl M13_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m13_y,ax
            jng M13_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m13_y,ax
            jnl M13_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M13_PLAYER2:

            mov ax,PLAYER2_X
            cmp m13_x, ax
            jng M13_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m13_x,ax
            jnl M13_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m13_y,ax
            jng M13_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m13_y,ax
            jnl M13_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M13_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M13 endp

        CHECK_COLLISION_PLAYERS_M14 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m14_x, ax
            jng M14_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m14_x,ax
            jnl M14_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m14_y,ax
            jng M14_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m14_y,ax
            jnl M14_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M14_PLAYER2:

            mov ax,PLAYER2_X
            cmp m14_x, ax
            jng M14_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m14_x,ax
            jnl M14_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m14_y,ax
            jng M14_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m14_y,ax
            jnl M14_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M14_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M14 endp

        CHECK_COLLISION_PLAYERS_M15 proc near

            ;condition is -> m_x > PLAYER1_X && m_x < PLAYER1_X + PLAYER_WIDTH
            ;&& m_y > PLAYER1_Y && m_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp m15_x, ax
            jng M15_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp m15_x,ax
            jnl M15_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp m15_y,ax
            jng M15_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp m15_y,ax
            jnl M15_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided
            call RESET_PLAYER1              
            dec mes_player1_lives
            ret

            ;CHECKS FOR PLAYER2
            M15_PLAYER2:

            mov ax,PLAYER2_X
            cmp m15_x, ax
            jng M15_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp m15_x,ax
            jnl M15_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp m15_y,ax
            jng M15_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp m15_y,ax
            jnl M15_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided
            call RESET_PLAYER2
            dec mes_player2_lives


            M15_EXIT:
            ret
        CHECK_COLLISION_PLAYERS_M15 endp


    RESET_PLAYER1 proc near

        mov PLAYER1_X,0AH
        mov PLAYER1_Y,0afH     ;player1 back to its initial position
        
        ret
    RESET_PLAYER1 endp

    RESET_PLAYER2 proc near

        mov PLAYER2_X,127H      ;player2 back to its initial position
        mov PLAYER2_Y,0afH
        ret
        
    RESET_PLAYER2 endp

    DRAW_SCORES proc near
        
        mov si,@DATA
        ;mes_player1 db 'Player 1 Lives:'   ; 15 characters
        ;mes_player2 db 'Player 2 Lives:'   ; 15 characters
        ;mes_player1_lives db '5'           ; 1 character
        ;mes_player2_lives db '5'           ; 1 character

        ;;displaying mes_player1
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,15           ;length of string
        mov dl, 2           ;Column(0 to 39)-   x axis
        mov dh, 23          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player1  
        int 10h 
        
        ;;displaying mes_player1_lives
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,1            ;length of string
        mov dl, 17          ;Column(0 to 39)-   x axis
        mov dh, 23          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player1_lives
        int 10h

        ;;displaying mes_player2
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,15           ;length of string
        mov dl, 21          ;Column(0 to 39)-   x axis
        mov dh, 23          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player2 
        int 10h 

        ;;displaying mes_player2_lives
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,1            ;length of string
        mov dl, 36          ;Column(0 to 39)-   x axis
        mov dh, 23          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player2_lives
        int 10h
        


        ret
    DRAW_SCORES endp

    DISPLAY_GAMEOVER proc near
        ;mes_player1_win db 'Player 1 won the game!' ; 22 characters
        ;mes_player2_win db 'Player 2 won the game!' ; 22 characters

        cmp mes_player2_lives,30h   ;zero = 30h
        je player1_win
        jne player2_win

        player1_win:
        ;;displaying mes_player1_win
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,22           ;length of string
        mov dl, 9           ;Column(0 to 39)-   x axis
        mov dh, 12          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player1_win  
        int 10h
        ret

        player2_win:
        ;;displaying mes_player2_win
        mov ah,13h          ;service to print string in graphics mode
        mov al,0            ;
        mov bh,0            ;
        mov bl,00001010b    ;0000(black)background , 1111(white)foreground

        mov cx,22           ;length of string
        mov dl, 9           ;Column(0 to 39)-   x axis
        mov dh, 12          ;Row(0 to 24)-  y axis
        mov es,si           ;moves si to es
        mov bp,offset mes_player2_win  
        int 10h

        ret
    DISPLAY_GAMEOVER endp


    ;;powerups 
        
        ;;SLOWED DOWN 
            DRAW_SD proc near

                cmp slowed_before,0
                jnz exit_sd

                mov cx,sd_x
                mov dx,sd_y
                mov ax,0c0bh
                int 10h

                exit_sd:
            ret
        DRAW_SD endp
            CHECK_COLLISION_SD proc near
            cmp slowed_before,0
            jnz exit_sd_col

            ;condition is -> sd_x > PLAYER1_X && sd_x < PLAYER1_X + PLAYER_WIDTH
            ;&& sd_y > PLAYER1_Y && sd_y < PLAYER1_Y + PLAYER_HEIGHT
            mov ax,PLAYER1_X
            cmp sd_x, ax
            jng sd_PLAYER2        ;if there is no collision it checks with player2
            
            mov ax,PLAYER1_X
            add ax,PLAYER_WIDTH
            cmp sd_x,ax
            jnl sd_PLAYER2        ;no collision-> check player2
            
            mov ax,PLAYER1_Y
            sub ax,2d
            cmp sd_y,ax
            jng sd_PLAYER2        ;no collision-> check player2

            mov ax,PLAYER1_Y
            add ax,6d                          
            cmp sd_y,ax
            jnl sd_PLAYER2        ;no collision-> check player2
        
            ;if it reaches here then player1 collided -> slow down player2 , inc slowed_before, inc player2_isslowed

            inc slowed_before
            inc player2_isslowed

            cmp player2_itisreversed,1  
            jne normal_slow_2           ;if player2 is already reversed we add velocity
            
            add PLAYER2_VELOCITY,03h
            ret

            normal_slow_2:
            sub PLAYER2_VELOCITY,03h    ;it was 05H

            ret

            ;CHECKS FOR PLAYER2
            sd_PLAYER2:

            mov ax,PLAYER2_X
            cmp sd_x, ax
            jng sd_EXIT                           ;if there is no collision it exits
            
            mov ax,PLAYER2_X
            add ax,PLAYER_WIDTH
            cmp sd_x,ax
            jnl sd_EXIT                           ;no collision-> exits
            
            mov ax,PLAYER2_Y
            sub ax,2d
            cmp sd_y,ax
            jng sd_EXIT                           ;no collision-> exits

            mov ax,PLAYER2_Y
            add ax,6d                          
            cmp sd_y,ax
            jnl sd_EXIT                           ;no collision-> exits
        
            ;if it reaches here then player2 collided -> slows down player1 , inc slowed_before, inc player1_isslowed
            
            inc slowed_before
            inc player1_isslowed

            cmp player1_itisreversed,1  
            jne normal_slow_1           ;if player2 is already reversed we add velocity
            
            add PLAYER1_VELOCITY,03h
            ret

            normal_slow_1:
            sub PLAYER1_VELOCITY,03h    ;it was 05H

            ret

            sd_EXIT:
            exit_sd_col:

            ret
        CHECK_COLLISION_SD endp
        ;;REVERSE
            DRAW_R proc near

                cmp reversed_before,0
                jnz exit_r

                mov cx,r_x
                mov dx,r_y
                mov ax,0c0dh
                int 10h

                exit_r:
                ret
            DRAW_R endp
            CHECK_COLLISION_R proc near
                cmp reversed_before,0
                jnz exit_r_col

                ;condition is -> r_x > PLAYER1_X && r_x < PLAYER1_X + PLAYER_WIDTH
                ;&& r_y > PLAYER1_Y && r_y < PLAYER1_Y + PLAYER_HEIGHT
                mov ax,PLAYER1_X
                cmp r_x, ax
                jng r_PLAYER2        ;if there is no collision it checks with player2
                
                mov ax,PLAYER1_X
                add ax,PLAYER_WIDTH
                cmp r_x,ax
                jnl r_PLAYER2        ;no collision-> check player2
                
                mov ax,PLAYER1_Y
                sub ax,2d
                cmp r_y,ax
                jng r_PLAYER2        ;no collision-> check player2

                mov ax,PLAYER1_Y
                add ax,6d                          
                cmp r_y,ax
                jnl r_PLAYER2        ;no collision-> check player2
            
                ;if it reaches here then player1 collided -> player2 is reversed, inc reversed_before, inc player2_isreversed
                
                neg PLAYER2_VELOCITY
                inc reversed_before
                inc player2_isreversed

                inc player2_itisreversed
                ret

                ;CHECKS FOR PLAYER2
                r_PLAYER2:

                mov ax,PLAYER2_X
                cmp r_x, ax
                jng r_EXIT                           ;if there is no collision it exits
                
                mov ax,PLAYER2_X
                add ax,PLAYER_WIDTH
                cmp r_x,ax
                jnl r_EXIT                           ;no collision-> exits
                
                mov ax,PLAYER2_Y
                sub ax,2d
                cmp r_y,ax
                jng r_EXIT                           ;no collision-> exits

                mov ax,PLAYER2_Y
                add ax,6d                          
                cmp r_y,ax
                jnl r_EXIT                           ;no collision-> exits
            
                ;if it reaches here then player2 collided -> player1 reversed, inc reversed_before, inc player1_isreversed
                
                neg PLAYER1_VELOCITY
                inc reversed_before
                inc player1_isreversed

                inc player1_itisreversed

                r_EXIT:
                exit_r_col:
                ret
            CHECK_COLLISION_R endp
        ;;BULLET
            DRAW_B proc near

                cmp bullet_before,0
                jnz exit_b

                mov cx,b_x
                mov dx,b_y
                mov ax,0c0ch
                int 10h

                exit_b:
                ret
            DRAW_B endp
            CHECK_COLLISION_B proc near

                cmp bullet_before,0
                jnz exit_b_col

                ;condition is -> b_x > PLAYER1_X && b_x < PLAYER1_X + PLAYER_WIDTH
                ;&& b_y > PLAYER1_Y && b_y < PLAYER1_Y + PLAYER_HEIGHT
                mov ax,PLAYER1_X
                cmp b_x, ax
                jng b_PLAYER2        ;if there is no collision it checks with player2
                
                mov ax,PLAYER1_X
                add ax,PLAYER_WIDTH
                cmp b_x,ax
                jnl b_PLAYER2        ;no collision-> check player2
                
                mov ax,PLAYER1_Y
                sub ax,2d
                cmp b_y,ax
                jng b_PLAYER2        ;no collision-> check player2

                mov ax,PLAYER1_Y
                add ax,6d                          
                cmp b_y,ax
                jnl b_PLAYER2        ;no collision-> check player2
            
                ;if it reaches here then player1 collided -> player1_hasgun = 1, inc bullet_before, inc player1_hasbullet
                
                mov player1_hasgun,1
                inc bullet_before
                inc player1_hasbullet
                ret

                ;CHECKS FOR PLAYER2
                b_PLAYER2:

                mov ax,PLAYER2_X
                cmp b_x, ax
                jng b_EXIT                           ;if there is no collision it exits
                
                mov ax,PLAYER2_X
                add ax,PLAYER_WIDTH
                cmp b_x,ax
                jnl b_EXIT                           ;no collision-> exits
                
                mov ax,PLAYER2_Y
                sub ax,2d
                cmp b_y,ax
                jng b_EXIT                           ;no collision-> exits

                mov ax,PLAYER2_Y
                add ax,6d                          
                cmp b_y,ax
                jnl b_EXIT                           ;no collision-> exits
            
                ;if it reaches here then player2 collided -> player2_hasgun = 0, inc bullet_before, inc player2_hasbullet
                
                mov player2_hasgun,1
                inc bullet_before
                inc player2_hasbullet

                b_EXIT:
                exit_b_col:
                ret
            CHECK_COLLISION_B endp
            CHECK_TRIGGER proc near

                cmp player1_hasgun,1
                jne check_player2_gun

                ;;player1 has gun                
                ;;;;;;
                mov ah,01H
                int 16h                 ;CHECK WHICH KEY IS PRESSED
                jz check_player2_gun    ;jz if no click

                MOV AH,00H
                INT 16H
                ;;;;;;;
                CMP AL,32d ;'space bar'
                jne end_trigger
                
                ;;ACTIONS
                mov ax,PLAYER1_X
                mov bullet_x,ax
                add bullet_x,8

                mov ax,PLAYER1_Y
                mov bullet_y,ax

                mov shoot_player,1

                ;;;;;;;;;;;;;;;;;
                check_player2_gun:
                cmp player2_hasgun,1
                jne end_trigger

                ;;player2 has gun
                ;;;;;;;;;
                mov ah,01H
                int 16h                 ;CHECK WHICH KEY IS PRESSED
                jz end_trigger          ;jz if no click

                MOV AH,00H
                INT 16H

                ;;;;;;;
                CMP AL,32d ;'space bar'
                jne end_trigger
                
                ;;ACTIONS
                mov ax,PLAYER2_X
                mov bullet_x,ax
                add bullet_x,8

                mov ax,PLAYER2_Y
                mov bullet_y,ax

                mov shoot_player,1

                ;;;;;;;;;;;;;;;;;

                end_trigger:
                ret
            CHECK_TRIGGER endp
            DRAW_BULLET proc near
        
                mov cx,bullet_x
                mov dx,bullet_y
                mov ax,0c0fh
                int 10h


                ret
            DRAW_BULLET endp
            SHOOT_BULLET proc near

                cmp shoot_player,1
                jne exit_shoot

                call DRAW_BULLET
                ;dec bullet_y
                    mov ax,bullet_velocity
                    sub bullet_y,ax
                ;checks collision with boundary
                    cmp bullet_y,14h
                    jl NEG_BULLET
                    mov ax,0b3h
                    cmp bullet_y,ax
                    jg NEG_BULLET
                ;;;;;;;;;;;;;;;;;;CHEKS COLLISION WITH PLAYERS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    cmp player2_hasgun,1
                    jne bullet_PLAYER2
                    ;condition is -> bullet_x > PLAYER1_X && bullet_x < PLAYER1_X + PLAYER_WIDTH
                    ;&& bullet_y > PLAYER1_Y && bullet_y < PLAYER1_Y + PLAYER_HEIGHT
                    mov ax,PLAYER1_X
                    cmp bullet_x, ax
                    jng bullet_PLAYER2        ;if there is no collision it checks with player2
                    
                    mov ax,PLAYER1_X
                    add ax,PLAYER_WIDTH
                    cmp bullet_x,ax
                    jnl bullet_PLAYER2        ;no collision-> check player2
                    
                    mov ax,PLAYER1_Y
                    sub ax,2d
                    cmp bullet_y,ax
                    jng bullet_PLAYER2        ;no collision-> check player2

                    mov ax,PLAYER1_Y
                    add ax,6d                          
                    cmp bullet_y,ax
                    jnl bullet_PLAYER2        ;no collision-> check player2
                
                    ;if it reaches here then player1 collided
                    call RESET_PLAYER1              
                    dec mes_player1_lives
                    ret

                    ;CHECKS FOR PLAYER2
                    bullet_PLAYER2:
                    cmp player1_hasgun,1
                    jne bullet_EXIT

                    mov ax,PLAYER2_X
                    cmp bullet_x, ax
                    jng bullet_EXIT                           ;if there is no collision it exits
                    
                    mov ax,PLAYER2_X
                    add ax,PLAYER_WIDTH
                    cmp bullet_x,ax
                    jnl bullet_EXIT                           ;no collision-> exits
                    
                    mov ax,PLAYER2_Y
                    sub ax,2d
                    cmp bullet_y,ax
                    jng bullet_EXIT                           ;no collision-> exits

                    mov ax,PLAYER2_Y
                    add ax,6d                          
                    cmp bullet_y,ax
                    jnl bullet_EXIT                           ;no collision-> exits
                
                    ;if it reaches here then player2 collided
                    call RESET_PLAYER2
                    dec mes_player2_lives


                    bullet_EXIT:
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                exit_shoot: 
                ret
            SHOOT_BULLET endp
            NEG_BULLET proc near
                neg bullet_velocity
                ret
            NEG_BULLET endp
        ;;BOOST
            DRAW_BOOST proc near

                cmp boost_before,0
                jnz exit_draw_boost

                mov cx,boost_x
                mov dx,boost_y
                mov ax,0c0dh
                int 10h

                exit_draw_boost:

                ret
            DRAW_BOOST endp
            CHECK_COLLISION_BOOST proc near

                cmp boost_before,0
                jnz exit_boost_col

                ;condition is -> boost_x > PLAYER1_X && boost_x < PLAYER1_X + PLAYER_WIDTH
                ;&& boost_y > PLAYER1_Y && boost_y < PLAYER1_Y + PLAYER_HEIGHT
                mov ax,PLAYER1_X
                cmp boost_x, ax
                jng boost_PLAYER2        ;if there is no collision it checks with player2
                
                mov ax,PLAYER1_X
                add ax,PLAYER_WIDTH
                cmp boost_x,ax
                jnl boost_PLAYER2        ;no collision-> check player2
                
                mov ax,PLAYER1_Y
                sub ax,2d
                cmp boost_y,ax
                jng boost_PLAYER2        ;no collision-> check player2

                mov ax,PLAYER1_Y
                add ax,6d                          
                cmp boost_y,ax
                jnl boost_PLAYER2        ;no collision-> check player2
            
                ;if it reaches here then player1 collided -> player1 is boosted, inc boost_before, inc player1_isboosted
                
                inc boost_before
                inc player1_isboosted

                cmp player1_itisreversed,1  
                jne normal_boost_1           ;if player1 is already reversed we subb velocity
            
                sub PLAYER1_VELOCITY,04h
                ret

                normal_boost_1:
                add PLAYER1_VELOCITY,04h  

                ret

                ;CHECKS FOR PLAYER2
                boost_PLAYER2:

                mov ax,PLAYER2_X
                cmp boost_x, ax
                jng boost_EXIT                           ;if there is no collision it exits
                
                mov ax,PLAYER2_X
                add ax,PLAYER_WIDTH
                cmp boost_x,ax
                jnl boost_EXIT                           ;no collision-> exits
                
                mov ax,PLAYER2_Y
                sub ax,2d
                cmp boost_y,ax
                jng boost_EXIT                           ;no collision-> exits

                mov ax,PLAYER2_Y
                add ax,6d                          
                cmp boost_y,ax
                jnl boost_EXIT                           ;no collision-> exits
            
                ;if it reaches here then player2 collided -> player2 is boosted, inc boost_before, inc player2_isboosted
                
                inc boost_before
                inc player2_isboosted

                cmp player2_itisreversed,1  
                jne normal_boost_2           ;if player2 is already reversed we subb velocity
            
                sub PLAYER2_VELOCITY,04h
                ret

                normal_boost_2:
                add PLAYER2_VELOCITY,04h  

                boost_EXIT:
                exit_boost_col:

                ret
            CHECK_COLLISION_BOOST endp
        
        ;;SPEED-UP M 
            DRAW_SPEED proc near

                cmp speed_before,0
                jnz exit_draw_speed

                mov cx,speed_x
                mov dx,speed_y
                mov ax,0c0ah
                int 10h

                exit_draw_speed:
                ret
            DRAW_SPEED endp
            CHECK_COLLISION_SPEED proc near

                cmp speed_before,0
                jnz exit_speed_col

                ;condition is -> speed_x > PLAYER1_X && speed_x < PLAYER1_X + PLAYER_WIDTH
                ;&& speed_y > PLAYER1_Y && speed_y < PLAYER1_Y + PLAYER_HEIGHT
                mov ax,PLAYER1_X
                cmp speed_x, ax
                jng speed_PLAYER2        ;if there is no collision it checks with player2
                
                mov ax,PLAYER1_X
                add ax,PLAYER_WIDTH
                cmp speed_x,ax
                jnl speed_PLAYER2        ;no collision-> check player2
                
                mov ax,PLAYER1_Y
                sub ax,2d
                cmp speed_y,ax
                jng speed_PLAYER2        ;no collision-> check player2

                mov ax,PLAYER1_Y
                add ax,6d                          
                cmp speed_y,ax
                jnl speed_PLAYER2        ;no collision-> check player2
            
                ;if it reaches here then player1 collided -> inc m_velocity's, inc speed_before
                
                inc speed_before

                ;add velocity
                    mov m1_velocity_r,04h
                    mov m2_velocity_r,04h
                    mov m3_velocity_r,04h
                    mov m4_velocity_r,04h
                    mov m5_velocity_r,04h
                    mov m6_velocity_r,04h
                    mov m7_velocity_r,04h
                    mov m8_velocity_r,04h
                    ;;;;;;;;;;;;;;;;;;;;
                    mov m9_velocity_l,04h
                    mov m10_velocity_l,04h
                    mov m11_velocity_l,04h
                    mov m12_velocity_l,04h
                    mov m13_velocity_l,04h
                    mov m14_velocity_l,04h
                    mov m15_velocity_l,04h


                ret

                ;CHECKS FOR PLAYER2
                speed_PLAYER2:

                mov ax,PLAYER2_X
                cmp speed_x, ax
                jng speed_EXIT                           ;if there is no collision it exits
                
                mov ax,PLAYER2_X
                add ax,PLAYER_WIDTH
                cmp speed_x,ax
                jnl speed_EXIT                           ;no collision-> exits
                
                mov ax,PLAYER2_Y
                sub ax,2d
                cmp speed_y,ax
                jng speed_EXIT                           ;no collision-> exits

                mov ax,PLAYER2_Y
                add ax,6d                          
                cmp speed_y,ax
                jnl speed_EXIT                           ;no collision-> exits
            
                ;if it reaches here then player2 collided -> inc m_velocity's, inc speed_before
                
                inc speed_before

                ;add velocity
                    mov m1_velocity_r,04h
                    mov m2_velocity_r,04h
                    mov m3_velocity_r,04h
                    mov m4_velocity_r,04h
                    mov m5_velocity_r,04h
                    mov m6_velocity_r,04h
                    mov m7_velocity_r,04h
                    mov m8_velocity_r,04h
                    ;;;;;;;;;;;;;;;;;;;;
                    mov m9_velocity_l,04h
                    mov m10_velocity_l,04h
                    mov m11_velocity_l,04h
                    mov m12_velocity_l,04h
                    mov m13_velocity_l,04h
                    mov m14_velocity_l,04h
                    mov m15_velocity_l,04h  

                speed_EXIT:
                exit_speed_col:
                
                ret
            CHECK_COLLISION_SPEED endp


    ;;power ups display procedures
        DISPLAY_PLAYER_SLOWED proc near


            ;mes_player1_slowed db 'Player 1 is slowed down!'        ; 24 characters
            ;mes_player2_slowed db 'Player 2 is slowed down!'        ; 24 characters

            cmp player2_isslowed,0
            jne  print2_slowed
            je checks_player1_sd

            print2_slowed:

            ;disable all other powerups display functions
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0

            ;;displaying mes_player2_slowed
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,24           ;length of string
            mov dl, 9           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player2_slowed
            int 10h

            checks_player1_sd:

            cmp player1_isslowed,0
            jne print1_slowed
            je exits_display_sd

            print1_slowed:

            ;disable all other powerups display functions
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0


            ;;displaying mes_player1_slowed
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,24           ;length of string
            mov dl, 9           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player1_slowed
            int 10h


            exits_display_sd:

            ret
        DISPLAY_PLAYER_SLOWED endp    
        DISPLAY_PLAYER_REVERSED proc near

            ;mes_player1_reversed db 'Player 1 movement is reversed!'    ; 30 characters
            ;mes_player2_reversed db 'Player 2 movement is reversed!'    ; 30 characters

            cmp player2_isreversed,0
            jne  print2_reversed
            je checks_player1_r

            print2_reversed:

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0

            ;;displaying mes_player2_reversed
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,30           ;length of string
            mov dl, 5           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player2_reversed
            int 10h

            ret
            checks_player1_r:

            cmp player1_isreversed,0
            jne print1_reversed
            je exits_display_r


            print1_reversed:

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0

            ;;displaying mes_player1_reversed
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,30           ;length of string
            mov dl, 5           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player1_reversed
            int 10h


            exits_display_r:
            ret
        DISPLAY_PLAYER_REVERSED endp
        DISPLAY_PLAYER_BULLET proc near
            ;keeps drawing as long as player1_hasbullet != 0 || player2_hasbullet != 0

            ;mes_player1_hasgun db 'Player 1 has the rocket launcher!'   ; 33 characters
            ;mes_player2_hasgun db 'Player 2 has the rocket launcher!'   ; 33 characters

            cmp player1_hasbullet,1
            jne player2_has

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0

            ;;displaying mes_player1_hasgun
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,33           ;length of string
            mov dl, 3           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player1_hasgun
            int 10h

            ret
            player2_has:

            cmp player2_hasbullet,1
            jne exits_display_b

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov player1_isboosted,0
            mov player2_isboosted,0
            mov speed_before,0

            ;;displaying mes_player2_hasgun
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,33           ;length of string
            mov dl, 3           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player2_hasgun
            int 10h


            exits_display_b:

            ret
        DISPLAY_PLAYER_BULLET endp
        DISPLAY_PLAYER_BOOST proc near

            ;mes_player1_boosted db 'Player 1 boosted!'                  ; 16 characters
            ;mes_player2_boosted db 'Player 2 boosted!'                  ; 16 characters
            
            cmp player1_isboosted,0
            jne  print1_boosted
            je checks_player2_boosted

            print1_boosted:

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov speed_before,0

            ;;displaying mes_player1_boosted
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,16           ;length of string
            mov dl,12           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player1_boosted
            int 10h

            ret
            checks_player2_boosted:

            cmp player2_isboosted,0
            jne print2_boosted
            je exits_display_boosted


            print2_boosted:

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov speed_before,0

            ;;displaying mes_player2_boosted
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,16           ;length of string
            mov dl,12           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_player2_boosted
            int 10h


            exits_display_boosted:
            
            ret
        DISPLAY_PLAYER_BOOST endp
        DISPLAY_SPEED proc near

            ;mes_speed db 'SHOCK WAVE!'                                  ; 11 characters
            cmp speed_before,0
            jz exit_speed_display

            ;disable all other powerups display functions
            mov player1_isslowed,0
            mov player2_isslowed,0
            mov player1_hasbullet,0
            mov player2_hasbullet,0
            mov player1_isreversed,0
            mov player2_isreversed,0
            mov player1_isboosted,0
            mov player2_isboosted,0

            ;;displaying mes_speed
            mov ah,13h          ;service to print string in graphics mode
            mov al,0            ;
            mov bh,0            ;
            mov bl,00001010b    ;0000(black)background , 1111(white)foreground

            mov cx,11           ;length of string
            mov dl,15           ;Column(0 to 39)-   x axis
            mov dh, 1           ;Row(0 to 24)-  y axis
            mov es,si           ;moves si to es
            mov bp,offset mes_speed
            int 10h


            exit_speed_display:

            ret
        DISPLAY_SPEED endp



END MAIN