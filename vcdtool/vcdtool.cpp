
#include "VCDFileParser.hpp"
#include "cxxopts.hpp"
#include "gitversion.h"

void print_scope_signals(VCDScope * scope, std::string local_parent)
{
    for(VCDSignal * signal : scope -> signals) {

        std::cout << "\t" << signal -> hash << "\t" 
                    << local_parent << "." << signal -> reference;

        if(signal -> size > 1) {
            std::cout << "[" << signal -> lindex << ":" << signal -> rindex << "]";
        } else if (signal -> lindex >= 0) {
            std::cout << "[" << signal -> lindex << "]";
        }
        
        std::cout << std::endl;

    }
}

void traverse_scope(std::string parent, VCDScope * scope, bool instances, bool fullpath)
{
    std::string local_parent = parent;

    if (parent.length())
        local_parent += ".";
    local_parent += scope->name;
    if (instances)
        std::cout << "Scope: " << local_parent  << std::endl;
    if (fullpath)
        print_scope_signals(scope, local_parent);
    for (auto child : scope->children)
        traverse_scope(local_parent, child, instances, fullpath);
}
/*!
@brief Standalone test function to allow testing of the VCD file parser.
*/
int main (int argc, char** argv)
{

    cxxopts::Options options("vcdtoggle", "Count number of signal toggles in VCD file");
    options.add_options()
        ("h,help", "show help message")
        ("v,version", "Show version")
        ("i,instances", "Show only instances")
        ("t,toggles", "Show toggles")
        ("r,header", "Show header")
        ("u,fullpath", "Show full signal path")
        ("s,start", "Start time (default to 0)", cxxopts::value<int>()->default_value("-1"))
        ("e,end", "End time (default to end of file)", cxxopts::value<int>()->default_value("-1"))
        ("f,file", "filename containing scopes and signal name regex", cxxopts::value<std::string>())
        ("positional", "Positional pareameters", cxxopts::value<std::vector<std::string>>())
    ;
    options.parse_positional({"positional"});
    auto result = options.parse(argc, argv);
    if (result["help"].as<bool>())
        std::cout << options.help() << std::endl;
    if (result["version"].as<bool>())
        std::cout << "Version:  0.1\nGit HEAD: "  << gitversion << std::endl;

    std::string infile (result["positional"].as<std::vector<std::string>>().back());

    VCDFileParser parser;

    VCDFile * trace = parser.parse_file(infile);
    bool instances = result["instances"].as<bool>();
    bool fullpath = result["fullpath"].as<bool>();

    if (trace) {
        if (result["header"].as<bool>()) {
            std::cout << "Parse successful." << std::endl;
            std::cout << "Version:       " << trace -> version << std::endl;
            std::cout << "Comment:       " << trace -> comment << std::endl;
            std::cout << "Date:          " << trace -> date << std::endl;
            std::cout << "Signal count:  " << trace -> get_signals() -> size() <<std::endl;
            std::cout << "Times Recorded:" << trace -> get_timestamps() -> size() << std::endl;
        }    
        // Print out every signal in every scope.
        traverse_scope(std::string(""), trace->root_scope, instances, fullpath);

        if (result["toggles"].as<bool>()) {
            std::cout << "T.B.D!" >> std::endl;
        }
        delete trace;
        
        return 0;
    } else {
        std::cout << "Parse Failed." << std::endl;
        return 1;
    }
}
