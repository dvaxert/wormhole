#include "wormhole_driver/wormhole_driver.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

DriverSimpleTestingClass::DriverSimpleTestingClass() {
    std::cout << "DriverSimpleTestingClass::DriverSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

DriverSimpleTestingClass::~DriverSimpleTestingClass() {
    std::cout << "DriverSimpleTestingClass::~DriverSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void DriverSimpleTestingClass::Print() {
    std::cout << "DriverSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int DriverSimpleTestingClass::GetFive() {
    std::cout << "DriverSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
