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

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
BUILD=$(CURDIR)/build
BUILD_GCOV=$(CURDIR)/build_gcov

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD): $(SRC_PATH)
	mkdir -p ${BUILD}
	cd ${BUILD}; $(SRC_PATH)/configure CC=$(WLLVM) CFLAGS="-g"

$(BUILD_GCOV): $(SRC_PATH)
	rm -rf $(BUILD_GCOV) && mkdir $(BUILD_GCOV)
	cd $(BUILD_GCOV) ; CC=gcc CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" $(SRC_PATH)/configure $(CONF_FLAGS); cd -

all: $(BUILD) $(BUILD_GCOV)
	make -C $(BUILD) -j4
	$(EXTRACT_BC) $(BUILD)/gas/as-new
	$(OPT) -mem2reg $(BUILD)/gas/as-new.bc -o $(BUILD)/gas/as-new.bc
	make -C $(BUILD_GCOV) -j4

clean:
	rm -rf *.o *.bc *.ll *.gcno *.gcda $(BUILD)
