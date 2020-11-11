%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <malloc.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

struct id_struct
{
    char id_name[50];
    double id_value;
}id;
%}

%token NUMBER
%token ADD
%token MUL
%token DIV
%token LB RB
%token SUB
%token ID 
%token EQUAL
%token ADD_ADD SUB_SUB

%right EQUAL
%left ADD MUS
%left MUL DIV
%right UMINUS
%right ADD_ADD SUB_SUB
%%

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
        | ID {$$ = id.id_value;}
        | ID EQUAL expr {
                        $$ = $3;
                        id.id_value = $3;
                        }
        | ADD_ADD ID    { $$ = id.id_value + 1; id.id_value += 1; } // (++a)
		| SUB_SUB ID    { $$ = id.id_value - 1; id.id_value -= 1; } // (--a)
		| ID ADD_ADD    { $$ = id.id_value; id.id_value += 1; } //  (a++)
		| ID SUB_SUB    { $$ = id.id_value; id.id_value -= 1; }  // (a--)
	    ; 

%%

int yylex()
{
	char t,t_temp;
    
	while (1){
		t = getchar();
		if (t == ' ' || t == '\t'||t=='\n')
		{}
        else if (t == '+'){
            t = getchar();
			if (t == '+')
				return ADD_ADD;
			else {
				ungetc(t, stdin);
				return ADD;
                }
        }
        else if (t == '-'){
            t = getchar();

			if (t == '-')
				return SUB_SUB;
			else {
				ungetc(t, stdin);
				return SUB;
                }
        }
        else if (t == '*')
            return MUL;
        else if (t == '/')
            return DIV;
		else if (t == '(')
			return LB;
		else if (t == ')')
			return RB;
        else if (t == '=')
            return EQUAL;
		else if (isdigit(t)) {
            yylval = 0;
            while(isdigit(t)){
			yylval = yylval * 10 + t - '0';
            t = getchar();
            }
            ungetc(t, stdin);
			return NUMBER;
		}
        else if ((t >= 'a' && t <= 'z' ) || (t >= 'A' && t <= 'Z') || (t == '_')) {
            int ti=0;
            while(('a'<=t&&t<='z')||('A'<=t&&'Z'>=t)||(t=='_')||(t>='0'&&t<='9')){
                id.id_name[ti] = t;
                ti++;
                t=getchar(); 
            }
            id.id_name[ti] = '\0';
            ungetc(t,stdin);
            return ID; 
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
