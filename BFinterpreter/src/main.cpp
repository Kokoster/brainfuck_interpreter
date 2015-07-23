//
//  main.c
//  BFinterpreter
//
//  Created by Ольга Диденко on 05.07.15.
//
//

#include <fstream>
#include <iostream>
#include <string>
#include <unistd.h>

//extern void interpret(std::string code);
extern "C" void eval(const char* code);
//extern "C" void interpret();
//void interpret();

int main(int argc, const char * argv[]) {
//    char * dir = getcwd(NULL, 0);
//    std::cout << "Current dir: " << dir << std::endl;
    
    std::ifstream bfStream("BFinterpreter/tests/second.txt");
    std::string code;
    
    if (bfStream.fail()) {
        std::cout << "fail" << std::endl;
    }

    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("BFinterpreter/tests/second.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();

    bfStream.open("BFinterpreter/tests/third.txt");
    bfStream >> code;
    eval(code.c_str());
//    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("BFinterpreter/tests/fourth.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
//    bfStream.open("BFinterpreter/tests/fifth.txt");
//    
//    bfStream >> code;
//    eval(code.c_str());
//    std::cout << std::endl;
//    bfStream.close();
    
    bfStream.open("BFinterpreter/tests/sixth.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("BFinterpreter/tests/seventh.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("BFinterpreter/tests/eighth.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    return 0;
}
