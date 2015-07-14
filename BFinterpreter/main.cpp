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
    std::ifstream bfStream("Test.txt");
    std::string code;

    bfStream >> code;
    
//    const char* c = code.c_str();
//    interpret("+.>++.>+++.>++++.>+++++.>++++++.");
    eval("+++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++.<.");
    std::cout << std::endl;
    eval("+++++++++>+++++++++++++++++++++++++++++++++++++++++++++++++<[>.+<-]");
    std::cout << std::endl;
    eval("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.");
//    eval("++++++++[>++++[>++<-]>+[<]<-]>>.");
    std::cout << std::endl;

    return 0;
}
