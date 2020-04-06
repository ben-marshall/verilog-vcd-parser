
#include <iostream>
#include <cassert>

#include "VCDFile.hpp"

        
//! Instance a new VCD file container.
VCDFile::VCDFile(){
}
        
//! Destructor
VCDFile::~VCDFile(){
    // Delete signals and scopes.
    for (VCDScope * scope : this -> scopes) {
    
        for (VCDSignal * signal : scope -> signals) {
            delete signal;
        }
        
        delete scope;
    }
}


/*!
@brief Add a new scope object to the VCD file
*/
void VCDFile::add_scope(VCDScope * s){
    scopes.push_back(s);
}


/*!
@brief Add a new signal object to the VCD file
*/
void VCDFile::add_signal(VCDSignal * s){
    signals.push_back(s);

    // Add a timestream entry
    if(val_map.find(s->hash) == val_map.end()) {
        // Values will be populated later.
        val_map[s -> hash] = VCDSignalValues();
    }
}


/*!
 */
VCDScope *VCDFile::get_scope(VCDScopeName name) {
  for (auto &scope : scopes) {
    if (scope->name == name) {
      return scope;
    }
  }
  return nullptr;
}


/*!
@brief Add a new signal value to the VCD file, tagged by time.
*/
void VCDFile::add_signal_value(
    VCDTimedValue&& time_val,
    VCDSignalHash   hash
){
    assert(val_map.find(hash) != val_map.end());

    val_map[hash].push_back(time_val);
}


/*!
*/
std::vector<VCDTime>* VCDFile::get_timestamps(){
    return &times; // what the fuck is this pointer for?
}


/*!
*/
std::vector<VCDScope*>* VCDFile::get_scopes(){
    return &scopes; // what the fuck is this pointer for?
}


/*!
*/
std::vector<VCDSignal*>* VCDFile::get_signals(){
    return &this -> signals;
}


/*!
*/
void VCDFile::add_timestamp(
    VCDTime time
){
    times.push_back(time);
}

/*!
*/
VCDValue * VCDFile::get_signal_value_at (
    const VCDSignalHash& hash,
    VCDTime time,
    bool erase_prior
){
    auto find = val_map.find(hash); 
    if(find == val_map.end()) {
        return nullptr;
    }
    
    VCDSignalValues& vals = find->second;

    if(vals.size() == 0) {
        return nullptr;
    }

    VCDSignalValues::iterator erase_until = vals.begin();

    VCDValue * tr = nullptr;

    for(auto it = vals.begin(); it != vals.end(); ++ it) {
        if((*it).time <= time) {
            erase_until = it;
            tr = &(it->value);
        } else {
            break;
        }
    }

    if (erase_prior) {
        vals.erase(vals.begin(), erase_until);
    }

    return tr;
}
