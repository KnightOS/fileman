doListing:
    kld(a, (config_browseRoot))
    or a
    jr nz, _
    kld(hl, (currentPath))
    kld(de, (config_initialPath))
    pcall(strcmp)
    jr z, +++_

_:  kld(hl, (currentPath))
    inc hl
    ld a, (hl)
    dec hl
    or a ; cp 0 (basically, test if we're at the root
    jr z, ++_

_:  ; Add a .. entry if this is not the root
    kld(hl, directoryIcon)
    kld((dotdot), hl)
    kld(hl, (directoryList))
    kld(de, dotdot)
    ld (hl), e
    inc hl
    ld (hl), d
    inc hl
    kld((directoryList), hl)

_:  kld(hl, (currentPath))
    ex de, hl
    kld(hl, listCallback)
    exx
        ld bc, 0
    exx
    pcall(listDirectory)
    exx
    push bc
        exx
    pop bc
    ; B: Num directories
    ; C: Num files
    ; Add the imaginary .. entry to the list
    push de
        kld(ix, (directoryList))
        pcall(memSeekToStart)
        kld((directoryList), ix)
        ld l, (ix)
        ld h, (ix + 1)
        kld(de, dotdot)
        pcall(cpHLDE)
    pop de
    jr nz, _ 
    inc b
_:  push bc ; Sort results
        ld a, b
        or a
        jr z, ++_
        ld a, b
        ld b, 0
        ld c, a
        ; Check for root and move past the .. if not
        ld l, (ix)
        ld h, (ix + 1)
        kld(de, dotdot)
        pcall(cpHLDE)
        push ix \ pop hl
        jr nz, _
        ; We are not on the root, so skip the .. entry for sorting
        inc hl \ inc hl
        dec bc
_:      ld d, h \ ld e, l
        add hl, bc
        add hl, bc
        ex hl, de
        dec de \ dec de
        ld bc, 2
        kld(ix, sort_callback)
        pcall(callbackSort) ; Sort directory list
    pop bc \ push bc
        ld a, c
        or a
        jr z, _
        kld(ix, (fileList))
        pcall(memSeekToStart)
        kld((fileList), ix)
        push ix \ pop hl
        ld d, h \ ld e, l
        ld b, 0
        add hl, bc
        add hl, bc
        ex hl, de
        dec de \ dec de
        ld bc, 2
        kld(ix, sort_callback)
        pcall(callbackSort) ; Sort file list
_:  pop bc
    ld a, b
    kld((totalDirectories), a)
    ld a, c
    kld((totalFiles), a)
    ret

sort_callback:
    push de
    push hl
        pcall(indirect16HLDE)
        inc hl \ inc hl
        inc de \ inc de
        pcall(strcmp)
    pop hl
    pop de
    ret

listCallback:
    push hl
    exx
    pop hl
        push bc
            cp fsFile
            jr z, .handleFile
            cp fsSymLink
            kjp(z, .handleLink)
            cp fsDirectory
            kjp(nz, .handleUnknown)

.handleDirectory:
            ld hl, kernelGarbage
            kld(a, (config_showHidden))
            or a
            jr nz, _
            ld a, (hl)
            cp '.'
            kjp(z, .handleUnknown) ; Skip hidden directory
_:          pcall(strlen)
            inc bc \ inc bc \ inc bc ; Include delimiter and icon
            pcall(malloc) ; TODO: Handle out of memory (how?)
            kld(de, directoryIcon)
            ld (ix), e \ ld (ix + 1), d
            push ix \ pop de \ inc de \ inc de
            dec bc \ dec bc
            ldir

            kld(hl, (directoryList))
            push ix \ pop de
            ld (hl), e
            inc hl
            ld (hl), d
            inc hl
            kld((directoryList), hl)
            pop bc
        inc b
    exx
    ret
.handleFile:
            push hl
                ld hl, kernelGarbage
                kld(a, (config_showHidden))
                or a
                jr nz, _
                ld a, (hl)
                cp '.'
                jr nz, _
            pop hl
            kjp(.handleUnknown) ; Skip hidden file
_:              pcall(strlen)
                ld a, 6
                add c \ ld c, a \ jr nc, $+3 \ inc b ; Add delimter, file size, icon
                pcall(malloc) ; TODO: Handle out of memory (how?)
                kld(de, fileIcon)
                ld (ix), e \ ld (ix + 1), d
                push ix \ pop de \ inc de \ inc de
                dec bc \ dec bc \ dec bc \ dec bc \ dec bc
                ldir
            pop hl
            ; File size
            ld bc, -6
            or a
            adc hl, bc
            ld a, (hl)
            ld (de), a
            dec hl \ inc de
            ld a, (hl)
            ld (de), a
            dec hl \ inc de
            ld a, (hl)
            ld (de), a

            kld(hl, (fileList))
            push ix \ pop de
            ld (hl), e
            inc hl
            ld (hl), d
            inc hl
            kld((fileList), hl)
        pop bc
        inc c
    exx
    ret
.handleLink:
_:          push hl
                ld hl, kernelGarbage
                ld hl, kernelGarbage
                kld(a, (config_showHidden))
                or a
                jr nz, _
                ld a, (hl)
                cp '.'
                jr nz, _
            pop hl
            kjp(.handleUnknown) ; Skip hidden file
_:              pcall(strlen)
                ld a, 6
                add c \ ld c, a \ jr nc, $+3 \ inc b ; Add delimter, file size, icon
                pcall(malloc) ; TODO: Handle out of memory (how?)
                kld(de, symlinkIcon)
                ld (ix), e \ ld (ix + 1), d
                push ix \ pop de \ inc de \ inc de
                dec bc \ dec bc \ dec bc \ dec bc \ dec bc
                ldir
            pop hl
            ; File size
            ; Symlinks need to be sorted with files so there's some workarounds
            ; One of these is that the file size is set to 0xFFFFF
            ld a, 0xFF
            ld (de), a
            inc de
            ld (de), a
            inc de
            ld (de), a

            kld(hl, (fileList))
            push ix \ pop de
            ld (hl), e
            inc hl
            ld (hl), d
            inc hl
            kld((fileList), hl)
        pop bc
        inc c
    exx
    ret
.handleUnknown:
        pop bc
    exx
    ret
