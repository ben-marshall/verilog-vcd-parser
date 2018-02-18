
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
        @brief Add a new signal to the VCD file
        */
        void add_signal(
            VCDSignal * s
        );
    

        /*!
        @brief Return the scope object in the VCD file with this name
        */
        VCDScope * get_scope(
            VCDScopeName name
        );
        

        //! Timescale of the VCD file.
        VCDTimeUnit time_units;

        //! Multiplier of the VCD file time units.
        VCDTimeRes  time_resolution;
        
        //! Date string of the VCD file.
        std::string date;

        //! Version string of the simulator which generated the VCD.
        std::string version;

        //! Root scope node of the VCD signals
        VCDScope * root_scope;
        
        //! Flat vector of all signals in the file.
        std::vector<VCDSignal*> signals;
        
        //! Flat mao of all scope objects in the file, keyed by name.
        std::vector<VCDScope*> scopes;
};


#endif
