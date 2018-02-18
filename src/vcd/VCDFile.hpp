
#include <map>
#include <string>
#include <vector>

#include "VCDTypes.hpp"

#ifndef VCDFile_HPP
#define VCDFile_HPP


/*!
@brief Top level object to represent a single VCD file.
*/
class VCDFile {

    public:
        
        //! Instance a new VCD file container.
        VCDFile();

        /*!
        @brief Add a new scope object to the VCD file
        */
        void add_scope(
            VCDScope * s
        );
    

        /*!
        @brief Return the scope object in the VCD file with this name
        */
        VCDScope * get_scope(
            VCDScopeName name
        );
        
        //! Date string of the VCD file.
        std::string date;

        //! Version string of the simulator which generated the VCD.
        std::string version;

    protected:

        //! Root scope node of the VCD signals
        VCDScope * root_scope;
        
        //! Flat mao of all scope objects in the file, keyed by name.
        std::map<VCDScopeName,VCDScope*> scopes;
        
        //! Flat vector of all signals in the file.
        std::vector<VCDSignal*> signals;
};


#endif
