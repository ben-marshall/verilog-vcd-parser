
BUILD_DIR       ?= ../../build

LEX_SRC         ?= VCDScanner.l
LEX_OUT         ?= $(BUILD_DIR)/VCDScanner.cpp
LEX_HEADER      ?= $(BUILD_DIR)/VCDScanner.hpp
LEX_OBJ         ?= $(BUILD_DIR)/VCDScanner.o

YAC_SRC         ?= VCDParser.ypp
YAC_OUT         ?= $(BUILD_DIR)/VCDParser.cpp
YAC_HEADER      ?= $(BUILD_DIR)/VCDParser.hpp
YAC_OBJ         ?= $(BUILD_DIR)/VCDParser.o

VCD_SRC         ?= VCDFile.cpp

CXXFLAGS        += -I$(BUILD_DIR) -I./

TEST_FILE       ?= VCDFileParser.cpp
TEST_APP        ?= $(BUILD_DIR)/vcd-parse

all : $(YAC_OUT) $(LEX_OUT) $(TEST_APP)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex  -P VCDParser --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

$(TEST_APP) : $(TEST_FILE) $(VCD_SRC) $(LEX_OBJ) $(YAC_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ -DVCD_PARSER_STANDALONE

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh VCDParser.output $(TEST_APP)
