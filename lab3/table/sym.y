%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <malloc.h>
#include "hash.h"

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char*);

%}

%union{
	char key[50];
    double value;
}

%type <value>expr

%token <value>NUMBER
%token <value>ADD
%token <value>MUL
%token <value>DIV
%token <value>LB RB
%token <value>SUB
%token <key>ID 
%token <value>EQUAL

%right EQUAL
%left ADD MUS
%left MUL DIV
%right UMINUS

%%

lines :  lines expr ';' {printf("%f\n", $2);}
		| lines ';'
		|
		;

expr :   expr ADD expr   {$$= $1+ $3;}
		| expr SUB expr  {$$ = $1 - $3;}
		| expr MUL expr  {$$ = $1 * $3;}
		| expr DIV expr  {
					if ($3==0.0)
						yyerror("divide by zero!");
					else
						$$ = $1 / $3;
						}
		| LB expr RB {$$ = $2;}
		| SUB expr %prec UMINUS {$$=-$2;}
		| NUMBER
        | ID {
			$$=lookup($1)->value;
		}
        | ID EQUAL expr {
                        $$ = $3;
                        set_table($1,$3);  //修改符号表，一定会执行在insert()之后
                    }
	    ; 

%%

// programs section

int yylex()
{
	char t,t_temp;
    
	while (1){
		t = getchar();
		if (t == ' ' || t == '\t'||t=='\n');
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
        else if (t == '=')
            return EQUAL;
		else if (isdigit(t)) {		//数字
			strcpy(yylval.key,"");
            yylval.value = 0;
            while(isdigit(t)){		
				yylval.value = yylval.value * 10 + t - '0';
				t = getchar();
            }
            ungetc(t, yyin);
			return NUMBER;
		}
        else if ((t >= 'a' && t <= 'z' ) || (t >= 'A' && t <= 'Z')|| (t == '_')) {  // 标识符
            int ti=0;
			char id_name[50];
            while((t >= 'a' && t <= 'z' ) || (t >= 'A' && t <= 'Z')||(t=='_')||(t>='0'&&t<='9')){
                id_name[ti] = t;
                ti++;
                t=getchar(); 
            }
            id_name[ti] = '\0';
			insert(id_name,0.0);		// insert函数会先检查是否存在，已存在则不插入符号表
			strcpy(yylval.key,id_name);
            ungetc(t,yyin);
            return ID; 
        }
		else {
			return t;
		}
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
