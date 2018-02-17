
LEX_SRC         ?= COVScanner.l
LEX_OUT         ?= COVScanner.cpp
LEX_HEADER      ?= COVScanner.hpp
LEX_OBJ         ?= COVScanner.o

YAC_SRC         ?= COVParser.ypp
YAC_OUT         ?= COVParser.cpp
YAC_HEADER      ?= COVParser.hpp
YAC_OBJ         ?= COVParser.o

all : $(YAC_OUT) $(LEX_OUT)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh COVParser.output
