
BUILD_DIR       ?= ../../build

LEX_SRC         ?= COVScanner.l
LEX_OUT         ?= $(BUILD_DIR)/COVScanner.cpp
LEX_HEADER      ?= $(BUILD_DIR)/COVScanner.hpp
LEX_OBJ         ?= $(BUILD_DIR)/COVScanner.o

YAC_SRC         ?= COVParser.ypp
YAC_OUT         ?= $(BUILD_DIR)/COVParser.cpp
YAC_HEADER      ?= $(BUILD_DIR)/COVParser.hpp
YAC_OBJ         ?= $(BUILD_DIR)/COVParser.o

CXXFLAGS        += -I$(BUILD_DIR) -I./

TEST_FILE       ?= COVFileParser.cpp
TEST_APP        ?= $(BUILD_DIR)/cov-parse

all : $(YAC_OUT) $(LEX_OUT) $(TEST_APP)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex -P COVParser --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

$(TEST_APP) : $(TEST_FILE) $(LEX_OBJ) $(YAC_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ -DCOV_PARSER_STANDALONE

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh COVParser.output $(TEST_APP)
