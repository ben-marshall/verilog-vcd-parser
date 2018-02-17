/*!
@file
@brief Definition of the VCDFileParser class
*/

#include "VCDFileParser.hpp"

VCDFileParser::VCDFileParser() {

    this -> trace_scanning = false;
    this -> trace_parsing  = false;

}

VCDFileParser::~VCDFileParser() {

}
        
/*!
*/
bool VCDFileParser::resolve_references () {

    bool to_return = true;

    return to_return;
}

int VCDFileParser::parse_file(const std::string &filepath) {

    this -> filepath = filepath;
    
    scan_begin();

    yy::parser parser(*this);

    parser.set_debug_level(trace_parsing);

    int result = parser.parse();

    scan_end();

    return result;

}
        

void VCDFileParser::error(const yy::location & l, const std::string & m){
    std::cerr << l << " : "<<m<<std::endl;
}

void VCDFileParser::error(const std::string & m){
    std::cerr << " : "<<m<<std::endl;
}

