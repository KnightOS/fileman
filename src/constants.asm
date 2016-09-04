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
    .db "Sorry, this file\ncould not be\nopened.", 0
openFailOptions:
    .db 1
    .db "Dismiss", 0
startNotFound:
    .db "Start-up directory\nnot found.", 0
menuOptions:
    .db 6
    .db "New...", 0
    .db "Copy", 0
    .db "Paste", 0
    .db "Delete", 0
    .db "Rename", 0
    .db "Exit", 0
newOptions:
    .db 2 ; Modified from config to omit "Link" unless option enabled
    .db "Directory", 0
    .db "Link", 0
renamePrompt:
    .db "Rename file to:", 0
createDirPrompt:
    .db "Name of new directory:", 0
createLinkTargetPrompt:
    .db "Path to link target:", 0
createLinkNamePrompt:
    .db "Name of new link:", 0
duplicateName:
    .db "-1", 0
