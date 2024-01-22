#include "wormhole/webrtc/webrtc.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

WebrtcSimpleTestingClass::WebrtcSimpleTestingClass() {
    std::cout << "WebrtcSimpleTestingClass::WebrtcSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

WebrtcSimpleTestingClass::~WebrtcSimpleTestingClass() {
    std::cout << "WebrtcSimpleTestingClass::~WebrtcSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void WebrtcSimpleTestingClass::Print() {
    std::cout << "WebrtcSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int WebrtcSimpleTestingClass::GetFive() {
    std::cout << "WebrtcSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
