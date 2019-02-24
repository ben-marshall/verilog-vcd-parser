
#include "VCDFileParser.hpp"
#include "cxxopts.hpp"
#include "gitversion.h"

void print_scope_signals(VCDFile * trace, VCDScope * scope, std::string local_parent)
{
    for(VCDSignal * signal : scope -> signals) {
        std::cout << signal -> hash << "\t" << trace->get_signal_values(signal -> hash)->size() << "\t"
                    << local_parent << "." << signal -> reference;

        if(signal -> size > 1) {
            std::cout << "[" << signal -> lindex << ":" << signal -> rindex << "]";
        } else if (signal -> lindex >= 0) {
            std::cout << "[" << signal -> lindex << "]";
        }
        
        std::cout << std::endl;

    }
}

void traverse_scope(std::string parent, VCDFile * trace, VCDScope * scope, bool instances, bool fullpath)
{
    std::string local_parent = parent;

    if (parent.length())
        local_parent += ".";
    local_parent += scope->name;
    if (instances)
        std::cout << "Scope: " << local_parent  << std::endl;
    if (fullpath)
        print_scope_signals(trace, scope, local_parent);
    for (auto child : scope->children)
        traverse_scope(local_parent, trace, child, instances, fullpath);
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
        ("r,header", "Show header")
        ("u,fullpath", "Show full signal path")
        ("s,start", "Start time (default to 0)", cxxopts::value<VCDTime>())
        ("e,end", "End time (default to end of file)", cxxopts::value<VCDTime>())
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

    if (result.count("start"))
        parser.start_time = result["start"].as<VCDTime>();

    if (result.count("end"))
        parser.end_time = result["end"].as<VCDTime>();

    VCDFile * trace = parser.parse_file(infile);
    bool instances = result["instances"].as<bool>();
    bool fullpath = result["fullpath"].as<bool>();

    if (trace) {
        if (result["header"].as<bool>()) {
            std::cout << "Version:       " << trace -> version << std::endl;
            std::cout << "Comment:       " << trace -> comment << std::endl;
            std::cout << "Date:          " << trace -> date << std::endl;
            std::cout << "Signal count:  " << trace -> get_signals() -> size() <<std::endl;
            std::cout << "Times Recorded:" << trace -> get_timestamps() -> size() << std::endl;
            if (fullpath)
                std::cout << "Hash\tToggles\tFull signal path\n";
        }    
        // Print out every signal in every scope.
        traverse_scope(std::string(""), trace, trace->root_scope, instances, fullpath);

        delete trace;
        
        return 0;
    } else {
        std::cout << "Parse Failed." << std::endl;
        return 1;
    }
}
