#ifndef BUILTINS_H
#define BUILTINS_H

int is_builtin(const char* cmd);
void handle_builtin(char** args);
void builtin_history(void);
void free_history();


void builtin_cd(char** args);
void builtin_exit(char** args);
void builtin_pwd(char** args);
void builtin_export(char** args);
void builtin_unset(char** args);
void add_to_history(const char* line);
#endif