#include "wormhole/sqlite/sqlite.h"

#include <iostream>

//----------------------------------------------------------------------------------------------------------------------

SqliteSimpleTestingClass::SqliteSimpleTestingClass() {
    std::cout << "SqliteSimpleTestingClass::SqliteSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

SqliteSimpleTestingClass::~SqliteSimpleTestingClass() {
    std::cout << "SqliteSimpleTestingClass::~SqliteSimpleTestingClass()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

void SqliteSimpleTestingClass::Print() {
    std::cout << "SqliteSimpleTestingClass::Print()" << std::endl;
}

//----------------------------------------------------------------------------------------------------------------------

int SqliteSimpleTestingClass::GetFive() {
    std::cout << "SqliteSimpleTestingClass::GetFive()" << std::endl;
    return 5;
}
