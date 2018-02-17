
LEX_SRC         ?= VCDScanner.l
LEX_OUT         ?= VCDScanner.cpp
LEX_HEADER      ?= VCDScanner.hpp
LEX_OBJ         ?= VCDScanner.o

YAC_SRC         ?= VCDParser.ypp
YAC_OUT         ?= VCDParser.cpp
YAC_HEADER      ?= VCDParser.hpp
YAC_OBJ         ?= VCDParser.o

all : $(YAC_OUT) $(LEX_OUT)

$(YAC_OUT) : $(YAC_SRC)
	bison -v --defines=$(YAC_HEADER) $(YAC_SRC) -o $(YAC_OUT)

$(LEX_OUT) : $(LEX_SRC) $(YAC_OUT)
	flex --header-file=$(LEX_HEADER) -o $(LEX_OUT) $(LEX_SRC)

clean:
	rm -rf $(LEX_OUT) $(LEX_HEADER) $(LEX_OBJ) \
           $(YAC_OUT) $(YAC_HEADER) $(YAC_OBJ) \
           position.hh stack.hh location.hh parser.output
