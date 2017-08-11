/*
 * 
 * Program to parse the data from a RAM testing program on the Cyclone IV chip
 * Converts the raw data to two files containing arrays of space and newline delimited values
 *
 */

/* 
 * File:   main.cpp
 * Author: jmeijers
 *
 * Created on July 24, 2017, 4:57 PM
 */

#include <cstdlib>
#include <iostream>
#include <fstream>

using namespace std;



bool* split_8_int(int a){
    bool* split = new bool[8];
    for(int i = 0; i < 8; i++){
        split[i] = a % 2;
        a = a / 2;
    }
    return split;
}
int hex_to_int(char a, char b){
    int tmp = 0;
    if(a >= 'A' && a <= 'F') tmp += (a - 'A' + 10) * 16;
    else tmp += (a - '0') * 16;
    if(b >= 'A' && b <= 'F') tmp += (b - 'A' + 10);
    else tmp += (b - '0');
    
    return tmp;
}

/*
 * 
 */
int main(int argc, char** argv) {
    ifstream input;
    ofstream output;
    ofstream output2;
    
    if(argc < 4) {
        cout << "not enough arguments, input file followed by output file 1 followed by output file 2" << endl;
        return 0;
    }
    
    
    
    input.open(argv[1]);
    output.open(argv[2]);
    output2.open(argv[3]);
    if(!input.is_open()) cout << "failed to open" << endl;
    double frequency = 99 * 1.25; //start frequency, cycled immediately
    
    double words[8][128]; //the failing frequency of each word
    int number_fails[8][128]; //the number of fails found for each word
    for(int i = 0; i < 8; i++)
        for(int j = 0; j < 128; j++){
            words[i][j] = 0.0;
            number_fails[i][j] = 0;
        }
    
    int position = 0;
    
    int breaks = 0;
    
    while(!input.eof() && !input.fail()){
        
        //get value from the file and convert
        char a1, a2;
        input >> a1;
        input >> a2;
        int a = hex_to_int(a1, a2);
        
        if(a >= 68){ //frequency  cycle signal
            frequency += 1.25;
            position = 0;
        }
        else if(a == 64){ //address coming signal
            position = 1; //waiting for address
        }
        else if(position == 1 || position == 2){ //looking for address
            //get next value as well
            char b1, b2;
            input >> b1; 
            input >> b2;
            //convert
            int b = hex_to_int(b1, b2);

            if (b >= 64) { //issue with the value, expected half of address, got a flag
                breaks++;
                if (b >= 68) { //frequency increment flag
                    frequency += 1.25;
                    position = 0;
                } else if (b == 64) { //address coming flag
                    position = 1; //waiting for address
                }
                continue;
            }
            //convert two integers into addresses
            int address = a + b * 64;
            
            //get address position in the array and set values if necessary 
            int i = address % 8;
            int j = address / 8;
            if(words[i][j] < 90)
                words[i][j] = frequency;
            number_fails[i][j]++;
            
            //if position == 1, another address could be coming
            //if position == 2, a flag should come first
            if(position == 1) position = 2;
            else if(position == 2) position = 0;
        }
        

        
    }
    
    cout << "breaks: " << breaks << endl;
    cout << "frequency: " << frequency << endl;
    
    //output data to file, space and newline delimated values
    for(int i = 0; i < 128; i++){
        
        for(int j = 0; j < 8; j++){
            output << number_fails[j][i] << " ";
            if(words[j][i] < 100) output2 << 0 << " ";
            else output2 << words[j][i] << " ";
        }
        
        output << endl;
        
        output2 << endl;
    }

    
    
    
    
    return 0;
}

