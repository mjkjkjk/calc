#ifndef CALC_H
#define CALC_H

#define MAX_VARS 100
#define MAX_VAR_NAME 32

typedef struct {
    char name[MAX_VAR_NAME];
    int value;
} Variable;

extern Variable symbol_table[MAX_VARS];
extern int var_count;

int get_var_value(const char* name);
void set_var_value(const char* name, int value);

#endif 