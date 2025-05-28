%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "calc.h"

Variable symbol_table[MAX_VARS];
int var_count = 0;

double get_var_value(const char* name) {
    for(int i = 0; i < var_count; i++) {
        if(strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    return 0.0;  // Return 0 for undefined variables without error
}

void set_var_value(const char* name, double value) {
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

double calc_sin(double x) { return sin(x); }
double calc_cos(double x) { return cos(x); }
double calc_sqrt(double x) { return sqrt(x); }
double calc_log(double x) { return log(x); }
double calc_abs(double x) { return fabs(x); }

int yylex(void);
void yyerror(const char *s);
int yydebug = 0;
%}

/* tokens */
%union {
    double num;
    char id[MAX_VAR_NAME];
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE ASSIGN
%token LPAREN RPAREN
%token NEWLINE
%token SIN COS SQRT LOG ABS

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
    | exp NEWLINE { printf("Result: %g\n", $1); }
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
    | exp POWER exp          { $$ = pow($1, $3); }
    | MINUS exp %prec NEG    { $$ = -$2; }
    | LPAREN exp RPAREN      { $$ = $2; }
    | SIN LPAREN exp RPAREN  { $$ = calc_sin($3); }
    | COS LPAREN exp RPAREN  { $$ = calc_cos($3); }
    | SQRT LPAREN exp RPAREN { $$ = calc_sqrt($3); }
    | LOG LPAREN exp RPAREN  { $$ = calc_log($3); }
    | ABS LPAREN exp RPAREN  { $$ = calc_abs($3); }
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