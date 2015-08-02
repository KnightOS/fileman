details_loop:
    ld a, d
    cp b
    ret c ; TODO: Directories

    sub b
    add a, a
    kld(hl, (fileList))
    add l
    ld l, a
    jr nc, $+3 \ inc h
    kld((.file_info), hl)
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc de \ inc de
    ex de, hl
    kld((.file_name), hl)

    kcall(window)
    ld a, 1
    kld(hl, tabs)
    corelib(drawTabs)

    ; Draw file information:
    ld de, 0x020E
    ; file name
    kld(hl, (.file_name))
    pcall(drawStr)
    ld b, 5
    pcall(newline)

    ; Check for symlink
    dec hl \ ld b, (hl)
    dec hl \ ld c, (hl)
    push de
        kld(de, symlinkIcon)
        pcall(cpBCDE)
    pop de
    jr z, .symlink

    ; file size
    kld(hl, .size)
    pcall(drawStr)
    kld(hl, (.file_name))
    pcall(strlen)
    or a
    adc hl, bc
    inc hl
    push de
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        ex de, hl
    pop de
    pcall(drawDecHL)
    jr .continue
.symlink:
    kld(hl, .linkSprite)
    ld b, 5
    pcall(putSpriteOR)
    ld a, 5
    add a, d
    ld d, a
    kld(hl, .temp)
    pcall(drawStr)
.continue:

    pcall(fastCopy)
    pcall(flushKeys)
    pcall(waitKey)
    ret
.file_info:
    .dw 0
.file_name:
    .dw 0
.size:
    .db "Size: ", 0
.temp:
    .db "/todo/implement/this", 0
.linkSprite:
    .db 0b01000000
    .db 0b00100000
    .db 0b11110000
    .db 0b00100000
    .db 0b01000000
