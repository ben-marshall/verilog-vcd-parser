
LEX_SRC         ?= COVScanner.l
LEX_OUT         ?= COVScanner.cpp
LEX_HEADER      ?= COVScanner.hpp
LEX_OBJ         ?= COVScanner.o

YAC_SRC         ?= COVParser.ypp
YAC_OUT         ?= COVParser.cpp
YAC_HEADER      ?= COVParser.hpp
YAC_OBJ         ?= COVParser.o


TEST_FILE       ?= COVFileParser.cpp
TEST_APP        ?= cov-parse

all : $(YAC_OUT) $(LEX_OUT) $(TEST_APP)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex -P COVParser --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

$(TEST_APP) : $(TEST_FILE) $(LEX_OBJ) $(YAC_OBJ)
	$(CXX) $(CXX_FLAGS) -o $@ $^ -DCOV_PARSER_STANDALONE

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh COVParser.output $(TEST_APP)
