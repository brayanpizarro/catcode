%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *);
int yylex(void);

int sym[26]; // Array para almacenar valores de variables
%}

%union {
    int num;
    char id;
}

%token <num> INTEGER
%token <id> VARIABLE
%token GATITO GATOTE

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc '<' '>' "==" "<=" ">="
%nonassoc GATOTE
%left GATITO

%type <num> expression

%%

program:
    program statement '\n'
    | statement '\n'
    ;

statement:
    if_else_statement
    | expression { printf("%d\n", $1); }
    | VARIABLE '=' expression { sym[$1 - 'a'] = $3; }
    ;
if_else_statement:
    GATITO '(' expression ')' statement if_else_tail
    ;

if_else_tail:
    GATOTE statement
    ;

expression:
    INTEGER { $$ = $1; }
    | VARIABLE { $$ = sym[$1 - 'a']; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression {
        if ($3 == 0) {
            yyerror("No se puede dividir por 0");
            exit(1); // Salir con código de error
        } else {
            $$ = $1 / $3;
        }
    }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')' { $$ = $2; }
    | expression '<' expression { $$ = $1 < $3; }
    | expression '>' expression { $$ = $1 > $3; }
    | expression "==" expression { $$ = $1 == $3; }
    | expression "<=" expression { $$ = $1 <= $3; }
    | expression ">=" expression { $$ = $1 >= $3; }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    freopen("a.txt", "r", stdin);
    yyparse();
    return 0;
}