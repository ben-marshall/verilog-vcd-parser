/*!
@file
@brief Contains the lexical definition for the parser.
*/

%{

#include <climits>
#include <cstdlib>
#include <string>
#include <cstring>

#include "VCDFileParser.hpp"
#include "VCDParser.hpp"

static VCDParser::location loc;
    
%}

%option noyywrap nounput interactive noinput nodefault yylineno

KW_END              $end 
KW_COMMENT          $comment
KW_DATE             $date
KW_ENDDEFINITIONS   $enddefinitions
KW_SCOPE            $scope
KW_TIMESCALE        $timescale
KW_UPSCOPE          $upscope
KW_VAR              $var
KW_VERSION          $version
KW_DUMPALL          $dumpall
KW_DUMPOFF          $dumpoff
KW_DUMPON           $dumpon
KW_DUMPVARS         $dumpvars
KW_BEGIN            begin
KW_FORK             fork
KW_FUNCTION         function
KW_MODULE           module
KW_TASK             task
TIME_NUMBER         1|10|100
TIME_UNIT           s|ms|us|ns|ps|fs
VAR_TYPE_EVENT      event
VAR_TYPE_INTEGER    integer
VAR_TYPE_PARAMETER  parameter
VAR_TYPE_REAL       real
VAR_TYPE_REALTIME   realtime
VAR_TYPE_REG        reg
VAR_TYPE_SUPPLY0    supply0
VAR_TYPE_SUPPLY1    supply1
VAR_TYPE_TIME       time
VAR_TYPE_TRI        tri
VAR_TYPE_TRIAND     triand
VAR_TYPE_TRIOR      trior
VAR_TYPE_TRIREG     trireg
VAR_TYPE_TRI0       tri0
VAR_TYPE_TRI1       tri1
VAR_TYPE_WAND       wand
VAR_TYPE_WIRE       wire
VAR_TYPE_WOR        wor
SCALAR_NUM          0|1|x|X|z|Z       
BIN_NUM             (b|B){SCALAR_NUM}+
FIXED_POINT_NUMBER  {DECIMAL_NUM}\.{DECIMAL_NUM}
FLOAT_POINT_NUMBER  {DECIMAL_NUM}(\.{DECIMAL_NUM})?(e|E)(\+|-)?{DECIMAL_NUM}
REAL_NUM            (r|R)({FLOAT_POINT_NUMBER}|{FIXED_POINT_NUMBER})
GRAPHICAL_ASCII_CHAR [a-zA-Z0-9!"#$%&'()*+,-./:;<=>?@\[\\\]^_`{|}~]
IDENTIFIER_CODE     {GRAPHICAL_ASCII_CHAR}+
DECIMAL_NUM         [0-9]+
SIMULATION_TIME     #{DECIMAL_NUM}
REFERENCE           {IDENTIFIER_CODE}(\x20\[{DECIMAL_NUM}(:{DECIMAL_NUM})?\])?
WHITE_SPACE         (\x20|\t|\r|\n)

TEXT1               [^$]*
TEXT2               $[^(end)]

%x IN_TEXT
%x IN_TIMESCALE_NUMBER
%x IN_TIMESCALE_UNIT
%x IN_SCOPE_TYPE
%x IN_SCOPE_IDENTIFIER
%x IN_VAR_TYPE
%x IN_VAR_SIZE
%x IN_VAR_PID
%x IN_VAR_IDENTIFIER
%x IN_VAL_IDCODE
%x IN_END

%{
#define YY_USER_ACTION loc.end.line = yyget_lineno();
%}

%%

%{
    loc.step();
%}

<IN_VAL_IDCODE,IN_VAR_PID,IN_END>{KW_END} {
    BEGIN(INITIAL);
    //std::cout << yytext << std::endl;
    return VCDParser::parser::make_TOK_KW_END(loc);
}

{KW_END} {
    //std::cout << yytext << std::endl;
    return VCDParser::parser::make_TOK_KW_END(loc);
}

{KW_COMMENT} {
    BEGIN(IN_TEXT);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_COMMENT(loc);
}

{KW_DATE} {
    BEGIN(IN_TEXT);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_DATE(loc);
}

{KW_VERSION} {
    BEGIN(IN_TEXT);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_VERSION(loc);
}

<IN_TEXT>{TEXT1} {
    yymore();
}

<IN_TEXT>{TEXT2} {
    yymore();
}

<IN_TEXT>{KW_END} {
    BEGIN(IN_END);
    //std::cout << yytext << ", ";
    unsigned len = strlen(yytext) - 4;
    yyless(len);
    return VCDParser::parser::make_TOK_TEXT(std::string(yytext, len),loc);
}

{KW_TIMESCALE} {
    BEGIN(IN_TIMESCALE_NUMBER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_TIMESCALE(loc);
}

<IN_TIMESCALE_NUMBER>{TIME_NUMBER} {
    BEGIN(IN_TIMESCALE_UNIT);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_TIME_NUMBER(std::atoi(yytext),loc);
}

<IN_TIMESCALE_UNIT>{TIME_UNIT} {
    BEGIN(IN_END);
    //std::cout << yytext << ", ";
    VCDTimeUnit tr = TIME_S;

    if(std::strcmp(yytext, "s")) {
        tr = TIME_S;
    } else if(std::strcmp(yytext, "ms")) {
        tr = TIME_MS;
    } else if(std::strcmp(yytext, "us")) {
        tr = TIME_US;
    } else if(std::strcmp(yytext, "ns")) {
        tr = TIME_NS;
    } else if(std::strcmp(yytext, "ps")) {
        tr = TIME_PS;
    }

    return VCDParser::parser::make_TOK_TIME_UNIT(tr,loc);
}


{KW_SCOPE} {
    BEGIN(IN_SCOPE_TYPE);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE(loc);
}

<IN_SCOPE_TYPE>{KW_BEGIN} {
    BEGIN(IN_SCOPE_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE_TYPE(VCD_SCOPE_BEGIN,loc);
}

<IN_SCOPE_TYPE>{KW_FORK} {
    BEGIN(IN_SCOPE_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE_TYPE(VCD_SCOPE_FORK,loc);
}

<IN_SCOPE_TYPE>{KW_FUNCTION} {
    BEGIN(IN_SCOPE_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE_TYPE(VCD_SCOPE_FUNCTION, loc);
}

<IN_SCOPE_TYPE>{KW_MODULE} {
    BEGIN(IN_SCOPE_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE_TYPE(VCD_SCOPE_MODULE, loc);
}

<IN_SCOPE_TYPE>{KW_TASK} {
    BEGIN(IN_SCOPE_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE_TYPE(VCD_SCOPE_TASK, loc);
}

<IN_SCOPE_IDENTIFIER>{IDENTIFIER_CODE} {
    BEGIN(IN_END);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_IDENTIFIER(std::string(yytext),loc);
}

{KW_UPSCOPE} {
    BEGIN(IN_END);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_UPSCOPE(loc);
}

{KW_ENDDEFINITIONS} {
    BEGIN(IN_END);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_ENDDEFINITIONS(loc);
}

{KW_VAR} {
    BEGIN(IN_VAR_TYPE);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_VAR(loc);
}

<IN_VAR_TYPE>{VAR_TYPE_EVENT} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_EVENT    ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_INTEGER} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_INTEGER  ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_PARAMETER} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_PARAMETER,loc);}
<IN_VAR_TYPE>{VAR_TYPE_REAL} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_REAL     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_REALTIME} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_REALTIME ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_REG} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_REG      ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_SUPPLY0} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_SUPPLY0  ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_SUPPLY1} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_SUPPLY1  ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TIME} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TIME     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRI} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRI      ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRIAND} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRIAND   ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRIOR} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRIOR    ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRIREG} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRIREG   ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRI0} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRI0     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_TRI1} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_TRI1     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_WAND} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_WAND     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_WIRE} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_WIRE     ,loc);}
<IN_VAR_TYPE>{VAR_TYPE_WOR} { BEGIN(IN_VAR_SIZE); return VCDParser::parser::make_TOK_VAR_TYPE(VCD_VAR_WOR      ,loc);}

<IN_VAR_SIZE>{DECIMAL_NUM} {
    BEGIN(IN_VAR_IDENTIFIER);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_DECIMAL_NUM(std::atoi(yytext),loc);
}

<IN_VAR_IDENTIFIER>{IDENTIFIER_CODE} {
    BEGIN(IN_VAR_PID);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_IDENTIFIER(std::string(yytext),loc);
}

<IN_VAR_PID>{REFERENCE} {
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_REFERENCE(std::string(yytext),loc);
}

{SIMULATION_TIME} {
    //std::cout << yytext << std::endl;
    return VCDParser::parser::make_TOK_SIMULATION_TIME(std::atoi(yytext+1),loc);
}

{KW_DUMPALL} {
    BEGIN(INITIAL);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_DUMPALL(loc);
}

{KW_DUMPOFF} {
    BEGIN(INITIAL);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_DUMPOFF(loc);
}

{KW_DUMPON} {
    BEGIN(INITIAL);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_DUMPON(loc);
}

{KW_DUMPVARS} {
    BEGIN(INITIAL);
    //std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_DUMPVARS(loc);
}

{SCALAR_NUM} {
    //std::cout << yytext << ", ";
    BEGIN(IN_VAL_IDCODE);

    VCDBit val;

    switch(yytext[0]) {
        case '0':
            val = VCD_0;
            break;
        case '1':
            val = VCD_1;
            break;
        case 'x':
        case 'X':
            val = VCD_X;
            break;
        case 'z':
        case 'Z':
            val = VCD_Z;
            break;
        default:
            val = VCD_X;
            break;
    }

    return VCDParser::parser::make_TOK_VALUE(val, loc);
}

{BIN_NUM} {
    //std::cout << yytext << ", ";
    BEGIN(IN_VAL_IDCODE);
    return VCDParser::parser::make_TOK_BIN_NUM(std::string(yytext), loc);
}

{REAL_NUM} {
    //std::cout << yytext << ", ";
    BEGIN(IN_VAL_IDCODE);
    // Legal way of parsing dumped floats according to the spec.
    // Sec 21.7.2.1, paragraph 4.
    float tmp;
    std::sscanf(yytext+1, "%g", &tmp);
    return VCDParser::parser::make_TOK_REAL_NUM(tmp, loc);
}

<IN_VAL_IDCODE>{IDENTIFIER_CODE} {
    //std::cout << yytext << std::endl;
    BEGIN(INITIAL);
    return VCDParser::parser::make_TOK_IDENTIFIER(std::string(yytext),loc);
}

<*>{WHITE_SPACE} {}

<*>[^{WHITE_SPACE}] {
    //std::cout << yytext << std::endl;
    return VCDParser::parser::make_TOK_UNUDENTIFIED_SYMBOL(loc);
}

<<EOF>> {
    return VCDParser::parser::make_END(loc);
}

%%

void VCDFileParser::scan_begin() {
    yy_flex_debug = trace_scanning;
    yyin = file;
}

void VCDFileParser::scan_end() {
    yyin = NULL;
}
