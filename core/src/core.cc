#include "wormhole/core.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

CoreSimpleTestingClass::CoreSimpleTestingClass() {
    std::cout << "CoreSimpleTestingClass::CoreSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

CoreSimpleTestingClass::~CoreSimpleTestingClass() {
    std::cout << "CoreSimpleTestingClass::~CoreSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void CoreSimpleTestingClass::Print() {
    std::cout << "CoreSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int CoreSimpleTestingClass::GetFive() {
    std::cout << "CoreSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
