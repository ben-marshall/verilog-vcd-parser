
LEX_SRC         ?= VCDScanner.l
LEX_OUT         ?= VCDScanner.cpp
LEX_HEADER      ?= VCDScanner.hpp
LEX_OBJ         ?= VCDScanner.o

YAC_SRC         ?= VCDParser.ypp
YAC_OUT         ?= VCDParser.cpp
YAC_HEADER      ?= VCDParser.hpp
YAC_OBJ         ?= VCDParser.o


TEST_FILE       ?= VCDFileParser.cpp
TEST_APP        ?= vcd-parse

all : $(YAC_OUT) $(LEX_OUT) $(TEST_APP)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex  -P VCDParser --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

$(TEST_APP) : $(TEST_FILE) $(LEX_OBJ) $(YAC_OBJ)
	$(CXX) $(CXX_FLAGS) -o $@ $^ -DVCD_PARSER_STANDALONE

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh VCDParser.output
