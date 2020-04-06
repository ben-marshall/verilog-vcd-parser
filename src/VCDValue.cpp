
#include "VCDValue.hpp"


/*!
*/
VCDValue::VCDValue(VCDBit  value){
    type_ = VCD_SCALAR;
    value_ = value;
}

/*!
*/
VCDValue::VCDValue(VCDBitVector&&  value){
    type_ = VCD_VECTOR;
    value_ = value;
}

/*!
*/
VCDValue::VCDValue(VCDReal value){
    type_ = VCD_REAL;
    value_ = value;
}


VCDValueType VCDValue::get_type() const{
    return type_;
}


/*!
*/
VCDBit VCDValue::get_value_bit() const{
    return std::get<VCDBit>(value_);
}


/*!
*/
VCDBitVector const& VCDValue::get_value_vector() const{
    return std::get<VCDBitVector>(value_);
}


/*!
*/
VCDReal VCDValue::get_value_real() const{
    return std::get<VCDReal>(value_);
}

