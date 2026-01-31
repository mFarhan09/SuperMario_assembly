INCLUDE Irvine32.inc

; Declare Windows API Beep function
Beep PROTO, dwFreq:DWORD, dwDuration:DWORD

;MCI functions for MP3 playback
INCLUDELIB winmm.lib
mciSendStringA PROTO, lpstrCommand:PTR BYTE, lpstrReturnString:PTR BYTE, uReturnLength:DWORD, hWndCallback:DWORD



; SUPER MARIO BROS
; Roll Number: 24I-0624

.data

; Sound file paths
sndJump BYTE "open jump.mp3 type mpegvideo alias jump", 0
sndJumpPlay BYTE "play jump from 0", 0
sndCoin BYTE "open collectcoin.mp3 type mpegvideo alias coin", 0
sndCoinPlay BYTE "play coin from 0", 0
sndFire BYTE "open shootfire.mp3 type mpegvideo alias fire", 0
sndFirePlay BYTE "play fire from 0", 0
soundsLoaded BYTE 0

;CONSTANTS 
SCREEN_W = 120
SCREEN_H = 30
MAP_W = 120
MAP_H = 27
MAX_ENEMIES = 10
MAX_COINS = 20
MAX_FIREBALLS = 5

; Score requirements
SCORE_L1 = 700
SCORE_L2 = 500

; Jump physics constants
JUMP_VELOCITY = -4
DOUBLE_JUMP_VEL = -3
GRAVITY = 1
MAX_FALL_SPEED = 4

; Sound frequencies (Hz)
SOUND_JUMP = 600
SOUND_COIN = 1200
SOUND_STOMP = 300
SOUND_POWERUP = 800
SOUND_DAMAGE = 200
SOUND_FREEZE = 1500
SOUND_FIREBALL = 400

;GAME STATE 
gameState BYTE 0
currentLevel BYTE 1

;       MARIO
marioX BYTE 5
marioY BYTE 24
prevMarioX BYTE 5
prevMarioY BYTE 24
marioVelY SBYTE 0
marioLives BYTE 3
marioPower BYTE 0          ; 0=small, 1=big, 2=fire
marioOnGround BYTE 1
marioInvinc BYTE 0
invincTimer WORD 0
canDoubleJump BYTE 1
usedDouble BYTE 0
marioDir BYTE 1
jumpHeld BYTE 0

;        SCORE 
score DWORD 0
coins BYTE 0
timer WORD 150             ; Changed to 150 seconds as requested
highScore DWORD 0

;        PLAYER
playerName BYTE 16 DUP(0)

;        ENEMIES
enemyX BYTE MAX_ENEMIES DUP(0)
enemyY BYTE MAX_ENEMIES DUP(0)
enemyPrevX BYTE MAX_ENEMIES DUP(0)
enemyPrevY BYTE MAX_ENEMIES DUP(0)
enemyDir BYTE MAX_ENEMIES DUP(0)
enemyActive BYTE MAX_ENEMIES DUP(0)
enemyType BYTE MAX_ENEMIES DUP(0)    ; 0=Goomba, 1=Koopa, 2=Shell
enemyCount BYTE 0

;          COINS
coinX BYTE MAX_COINS DUP(0)
coinY BYTE MAX_COINS DUP(0)
coinActive BYTE MAX_COINS DUP(0)
coinCount BYTE 0

;          FIREBALLS
fireballX BYTE MAX_FIREBALLS DUP(0)
fireballY BYTE MAX_FIREBALLS DUP(0)
fireballDir BYTE MAX_FIREBALLS DUP(0)
fireballActive BYTE MAX_FIREBALLS DUP(0)
fireballCount BYTE 0

;          FREEZE POWER
freezeActive BYTE 0
freezeTimer WORD 0
freezeX BYTE 0
freezeY BYTE 0
freezeCollected BYTE 0

;          MUSHROOM POWER-UP
mushroomX BYTE 0
mushroomY BYTE 0
mushroomPrevX BYTE 0
mushroomPrevY BYTE 0
mushroomActive BYTE 0
mushroomDir BYTE 1

;          LEVEL
levelMap BYTE 3240 DUP(' ')
goalX BYTE 10
goalY BYTE 3
goalReached BYTE 0

;         RENDERING
needFullRedraw BYTE 1
frameCount BYTE 0

;           FILES
fileScore BYTE "mario_hs.dat", 0
fileProgress BYTE "mario_prog.dat", 0
fileHandle DWORD ?

;           TOP 3 HIGH SCORES
topScores DWORD 0, 0, 0                    ; 3 scores
topNames BYTE 48 DUP(0)                    ; 3 names x 16 chars each

;           PROGRESS DATA
savedLevel BYTE 1
savedLives BYTE 3
savedScore DWORD 0
savedMarioX BYTE 5
savedMarioY BYTE 24
savedPower BYTE 0
savedCoins BYTE 0
savedTimer WORD 150

;          STRINGS
strTitle BYTE "......................SUPER MARIO BROS...................", 0
strRoll BYTE "Roll Number: 24I-0624", 0
strMenu1 BYTE "    [1] START NEW GAME    ", 0
strMenu2 BYTE "    [2] CONTINUE GAME     ", 0
strMenu3 BYTE "    [3] HIGH SCORES       ", 0
strMenu4 BYTE "    [4] HOW TO PLAY       ", 0
strMenu5 BYTE "    [5] EXIT GAME         ", 0
strName BYTE "Enter your name: ", 0
strHello BYTE "Welcome, ", 0
strLoad BYTE "Loading Level...", 0
strPause BYTE "[ GAME PAUSED ]", 0
strPause2 BYTE "[R] Resume  [M] Menu  [X] Exit", 0
strOver BYTE "G A M E   O V E R", 0
strWin BYTE "C O N G R A T U L A T I O N S !", 0
strWin2 BYTE "You saved the Princess!", 0
strDone BYTE "L E V E L   C O M P L E T E !", 0
strNeed BYTE ">>> Need 700+ score to pass! <<<", 0
strHigh BYTE "=== TOP 3 HIGH SCORES ===", 0
strYour BYTE "Your Score: ", 0
strNew BYTE "*** NEW HIGH SCORE! ***", 0
strKey BYTE "Press any key...", 0
strCtrl BYTE "=== CONTROLS ===", 0
strCtrl1 BYTE "W / UP Arrow    = Jump (press twice for double jump!)", 0
strCtrl2 BYTE "A / LEFT Arrow  = Move Left", 0
strCtrl3 BYTE "D / RIGHT Arrow = Move Right", 0
strCtrl4 BYTE "SPACE           = Shoot Fireball (when Fire Mario)", 0
strCtrl5 BYTE "P               = Pause Game", 0
strCtrl6 BYTE "X               = Exit to Menu", 0
strFeat BYTE "=== FEATURES ===", 0
strFeat1 BYTE "o = Coins (100 pts each, 50 coins = extra life)", 0
strFeat2 BYTE "? = Mystery Block (hit from below for power-up)", 0
strFeat3 BYTE "= = Breakable Platform (hit from below to destroy)", 0
strFeat4 BYTE "G = Goomba (stomp to defeat, 100 pts)", 0
strFeat5 BYTE "K = Koopa (stomp to create shell)", 0
strFeat6 BYTE "C = FREEZE POWER! (stops all enemies for 5 seconds)", 0
strFeat7 BYTE "M = Mushroom (makes Mario grow)", 0
strFeat8 BYTE "F = Flag (reach with 700+ score to complete level)", 0
strBonus BYTE " TIME BONUS: +", 0
strPlayer BYTE "Player: ", 0
strFell BYTE "You fell into a pit!", 0
strFreeze BYTE "*** FREEZE ACTIVATED! ***", 0
strRank1 BYTE "1st: ", 0
strRank2 BYTE "2nd: ", 0
strRank3 BYTE "3rd: ", 0
strDots BYTE " ... ", 0
strEmpty BYTE "---", 0

; === LEVEL 1: Classic Mario Style with Pitfalls + Hidden C ===
level1 BYTE "########################################################################################################################"
       BYTE "#                                                                                                       [===]          #"
       BYTE "#                                                                                                       [   ]          #"
       BYTE "#                                                                                                       [ F ]          #"
       BYTE "#                                                                                  ============         [   ]          #"
       BYTE "#                                                                          o  o                                        #"
       BYTE "#                                                                        #######    G                                  #"
       BYTE "#                               #                                               ==========                             #"
       BYTE "#                               #                                 o   o              ?                                 #"
       BYTE "#                               #                               #######                                                #"
       BYTE "#                               #                        K                                     ############            #"
       BYTE "#                                                     =========        o                                               #"
       BYTE "#                                              o  o                  ######                                            #"
       BYTE "#                                            ######   G       ?                                                        #"
       BYTE "#                                     C            =======                                                             #"
       BYTE "#                                    o   o                                                                             #"
       BYTE "#                                   ######         o    o    o                                                         #"
       BYTE "#                            K                     ###########                                                         #"
       BYTE "#                         =========       ?                                                                            #"
       BYTE "#                  o  o   #########      G                                #                                            #"
       BYTE "#                ######             ==========                            #                                            #"
       BYTE "#         o               ?    ?                                          #                                            #"
       BYTE "#       ####    G              o                                          #                                            #"
       BYTE "#            ========       ######        K                               #                                            #"
       BYTE "#  o   o                                ======                                                                         #"
       BYTE "########       ################                  #########################################################          ####"
       BYTE "########       ################                  ############################################################      #####"

; === LEVEL 2: Pyramid with scattered platforms + Hidden C ===
level2 BYTE "########################################################################################################################"
       BYTE "#                                                                                                                      #"
       BYTE "#                                                     [===]                                                            #"
       BYTE "#                                                     [ F ]                                                            #"
       BYTE "#                                                     [===]                                                            #"
       BYTE "#                                                    ========                                                          #"
       BYTE "#                                                                                                                      #"
       BYTE "#                                        o  o          G           o  o                                                #"
       BYTE "#                                      ========     ========     ========                                              #"
       BYTE "#                                                                                                                      #"
       BYTE "#                            K                                              K                                          #"
       BYTE "#                         ========              o  o  o              ========                                          #"
       BYTE "#                                              ==========                                                              #"
       BYTE "#                                                  ?                                                                   #"
       BYTE "#                   o  o        G                                      G        o  o                                   #"
       BYTE "#                 ========   ========                              ========   ========                                 #"
       BYTE "#                                                                                                                      #"
       BYTE "#                                                 C                                                                    #"
       BYTE "#          K                          o  o          o  o                            K                                  #"
       BYTE "#       ========      G             ========      ========             G        ========                               #"
       BYTE "#                  ========                                          ========                                          #"
       BYTE "#    o  o                   ?                                   ?                o  o                                  #"
       BYTE "#  ========             K                          G                    K          ========                            #"
       BYTE "#                    ========      o  o  o      ========      o  o  o  ========                                        #"
       BYTE "#                                ============                ============                                              #"
       BYTE "########################################################################################################################"
       BYTE "########################################################################################################################"

.code

; ============================================================================
; SOUND PROCEDURES - Using MP3 files via MCI
; ============================================================================
InitSounds PROC
    pushad
    ; Open jump sound
    INVOKE mciSendStringA, OFFSET sndJump, NULL, 0, 0
    ; Open coin sound
    INVOKE mciSendStringA, OFFSET sndCoin, NULL, 0, 0
    ; Open fire sound
    INVOKE mciSendStringA, OFFSET sndFire, NULL, 0, 0
    mov soundsLoaded, 1
    popad
    ret
InitSounds ENDP

PlayJumpSound PROC
    pushad
    cmp soundsLoaded, 1
    jne JumpBeep
    INVOKE mciSendStringA, OFFSET sndJumpPlay, NULL, 0, 0
    jmp JumpDone
JumpBeep:
    INVOKE Beep, 600, 50
JumpDone:
    popad
    ret
PlayJumpSound ENDP

PlayCoinSound PROC
    pushad
    cmp soundsLoaded, 1
    jne CoinBeep
    INVOKE mciSendStringA, OFFSET sndCoinPlay, NULL, 0, 0
    jmp CoinDone
CoinBeep:
    INVOKE Beep, 1200, 80
CoinDone:
    popad
    ret
PlayCoinSound ENDP

PlayStompSound PROC
    pushad
    INVOKE Beep, 300, 100
    popad
    ret
PlayStompSound ENDP

PlayPowerupSound PROC
    pushad
    INVOKE Beep, 800, 150
    popad
    ret
PlayPowerupSound ENDP

PlayDamageSound PROC
    pushad
    INVOKE Beep, 200, 200
    popad
    ret
PlayDamageSound ENDP

PlayFreezeSound PROC
    pushad
    INVOKE Beep, 1500, 150
    popad
    ret
PlayFreezeSound ENDP

PlayFireballSound PROC
    pushad
    cmp soundsLoaded, 1
    jne FireBeep
    INVOKE mciSendStringA, OFFSET sndFirePlay, NULL, 0, 0
    jmp FireDone
FireBeep:
    INVOKE Beep, 400, 50
FireDone:
    popad
    ret
PlayFireballSound ENDP

PlayVictorySound PROC
    pushad
    INVOKE Beep, 523, 150
    INVOKE Beep, 659, 150
    INVOKE Beep, 784, 150
    INVOKE Beep, 1047, 300
    popad
    ret
PlayVictorySound ENDP

PlayGameOverSound PROC
    pushad
    INVOKE Beep, 392, 200
    INVOKE Beep, 330, 200
    INVOKE Beep, 262, 400
    popad
    ret
PlayGameOverSound ENDP

;  Check if tile is solid
IsSolidTile PROC
    cmp al, '#'
    je IsSolid
    cmp al, '['
    je IsSolid
    cmp al, ']'
    je IsSolid
    cmp al, '-'
    je IsSolid
    cmp al, '?'
    je IsSolid
    or al, al
    ret
IsSolid:
    xor al, al
    ret
IsSolidTile ENDP

;Check if tile is breakable (=)
IsBreakableTile PROC
    cmp al, '='
    je IsBreakable
    or al, al
    ret
IsBreakable:
    xor al, al
    ret
IsBreakableTile ENDP

; Check if tile blocks movement (solid OR breakable)
IsBlockingTile PROC
    push eax
    call IsSolidTile
    jz ItsBlocking
    pop eax
    push eax
    call IsBreakableTile
    jz ItsBlocking
    pop eax
    or al, al
    ret
ItsBlocking:
    pop eax
    xor al, al
    ret
IsBlockingTile ENDP

; Get tile at position (BL=X, BH=Y) -> AL=tile
GetTileAt PROC
    push ebx
    push edx
    movzx eax, bh
    imul eax, MAP_W
    movzx edx, bl
    add eax, edx
    mov esi, OFFSET levelMap
    mov al, BYTE PTR [esi + eax]
    pop edx
    pop ebx
    ret
GetTileAt ENDP

; Set tile at position (BL=X, BH=Y, CL=new tile)
SetTileAt PROC
    push eax
    push ebx
    push edx
    movzx eax, bh
    imul eax, MAP_W
    movzx edx, bl
    add eax, edx
    mov esi, OFFSET levelMap
    mov BYTE PTR [esi + eax], cl
    pop edx
    pop ebx
    pop eax
    ret
SetTileAt ENDP

;HIDE CURSOR 
HideCursor PROC
    pushad
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov ebx, eax
    sub esp, 8
    mov DWORD PTR [esp], 1
    mov DWORD PTR [esp+4], 0
    INVOKE SetConsoleCursorInfo, ebx, esp
    add esp, 8
    popad
    ret
HideCursor ENDP

;SHOW CURSOR
ShowCursor PROC
    pushad
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov ebx, eax
    sub esp, 8
    mov DWORD PTR [esp], 20
    mov DWORD PTR [esp+4], 1
    INVOKE SetConsoleCursorInfo, ebx, esp
    add esp, 8
    popad
    ret
ShowCursor ENDP

main PROC
    call Randomize
    call Clrscr
    call HideCursor
    call InitSounds
    call LoadScore
    call LoadProgress

MainLoop:
    mov al, gameState
    cmp al, 0
    je DoMenu
    cmp al, 1
    je DoPlay
    cmp al, 2
    je DoPause
    cmp al, 3
    je DoLvlDone
    cmp al, 4
    je DoOver
    cmp al, 5
    je DoWin
    jmp ExitProg

DoMenu:
    call MenuScreen
    jmp MainLoop
DoPlay:
    call PlayGame
    jmp MainLoop
DoPause:
    call PauseScreen
    jmp MainLoop
DoLvlDone:
    call LevelDoneScreen
    jmp MainLoop
DoOver:
    call GameOverScreen
    jmp MainLoop
DoWin:
    call WinScreen
    jmp MainLoop

ExitProg:
    call SaveScore
    call SaveProgress
    call ShowCursor
    exit
main ENDP

MenuScreen PROC
    call Clrscr
    
    ; Draw title
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 3
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strTitle
    call WriteString
    
    ; Draw roll number
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov dh, 5
    mov dl, 48
    call Gotoxy
    mov edx, OFFSET strRoll
    call WriteString
    
    ; Draw menu options
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 9
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strMenu1
    call WriteString
    
    mov dh, 11
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strMenu2
    call WriteString
    
    mov dh, 13
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strMenu3
    call WriteString
    
    mov dh, 15
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strMenu4
    call WriteString
    
    mov dh, 17
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strMenu5
    call WriteString

WaitMenu:
    call ReadChar
    cmp al, '1'
    je StartNew
    cmp al, '2'
    je ContinueGame
    cmp al, '3'
    je ShowHigh
    cmp al, '4'
    je ShowHelp
    cmp al, '5'
    je QuitGame
    jmp WaitMenu

StartNew:
    call GetName
    ; Reset saved progress for new game
    mov savedLevel, 1
    mov savedLives, 3
    mov savedScore, 0
    mov savedMarioX, 5
    mov savedMarioY, 24
    mov savedPower, 0
    mov savedCoins, 0
    mov savedTimer, 150
    call InitGame
    mov gameState, 1
    ret

ContinueGame:
    call GetName
    call LoadProgress
    mov al, savedLevel
    mov currentLevel, al
    mov al, savedLives
    mov marioLives, al
    mov eax, savedScore
    mov score, eax
    mov al, savedPower
    mov marioPower, al
    mov al, savedCoins
    mov coins, al
    mov ax, savedTimer
    mov timer, ax
    call LoadLevelData
    ; Restore Mario position AFTER loading level (LoadLevelData resets position)
    mov al, savedMarioX
    mov marioX, al
    mov prevMarioX, al
    mov al, savedMarioY
    mov marioY, al
    mov prevMarioY, al
    mov gameState, 1
    ret

ShowHigh:
    call HighScoreScreen
    jmp MenuScreen

ShowHelp:
    call HelpScreen
    jmp MenuScreen

QuitGame:
    mov gameState, 255
    ret
MenuScreen ENDP

GetName PROC
    call Clrscr
    call ShowCursor
    
    ; Clear playerName buffer first to avoid garbage data
    pushad
    mov edi, OFFSET playerName
    mov ecx, 16
    xor al, al
    rep stosb
    popad
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 10
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET strName
    call WriteString
    mov edx, OFFSET playerName
    mov ecx, 15
    call ReadString
    call HideCursor
    
    ; Ensure null termination
    mov BYTE PTR [playerName + 15], 0
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 12
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET strHello
    call WriteString
    mov edx, OFFSET playerName
    call WriteString
    mov al, '!'
    call WriteChar
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, 15
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strLoad
    call WriteString
    mov eax, 1000
    call Delay
    ret
GetName ENDP

HelpScreen PROC
    call Clrscr
    
    ; Controls header
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 2
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strCtrl
    call WriteString
    
    ; Controls
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dh, 4
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl1
    call WriteString
    
    mov dh, 5
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl2
    call WriteString
    
    mov dh, 6
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl3
    call WriteString
    
    mov dh, 7
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl4
    call WriteString
    
    mov dh, 8
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl5
    call WriteString
    
    mov dh, 9
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strCtrl6
    call WriteString
    
    ; Features header
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 11
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strFeat
    call WriteString
    
    ; Features
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov dh, 13
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat1
    call WriteString
    
    mov dh, 14
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat2
    call WriteString
    
    mov eax, brown + (black * 16)
    call SetTextColor
    mov dh, 15
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat3
    call WriteString
    
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat4
    call WriteString
    
    mov dh, 17
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat5
    call WriteString
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 18
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat6
    call WriteString
    
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dh, 19
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat7
    call WriteString
    
    mov eax, green + (black * 16)
    call SetTextColor
    mov dh, 20
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strFeat8
    call WriteString
    
    ; Score requirement
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 23
    mov dl, 40
    call Gotoxy
    mov edx, OFFSET strNeed
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 26
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strKey
    call WriteString
    call ReadChar
    ret
HelpScreen ENDP

HighScoreScreen PROC
    call Clrscr
    
    ; Title
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 6
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strHigh
    call WriteString
    
    ; 1st Place
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 10
    mov dl, 35
    call Gotoxy
    mov edx, OFFSET strRank1
    call WriteString
    
    ; Check if score exists
    mov eax, topScores[0]
    cmp eax, 0
    je Empty1
    
    ; Display name
    mov edx, OFFSET topNames
    call WriteString
    mov edx, OFFSET strDots
    call WriteString
    mov eax, topScores[0]
    call WriteDec
    jmp Show2nd
    
Empty1:
    mov edx, OFFSET strEmpty
    call WriteString
    
Show2nd:
    ; 2nd Place
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dh, 13
    mov dl, 35
    call Gotoxy
    mov edx, OFFSET strRank2
    call WriteString
    
    mov eax, topScores[4]
    cmp eax, 0
    je Empty2
    
    mov edx, OFFSET topNames
    add edx, 16
    call WriteString
    mov edx, OFFSET strDots
    call WriteString
    mov eax, topScores[4]
    call WriteDec
    jmp Show3rd
    
Empty2:
    mov edx, OFFSET strEmpty
    call WriteString
    
Show3rd:
    ; 3rd Place
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 35
    call Gotoxy
    mov edx, OFFSET strRank3
    call WriteString
    
    mov eax, topScores[8]
    cmp eax, 0
    je Empty3
    
    mov edx, OFFSET topNames
    add edx, 32
    call WriteString
    mov edx, OFFSET strDots
    call WriteString
    mov eax, topScores[8]
    call WriteDec
    jmp ShowKeyPrompt
    
Empty3:
    mov edx, OFFSET strEmpty
    call WriteString
    
ShowKeyPrompt:
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 22
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strKey
    call WriteString
    call ReadChar
    ret
HighScoreScreen ENDP

InitGame PROC
    mov marioX, 5
    mov marioY, 24
    mov prevMarioX, 5
    mov prevMarioY, 24
    mov marioVelY, 0
    mov marioLives, 3
    mov marioPower, 0
    mov marioOnGround, 1
    mov marioInvinc, 0
    mov usedDouble, 0
    mov marioDir, 1
    mov jumpHeld, 0
    mov score, 0
    mov coins, 0
    mov timer, 150              ; 150 seconds per level
    mov currentLevel, 1
    mov goalReached, 0
    mov needFullRedraw, 1
    mov frameCount, 0
    mov freezeActive, 0
    mov freezeTimer, 0
    mov mushroomActive, 0
    call ClearEnts
    call ClearFireballs
    call LoadLevelData
    ret
InitGame ENDP

ClearEnts PROC
    pushad
    xor al, al
    mov ecx, MAX_ENEMIES
    mov edi, OFFSET enemyActive
    rep stosb
    mov enemyCount, 0
    mov ecx, MAX_COINS
    mov edi, OFFSET coinActive
    rep stosb
    mov coinCount, 0
    popad
    ret
ClearEnts ENDP

ClearFireballs PROC
    pushad
    xor al, al
    mov ecx, MAX_FIREBALLS
    mov edi, OFFSET fireballActive
    rep stosb
    mov fireballCount, 0
    popad
    ret
ClearFireballs ENDP

LoadLevelData PROC
    pushad
    call ClearEnts
    call ClearFireballs
    mov marioX, 5
    mov marioY, 24
    mov prevMarioX, 5
    mov prevMarioY, 24
    mov marioVelY, 0
    mov marioOnGround, 1
    mov goalReached, 0
    mov needFullRedraw, 1
    mov jumpHeld, 0
    mov usedDouble, 0
    mov freezeActive, 0
    mov freezeTimer, 0
    mov freezeCollected, 0
    mov mushroomActive, 0

    mov al, currentLevel
    cmp al, 1
    je UseL1
    jmp UseL2
UseL1:
    mov esi, OFFSET level1
    jmp CopyMap
UseL2:
    mov esi, OFFSET level2
CopyMap:
    mov edi, OFFSET levelMap
    mov ecx, 3240
    rep movsb
    call FindEntities
    popad
    ret
LoadLevelData ENDP

FindEntities PROC
    pushad
    mov esi, OFFSET levelMap
    xor ebx, ebx
FindRow:
    xor ecx, ecx
FindCol:
    mov eax, ebx
    imul eax, 120
    add eax, ecx
    mov dl, BYTE PTR [esi + eax]
    cmp dl, 'o'
    je AddCoin
    cmp dl, 'G'
    je AddGoomba
    cmp dl, 'K'
    je AddKoopa
    cmp dl, 'F'
    je SetGoal
    cmp dl, 'C'
    je SetFreeze
    jmp FindNext

AddCoin:
    push eax
    movzx eax, coinCount
    cmp al, MAX_COINS
    jge SkipC
    mov edi, eax
    mov coinX[edi], cl
    mov coinY[edi], bl
    mov coinActive[edi], 1
    inc coinCount
SkipC:
    pop eax
    mov BYTE PTR [esi + eax], ' '
    jmp FindNext

AddGoomba:
    push eax
    movzx eax, enemyCount
    cmp al, MAX_ENEMIES
    jge SkipE
    mov edi, eax
    mov enemyX[edi], cl
    mov enemyY[edi], bl
    mov enemyPrevX[edi], cl
    mov enemyPrevY[edi], bl
    mov enemyDir[edi], 0
    mov enemyActive[edi], 1
    mov enemyType[edi], 0
    inc enemyCount
SkipE:
    pop eax
    mov BYTE PTR [esi + eax], ' '
    jmp FindNext

AddKoopa:
    push eax
    movzx eax, enemyCount
    cmp al, MAX_ENEMIES
    jge SkipK
    mov edi, eax
    mov enemyX[edi], cl
    mov enemyY[edi], bl
    mov enemyPrevX[edi], cl
    mov enemyPrevY[edi], bl
    mov enemyDir[edi], 1
    mov enemyActive[edi], 1
    mov enemyType[edi], 1
    inc enemyCount
SkipK:
    pop eax
    mov BYTE PTR [esi + eax], ' '
    jmp FindNext

SetGoal:
    mov goalX, cl
    mov goalY, bl
    jmp FindNext

SetFreeze:
    mov freezeX, cl
    mov freezeY, bl
    mov freezeCollected, 0
    ; Keep C in the map for display
    jmp FindNext

FindNext:
    inc ecx
    cmp ecx, 120
    jl FindCol
    inc ebx
    cmp ebx, 27
    jl FindRow
    popad
    ret
FindEntities ENDP

PlayGame PROC
    call Clrscr
    mov needFullRedraw, 1
GameTick:
    cmp gameState, 1
    jne EndPlay
    call GetInput
    call MoveMario
    call MoveFireballs
    call MoveMushroom
    call CheckPitfall
    inc frameCount

    ; Update freeze timer
    cmp freezeActive, 1
    jne NoFreezeUpdate
    cmp freezeTimer, 0
    je FreezeEnd
    dec freezeTimer
    jmp SkipEnMove

FreezeEnd:
    mov freezeActive, 0
    jmp SkipEnMove

NoFreezeUpdate:
    ; Move enemies only if not frozen
    mov al, frameCount
    and al, 1
    cmp al, 0
    jne SkipEnMove
    call MoveEnemies

SkipEnMove:
    call CheckHits
    call CheckFreezePowerup
    call CheckMushroomHit
    call CheckGoalPos
    call RenderFrame
    mov eax, 45
    call Delay

    mov al, frameCount
    and al, 31
    cmp al, 0
    jne NoTimerDec
    cmp timer, 0
    je TimeDie
    dec timer
NoTimerDec:
    jmp GameTick
TimeDie:
    call DieMario
    jmp GameTick
EndPlay:
    ret
PlayGame ENDP

CheckPitfall PROC
    pushad
    movzx eax, marioY
    cmp eax, 25
    jl NoPitfall
    mov bl, marioX
    mov bh, marioY
    call GetTileAt
    cmp al, ' '
    jne NoPitfall
    cmp marioY, 26
    jge FellIntoPit
    mov bl, marioX
    mov bh, marioY
    inc bh
    cmp bh, 27
    jge CheckCurrentTile
    call GetTileAt
    cmp al, ' '
    je NoPitfall
    jmp NoPitfall
CheckCurrentTile:
FellIntoPit:
    popad
    call ShowPitfallMessage
    call DieMario
    ret
NoPitfall:
    popad
    ret
CheckPitfall ENDP

ShowPitfallMessage PROC
    pushad
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dh, 14
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strFell
    call WriteString
    call PlayDamageSound
    mov eax, 1000
    call Delay
    popad
    ret
ShowPitfallMessage ENDP

CheckFreezePowerup PROC
    pushad
    cmp freezeCollected, 1
    je NoFreezeColl
    
    ; Check if freeze exists (freezeX and freezeY not both 0)
    mov al, freezeX
    or al, freezeY
    jz NoFreezeColl
    
    ; Check if Mario is at freeze location (allow 1 tile tolerance)
    mov al, marioX
    sub al, freezeX
    cmp al, 1
    ja CheckFreezeNeg
    jmp CheckFreezeY
CheckFreezeNeg:
    cmp al, 255      ; -1 in unsigned
    jne NoFreezeColl
CheckFreezeY:
    mov al, marioY
    sub al, freezeY
    cmp al, 1
    ja CheckFreezeYNeg
    jmp FreezeHit
CheckFreezeYNeg:
    cmp al, 255
    jne NoFreezeColl
    
FreezeHit:
    ; Collect freeze power!
    mov freezeCollected, 1
    mov freezeActive, 1
    mov freezeTimer, 150       ; ~5 seconds at 30fps
    add score, 200
    
    ; Erase C from screen directly
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, freezeX
    mov dh, freezeY
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Remove C from map
    mov bl, freezeX
    mov bh, freezeY
    mov cl, ' '
    call SetTileAt
    
    ; Show message briefly
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov dh, 0
    mov dl, 100
    call Gotoxy
    mov edx, OFFSET strFreeze
    call WriteString
    call PlayFreezeSound
    
NoFreezeColl:
    popad
    ret
CheckFreezePowerup ENDP

GetInput PROC
    call ReadKey
    jz NoKeyPressed
    cmp al, 'w'
    je JumpKey
    cmp al, 'W'
    je JumpKey
    cmp al, 72
    je JumpKey
    cmp al, 'a'
    je LeftKey
    cmp al, 'A'
    je LeftKey
    cmp al, 75
    je LeftKey
    cmp al, 'd'
    je RightKey
    cmp al, 'D'
    je RightKey
    cmp al, 77
    je RightKey
    cmp al, ' '
    je FireKey
    cmp al, 'p'
    je PauseKey
    cmp al, 'P'
    je PauseKey
    cmp al, 'x'
    je QuitKey
    cmp al, 'X'
    je QuitKey
    jmp NoKeyPressed

JumpKey:
    cmp marioOnGround, 1
    je DoGroundJump
    cmp canDoubleJump, 1
    jne NoKeyPressed
    cmp usedDouble, 1
    je NoKeyPressed
    mov marioVelY, DOUBLE_JUMP_VEL
    mov usedDouble, 1
    mov marioOnGround, 0
    call PlayJumpSound
    jmp NoKeyPressed

DoGroundJump:
    mov marioVelY, JUMP_VELOCITY
    mov marioOnGround, 0
    mov usedDouble, 0
    call PlayJumpSound
    jmp NoKeyPressed

LeftKey:
    mov marioDir, 0
    call TryMoveLeft
    jmp NoKeyPressed

RightKey:
    mov marioDir, 1
    call TryMoveRight
    jmp NoKeyPressed

FireKey:
    cmp marioPower, 2
    jne NoKeyPressed
    call ShootFireball
    jmp NoKeyPressed

PauseKey:
    mov gameState, 2
    jmp NoKeyPressed

QuitKey:
    mov gameState, 0

NoKeyPressed:
    ret
GetInput ENDP

ShootFireball PROC
    pushad
    ; Find inactive fireball slot
    xor ebx, ebx
FindFireSlot:
    cmp ebx, MAX_FIREBALLS
    jge NoFireSlot
    cmp fireballActive[ebx], 0
    je FoundFireSlot
    inc ebx
    jmp FindFireSlot

FoundFireSlot:
    ; Spawn fireball in front of Mario based on direction
    mov al, marioX
    cmp marioDir, 0
    je FireSpawnLeft
    inc al              ; Spawn 1 tile to the right
    jmp FireSpawnDone
FireSpawnLeft:
    dec al              ; Spawn 1 tile to the left
FireSpawnDone:
    mov fireballX[ebx], al
    mov al, marioY
    mov fireballY[ebx], al
    mov al, marioDir
    mov fireballDir[ebx], al
    mov fireballActive[ebx], 1
    call PlayFireballSound

NoFireSlot:
    popad
    ret
ShootFireball ENDP

MoveFireballs PROC
    pushad
    xor ebx, ebx
FireLoop:
    cmp ebx, MAX_FIREBALLS
    jge FireDone
    cmp fireballActive[ebx], 0
    je NextFire
    
    ; Erase old position
    push ebx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, fireballX[ebx]
    mov dh, fireballY[ebx]
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop ebx
    
    ; Move fireball
    cmp fireballDir[ebx], 0
    je FireLeft
    inc fireballX[ebx]
    jmp CheckFireColl
FireLeft:
    dec fireballX[ebx]

CheckFireColl:
    ; Check bounds
    movzx eax, fireballX[ebx]
    cmp eax, 2
    jle DeactiveFire
    cmp eax, 117
    jge DeactiveFire
    
    ; Check wall collision
    push ebx
    mov bl, fireballX[ebx]
    mov bh, fireballY[ebx]
    call GetTileAt
    call IsBlockingTile
    pop ebx
    jz DeactiveFire
    
    ; Check enemy collision
    call CheckFireballEnemyHit
    jmp NextFire

DeactiveFire:
    mov fireballActive[ebx], 0

NextFire:
    inc ebx
    jmp FireLoop

FireDone:
    popad
    ret
MoveFireballs ENDP

CheckFireballEnemyHit PROC
    ; EBX = fireball index
    pushad
    movzx ecx, enemyCount
    cmp ecx, 0
    je NoFireEnHit
    xor edi, edi

FireEnLoop:
    cmp enemyActive[edi], 0
    je NextFireEn
    
    mov al, fireballX[ebx]
    cmp al, enemyX[edi]
    jne NextFireEn
    mov al, fireballY[ebx]
    cmp al, enemyY[edi]
    jne NextFireEn
    
    ; Hit! Kill enemy
    mov enemyActive[edi], 0
    mov fireballActive[ebx], 0
    add score, 150
    call PlayStompSound
    
    ; Erase enemy
    push ebx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, enemyX[edi]
    mov dh, enemyY[edi]
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop ebx
    jmp NoFireEnHit

NextFireEn:
    inc edi
    cmp edi, ecx
    jl FireEnLoop

NoFireEnHit:
    popad
    ret
CheckFireballEnemyHit ENDP

TryMoveLeft PROC
    pushad
    movzx eax, marioX
    cmp eax, 2
    jle CantMoveLeft
    mov bl, marioX
    dec bl
    mov bh, marioY
    call GetTileAt
    call IsBlockingTile
    jz CantMoveLeft
    dec marioX
CantMoveLeft:
    popad
    ret
TryMoveLeft ENDP

TryMoveRight PROC
    pushad
    movzx eax, marioX
    cmp eax, 117
    jge CantMoveRight
    mov bl, marioX
    inc bl
    mov bh, marioY
    call GetTileAt
    call IsBlockingTile
    jz CantMoveRight
    inc marioX
CantMoveRight:
    popad
    ret
TryMoveRight ENDP

MoveMario PROC
    pushad
    
    ; Always check if still on ground
    cmp marioOnGround, 1
    jne SkipGroundCheck
    
    ; Check tile below Mario
    mov bl, marioX
    mov bh, marioY
    inc bh
    cmp bh, 27
    jge StillOnGround
    call GetTileAt
    call IsBlockingTile
    jz StillOnGround
    ; No ground below - start falling
    mov marioOnGround, 0
    mov marioVelY, 1
    jmp ApplyGravity
    
StillOnGround:
    jmp NoVerticalMove
    
SkipGroundCheck:
ApplyGravity:
    ; Apply gravity
    movsx eax, marioVelY
    add eax, GRAVITY
    cmp eax, MAX_FALL_SPEED
    jle VelOk
    mov eax, MAX_FALL_SPEED
VelOk:
    mov marioVelY, al
    
    ; Apply vertical velocity
    movsx eax, marioVelY
    cmp eax, 0
    je NoVerticalMove
    jl MovingUp
    call MoveDown
    jmp NoVerticalMove
MovingUp:
    call MoveUp
    
NoVerticalMove:
    cmp invincTimer, 0
    je NoInvDec
    dec invincTimer
    cmp invincTimer, 0
    jne NoInvDec
    mov marioInvinc, 0
NoInvDec:
    popad
    ret
MoveMario ENDP

MoveDown PROC
    pushad
    movsx ecx, marioVelY
MoveDownLoop:
    cmp ecx, 0
    jle MoveDownDone
    movzx eax, marioY
    inc eax
    cmp eax, 26
    jg HitBottom
    mov bl, marioX
    mov bh, al
    push eax
    call GetTileAt
    call IsBlockingTile
    pop eax
    jz LandOnGround
    mov marioY, al
    dec ecx
    jmp MoveDownLoop
LandOnGround:
    mov marioVelY, 0
    mov marioOnGround, 1
    mov usedDouble, 0
    jmp MoveDownDone
HitBottom:
    mov marioY, 26
    mov marioVelY, 0
MoveDownDone:
    popad
    ret
MoveDown ENDP

MoveUp PROC
    pushad
    movsx ecx, marioVelY
    neg ecx
MoveUpLoop:
    cmp ecx, 0
    jle MoveUpDone
    movzx eax, marioY
    dec eax
    cmp eax, 1
    jl HitCeiling
    mov bl, marioX
    mov bh, al
    push eax
    push ecx
    call GetTileAt
    
    ; Check for question block
    cmp al, '?'
    je HitQuestionBlock
    
    ; Check for breakable platform
    cmp al, '='
    je HitBreakable
    
    call IsSolidTile
    pop ecx
    pop eax
    jz HitCeiling
    mov marioY, al
    dec ecx
    jmp MoveUpLoop

HitQuestionBlock:
    pop ecx
    pop eax
    push eax
    push ebx
    ; Change ? to - in map
    movzx eax, bh
    imul eax, MAP_W
    movzx edx, bl
    add eax, edx
    mov esi, OFFSET levelMap
    mov BYTE PTR [esi + eax], '-'
    add score, 50
    
    ; Redraw just that tile as '-'
    push ebx
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, bl
    mov dh, bh
    inc dh
    call Gotoxy
    mov al, '-'
    call WriteChar
    pop ebx
    
    ; Spawn mushroom if Mario is small
    cmp marioPower, 0
    jne NoPowerGive
    mov al, bl
    mov mushroomX, al
    mov mushroomPrevX, al
    mov al, bh
    dec al
    mov mushroomY, al
    mov mushroomPrevY, al
    mov mushroomActive, 1
    mov mushroomDir, 1
    jmp PowerGiven

NoPowerGive:
    ; Give fire power if big
    cmp marioPower, 1
    jne PowerGiven
    mov marioPower, 2

PowerGiven:
    call PlayPowerupSound
    pop ebx
    pop eax
    jmp HitCeiling

HitBreakable:
    pop ecx
    pop eax
    push eax
    push ebx
    ; Break the platform - replace with space
    movzx eax, bh
    imul eax, MAP_W
    movzx edx, bl
    add eax, edx
    mov esi, OFFSET levelMap
    mov BYTE PTR [esi + eax], ' '
    add score, 25
    
    ; Redraw just that tile as space
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, bl
    mov dh, bh
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    call PlayStompSound
    pop ebx
    pop eax

HitCeiling:
    mov marioVelY, 1
    mov marioOnGround, 0
MoveUpDone:
    popad
    ret
MoveUp ENDP

MoveMushroom PROC
    pushad
    cmp mushroomActive, 0
    je NoMushMove
    
    ; Move mushroom
    cmp mushroomDir, 0
    je MushLeft
    
    ; Move right
    movzx eax, mushroomX
    inc eax
    cmp eax, 117
    jge MushReverseL
    mov bl, al
    mov bh, mushroomY
    push eax
    call GetTileAt
    call IsBlockingTile
    pop eax
    jz MushReverseL
    mov mushroomX, al
    jmp NoMushMove

MushReverseL:
    mov mushroomDir, 0
    jmp NoMushMove

MushLeft:
    movzx eax, mushroomX
    dec eax
    cmp eax, 2
    jle MushReverseR
    mov bl, al
    mov bh, mushroomY
    push eax
    call GetTileAt
    call IsBlockingTile
    pop eax
    jz MushReverseR
    mov mushroomX, al
    jmp NoMushMove

MushReverseR:
    mov mushroomDir, 1

NoMushMove:
    popad
    ret
MoveMushroom ENDP

CheckMushroomHit PROC
    pushad
    cmp mushroomActive, 0
    je NoMushHit
    
    ; Check X within 1 tile
    movzx eax, marioX
    movzx ebx, mushroomX
    sub eax, ebx
    cmp eax, 1
    jle CheckMushX2
    jmp NoMushHit
CheckMushX2:
    cmp eax, -1
    jge CheckMushY
    jmp NoMushHit
    
CheckMushY:
    ; Check Y within 1 tile
    movzx eax, marioY
    movzx ebx, mushroomY
    sub eax, ebx
    cmp eax, 1
    jle CheckMushY2
    jmp NoMushHit
CheckMushY2:
    cmp eax, -1
    jge MushCollected
    jmp NoMushHit
    
MushCollected:
    ; Erase mushroom from screen
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, mushroomX
    mov dh, mushroomY
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Collected mushroom!
    mov mushroomActive, 0
    cmp marioPower, 0
    jne AlreadyPowered
    mov marioPower, 1
    call PlayPowerupSound
    add score, 100

AlreadyPowered:
NoMushHit:
    popad
    ret
CheckMushroomHit ENDP

MoveEnemies PROC
    pushad
    movzx ecx, enemyCount
    cmp ecx, 0
    je NoEnMove
    xor ebx, ebx

EnMoveLoop:
    cmp enemyActive[ebx], 0
    je NextEnemy

    ; Save previous position
    mov al, enemyX[ebx]
    mov enemyPrevX[ebx], al
    mov al, enemyY[ebx]
    mov enemyPrevY[ebx], al

    ; Check direction
    mov al, enemyDir[ebx]
    cmp al, 0
    je EnMoveLeft

    ; Move right
    movzx edx, enemyX[ebx]
    inc edx
    cmp edx, 117
    jge EnReverseToLeft

    push ebx
    push edx
    mov al, enemyY[ebx]
    mov bh, al
    mov bl, dl
    call GetTileAt
    call IsBlockingTile
    pop edx
    pop ebx
    jz EnReverseToLeft

    inc enemyX[ebx]
    jmp NextEnemy

EnReverseToLeft:
    mov enemyDir[ebx], 0
    jmp NextEnemy

EnMoveLeft:
    movzx edx, enemyX[ebx]
    dec edx
    cmp edx, 2
    jle EnReverseToRight

    push ebx
    push edx
    mov al, enemyY[ebx]
    mov bh, al
    mov bl, dl
    call GetTileAt
    call IsBlockingTile
    pop edx
    pop ebx
    jz EnReverseToRight

    dec enemyX[ebx]
    jmp NextEnemy

EnReverseToRight:
    mov enemyDir[ebx], 1

NextEnemy:
    inc ebx
    cmp ebx, ecx
    jl EnMoveLoop
NoEnMove:
    popad
    ret
MoveEnemies ENDP

CheckHits PROC
    call CheckCoins
    call CheckEnemies
    ret
CheckHits ENDP

CheckCoins PROC
    pushad
    movzx ecx, coinCount
    cmp ecx, 0
    je NoCoinHit
    xor ebx, ebx
CoinLoop:
    cmp coinActive[ebx], 0
    je NextCoin
    
    ; Check X within 1 tile
    movzx eax, marioX
    movzx edx, coinX[ebx]
    sub eax, edx
    cmp eax, 1
    jg NextCoin
    cmp eax, -1
    jl NextCoin
    
    ; Check Y within 1 tile
    movzx eax, marioY
    movzx edx, coinY[ebx]
    sub eax, edx
    cmp eax, 1
    jg NextCoin
    cmp eax, -1
    jl NextCoin
    
    ; Collect coin
    mov coinActive[ebx], 0
    inc coins
    add score, 100
    call PlayCoinSound
    push ebx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, coinX[ebx]
    mov dh, coinY[ebx]
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop ebx
    cmp coins, 50
    jl NextCoin
    mov coins, 0
    inc marioLives
NextCoin:
    inc ebx
    cmp ebx, ecx
    jl CoinLoop
NoCoinHit:
    popad
    ret
CheckCoins ENDP

CheckEnemies PROC
    pushad
    cmp marioInvinc, 1
    je NoEnHit
    movzx ecx, enemyCount
    cmp ecx, 0
    je NoEnHit
    xor ebx, ebx
EnHitLoop:
    cmp enemyActive[ebx], 0
    je NextEn
    
    ; Check X within 1 tile
    movzx eax, marioX
    movzx edx, enemyX[ebx]
    sub eax, edx
    cmp eax, 1
    jg NextEn
    cmp eax, -1
    jl NextEn
    
    ; Check Y - stomp if Mario is 1 or 2 above (coming down on enemy)
    movzx eax, marioY
    movzx edx, enemyY[ebx]
    sub eax, edx
    cmp eax, -2
    jl NextEn           ; Too far above
    cmp eax, -1
    jle StompEnemy      ; Mario is 1-2 tiles above = stomp
    cmp eax, 0
    je DamageFromSide   ; Same level = damage
    cmp eax, 1
    je DamageFromSide   ; Mario below = damage
    jmp NextEn

DamageFromSide:
    call TakeDmg
    jmp NoEnHit

StompEnemy:
    ; Check enemy type
    cmp enemyType[ebx], 1
    je StompKoopa
    
    ; Stomp Goomba - just defeat it (no NOM)
    mov enemyActive[ebx], 0
    add score, 100
    mov marioVelY, -2
    call PlayStompSound
    
    push ebx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, enemyX[ebx]
    mov dh, enemyY[ebx]
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop ebx
    jmp NextEn

StompKoopa:
    ; Convert to shell (type 2)
    mov enemyType[ebx], 2
    add score, 100
    mov marioVelY, -2
    call PlayStompSound
    jmp NextEn

NextEn:
    inc ebx
    cmp ebx, ecx
    jl EnHitLoop
NoEnHit:
    popad
    ret
CheckEnemies ENDP

CheckGoalPos PROC
    cmp goalReached, 1
    je GoalDone
    movzx eax, marioX
    movzx ebx, goalX
    sub eax, ebx
    cmp eax, -1
    jl GoalDone
    cmp eax, 1
    jg GoalDone
    movzx eax, marioY
    movzx ebx, goalY
    sub eax, ebx
    cmp eax, -1
    jl GoalDone
    cmp eax, 1
    jg GoalDone
    mov goalReached, 1
    mov eax, score
    mov bl, currentLevel
    cmp bl, 1
    je CheckL1
    jmp CheckL2
CheckL1:
    cmp eax, SCORE_L1
    jge LevelOK
    jmp NeedMore
CheckL2:
    cmp eax, SCORE_L2
    jge WinGame
    jmp NeedMore
LevelOK:
    mov gameState, 3
    call PlayVictorySound
    jmp GoalDone
WinGame:
    mov gameState, 5
    call PlayVictorySound
    jmp GoalDone
NeedMore:
    push eax
    push edx
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dh, 14
    mov dl, 40
    call Gotoxy
    mov edx, OFFSET strNeed
    call WriteString
    call PlayDamageSound
    mov eax, 1500
    call Delay
    mov needFullRedraw, 1
    pop edx
    pop eax
    mov goalReached, 0
GoalDone:
    ret
CheckGoalPos ENDP

TakeDmg PROC
    cmp marioInvinc, 1
    je NoDmg
    cmp marioPower, 0
    je MustDie
    dec marioPower
    mov marioInvinc, 1
    mov invincTimer, 60
    call PlayDamageSound
    jmp NoDmg
MustDie:
    call DieMario
NoDmg:
    ret
TakeDmg ENDP

DieMario PROC
    dec marioLives
    call PlayDamageSound
    cmp marioLives, 0
    jle GameEnd
    mov needFullRedraw, 1
    mov timer, 150              ; Reset timer to 150
    call LoadLevelData
    ret
GameEnd:
    mov gameState, 4
    ret
DieMario ENDP

RenderFrame PROC
    cmp needFullRedraw, 1
    je DoFullRedraw
    call DrawHUD
    call ErasePrevMario
    call DrawEnemySprites
    call DrawCoinsSprites
    call DrawFireballSprites
    call DrawMushroomSprite
    call DrawFreezeSprite
    call DrawMarioSprite
    call SavePrevPositions
    jmp RenderDone
DoFullRedraw:
    call Clrscr
    call DrawHUD
    call DrawMap
    call DrawCoinsSprites
    call DrawEnemySprites
    call DrawFireballSprites
    call DrawMushroomSprite
    call DrawFreezeSprite
    call DrawMarioSprite
    call SavePrevPositions
    mov needFullRedraw, 0
RenderDone:
    ret
RenderFrame ENDP

SavePrevPositions PROC
    mov al, marioX
    mov prevMarioX, al
    mov al, marioY
    mov prevMarioY, al
    ret
SavePrevPositions ENDP

ErasePrevMario PROC
    pushad
    mov al, prevMarioX
    cmp al, marioX
    jne DoErase
    mov al, prevMarioY
    cmp al, marioY
    je NoErase
DoErase:
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, prevMarioX
    mov dh, prevMarioY
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
NoErase:
    popad
    ret
ErasePrevMario ENDP

DrawHUD PROC
    pushad
    mov dh, 0
    mov dl, 0
    call Gotoxy
    
    ; Player name
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET strPlayer
    call WriteString
    mov edx, OFFSET playerName
    call WriteString
    
    ; Score
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    mov al, 'S'
    call WriteChar
    mov al, 'C'
    call WriteChar
    mov al, 'O'
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, ':'
    call WriteChar
    mov eax, score
    call WriteDec
    
    ; Coins
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    mov al, 'o'
    call WriteChar
    mov al, ':'
    call WriteChar
    movzx eax, coins
    call WriteDec
    
    ; Level
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    mov al, 'L'
    call WriteChar
    mov al, 'V'
    call WriteChar
    mov al, 'L'
    call WriteChar
    mov al, ':'
    call WriteChar
    movzx eax, currentLevel
    call WriteDec
    mov al, '/'
    call WriteChar
    mov al, '2'
    call WriteChar
    
    ; Timer
    mov al, ' '
    call WriteChar
    call WriteChar
    mov al, 'T'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'M'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, ':'
    call WriteChar
    movzx eax, timer
    call WriteDec
    
    ; Lives
    mov eax, red + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    mov al, 'M'
    call WriteChar
    mov al, 'x'
    call WriteChar
    movzx eax, marioLives
    call WriteDec
    
    ; Power indicator
    mov al, ' '
    call WriteChar
    cmp marioPower, 2
    je ShowFire
    cmp marioPower, 1
    je ShowBig
    jmp ShowSmall
ShowFire:
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov al, 'F'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, 'E'
    call WriteChar
    jmp AfterPower
ShowBig:
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov al, 'B'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'G'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp AfterPower
ShowSmall:
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar

AfterPower:
    ; Freeze indicator
    cmp freezeActive, 1
    jne NoFreezeInd
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, 'F'
    call WriteChar
    mov al, 'R'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'Z'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, '!'
    call WriteChar

NoFreezeInd:
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, ' '
    mov ecx, 10
ClearRest:
    call WriteChar
    loop ClearRest
    popad
    ret
DrawHUD ENDP

DrawMap PROC
    pushad
    mov esi, OFFSET levelMap
    xor ebx, ebx
MapRow:
    mov dh, bl
    inc dh
    xor dl, dl
    call Gotoxy
    xor ecx, ecx
MapCol:
    mov eax, ebx
    imul eax, 120
    add eax, ecx
    mov al, BYTE PTR [esi + eax]
    cmp al, '#'
    je ColBrick
    cmp al, '?'
    je ColQ
    cmp al, '='
    je ColPlat
    cmp al, '-'
    je ColUsed
    cmp al, '~'
    je ColLava
    cmp al, 'F'
    je ColFlag
    cmp al, '['
    je ColCastle
    cmp al, ']'
    je ColCastle
    cmp al, 'C'
    je ColFreeze
    jmp ColNorm
ColBrick:
    push eax
    mov eax, red + (black * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColQ:
    push eax
    mov eax, yellow + (black * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColPlat:
    push eax
    mov eax, brown + (black * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColUsed:
    push eax
    mov eax, gray + (black * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColLava:
    push eax
    mov eax, lightRed + (red * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColFlag:
    push eax
    mov eax, white + (green * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColCastle:
    push eax
    mov eax, lightGray + (black * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColFreeze:
    push eax
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    pop eax
    jmp DoChar
ColNorm:
    push eax
    mov eax, white + (black * 16)
    call SetTextColor
    pop eax
DoChar:
    call WriteChar
    inc ecx
    cmp ecx, 120
    jl MapCol
    inc ebx
    cmp ebx, 27
    jl MapRow
    popad
    ret
DrawMap ENDP

DrawCoinsSprites PROC
    pushad
    movzx ecx, coinCount
    cmp ecx, 0
    je NoCoinDraw
    mov eax, yellow + (black * 16)
    call SetTextColor
    xor ebx, ebx
CoinDraw:
    cmp coinActive[ebx], 0
    je SkipCoin
    mov dl, coinX[ebx]
    mov dh, coinY[ebx]
    inc dh
    call Gotoxy
    mov al, 'o'
    call WriteChar
SkipCoin:
    inc ebx
    cmp ebx, ecx
    jl CoinDraw
NoCoinDraw:
    popad
    ret
DrawCoinsSprites ENDP

DrawFireballSprites PROC
    pushad
    mov eax, lightRed + (yellow * 16)
    call SetTextColor
    xor ebx, ebx
FireDraw:
    cmp ebx, MAX_FIREBALLS
    jge NoFireDraw
    cmp fireballActive[ebx], 0
    je SkipFireDraw
    mov dl, fireballX[ebx]
    mov dh, fireballY[ebx]
    inc dh
    call Gotoxy
    mov al, '*'
    call WriteChar
SkipFireDraw:
    inc ebx
    jmp FireDraw
NoFireDraw:
    popad
    ret
DrawFireballSprites ENDP

DrawMushroomSprite PROC
    pushad
    cmp mushroomActive, 0
    je CheckMushErase
    
    ; Erase previous position if moved
    mov al, mushroomPrevX
    cmp al, mushroomX
    je NoMushErase
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, mushroomPrevX
    mov dh, mushroomPrevY
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
NoMushErase:
    ; Draw at new position
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dl, mushroomX
    mov dh, mushroomY
    inc dh
    call Gotoxy
    mov al, 'M'
    call WriteChar
    
    ; Save current as previous
    mov al, mushroomX
    mov mushroomPrevX, al
    mov al, mushroomY
    mov mushroomPrevY, al
    jmp NoMushDraw

CheckMushErase:
    ; Mushroom not active - erase its last position if it existed
    mov al, mushroomPrevX
    cmp al, 0
    je NoMushDraw
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, mushroomPrevX
    mov dh, mushroomPrevY
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    ; Reset prev position so we don't keep erasing
    mov mushroomPrevX, 0
    mov mushroomPrevY, 0
    
NoMushDraw:
    popad
    ret
DrawMushroomSprite ENDP

DrawFreezeSprite PROC
    pushad
    cmp freezeCollected, 1
    je NoFreezeDraw
    mov eax, lightCyan + (blue * 16)
    call SetTextColor
    mov dl, freezeX
    mov dh, freezeY
    inc dh
    call Gotoxy
    mov al, 'C'
    call WriteChar
NoFreezeDraw:
    popad
    ret
DrawFreezeSprite ENDP

DrawEnemySprites PROC
    pushad
    movzx ecx, enemyCount
    cmp ecx, 0
    je NoEnDraw
    xor ebx, ebx
EnDraw:
    cmp enemyActive[ebx], 0
    je SkipEnDraw
    mov al, enemyPrevX[ebx]
    cmp al, enemyX[ebx]
    je NoEraseEn
    push ebx
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, enemyPrevX[ebx]
    mov dh, enemyPrevY[ebx]
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop ebx
NoEraseEn:
    mov dl, enemyX[ebx]
    mov dh, enemyY[ebx]
    inc dh
    call Gotoxy
    
    ; Check enemy type
    cmp enemyType[ebx], 2
    je DrawShell
    cmp enemyType[ebx], 1
    je DrawK
    
    ; Goomba
    mov eax, brown + (black * 16)
    call SetTextColor
    mov al, 'G'
    call WriteChar
    jmp SkipEnDraw

DrawK:
    mov eax, green + (black * 16)
    call SetTextColor
    mov al, 'K'
    call WriteChar
    jmp SkipEnDraw

DrawShell:
    mov eax, green + (black * 16)
    call SetTextColor
    mov al, 'S'
    call WriteChar

SkipEnDraw:
    inc ebx
    cmp ebx, ecx
    jl EnDraw
NoEnDraw:
    popad
    ret
DrawEnemySprites ENDP

DrawMarioSprite PROC
    pushad
    mov dl, marioX
    mov dh, marioY
    inc dh
    call Gotoxy
    cmp marioInvinc, 1
    je InvincibleMario
    cmp marioPower, 2
    je FireMario
    cmp marioPower, 1
    je BigMario
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, 'm'
    call WriteChar
    jmp MarioDone
BigMario:
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov al, 'M'
    call WriteChar
    jmp MarioDone
FireMario:
    mov eax, white + (red * 16)
    call SetTextColor
    mov al, 'M'
    call WriteChar
    jmp MarioDone
InvincibleMario:
    mov eax, yellow + (magenta * 16)
    call SetTextColor
    mov al, 'M'
    call WriteChar
MarioDone:
    popad
    ret
DrawMarioSprite ENDP

PauseScreen PROC
    pushad
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 12
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strPause
    call WriteString
    mov dh, 14
    mov dl, 42
    call Gotoxy
    mov edx, OFFSET strPause2
    call WriteString

WaitPause:
    call ReadChar
    cmp al, 'r'
    je ResumeGame
    cmp al, 'R'
    je ResumeGame
    cmp al, 'm'
    je GoToMenu
    cmp al, 'M'
    je GoToMenu
    cmp al, 'x'
    je ExitGame
    cmp al, 'X'
    je ExitGame
    jmp WaitPause

ResumeGame:
    mov gameState, 1
    mov needFullRedraw, 1
    jmp PauseDone

GoToMenu:
    call SaveProgress
    mov gameState, 0
    jmp PauseDone

ExitGame:
    call SaveProgress
    mov gameState, 255

PauseDone:
    popad
    ret
PauseScreen ENDP

LevelDoneScreen PROC
    call Clrscr
    call PlayVictorySound
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 8
    mov dl, 42
    call Gotoxy
    mov edx, OFFSET strDone
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 11
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strYour
    call WriteString
    mov eax, score
    call WriteDec
    mov dh, 13
    mov dl, 48
    call Gotoxy
    mov edx, OFFSET strBonus
    call WriteString
    movzx eax, timer
    shl eax, 1
    call WriteDec
    movzx eax, timer
    shl eax, 1
    add score, eax
    mov eax, 2500
    call Delay
    inc currentLevel
    mov timer, 150              ; Reset to 150 for next level
    call SaveProgress
    call LoadLevelData
    mov gameState, 1
    ret
LevelDoneScreen ENDP

GameOverScreen PROC
    call Clrscr
    call PlayGameOverSound
    mov eax, red + (black * 16)
    call SetTextColor
    mov dh, 10
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strOver
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 13
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strYour
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Check if made top 3
    mov eax, score
    cmp eax, topScores[8]
    jle NotNewHigh
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 46
    call Gotoxy
    mov edx, OFFSET strNew
    call WriteString
    
NotNewHigh:
    call SaveScore
    ; Reset progress
    mov savedLevel, 1
    mov savedLives, 3
    mov savedScore, 0
    call SaveProgress
    mov eax, 3000
    call Delay
    mov gameState, 0
    ret
GameOverScreen ENDP

WinScreen PROC
    call Clrscr
    call PlayVictorySound
    mov eax, yellow + (green * 16)
    call SetTextColor
    mov dh, 8
    mov dl, 40
    call Gotoxy
    mov edx, OFFSET strWin
    call WriteString
    mov dh, 10
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET strWin2
    call WriteString
    mov eax, white + (green * 16)
    call SetTextColor
    mov dh, 13
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET strYour
    call WriteString
    movzx eax, timer
    shl eax, 2
    add score, eax
    mov eax, score
    call WriteDec
    
    ; Check if made top 3
    mov eax, score
    cmp eax, topScores[8]
    jle NotNewHighW
    
    mov eax, yellow + (green * 16)
    call SetTextColor
    mov dh, 16
    mov dl, 46
    call Gotoxy
    mov edx, OFFSET strNew
    call WriteString
    
NotNewHighW:
    call SaveScore
    ; Reset progress
    mov savedLevel, 1
    mov savedLives, 3
    mov savedScore, 0
    call SaveProgress
    mov eax, 4000
    call Delay
    mov gameState, 0
    ret
WinScreen ENDP

LoadScore PROC
    pushad
    
    ; Initialize topScores and topNames with zeros first
    ; This ensures clean data if file doesn't exist
    push edi
    push ecx
    push eax
    
    ; Clear scores
    mov edi, OFFSET topScores
    mov ecx, 3
    xor eax, eax
ClearScores:
    mov DWORD PTR [edi], eax
    add edi, 4
    loop ClearScores
    
    ; Clear names
    mov edi, OFFSET topNames
    mov ecx, 48
    xor al, al
    rep stosb
    
    pop eax
    pop ecx
    pop edi
    
    ; Now try to load from file
    mov edx, OFFSET fileScore
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je NoLoad
    
    mov fileHandle, eax
    
    ; Read 3 scores (12 bytes)
    mov edx, OFFSET topScores
    mov ecx, 12
    call ReadFromFile
    
    ; Read 3 names (48 bytes)
    mov edx, OFFSET topNames
    mov ecx, 48
    call ReadFromFile
    
    mov eax, fileHandle
    call CloseFile
    
    ; Set highScore to top score for compatibility
    mov eax, topScores[0]
    mov highScore, eax
    
NoLoad:
    popad
    ret
LoadScore ENDP
SaveScore PROC
    pushad
    ; First check if current score qualifies for top 3
    call UpdateTopScores
    
    mov edx, OFFSET fileScore
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je NoSave
    mov fileHandle, eax
    ; Write 3 scores (12 bytes)
    mov edx, OFFSET topScores
    mov ecx, 12
    call WriteToFile
    ; Write 3 names (48 bytes)
    mov edx, OFFSET topNames
    mov ecx, 48
    call WriteToFile
    mov eax, fileHandle
    call CloseFile
NoSave:
    popad
    ret
SaveScore ENDP

UpdateTopScores PROC
    pushad
    mov eax, score
    
    ; Check if beats 1st place
    cmp eax, topScores[0]
    jle Check2nd
    
    ; New 1st place! Shift others down
    ; First shift 2nd place score and name to 3rd
    mov ebx, topScores[4]
    mov topScores[8], ebx
    
    ; Copy name from slot 1 to slot 2 (2nd to 3rd)
    mov ecx, 0
CopyName1to2:
    cmp ecx, 16
    jge DoneCopy1to2
    mov bl, BYTE PTR [topNames + ecx + 16]
    mov BYTE PTR [topNames + ecx + 32], bl
    inc ecx
    jmp CopyName1to2
DoneCopy1to2:
    ; Ensure null termination
    mov BYTE PTR [topNames + 32 + 15], 0
    
    ; Now shift 1st place score and name to 2nd
    mov ebx, topScores[0]
    mov topScores[4], ebx
    
    ; Copy name from slot 0 to slot 1 (1st to 2nd)
    mov ecx, 0
CopyName0to1:
    cmp ecx, 16
    jge DoneCopy0to1
    mov bl, BYTE PTR [topNames + ecx]
    mov BYTE PTR [topNames + ecx + 16], bl
    inc ecx
    jmp CopyName0to1
DoneCopy0to1:
    ; Ensure null termination
    mov BYTE PTR [topNames + 16 + 15], 0
    
    ; Set new 1st place
    mov topScores[0], eax
    mov highScore, eax
    
    ; Copy player name to slot 0
    mov esi, OFFSET playerName
    mov edi, OFFSET topNames
    mov ecx, 16
    rep movsb
    ; Ensure null termination
    mov BYTE PTR [topNames + 15], 0
    jmp UpdateDone
    
Check2nd:
    cmp eax, topScores[4]
    jle Check3rd
    
    ; New 2nd place! Shift 2nd to 3rd first
    mov ebx, topScores[4]
    mov topScores[8], ebx
    
    ; Copy name from slot 1 to slot 2
    mov ecx, 0
CopyName1to2B:
    cmp ecx, 16
    jge DoneCopy1to2B
    mov bl, BYTE PTR [topNames + ecx + 16]
    mov BYTE PTR [topNames + ecx + 32], bl
    inc ecx
    jmp CopyName1to2B
DoneCopy1to2B:
    ; Ensure null termination
    mov BYTE PTR [topNames + 32 + 15], 0
    
    ; Set new 2nd
    mov topScores[4], eax
    
    ; Copy player name to slot 1
    mov esi, OFFSET playerName
    mov edi, OFFSET topNames
    add edi, 16
    mov ecx, 16
    rep movsb
    ; Ensure null termination
    mov BYTE PTR [topNames + 16 + 15], 0
    jmp UpdateDone
    
Check3rd:
    cmp eax, topScores[8]
    jle UpdateDone
    
    ; New 3rd place!
    mov topScores[8], eax
    
    ; Copy player name to slot 2
    mov esi, OFFSET playerName
    mov edi, OFFSET topNames
    add edi, 32
    mov ecx, 16
    rep movsb
    ; Ensure null termination
    mov BYTE PTR [topNames + 32 + 15], 0
    
UpdateDone:
    popad
    ret
UpdateTopScores ENDP

LoadProgress PROC
    pushad
    mov edx, OFFSET fileProgress
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je NoProgLoad
    mov fileHandle, eax
    mov edx, OFFSET savedLevel
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedLives
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedScore
    mov ecx, 4
    call ReadFromFile
    mov edx, OFFSET savedMarioX
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedMarioY
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedPower
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedCoins
    mov ecx, 1
    call ReadFromFile
    mov edx, OFFSET savedTimer
    mov ecx, 2
    call ReadFromFile
    mov eax, fileHandle
    call CloseFile
NoProgLoad:
    popad
    ret
LoadProgress ENDP

SaveProgress PROC
    pushad
    ; Update saved data with current game state
    mov al, currentLevel
    mov savedLevel, al
    mov al, marioLives
    mov savedLives, al
    mov eax, score
    mov savedScore, eax
    mov al, marioX
    mov savedMarioX, al
    mov al, marioY
    mov savedMarioY, al
    mov al, marioPower
    mov savedPower, al
    mov al, coins
    mov savedCoins, al
    mov ax, timer
    mov savedTimer, ax
    
    mov edx, OFFSET fileProgress
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je NoProgSave
    mov fileHandle, eax
    mov edx, OFFSET savedLevel
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedLives
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedScore
    mov ecx, 4
    call WriteToFile
    mov edx, OFFSET savedMarioX
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedMarioY
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedPower
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedCoins
    mov ecx, 1
    call WriteToFile
    mov edx, OFFSET savedTimer
    mov ecx, 2
    call WriteToFile
    mov eax, fileHandle
    call CloseFile
NoProgSave:
    popad
    ret
SaveProgress ENDP

END main