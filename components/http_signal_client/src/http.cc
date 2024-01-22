#include "wormhole/signal/http.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

HttpSimpleTestingClass::HttpSimpleTestingClass() {
    std::cout << "HttpSimpleTestingClass::HttpSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

HttpSimpleTestingClass::~HttpSimpleTestingClass() {
    std::cout << "HttpSimpleTestingClass::~HttpSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void HttpSimpleTestingClass::Print() {
    std::cout << "HttpSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int HttpSimpleTestingClass::GetFive() {
    std::cout << "HttpSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
