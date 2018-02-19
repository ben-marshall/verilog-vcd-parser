
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
        @brief Add a new timestamp value to the VCD file.
        @details Add a time stamp to the sorted array of existing
        timestamps in the file.
        */
        void add_timestamp(
            VCDTime time
        );
    

        /*!
        @brief Return the scope object in the VCD file with this name
        */
        VCDScope * get_scope(
            VCDScopeName name
        );


        /*!
        @brief Add a new signal value to the VCD file, tagged by time.
        */
        void add_signal_value(
            VCDTimedValue * time_val,
            VCDSignalHash   hash
        );

        
        /*!
        @brief Return a pointer to the set of timestamp samples present in
               the VCD file.
        */
        std::vector<VCDTime>* get_timestamps();
        
        /*!
        @brief Get a vector of all scopes present in the file.
        */
        std::vector<VCDScope*>* get_scopes();
        
        /*!
        @brief Return a flattened vector of all signals in the file.
        */
        std::vector<VCDSignal*>* get_signals();

    protected:
        
        //! Flat vector of all signals in the file.
        std::vector<VCDSignal*> signals;
        
        //! Flat mao of all scope objects in the file, keyed by name.
        std::vector<VCDScope*>  scopes;

        //! Vector of time values present in the VCD file - sorted, asc
        std::vector<VCDTime>    times;

        //! Map of hashes onto vectors of times and signal values.
        std::map<VCDSignalHash, VCDSignalValues*> val_map;
};


#endif
