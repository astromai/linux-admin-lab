#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stddef.h>
#include "builtins.h"

#define MAX_HISTORY 100

static char* history[MAX_HISTORY] = {NULL};
static int history_count = 0;

int is_builtin(const char* cmd) {
    const char* builtins[] = {"cd", "exit", "pwd", "export", "unset", "history"};
    for (int i = 0; i < 6; i++) {
        if (strcmp(cmd, builtins[i]) == 0) return 1;
    }
    return 0;
}

void handle_builtin(char** args) {
    if (!args || !args[0]) return;

    if (strcmp(args[0], "history") == 0) {
        for (int i = 0; i < history_count; i++) {
            if (history[i]) printf("%d: %s\n", i+1, history[i]);
        }
        return;
    }

    if (strcmp(args[0], "cd") == 0) builtin_cd(args);
    else if (strcmp(args[0], "exit") == 0) builtin_exit(args);
    else if (strcmp(args[0], "pwd") == 0) builtin_pwd(args);
    else if (strcmp(args[0], "export") == 0) builtin_export(args);
    else if (strcmp(args[0], "unset") == 0) builtin_unset(args);
    else if (strcmp(args[0], "history") == 0) {
        printf("DEBUG: Entrando a builtin_history\n");
        builtin_history();
        return;
    }

}

void builtin_cd(char** args) {
    if (args[1] == NULL) {
        fprintf(stderr, "cd: missing argument\n");
    } else if (chdir(args[1]) != 0) {
        perror("cd failed");
    }
}

void builtin_exit(char** args) {
    int status = 0;
    if (args[1] != NULL) status = atoi(args[1]);
    exit(status);
}

void builtin_pwd(char** args) {
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("%s\n", cwd);
    } else {
        perror("pwd failed");
    }
}

void builtin_export(char** args) {
    if (args[1] == NULL) return;
    char* name = args[1];
    char* value = strchr(name, '=');
    if (value) {
        *value = '\0';
        setenv(name, value + 1, 1);
    }
}

void builtin_unset(char** args) {
    if (args[1] == NULL) return;
    unsetenv(args[1]);
}

void builtin_history(void) {
    printf("builtin");
    for (int i = 0; i < history_count; i++) {
        if (history[i]) {
            printf("%d: %s\n", i + 1, history[i]);
        }
    }
}

void free_history() {
    for (int i = 0; i < history_count; i++) {
        free(history[i]);
    }
}

void add_to_history(const char* line) {
    if (line && history_count < MAX_HISTORY) {
        history[history_count] = strdup(line);
        if (!history[history_count]) {
            perror("strdup failed");
            return;
        }
        history_count++;
    }
}