
#include <map>
#include <string>
#include <vector>

#include "VCDTypes.hpp"
#include "VCDValue.hpp"

#ifndef VCDFile_HPP
#define VCDFile_HPP


/*!
@brief Top level object to represent a single VCD file.
*/
class VCDFile {
    public:

        typedef std::map<VCDSignalHash, VCDSignalValues> value_map_t;

        //! Instance a new VCD file container.
        VCDFile();
        
        //! Destructor
        ~VCDFile();
        
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
        @param s in - The VCDScope object to add to the VCD file.
        */
        void add_scope(VCDScope * s);

        /*!
        @brief Add a new signal to the VCD file
        @param s in - The VCDSignal object to add to the VCD file.
        */
        void add_signal(VCDSignal * s);


        /*!
        @brief Add a new timestamp value to the VCD file.
        @details Add a time stamp to the sorted array of existing
        timestamps in the file.
        @param time in - The timestamp value to add to the file.
        */
        void add_timestamp(VCDTime time);
    

        /*!
        @brief Return the scope object in the VCD file with this name
        @param name in - The name of the scope to get and return.
        */
        VCDScope * get_scope(VCDScopeName name);


        /*!
        @brief Add a new signal value to the VCD file, tagged by time.
        @param time_val in - A signal value, tagged by the time it occurs.
        @param hash in - The VCD hash value representing the signal.
        */
        void add_signal_value(VCDTimedValue&& time_val, VCDSignalHash   hash);
        

        /*!
        @brief Get the value of a particular signal at a specified time.
        @note The supplied time value does not need to exist in the
        vector returned by get_timestamps().
        @param hash in - The hashcode for the signal to identify it.
        @param time in - The time at which we want the value of the signal.
        @param erase_prior in - Erase signals prior to this time. Avoids O(n^2) searching times when scanning large .vcd files sequentially.
        @returns A pointer to the value at the supplie time, or nullptr if
        no such record can be found.
        */
        VCDValue * get_signal_value_at (const VCDSignalHash& hash, VCDTime time,
            bool erase_prior = false);

        
        /*!
        @brief Return a pointer to the set of timestamp samples present in
               the VCD file.
        */
        std::vector<VCDTime> const& get_timestamps() const;


        VCDTime get_last_time() const {return *times.crbegin();}
        VCDTime get_first_time() const {return *times.begin();}


        /*!
        @brief Get a vector of all scopes present in the file.
        */
        std::vector<VCDScope*> const& get_scopes(); //cannot be const, 'cause stupid pointer
        
        /*!
        @brief Return a flattened vector of all signals in the file.
        */
        std::vector<VCDSignal*> const& get_signals(); //cannot be const, 'cause stupid pointer

        VCDSignalValues const& get_values(const VCDSignalHash& hash) const {
            return val_map.at(hash);
        }

    protected:
        
        //! Flat vector of all signals in the file.
        // what the fuck is this pointer for?
        std::vector<VCDSignal*> signals;
        
        //! Flat mao of all scope objects in the file, keyed by name.
        // what the fuck is this pointer for?
        std::vector<VCDScope*>  scopes;

        //! Vector of time values present in the VCD file - sorted, asc
        std::vector<VCDTime>    times;

        //! Map of hashes onto vectors of times and signal values.
        value_map_t val_map;
};


#endif
