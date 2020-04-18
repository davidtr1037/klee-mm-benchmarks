include ../Makefile.config
SRC_PATH=$(shell realpath ./binutils-2.31.1)

INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include
DEFINES=

COVERAGE_CFLAGS=-fprofile-arcs -ftest-coverage
COVERAGE_LDFLAGS=-lgcov --coverage

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
	$(EXTRACT_BC) $(BUILD_DIR)/gas/as-new
	$(OPT) -mem2reg $(BUILD_DIR)/gas/as-new.bc -o $(BUILD_DIR)/gas/as-new.bc

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda $(BUILD_DIR)
