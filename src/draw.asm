window:
    pcall(clearBuffer)
    kld(hl, (currentPath))
    ld a, 0b00000100
    corelib(drawWindow)
    ret

drawList:
    kcall(window)
    xor a
    cp b
    jr nz, _
    cp c
    jr nz, _
    ; There are no files or folders here
    ld de, 0x020E
    kld(hl, nothingHereText)
    pcall(drawStr)
    kjp(.done)

_:  ld de, 0x080E
    kld(a, (scrollTop))
    ld h, a
    push bc
        kld(ix, (directoryList))
        xor a
_:      cp h
        jr z, _
        dec h
        inc ix \ inc ix
        dec b
        jr nz, -_
_:      ld a, b
        or a
        jr z, .drawFiles
        xor a
        push hl \ kcall(.draw) \ pop hl
.drawFiles:
    pop bc \ push bc
        kld(ix, (fileList))
        xor a
_:      cp h
        jr z, _
        dec h
        inc ix \ inc ix
        dec c
        jr nz, -_
_:      ld a, c
        ld b, a
        or a
        jr z, ._done
        ld a, 1
        kcall(.draw)
._done:
    pop bc
    jr .done

.draw:
    push af
        ld a, e
        cp 0x38 ; Stop drawing at Y=0x38
        jr nz, ++_
        ld a, b
        or a
        jr z, _
        kld(hl, downCaretIcon)
        ld b, 3
        push de
            ld de, 0x5934
            pcall(putSpriteOR)
        pop de
_:  pop af
    ret
_:  pop af
    ld l, (ix)
    ld h, (ix + 1)
    inc hl
    inc hl
    ld c, 16
    kcall(drawStrTrunc)
    push bc
        or a
        jr z, _
        kld(a, (config_showSize))
        or a
        jr z, _
        ; File size
        pcall(strlen)
        or a
        push hl
            adc hl, bc
            inc hl
            push af
                push de
                    ld e, (hl)
                    inc hl
                    ld d, (hl)
                    inc hl
                    ld a, (hl)
                    ex de, hl
                pop de
                cp 0xFF ; TODO: Check all of AHL
                kcall(nz, drawFileSize)
            pop af
        pop hl
_:      ld b, 6
        push de
            dec hl \ dec hl
            ld e, (hl)
            inc hl
            ld d, (hl)
            ex de, hl
        pop de
        ld d, 2
        pcall(putSpriteOR)
        ld d, 8
        ld b, 8
        pcall(newline)
    pop bc
    inc ix \ inc ix
    djnz .draw
    ret
.done:
    ret

drawChrome:
    kld(a, (scrollTop))
    or a
    jr z, _
    kld(hl, upCaretIcon)
    ld de, 0x590E
    ld b, 3
    pcall(putSpriteOR)

_:  ld e, 8 ; x
    kld(a, (scrollOffset))
    kld(hl, scrollTop)
    sub (hl)
    ld l, a
    add a, a
    add a, a
    add a, l
    add a, l
    add a, 14
    ld l, a ; y
    ld c, 87 ; w
    ld b, 6 ; h
    pcall(rectXOR)
    ret

; AHL: File size
; E: Y pos
drawFileSize:
    ; TODO: Files >65535 bytes
    ld d, 96 - 11
    push bc
        ld b, 0
_:      ld c, 10
        pcall(divHLbyC)
        add a, '0'
        pcall(drawChar)
        ld a, -8
        add a, d
        ld d, a
        ld c, 0
        pcall(cpHLBC)
        jr nz, -_
    pop bc
    ret

; Same arguments as drawStr
; C: Maximum length
drawStrTrunc:
    push af
    push hl
        push bc
            pcall(strlen)
            ld a, c
        pop bc
        cp c
        jr c, _
        push bc \ push hl \ push de
            ld b, e ; save e (faster than push/pop)
            ld h, 4 ; char width
            ld e, c ; length of string
            inc e
            pcall(mul8By8)
            ld e, b ; restore e
            ld d, l ; low byte of hl
            ld b, 5
            kld(hl, trunc_sprite)
            pcall(putSpriteOR)
        pop de \ pop hl \ pop bc
        dec c

_:      ld a, c
        or a
        jr z, _
        dec c
        ld a, (hl)
        or a
        jr z, _
        pcall(drawChar)
        inc hl
        jr -_
_:  pop hl
    pop af
    ret

trunc_sprite:
    .db 0b00000000
    .db 0b00100000
    .db 0b11100000
    .db 0b00100000
    .db 0b00000000
