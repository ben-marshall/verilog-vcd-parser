/*!
@file
@brief Contains the lexical definition for the parser.
*/

%{
    
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <string>

#include "COVFileParser.hpp"
#include "parser.hpp"

#undef yywrap
#define yywrap() 1

static yy::location loc;
    
%}

%option noyywrap nounput batch debug noinput

PAREN_O         "("
PAREN_C         ")"

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

%%

%{
    loc.step();
%}


{PAREN_O} {
    return yy::parser::make_TOK_PAREN_O(loc);
}

{PAREN_C} {
    return yy::parser::make_TOK_PAREN_C(loc);
}

" " {}
"\t" {}
"\n" {}
"\r" {}

<<EOF>> {
    return yy::parser::make_END(loc);
}

%%

void COVFileParser::scan_begin() {
    yy_flex_debug = trace_scanning;
    if(filepath.empty() || filepath == "-") {
        yyin = stdin;
    }
    else if(!(yyin = fopen(filepath.c_str(), "r"))) {
        error("Cannot open "+filepath+": "+strerror(errno));
        exit(EXIT_FAILURE);
    }
}

void COVFileParser::scan_end() {
    fclose(yyin);
    yypop_buffer_state();
}
