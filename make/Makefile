include ../Makefile.config

SRC=$(shell realpath ./make-4.2)
BUILD=$(shell realpath ./build)
TARGET=$(BUILD)/make
BC_TARGET=$(BUILD)/make.bc

CFLAGS=-g

.PHONY: all

$(SRC): make.patch main.patch
	tar xzf make-4.2.tar.gz
ifndef NO_PATCH
	patch -p1 < make.patch
else
	patch -p1 < main.patch
endif

$(BUILD): $(SRC)
	mkdir $(BUILD)
	cd $(BUILD) ; CC=$(WLLVM) CFLAGS=$(CFLAGS) ../make-4.2/configure --disable-nls --disable-largefile --disable-job-server --disable-load; cd -

make: $(BUILD)
	make -C $(BUILD) -j4

$(BC_TARGET): make
	$(EXTRACT_BC) $(TARGET)

all: $(BC_TARGET)

clean:
	rm -rf $(SRC) $(BUILD)
