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

.redraw:
    pcall(clearBuffer)
    kld(hl, (currentPath))
    xor a
    corelib(drawWindow)

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
    kld(hl, .bytes)
    pcall(drawStr)
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
    ; Draw actions
    ld de, 0x0226
    ld b, 2
    kld(hl, .open_with)
    pcall(drawStr)

    ld b, 0
.draw_loop:
    kcall(.draw_select)
.idle_loop:
    pcall(fastCopy)
    pcall(flushKeys)
    pcall(waitKey)
    cp kLeft
    ret z
    cp kClear
    ret z
    cp kDown
    jr z, .handle_down
    cp kUp
    jr z, .handle_up
    cp kEnter
    jr z, .handle_enter
    cp k2nd
    jr z, .handle_enter
    jr .idle_loop
.handle_down:
    kcall(.draw_select)
    ld b, 1
    jr .draw_loop
.handle_up:
    kcall(.draw_select)
    ld b, 0
    jr .draw_loop
.handle_enter:
    ld a, b
    or a
    jr nz, .launch_picker
    ; Launch program
    kld(de, (.file_name))
    kjp(with_de@action_open)
.launch_picker:
    kld(hl, .not_implemented)
    kld(de, openFailOptions)
    xor a
    corelib(showMessage)
    kjp(.redraw)
.draw_select:
    push bc
        ld l, 0x26 + 6
        ld a, b
        add a, a \ ld b, a \ add a, a \ add a, b ; A *= 6
        add a, l
        ld l, a
        ld c, 94
        ld b, 6
        ld e, 1
        pcall(rectXOR)
    pop bc
    ret
.file_info:
    .dw 0
.file_name:
    .dw 0
.size:
    .db "Size: ", 0
.bytes:
    .db " bytes", 0
.open_with:
    .db "Open with:\n"
    .db " Default program\n"
    .db " Other...", 0
.temp:
    .db "/todo/implement/this", 0
.not_implemented:
    .db "Not implemented", 0
.linkSprite:
    .db 0b01000000
    .db 0b00100000
    .db 0b11110000
    .db 0b00100000
    .db 0b01000000
