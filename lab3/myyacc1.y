%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

%}

%token NUMBER
%token ADD
%token MUL
%token DIV
%token LB RB
%token SUB

%left ADD MUS
%left MUL DIV
%right UMINUS

%%
// TODO  %d error why?
lines :  lines expr ';' {printf("result: %f\n", $2);}
		| lines ';'
		|
		;

expr :   expr ADD expr   {$$ = $1 + $3;}
		| expr SUB expr  {$$ = $1 - $3;}
		| expr MUL expr  {$$ = $1 * $3;}
		| expr DIV expr  {
					if ($3==0.0)
						yyerror("divide by zero!");
					else
						$$ = $1 / $3;
						}
		| LB expr RB {$$ = $2;}
		//可以用%prec强制定义产生式的优先级和结合性
		| SUB expr %prec UMINUS {$$=-$2;}
		| NUMBER
	    ; 


%%

int yylex()
{
	char t;
	while (1) {
		t = getchar();
		if (t == ' ' || t == '\t'||t=='\n')
		{}
        else if (t == '+')
			return ADD;
        else if (t == '-')
			return SUB;
        else if (t == '*')
            return MUL;
        else if (t == '/')
            return DIV;
		else if (t == '(')
			return LB;
		else if (t == ')')
			return RB;
		else if (isdigit(t)) {
			yylval = t - '0';
			return NUMBER;
		}
		else {return t; }
	}
}
void yyerror(const char* s){
	fprintf(stderr, "Parse erro: %s\n", s);
	exit(1);
}
int main(void)
{
	yyin = stdin;
	do{
		yyparse();
	}while(!feof(yyin));

	return 0;
}
