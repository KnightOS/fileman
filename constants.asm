corelibPath:
    .db "/lib/core", 0
configlibPath:
    .db "/lib/config", 0
upText:
    .db "..\n", 0
dotdot:
    .dw 0
    .db "..", 0
initialPath:
    .db "/home/", 0
directoryIcon:
    .db 0b11100000
    .db 0b10011000
    .db 0b11101000
    .db 0b10001000
    .db 0b11111000
    .db 0
fileIcon:
    .db 0b01111000
    .db 0b10001000
    .db 0b10001000
    .db 0b10001000
    .db 0b11111000
    .db 0
symlinkIcon:
    .db 0b00100000
    .db 0b00110000
    .db 0b01111000
    .db 0b10110000
    .db 0b00100000
    .db 0
downCaretIcon:
    .db 0b11111000
    .db 0b01110000
    .db 0b00100000
upCaretIcon:
    .db 0b00100000
    .db 0b01110000
    .db 0b11111000
nothingHereText:
    .db "Nothing here!", 0
deletionMessage:
    .db "Are you sure\nyou want to\ndelete this?", 0
deletionOptions:
    .db 2
    .db "Cancel", 0
    .db "Delete", 0
openFailMessage:
    .db "Sorry, this\nfile could not\nbe opened.", 0
openFailOptions:
    .db 1
    .db "Dismiss", 0
startNotFound:
    .db "Start-up\ndirectory not\nfound.", 0
