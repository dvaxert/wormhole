#include "wormhole/signal/telegram.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

TelegramSimpleTestingClass::TelegramSimpleTestingClass() {
    std::cout << "TelegramSimpleTestingClass::TelegramSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

TelegramSimpleTestingClass::~TelegramSimpleTestingClass() {
    std::cout << "TelegramSimpleTestingClass::~TelegramSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void TelegramSimpleTestingClass::Print() {
    std::cout << "TelegramSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int TelegramSimpleTestingClass::GetFive() {
    std::cout << "TelegramSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
