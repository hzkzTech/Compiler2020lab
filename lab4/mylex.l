%option noyywrap
%top{
#include<map>
#include<iomanip>
#include<math.h>
}
%{
int chars=0,words=0,lines=0;
%}

word [a-zA-Z]+
line \n
char .
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x COMMENT

%%
{word} {words++;chars+=strlen(yytext);}
{line} {lines++;}
{char} {chars++;}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
%%

int main(){
    yyFlexLexer lexer;
    lexer.yylex();
    std::cout<<std::setw(8)<<lines<<std::setw(8)<<words<<std::setw(8)<<chars<<std::endl;
    return 0;
}