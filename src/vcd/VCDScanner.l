/*!
@file
@brief Contains the lexical definition for the parser.
*/

%{
    
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <string>

#include "VCDFileParser.hpp"
#include "VCDParser.hpp"

#undef yywrap
#define yywrap() 1

static VCDParser::location loc;
    
%}

%option noyywrap nounput batch debug noinput

%x EXPECT_ID
%x EXPECT_SIZE
%x EXPECT_ID_CODE
%x EXPECT_DECIMAL
%x EXPECT_DECIMAL_TIME
%x EXPECT_TIME_UNIT
%x EXPECT_TIME_NUMBER
%x EXPECT_REAL_NUM
%x IN_DUMP_VARS
%x IN_DUMP_CODE
%x EXPECT_VAR_TYPE
%x SCOPE_ID

BRACKET_O           \[
BRACKET_C           \]
COLON               :
DOLLAR              \$
KW_END              \$end 
KW_COMMENT          \$comment
KW_DATE             \$date
KW_ENDDEFINITIONS   \$enddefinitions
KW_SCOPE            \$scope
KW_TIMESCALE        \$timescale
KW_UPSCOPE          \$upscope
KW_VAR              \$var
KW_VERSION          \$version
KW_DUMPALL          \$dumpall
KW_DUMPOFF          \$dumpoff
KW_DUMPON           \$dumpon
KW_DUMPVARS         \$dumpvars
KW_BEGIN            begin
KW_FORK             fork
KW_FUNCTION         function
KW_MODULE           module
KW_TASK             task
TIME_NUMBER         1|10|100
TIME_UNIT           s|ms|us|ns|ps|fs
VAR_TYPE            event|integer|parameter|real|realtime|reg|supply0|supply1|time|tri|triand|trior|trireg|tri0|tri1|wand|wire|wor
HASH                #
VALUE               (0|1|x|X|z|Z)+
BIN_NUM             b|B
REAL_NUM            r|R
REAL_NUMBER         (0-9)+[\.(0.9)+]
IDENTIFIER          (.)+
IDENTIFIER_CODE     [a-zA-Z_0-9!/\.@':~#\*\(\)\+\{\}\$]+
SCOPE_IDENTIFIER    [a-zA-Z_][a-zA-Z_0-9]+
DECIMAL_NUM         [0-9]+

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
    loc.step();
%}

" " {}
"\t" {}
"\n" {}
"\r" {}

{BRACKET_O} {
    BEGIN(EXPECT_SIZE);
    return VCDParser::parser::make_TOK_BRACKET_O(loc);
    }

{BRACKET_C} {
    return VCDParser::parser::make_TOK_BRACKET_C(loc);
    }

{COLON} {
    BEGIN(EXPECT_SIZE);
    return VCDParser::parser::make_TOK_COLON(loc);
    }

{DOLLAR} {
    return VCDParser::parser::make_TOK_DOLLAR(loc);
    }

<*>{KW_END} {
    BEGIN(INITIAL);
    std::cout<<"END: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_END(loc);
    }

{KW_COMMENT} {
    BEGIN(EXPECT_ID);
    std::cout<<"COMMENT: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_COMMENT(loc);
    }

{KW_DATE} {
    BEGIN(EXPECT_ID);
    std::cout<<"DATE: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_DATE(loc);
    }

{KW_ENDDEFINITIONS} {
    return VCDParser::parser::make_TOK_KW_ENDDEFINITIONS(loc);
    }

{KW_SCOPE} {
    std::cout<<"SCOPE: " << yytext ;
    return VCDParser::parser::make_TOK_KW_SCOPE(loc);
    }

{KW_TIMESCALE} {
    BEGIN(EXPECT_TIME_NUMBER);
    return VCDParser::parser::make_TOK_KW_TIMESCALE(loc);
    }

{KW_UPSCOPE} {
    return VCDParser::parser::make_TOK_KW_UPSCOPE(loc);
    }

{KW_VAR} {
    BEGIN(EXPECT_VAR_TYPE);
    return VCDParser::parser::make_TOK_KW_VAR(loc);
    }

{KW_VERSION} {
    BEGIN(EXPECT_ID);
    return VCDParser::parser::make_TOK_KW_VERSION(loc);
    }

{KW_DUMPALL} {
    BEGIN(IN_DUMP_VARS);
    return VCDParser::parser::make_TOK_KW_DUMPALL(loc);
    }

{KW_DUMPOFF} {
    BEGIN(IN_DUMP_VARS);
    return VCDParser::parser::make_TOK_KW_DUMPOFF(loc);
    }

{KW_DUMPON} {
    BEGIN(IN_DUMP_VARS);
    return VCDParser::parser::make_TOK_KW_DUMPON(loc);
    }

{KW_DUMPVARS} {
    BEGIN(IN_DUMP_VARS);
    return VCDParser::parser::make_TOK_KW_DUMPVARS(loc);
    }

{KW_BEGIN} {
    BEGIN(SCOPE_ID);
    std::cout<<": " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_BEGIN(loc);
    }

{KW_FORK} {
    BEGIN(SCOPE_ID);
    std::cout<<": " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_FORK(loc);
    }

{KW_FUNCTION} {
    BEGIN(SCOPE_ID);
    std::cout<<": " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_FUNCTION(loc);
    }

{KW_MODULE} {
    BEGIN(SCOPE_ID);
    std::cout<<": " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_MODULE(loc);
    }

{KW_TASK} {
    BEGIN(SCOPE_ID);
    std::cout<<": " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_KW_TASK(loc);
    }

<EXPECT_TIME_NUMBER>{TIME_NUMBER} {
    BEGIN(EXPECT_TIME_UNIT);
    return VCDParser::parser::make_TOK_TIME_NUMBER(loc);
    }

<EXPECT_TIME_UNIT>{TIME_UNIT} {
    BEGIN(INITIAL);
    return VCDParser::parser::make_TOK_TIME_UNIT(loc);
    }

<EXPECT_VAR_TYPE>{VAR_TYPE} {
    BEGIN(EXPECT_DECIMAL);
    std::cout<<"VAR_TYPE: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_VAR_TYPE(loc);
    }

{HASH} {
    BEGIN(EXPECT_DECIMAL_TIME);
    return VCDParser::parser::make_TOK_HASH(loc);
    }

<IN_DUMP_VARS>{BIN_NUM} {
    std::cout<<"DUMP VECTOR BIN: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_BIN_NUM(loc);
    }
<IN_DUMP_VARS>{VALUE} {
    BEGIN(IN_DUMP_CODE);
    std::cout<<"DUMP VALUE: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_VALUE(loc);
    }
<IN_DUMP_CODE>{IDENTIFIER_CODE} {
    BEGIN(IN_DUMP_VARS);
    std::cout<<"DUMP CODE IDENTIFIER: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
    }


<EXPECT_REAL_NUM>{REAL_NUM} {
    return VCDParser::parser::make_TOK_REAL_NUM(loc);
    }

{REAL_NUMBER} {
    return VCDParser::parser::make_TOK_REAL_NUMBER(loc);
    }

<EXPECT_ID_CODE>{IDENTIFIER_CODE} {
    BEGIN(SCOPE_ID);
    std::cout<<"CODE IDENTIFIER: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
    }

<SCOPE_ID>{SCOPE_IDENTIFIER} {
    BEGIN(INITIAL);
    std::cout<<"SCOPE IDENTIFIER: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
    }

<EXPECT_ID>{IDENTIFIER} {
    BEGIN(INITIAL);
    std::cout<<"IDENTIFIER: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
    }

<EXPECT_DECIMAL_TIME>{DECIMAL_NUM} {
    BEGIN(INITIAL);
    std::cout<<"SIM TIME: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_DECIMAL_NUM(loc);
    }

<EXPECT_SIZE>{DECIMAL_NUM} {
    BEGIN(INITIAL);
    std::cout<<"SIZE: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_DECIMAL_NUM(loc);
    }

<EXPECT_DECIMAL>{DECIMAL_NUM} {
    BEGIN(EXPECT_ID_CODE);
    std::cout<<"SIZE: " << yytext <<std::endl;
    return VCDParser::parser::make_TOK_DECIMAL_NUM(loc);
    }


<<EOF>> {
    return VCDParser::parser::make_END(loc);
}

%%

void VCDFileParser::scan_begin() {
    yy_flex_debug = trace_scanning;
    if(filepath.empty() || filepath == "-") {
        yyin = stdin;
    }
    else if(!(yyin = fopen(filepath.c_str(), "r"))) {
        error("Cannot open "+filepath+": "+strerror(errno));
        exit(EXIT_FAILURE);
    }
}

void VCDFileParser::scan_end() {
    fclose(yyin);
    yypop_buffer_state();
}
