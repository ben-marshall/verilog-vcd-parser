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

int VCDFileParser::parse_file(const std::string &filepath) {

    this -> filepath = filepath;
    
    scan_begin();

    VCDParser::parser parser(*this);

    parser.set_debug_level(trace_parsing);

    int result = parser.parse();

    scan_end();

    return result;

}
        

void VCDFileParser::error(const VCDParser::location & l, const std::string & m){
    std::cerr << l << " : "<<m<<std::endl;
}

void VCDFileParser::error(const std::string & m){
    std::cerr << " : "<<m<<std::endl;
}



#ifdef VCD_PARSER_STANDALONE

/*!
@brief Standalone test function to allow testing of the VCD file parser.
*/
int main (int argc, char** argv){

    std::string infile (argv[1]);

    std::cout << "Parsing " << infile << std::endl;

    VCDFileParser parser;

    int result = parser.parse_file(infile);

    return result;
}


#endif
