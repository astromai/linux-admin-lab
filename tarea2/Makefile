CC = gcc
CFLAGS = -Wall -Wextra -std=c11
SRC = shell.c builtins.c 
OUT = shell

all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)  # Ahora compila ambos .c

run: $(OUT)
	./$(OUT)

clean:
	rm -f $(OUT)