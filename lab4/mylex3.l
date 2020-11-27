%option noyywrap c++
%top{
#include<math.h>
#include<iostream>
#include <iomanip>
#include<map>
#include<string>
using namespace std;
int mylineno = 0;
map<string,int> id_table;
int id_count=0;
}

ws      [" "\t]+
keyword while|return|if|else|break|continue|for
typename  int|double|char|bool|float|void
point_type {typename}{ws}?\*
stmtend ";"

rightbracket ")"
leftbrackets "("
rightsquare "]"
leftsquare "["
rightcurly "}"
leftcurly "{"

assignment "="|"*="|"+="|"-="|"/="
comp <|>|<=|>=|!=|==
calop "+"|"-"|"*"|"/"|"%"
ralop "||"|"&&"|!
bitop "|"|"&"|"^"
selfop "++"|"--"

string  \"[^\n"]+\"

alpha   [A-Za-z]
dig     [0-9]
num1    {dig}+\.?([eE][-+]?{dig}+)?
num2    {dig}*\.{dig}+([eE][-+]?{dig}+)?
number  {num1}|{num2}

id ({alpha}|"_")({alpha}|{dig}|"_")*

commentbegin "/*"
commentelement .
commentend "*/"

linecommentbegin "//"
linecommentelement .
linecommentend "\n"
%x COMMENT
%x LINECOMMENT

%%

{ws}    /* skip blanks and tabs */

{keyword} {cout<<std::setw(20)<<"keyword"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{typename} {cout<<std::setw(20)<<"typename"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{point_type} {cout<<std::setw(20)<<"point_type"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{stmtend} {cout<<std::setw(20)<<"stmtend"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}

{rightbracket} {cout<<std::setw(20)<<"rightbracket"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{leftbrackets} {cout<<std::setw(20)<<"leftbrackets"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{rightsquare} {cout<<std::setw(20)<<"rightsquare"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{leftsquare} {cout<<std::setw(20)<<"leftsquare"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;} 
{rightcurly} {cout<<std::setw(20)<<"rightcurly"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{leftcurly} {cout<<std::setw(20)<<"leftcurly"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}

{assignment} {cout<<std::setw(20)<<"assignment"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{comp} {cout<<std::setw(20)<<"comp"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{calop} {cout<<std::setw(20)<<"calop"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;} 
{ralop} {cout<<std::setw(20)<<"ralop"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{bitop} {cout<<std::setw(20)<<"bitop"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;} 
{selfop} {cout<<std::setw(20)<<"selfop"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;} 

{string} {cout<<std::setw(20)<<"string"<<std::setw(20)<<YYText()<<std::setw(20)<<""<<std::setw(20)<<mylineno<<endl;}
{number} {cout<<std::setw(20)<<"number"<<std::setw(20)<<YYText()<<std::setw(20)<<atof(YYText())<<std::setw(20)<<mylineno<<endl;}

{id} {
        if(id_table.find(YYText())==id_table.end()){
            id_count++;
            id_table .insert(pair<string, int>(YYText(),id_count));
        }
        int temp=id_table.find(YYText())->second;
        cout<<std::setw(20)<<"id"<<std::setw(20)<<YYText()<<std::setw(20)<<temp<<std::setw(20)<<mylineno<<endl;
    }

"\n" {mylineno++;}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>"\n" {mylineno++;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}

{linecommentbegin} {BEGIN LINECOMMENT;}
<LINECOMMENT>{linecommentelement} {mylineno++;}
<LINECOMMENT>{linecommentend} {BEGIN INITIAL;}

%%



int main( int argc, char**  argv )
{
    cout<<std::setw(20)<<"token_type"<<std::setw(20)<<"token"<<std::setw(20)<<"value"<<std::setw(20)<<"lineno"<<endl;
    cout<<"--------------------------------------------------------------------------------"<<endl;
    FlexLexer* lexer = new yyFlexLexer;
    while(lexer->yylex() != 0)
        ;
    return 0;
}