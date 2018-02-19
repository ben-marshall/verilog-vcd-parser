
#include <iostream>

#include "VCDFile.hpp"
        
        
//! Instance a new VCD file container.
VCDFile::VCDFile(){

}


/*!
@brief Add a new scope object to the VCD file
*/
void VCDFile::add_scope(
    VCDScope * s
){
    this -> scopes.push_back(s);
}


/*!
@brief Add a new signal object to the VCD file
*/
void VCDFile::add_signal(
    VCDSignal * s
){
    this -> signals.push_back(s);

    // Add a timestream entry
    if(val_map.find(s -> hash) == val_map.end()) {
        // Values will be populated later.
        val_map[s -> hash] = new VCDSignalValues();
    }
}


/*!
*/
VCDScope * VCDFile::get_scope(
    VCDScopeName name
){
        return nullptr;
}


/*!
@brief Add a new signal value to the VCD file, tagged by time.
*/
void VCDFile::add_signal_value(
    VCDTimedValue * time_val,
    VCDSignalHash   hash
){
    this -> val_map[hash] -> push_back(time_val);
}


/*!
*/
std::vector<VCDTime>* VCDFile::get_timestamps(){
    return &this -> times;
}


/*!
*/
std::vector<VCDScope*>* VCDFile::get_scopes(){
    return &this -> scopes;
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
    this -> times.push_back(time);
}

