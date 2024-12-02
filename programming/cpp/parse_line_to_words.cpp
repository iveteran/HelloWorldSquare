#include <iostream>
#include <vector>
#include <sstream>

using namespace std;

int main()
{
    string str = " add  string \" this is a string with  space! \"  ";
    cout << "input: " << str << endl;

    vector<string> words;
    string word;
    for( size_t i=0; i<str.size(); i++) {
        char c = str[i];
        if (c == ' ') {
            if (! word.empty()) {
                words.push_back(word);
                word.clear();
            } else {
                continue;
            }
        } else if (c == '\"' ) {
            i++;
            for ( ; str[i] != '\"'; i++ ) {
                if (str[i] != ' ' || (! word.empty() && word.back() != ' ')) {
                    word.push_back(str[i]);
                }
            }
            if (word.back() == ' ') {
                word.erase(word.size()-1);
            }
            words.push_back(word);
            word.clear();
        } else {
            word.push_back(c);
        }
    }

    for (auto word : words) {
        cout << word << endl;
    }
    return 0;
}
// build: g++ -o parse_line_to_words parse_line_to_words.cpp
