
#include <map>
#include <string>
#include <vector>

/*!
@file VCDTypes.hpp
@brief A file for common types and data structures used by the VCD parser.
*/

#ifndef VCDTypes_HPP
#define VCDTypes_HPP

//! Friendly name for a signal
typedef std::string VCDSignalReference;

//! Friendly name for a scope
typedef std::string VCDScopeName;

//! Compressed hash representation of a signal.
typedef std::string VCDSignalHash;

//! Represents the type of SV construct who's scope we are in.
typedef enum {
    VCD_SCOPE_BEGIN,
    VCD_SCOPE_FORK,
    VCD_SCOPE_FUNCTION,
    VCD_SCOPE_MODULE,
    VCD_SCOPE_TASK
} VCDScopeType;


// Typedef over vcdscope.
typedef struct vcdscope VCDScope;

//! Represents a scope type, scope name pair.
struct vcdscope {
    VCDScopeName              name;
    VCDScopeType              type;
    VCDScope                * parent;
    std::vector<VCDScope*>    children;
};


#endif
