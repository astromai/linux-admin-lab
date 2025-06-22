#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>  
#include "builtins.h"

void show_prompt() {
    printf("radix> ");
    fflush(stdout);
}

char* read_input() {
    char *line = NULL;
    size_t len = 0;
    ssize_t nread = getline(&line, &len, stdin);
    
    if (nread == -1) {
        free(line);
        return NULL;
    }
    
    if (nread > 0 && line[nread-1] == '\n') {
        line[nread-1] = '\0';
    }
    
    return line;
}

char** parse_command(char* buf) {
    if (buf == NULL || strlen(buf) == 0) {
        return NULL;
    }

    int capacity = 10;
    int size = 0;
    char** tokens = malloc(capacity * sizeof(char*));
    if (!tokens) return NULL;
    
    char* token = strtok(buf, " ");
    while (token != NULL) {
        tokens[size++] = token;
        
        if (size >= capacity) {
            capacity *= 2;
            char** new_tokens = realloc(tokens, capacity * sizeof(char*));
            if (!new_tokens) {
                free(tokens);
                return NULL;
            }
            tokens = new_tokens;
        }
        
        token = strtok(NULL, " ");
    }
    
    tokens[size] = NULL;
    return tokens;
}

void execute_command(char** args) {
    if (args == NULL || args[0] == NULL) {
        return;
    }

    if (is_builtin(args[0])) {
        handle_builtin(args);
        return;
    }

    pid_t pid = fork();
    
    if (pid == 0) {
        execvp(args[0], args);
        fprintf(stderr, "Error ejecutando '%s': ", args[0]);
        perror("");
        exit(EXIT_FAILURE);
    } else if (pid > 0) {
        wait(NULL);
    } else {
        perror("fork failed");
    }
}

int main() {
    while (1) {
        show_prompt();
        char* input = read_input();
        if (!input) {
            printf("\n");
            break;
        }
        
        add_to_history(input);  

        char** args = parse_command(input);
        if (args) {
            execute_command(args);
            free(args);
        }
        free(input);
    }
    
    free_history();
    return 0;
}