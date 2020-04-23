include ../Makefile.config
SRC_PATH=$(shell realpath ./coreutils-8.31/)

INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES)
LDFLAGS=

$(SRC_PATH): $(SRC_PATH).tar.xz
	tar -xf $^

BUILD_DIR=build

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR}; $(SRC_PATH)/configure CC=$(WLLVM) CFLAGS="-g"

all: $(BUILD_DIR)
	make -C ${BUILD_DIR} -j4

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda $(BUILD_DIR)
