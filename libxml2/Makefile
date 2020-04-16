include ../Makefile.config

SRC_PATH=$(shell realpath ./libxml2-2.9.8)

INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES) -g
LDFLAGS=-lm -lz

$(SRC_PATH): $(SRC_PATH).tar.gz
	tar -xf $^

BUILD=build
BUILD_GCOV=build_gcov
CONF_FLAGS=--without-iconv --without-lzma --without-pthread --with-threads=no

TARGET=test_driver
BC_TARGET=test_driver.bc
TARGET_GCOV=test_driver_gcov

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

%.gcov.o: %.c $(SRC_PATH)
	$(CC) -c $(CFLAGS) $(COVERAGE_CFLAGS) $< -o $@

$(BUILD): $(SRC_PATH)
	mkdir -p $(BUILD)
	cd $(BUILD); $(SRC_PATH)/configure $(CONF_FLAGS) CC=$(WLLVM) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"; cd -

$(BUILD_GCOV): $(SRC_PATH)
	mkdir -p $(BUILD_GCOV)
	cd $(BUILD_GCOV); $(SRC_PATH)/configure $(CONF_FLAGS) CC=gcc CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)"; cd -

$(BUILD)/.libs/libxml2.a: $(BUILD)
	make -C $(BUILD) -j4

$(BUILD_GCOV)/.libs/libxml2.a: $(BUILD_GCOV)
	make -C $(BUILD_GCOV) -j4

$(TARGET): main.o $(BUILD)/.libs/libxml2.a
	$(WLLVM) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

$(TARGET_GCOV): main.gcov.o $(BUILD_GCOV)/.libs/libxml2.a
	$(CC) $(CFLAGS) $(COVERAGE_CFLAGS) $^ $(COVERAGE_LDFLAGS) $(LDFLAGS) -o $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) $(TARGET_GCOV) *.o *.bc *.ll *.gcno *.gcda $(BUILD) $(BUILD_GCOV)
