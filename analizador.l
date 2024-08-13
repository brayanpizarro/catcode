%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%
[a-z]           {
                yylval = *yytext - 'a';
                return VARIABLE;
                }
                
[-]?[0-9]+      {yylval = atoi(yytext);
                return INTEGER;
                }
                
"=="            { return '='; }
"<="            { return '<'; }
">="            { return '>'; }
"<"             { return '<'; }
">"             { return '>'; }

[-+()=/*\n]     { return *yytext; }

[ \t]   ;    

.               yyerror("el caracter ingresado no es reconido");

"GATITO"  {return IF; }
"GATOTE"  {return ELSE; }

%%

int yywrap(void) {
    return 1;
}