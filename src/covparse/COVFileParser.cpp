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

int COVFileParser::parse_file(const std::string &filepath) {

    this -> filepath = filepath;
    
    scan_begin();

    COVParser::parser parser(*this);

    parser.set_debug_level(trace_parsing);

    int result = parser.parse();

    scan_end();

    return result;

}
        

void COVFileParser::error(const COVParser::location & l, const std::string & m){
    std::cerr << l << " : "<<m<<std::endl;
}

void COVFileParser::error(const std::string & m){
    std::cerr << " : "<<m<<std::endl;
}


#ifdef COV_PARSER_STANDALONE

/*!
@brief Standalone test function to allow testing of the COV file parser.
*/
int main (int argc, char** argv){

    std::string infile (argv[1]);

    std::cout << "Parsing " << infile << std::endl;

    COVFileParser parser;

    int result = parser.parse_file(infile);

    return result;
}


#endif
