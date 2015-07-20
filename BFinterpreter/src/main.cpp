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

//extern void interpret(std::string code);
extern "C" void eval(const char* code);
//extern "C" void interpret();
//void interpret();

int main(int argc, const char * argv[]) {
    std::ifstream bfStream("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/first.txt");
    std::string code;

    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/second.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/third.txt");
    bfStream >> code;
    eval(code.c_str());
//    std::cout << std::endl;
    bfStream.close();
    
    bfStream.open("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/fourth.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
//    bfStream.open("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/fifth.txt");
//    bfStream >> code;
//    eval(code.c_str());
//    std::cout << std::endl;
//    bfStream.close();
    
    bfStream.open("/Users/kokoster/Documents/projects/BFinterpreter/BFinterpreter/tests/sixth.txt");
    bfStream >> code;
    eval(code.c_str());
    std::cout << std::endl;
    bfStream.close();
    
    return 0;
}
