%{
#include "calc.h"
#include "../build/calc.tab.h"
#include <stdio.h>
#include <ctype.h>
#include <string.h>
%}

%%
[0-9]+(\.[0-9]+)?    { yylval.num = atof(yytext); return NUMBER; }
"+"       { return PLUS; }
"-"       { return MINUS; }
"**"      { return POWER; }
"*"       { return MULTIPLY; }
"/"       { return DIVIDE; }
"="       { return ASSIGN; }
"("       { return LPAREN; }
")"       { return RPAREN; }
\n        { return NEWLINE; }
[ \t]     ; /* skip whitespace */
"sin"     { return SIN; }
"cos"     { return COS; }
"sqrt"    { return SQRT; }
"log"     { return LOG; }
"abs"     { return ABS; }
[a-zA-Z][a-zA-Z0-9]*   { 
    strncpy(yylval.id, yytext, sizeof(yylval.id) - 1);
    yylval.id[sizeof(yylval.id) - 1] = '\0';
    return IDENTIFIER;
}
.         { printf("Error: Invalid character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
} 