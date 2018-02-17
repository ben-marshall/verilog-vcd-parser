/*!
@file
@brief Contains the declaration of the parser driver class.
*/

#ifndef COVERAGE_PARSER_DRIVER_HPP
#define COVERAGE_PARSER_DRIVER_HPP

#include <string>
#include <map>
#include <set>

#include "parser.hpp"

#define YY_DECL \
    yy::parser::symbol_type yylex (COVFileParser & driver)

YY_DECL;


/*!
@brief Class for parsing files containing CSP notation.
*/
class COVFileParser {

    public:
        
        //! Create a new parser/
        COVFileParser();
        virtual ~COVFileParser();
        
        /*!
        @brief Parse the suppled file.
        @returns 0 if everything was parsed okay. Nonzero otherwise.
        */
        int parse_file(const std::string & filepath);
        
        //! The current file being parsed.
        std::string filepath;
        
        //! Should we debug tokenising?
        bool trace_scanning;

        //! Should we debug parsing of tokens?
        bool trace_parsing;

        //! Reports errors to stderr.
        void error(const yy::location & l, const std::string & m);

        //! Reports errors to stderr.
        void error(const std::string & m);
        
    protected:

        //! Utility function for starting parsing.
        void scan_begin ();
        
        //! Utility function for stopping parsing.
        void scan_end   ();
};

#endif

