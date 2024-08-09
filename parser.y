%{

    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(char *);
    int yylex(void);
    
    int sym[26];
%}


%token INTEGER VARIABLE IF ELSE

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS


%%

program:
        program statement '\n'
        | IF expression '\n'{
            if($2){
                printf("entro al if\n");
            }
        }
        | ELSE expression '\n'{
            if(!$2){
                printf("entro al else\n");
            }
        }
        ;
statement:
        expression                      { printf("%d\n", $1); }
        | VARIABLE '=' expression       { sym[$1] = $3; }
        ;

expression:
        INTEGER                         
        | VARIABLE                      { $$ = sym[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     {
            if ($3 == 0) {
                yyerror ("no se puede dividir con 0"); exit(0);
            }
            else{
                $$ = $1 / $3; 
            }
        }
        | '-' expression %prec UMINUS   { $$ = -$2;}
        | '(' expression ')'            { $$ = $2; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    freopen ("a.txt", "r", stdin);
    yyparse();
}