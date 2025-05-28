CC = gcc
CFLAGS = -Wall
SRC_DIR = src
BUILD_DIR = build
TEST_DIR = test

PARSER = $(BUILD_DIR)/calc.tab.c
PARSER_H = $(BUILD_DIR)/calc.tab.h
LEXER = $(BUILD_DIR)/lex.yy.c
EXECUTABLE = $(BUILD_DIR)/calc

GRAMMAR = $(SRC_DIR)/calc.y
LEXER_SRC = $(SRC_DIR)/calc.l

.PHONY: all clean test

all: $(EXECUTABLE)

$(EXECUTABLE): $(PARSER) $(LEXER)
	$(CC) $(CFLAGS) -o $@ $^

$(PARSER) $(PARSER_H): $(GRAMMAR)
	@mkdir -p $(BUILD_DIR)
	bison -d -o $(PARSER) $<

$(LEXER): $(LEXER_SRC) $(PARSER_H)
	@mkdir -p $(BUILD_DIR)
	flex -o $@ $<

test: $(EXECUTABLE)
	@echo "Running tests..."
	@cd $(TEST_DIR) && ./run_tests.sh

clean:
	rm -rf $(BUILD_DIR)/* 