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
IDENTIFIER_CODE     [a-zA-Z_0-9!/\.@':~#\*\(\)\+\{\}\$]+
SCOPE_IDENTIFIER    [a-zA-Z_][a-zA-Z_0-9]+
DECIMAL_NUM         [0-9]+

COMMENT_TEXT        .*
DATE_TEXT           .*
VERSION_TEXT        .*

%x IN_COMMENT
%x IN_DATE
%x IN_VERSION
%x IN_TIMESCALE
%x IN_SCOPE
%x IN_VAR
%x IN_VAR_RNG

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
    loc.step();
%}


{KW_END} {
    std::cout << yytext << ", " << std::endl;
    return VCDParser::parser::make_TOK_KW_END(loc);
}

<IN_VAR,IN_VAR_RNG,IN_VERSION,IN_DATE,IN_COMMENT,IN_TIMESCALE,IN_SCOPE>{KW_END} {
    BEGIN(INITIAL);
    std::cout << yytext << ", " << std::endl;
    return VCDParser::parser::make_TOK_KW_END(loc);
}

{KW_COMMENT} {
    BEGIN(IN_COMMENT);
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_COMMENT(loc);
}

<IN_COMMENT>{COMMENT_TEXT} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_COMMENT_TEXT(loc);
}

{KW_DATE} {
    BEGIN(IN_DATE);
    return VCDParser::parser::make_TOK_KW_DATE(loc);
}

<IN_DATE>{DATE_TEXT} {
    return VCDParser::parser::make_TOK_DATE_TEXT(loc);
}

{KW_VERSION} {
    BEGIN(IN_VERSION);
    return VCDParser::parser::make_TOK_KW_VERSION(loc);
}

<IN_VERSION>{VERSION_TEXT} {
    return VCDParser::parser::make_TOK_VERSION_TEXT(loc);
}

{KW_TIMESCALE} {
    BEGIN(IN_TIMESCALE);
    return VCDParser::parser::make_TOK_KW_TIMESCALE(loc);
}

<IN_TIMESCALE>{TIME_NUMBER} {
    return VCDParser::parser::make_TOK_TIME_NUMBER(loc);
}

<IN_TIMESCALE>{TIME_UNIT} {
    return VCDParser::parser::make_TOK_TIME_UNIT(loc);
}


{KW_SCOPE} {
    BEGIN(IN_SCOPE);
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_SCOPE(loc);
}

<IN_SCOPE>{KW_BEGIN} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_BEGIN(loc);
}

<IN_SCOPE>{KW_FORK} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_FORK(loc);
}

<IN_SCOPE>{KW_FUNCTION} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_FUNCTION(loc);
}

<IN_SCOPE>{KW_MODULE} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_MODULE(loc);
}

<IN_SCOPE>{KW_TASK} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_TASK(loc);
}

<IN_SCOPE>{SCOPE_IDENTIFIER} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
}

{KW_UPSCOPE} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_UPSCOPE(loc);
}

{KW_ENDDEFINITIONS} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_ENDDEFINITIONS(loc);
}

{KW_VAR} {
    BEGIN(IN_VAR);
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_KW_VAR(loc);
}

<IN_VAR>{VAR_TYPE} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_VAR_TYPE(loc);
}

<IN_VAR>{DECIMAL_NUM} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_DECIMAL_NUM(loc);
}

<IN_VAR>{IDENTIFIER_CODE} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
}

<IN_VAR>{SCOPE_IDENTIFIER} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_IDENTIFIER(loc);
}

<IN_VAR>{BRACKET_O} {
    BEGIN(IN_VAR_RNG);
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_BRACKET_O(loc);
}

<IN_VAR_RNG>{DECIMAL_NUM} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_DECIMAL_NUM(loc);
}

<IN_VAR_RNG>{COLON} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_COLON(loc);
}

<IN_VAR_RNG>{BRACKET_C} {
    std::cout << yytext << ", ";
    return VCDParser::parser::make_TOK_BRACKET_C(loc);
}


" " {}
"\t" {}
"\n" {loc.lines();}
"\r" {loc.lines();}

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
