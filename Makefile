include .knightos/variables.make

ALL_TARGETS:=$(BIN)fileman $(ETC)fileman.conf $(APPS)fileman.app \
	$(ETC)settings/File\ Manager.conf $(SHARE)icons/fileman.img

$(BIN)fileman: src/*.asm
	mkdir -p $(BIN)
	$(AS) $(ASFLAGS) --listing $(OUT)main.list src/main.asm $(BIN)fileman

$(ETC)fileman.conf: config/fileman.conf
	mkdir -p $(ETC)
	cp config/fileman.conf $(ETC)

$(ETC)settings/File\ Manager.conf: config/File\ Manager.conf
	mkdir -p $(ETC)settings
	cp config/File\ Manager.conf $(ETC)settings

$(APPS)fileman.app: config/fileman.app
	mkdir -p $(APPS)
	cp config/fileman.app $(APPS)

$(SHARE)icons/fileman.img: config/fileman.png
	mkdir -p $(SHARE)icons
	kimg -c config/fileman.png $(SHARE)icons/fileman.img

include .knightos/sdk.make
