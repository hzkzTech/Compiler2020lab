%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

BOOL "true"|"false"

/* 数字类型优先识别int，然后识别float */
INTEGER [0-9]+
dig     [0-9]
num1    {dig}+\.?([eE][-+]?{dig}+)?
num2    {dig}*\.{dig}+([eE][-+]?{dig}+)?
FLOAT  {num1}|{num2}

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"float" return T_FLOAT; /* TODO:在此添加类型声明 */

"=" return LOP_ASSIGN;

";" return  SEMICOLON;

{BOOL} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = yytext[0]=='t'?true:false;
    yylval = node;
    return BOOL;
}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{FLOAT} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_FLOAT;
    node->float_val = atof(yytext);
    yylval = node;
    return FLOAT;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val=yytext[1];
    yylval = node;
    return CHAR;
}

{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = yytext; 
    yylval = node;
    return STRING;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%