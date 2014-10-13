include .knightos/variables.make

ALL_TARGETS:=$(BIN)fileman $(ETC)fileman.conf $(APPS)fileman.app

$(BIN)fileman: main.asm
	mkdir -p $(BIN)
	$(AS) $(ASFLAGS) --listing $(OUT)main.list main.asm $(BIN)fileman

$(ETC)fileman.conf: config/fileman.conf
	mkdir -p $(ETC)
	cp config/fileman.conf $(ETC)

$(APPS)fileman.app: config/fileman.app
	mkdir -p $(APPS)
	cp config/fileman.app $(APPS)

include .knightos/sdk.make
