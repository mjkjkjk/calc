%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
int yydebug = 0;
%}

/* tokens */
%token NUMBER
%token PLUS MINUS MULTIPLY DIVIDE
%token LPAREN RPAREN
%token NEWLINE

/* operator precedence and associativity */
%left PLUS MINUS
%left MULTIPLY DIVIDE
%nonassoc NEG   /* negation--unary minus */
%right POWER      /* exponentiation */

%%

/* rules */
input:
    /* empty */
    | input line
    ;

line:
    NEWLINE
    | exp NEWLINE { printf("Result: %d\n", $1); }
    ;

exp:
    NUMBER                    { printf("Found number: %d\n", $1); $$ = $1; }
    | exp PLUS exp           { printf("Adding: %d + %d\n", $1, $3); $$ = $1 + $3; }
    | exp MINUS exp          { printf("Subtracting: %d - %d\n", $1, $3); $$ = $1 - $3; }
    | exp MULTIPLY exp       { printf("Multiplying: %d * %d\n", $1, $3); $$ = $1 * $3; }
    | exp DIVIDE exp         { printf("Dividing: %d / %d\n", $1, $3); $$ = $1 / $3; }
    | exp POWER exp          { 
        printf("Power: %d ** %d\n", $1, $3);
        int result = 1;
        for(int i = 0; i < $3; i++) result *= $1;
        $$ = result;
    }
    | MINUS exp %prec NEG    { printf("Negating: -%d\n", $2); $$ = -$2; }
    | LPAREN exp RPAREN      { printf("Parentheses: (%d)\n", $2); $$ = $2; }
    ;

%%

/* entry point */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yydebug = 1;  // Enable debug output
    printf("Simple Calculator (enter expressions, Ctrl+D to exit):\n");
    return yyparse();
}