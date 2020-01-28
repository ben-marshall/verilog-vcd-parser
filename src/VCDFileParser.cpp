/*!
@file
@brief Definition of the VCDFileParser class
*/

#include "VCDFileParser.hpp"

#include <cerrno>
#include <cstdio>
#include <cstring>

VCDFileParser::VCDFileParser() : trace_scanning(false), trace_parsing(false) {}

VCDFileParser::~VCDFileParser() {}

VCDFile *VCDFileParser::parse_file(const std::string &filep)
{
    error_str.clear();
    filepath = filep;
    file = fopen(filepath.c_str(), "r");
    if (!file) {
      error("Cannot open " + filepath + ": " + strerror(errno));
      return nullptr;
    }
    scan_begin();

    fh = new VCDFile();

    fh->root_scope = new VCDScope;
    fh->root_scope->name = std::string("$root");
    fh->root_scope->type = VCD_SCOPE_ROOT;

    scopes.push(fh->root_scope);

    fh->add_scope(scopes.top());

    VCDParser::parser parser(*this);

    parser.set_debug_level(trace_parsing);

    int result = parser.parse();

    scopes.pop();

    scan_end();
    fclose(file);

    if (result == 0)
    {
        VCDFile* tmp = fh;
        fh = nullptr;
        return tmp;
    }
    else
    {
        delete fh;
        fh = nullptr;
        return nullptr;
    }
}

void VCDFileParser::error(const VCDParser::location &l, const std::string &m)
{
    error("line "+std::to_string(l.begin.line)+" : "+m);
}

void VCDFileParser::error(const std::string &m)
{
    error_str = m;
}
