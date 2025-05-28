#ifndef CALC_H
#define CALC_H

#include <math.h>

#define MAX_VARS 100
#define MAX_VAR_NAME 32

typedef struct {
    char name[MAX_VAR_NAME];
    double value;
} Variable;

extern Variable symbol_table[MAX_VARS];
extern int var_count;

double get_var_value(const char* name);
void set_var_value(const char* name, double value);

double calc_sin(double x);
double calc_cos(double x);
double calc_sqrt(double x);
double calc_log(double x);
double calc_abs(double x);

#endif 