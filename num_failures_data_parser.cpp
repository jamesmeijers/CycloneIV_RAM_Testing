/*
 * 
 * Parses the data output from a Cyclone IV RAM testing project
 * converts the raw data to a table of space delimated values
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



bool* split_8_int(int a){ //splits an 8 bit integer into 8 boolean values
    bool* split = new bool[8];
    for(int i = 0; i < 8; i++){
        split[i] = a % 2;
        a = a / 2;
    }
    return split;
}
int hex_to_int(char a, char b){ //converts to hex characters to an integer
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
    //input.open("/home/jmeijers/Desktop/checker_num_failures.txt");
    if(argc < 3) {
        cout << "not enough arguments, input file followed by output file" << endl;
        return 0;
    }
    input.open(argv[1]);
    output.open(argv[2]);
    if(!input.is_open()) cout << "failed to open" << endl;
    double frequency = 99 * 1.25; //starting frequency (incremented to 100*1.25 immediately)

    int state = 0;
    int failures = 0;
    while(!input.eof() && !input.fail()){
        //get hex value and convert to integer
        char a1, a2;
        input >> a1;
        input >> a2;
        
        int a = hex_to_int(a1, a2);
        
        if(a < 64){ //any value less than 64 represents a cycle of frequency
            if(state != 0) //missing data, most likely lost by UART (UART unable to send HEX 11 or 13, unsure why)
                cout << "missing information for frequency " << frequency << endl;
            frequency += 1.25; //cycle frequency
            state = 1;
            failures = 0;
        }
        else if(state == 1){ //add lower bits to failure
            failures += a - 64;
            state = 2;
        }
        else if(state == 2){ //scale and add middle bits
            failures += (a - 64) * 64;
            state = 3;
        }
        else if(state == 3){ //scale and add upper bits and output result
            failures += (a - 64) * 4096;
            output << frequency << " " << failures << endl;
            state = 0;
        }
        else { //state is equal greater than 64, but a frequency cycle was expected
            if (!input.eof() && !input.fail()) {
                cout << "error, expected new frequency sign" << endl;
                failures = 0;
            }
        }
        
        
    }

    return 0;
}

