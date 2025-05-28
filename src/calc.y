%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.h"

Variable symbol_table[MAX_VARS];
int var_count = 0;

int get_var_value(const char* name) {
    for(int i = 0; i < var_count; i++) {
        if(strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    return 0;  // Return 0 for undefined variables without error
}

void set_var_value(const char* name, int value) {
    for(int i = 0; i < var_count; i++) {
        if(strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    if(var_count < MAX_VARS) {
        strncpy(symbol_table[var_count].name, name, MAX_VAR_NAME - 1);
        symbol_table[var_count].name[MAX_VAR_NAME - 1] = '\0';
        symbol_table[var_count].value = value;
        var_count++;
    } else {
        printf("Error: Too many variables\n");
    }
}

int yylex(void);
void yyerror(const char *s);
int yydebug = 0;
%}

/* tokens */
%union {
    int num;
    char id[MAX_VAR_NAME];
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE ASSIGN
%token LPAREN RPAREN
%token NEWLINE

/* operator precedence and associativity */
%left PLUS MINUS
%left MULTIPLY DIVIDE
%nonassoc NEG   /* negation--unary minus */
%right POWER    /* exponentiation */
%right ASSIGN   /* assignment */

%type <num> exp

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
    NUMBER                    { $$ = $1; }
    | IDENTIFIER             { $$ = get_var_value($1); }
    | IDENTIFIER ASSIGN exp  { 
        set_var_value($1, $3);
        $$ = $3;
    }
    | exp PLUS exp           { $$ = $1 + $3; }
    | exp MINUS exp          { $$ = $1 - $3; }
    | exp MULTIPLY exp       { $$ = $1 * $3; }
    | exp DIVIDE exp         { $$ = $1 / $3; }
    | exp POWER exp          { 
        int result = 1;
        for(int i = 0; i < $3; i++) result *= $1;
        $$ = result;
    }
    | MINUS exp %prec NEG    { $$ = -$2; }
    | LPAREN exp RPAREN      { $$ = $2; }
    ;

%%

/* entry point */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yydebug = 1;  // Enable debug output
    return yyparse();
}