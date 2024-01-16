#include "wormhole/ui/ui.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

UiSimpleTestingClass::UiSimpleTestingClass() {
    std::cout << "UiSimpleTestingClass::UiSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

UiSimpleTestingClass::~UiSimpleTestingClass() {
    std::cout << "UiSimpleTestingClass::~UiSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void UiSimpleTestingClass::Print() {
    std::cout << "UiSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int UiSimpleTestingClass::GetFive() {
    std::cout << "UiSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
