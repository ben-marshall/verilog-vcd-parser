
#ifndef VCDValue_HPP
#define VCDValue_HPP

#include "VCDTypes.hpp"
#include <variant>

/*!
@brief Represents a single value found in a VCD File.
@details Can contain a single bit (a scalar), a bti vector, or an
IEEE floating point number.
*/
class VCDValue {


    //! Convert a VCDBit to a single char
    static char VCDBit2Char(VCDBit b) {
        switch(b) {
            case(VCD_0):
                return '0';
            case(VCD_1):
                return '1';
            case(VCD_Z):
                return 'Z';
            case(VCD_X):
            default:
                return 'X';
        }
    }

    public:
        /*!
        @brief Create a new VCDValue with the type VCD_SCALAR
        */
        VCDValue (VCDBit  value);

        /*!
        @brief Create a new VCDValue with the type VCD_VECTOR
        */
        VCDValue (VCDBitVector&& value);

        /*!
        @brief Create a new VCDValue with the type VCD_VECTOR
        */
        VCDValue (VCDReal value);

        ~VCDValue () {}

        //! Return the type of value stored by this class instance.
        VCDValueType get_type() const;
        
        //! Get the bit value of the instance.
        VCDBit get_value_bit() const;
        
        //! Get the vector value of the instance.
        VCDBitVector const& get_value_vector() const;

        //! Get the real value of the instance.
        VCDReal get_value_real() const;

    protected:
        //! The type of value this instance stores.
        VCDValueType type_;
        
        //! The actual value stored, as identified by type.
        std::variant<VCDBit, VCDBitVector, VCDReal> value_;
};


//! A signal value tagged with times.
typedef struct {
    VCDTime     time;
    VCDValue    value;
} VCDTimedValue;


//! A vector of tagged time/value pairs, sorted by time values.
typedef std::deque<VCDTimedValue> VCDSignalValues;

#endif
