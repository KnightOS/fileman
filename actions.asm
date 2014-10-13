action_delete:
    ld a, d
    cp b
    jr c, .deleteDirectory
    push de
    push bc
        kld(hl, deletionMessage)
        kld(de, deletionOptions)
        xor a
        ld b, 0
        corelib(showMessage)
    pop bc
    pop de
    or a ; cp 0
    kjp(z, freeAndLoopBack)
    ; DELETE IT
    ; Load it onto currentPath for a moment
    ld a, d
    sub b
    add a, a
    kld(hl, (fileList))
    add l
    ld l, a
    jr nc, $+3
    inc h
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc de \ inc de
    kld(hl, (currentPath))
    xor a
    ld bc, 0
    cpir
    dec hl
    ex de, hl
    pcall(strlen)
    inc bc
    ldir
    kld(de, (currentPath))
    pcall(deleteFile)
    ret
.deleteDirectory:
    ; TODO: delete directories
    ret

action_open:
    sub b
    add a, a
    kld(hl, (fileList))
    add l
    ld l, a
    jr nc, $+3
    inc h
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc de \ inc de
    ; Copy DE into the current path, but not for long
    kld(hl, (currentPath))
    xor a
    ld bc, 0
    cpir
    dec hl
    di
    push hl
        ex de, hl
        pcall(strlen)
        inc bc
        ldir
        kld(de, (currentPath))
        corelib(open)
    pop hl
    push af
        xor a
        ld (hl), a
    pop af
    jr nz, .fail
    ; Set up the trampoline
    ; This is what takes users back to fileman when the program exits
    push hl
    push de
    push ix
        ld bc, trampoline_end - trampoline
        pcall(malloc)
        pcall(reassignMemory)
        kld(hl, trampoline)
        push ix \ pop de
        ldir
        push ix \ pop hl
        pcall(setReturnPoint)
        pcall(getCurrentThreadId)
        ld (ix + 1), a
    pop ix
    pop de
    pop hl
    ei
    pcall(suspendCurrentThread)
    kjp(freeAndLoopBack)
.fail:
    ei
    ; It failed to open, complain to the user
    kld(hl, openFailMessage)
    kld(de, openFailOptions)
    xor a
    ld b, 0
    corelib(showMessage)
    kjp(freeAndLoopBack)

trampoline:
    ld a, 0 ; Thread ID will be loaded here
    pcall(checkThread)
    corelib(nz, launchCastle)
    ld (hwLockLCD), a
    ld (hwLockKeypad), a
    pcall(resumeThread)
    pcall(killCurrentThread)
trampoline_end:
