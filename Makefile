include .knightos/variables.make

ALL_TARGETS:=$(BIN)fileman $(ETC)fileman.conf $(APPS)fileman.app \
	$(SHARE)icons/fileman.img

$(BIN)fileman: src/*.asm
	mkdir -p $(BIN)
	$(AS) $(ASFLAGS) --listing $(OUT)main.list src/main.asm $(BIN)fileman

$(ETC)fileman.conf: config/fileman.conf
	mkdir -p $(ETC)
	cp config/fileman.conf $(ETC)

$(APPS)fileman.app: config/fileman.app
	mkdir -p $(APPS)
	cp config/fileman.app $(APPS)

$(SHARE)icons/fileman.img: config/fileman.png
	mkdir -p $(SHARE)icons
	kimg -c config/fileman.png $(SHARE)icons/fileman.img

include .knightos/sdk.make
