/*!
@file
@brief Definition of the COVFileParser class
*/

#include "COVFileParser.hpp"

COVFileParser::COVFileParser() {

    this -> trace_scanning = false;
    this -> trace_parsing  = false;

}

COVFileParser::~COVFileParser() {

}
        
/*!
*/
bool COVFileParser::resolve_references () {

    bool to_return = true;

    return to_return;
}

int COVFileParser::parse_file(const std::string &filepath) {

    this -> filepath = filepath;
    
    scan_begin();

    yy::parser parser(*this);

    parser.set_debug_level(trace_parsing);

    int result = parser.parse();

    scan_end();

    return result;

}
        

void COVFileParser::error(const yy::location & l, const std::string & m){
    std::cerr << l << " : "<<m<<std::endl;
}

void COVFileParser::error(const std::string & m){
    std::cerr << " : "<<m<<std::endl;
}

