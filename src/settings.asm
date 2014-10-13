config_initialPath:
    .dw initialPath
config_browseRoot:
    .db 0
config_editSymLinks:
    .db 0
config_showHidden:
    .db 0
config_showSize:
    .db 0

config_initialPath_s:
    .db "startdir", 0
config_browseRoot_s:
    .db "browseroot", 0
config_editSymLinks_s:
    .db "editsymlinks", 0
config_showHidden_s:
    .db "showhidden", 0
config_showSize_s:
    .db "showsize", 0

configPath:
    .db "/etc/fileman.conf", 0

loadConfiguration:
    ; Set defaults
    kld(hl, initialPath)
    kld((config_initialPath), hl)
    ; Load actual
    kld(de, configPath)
    config(openConfigRead)
    ret nz

    kld(hl, config_browseRoot_s)
    config(readOption_bool)
    jr nz, _
    kld((config_browseRoot), a)

_:  kld(hl, config_editSymLinks_s)
    config(readOption_bool)
    jr nz, _
    kld((config_editSymLinks), a)
    
_:  kld(hl, config_showHidden_s)
    config(readOption_bool)
    jr nz, _
    kld((config_showHidden), a)
    
_:  kld(hl, config_showSize_s)
    config(readOption_bool)
    jr nz, _
    kld((config_showSize), a)

    kld(hl, config_initialPath)
_:  kld(hl, config_initialPath_s)
    config(readOption)
    jr nz, _
    kld((config_initialPath), hl)

_:  config(closeConfig)
    ret
