%{
#include "../build/calc.tab.h"
#include <stdio.h>
#include <ctype.h>
%}

%%
[0-9]+/[^a-zA-Z]    { yylval = atoi(yytext); return NUMBER; }
[0-9]+[a-zA-Z]      { printf("Error: Invalid number format: %s\n", yytext); }
"+"         { return PLUS; }
"-"         { return MINUS; }
"**"        { return POWER; }
"*"         { return MULTIPLY; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
\n          { return NEWLINE; }
[ \t]       ; /* skip whitespace */
[a-zA-Z][a-zA-Z0-9]*   { printf("Error: Variables not supported: %s\n", yytext); }
.           { printf("Error: Invalid character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
} 