# Simple Calculator

A command-line calculator built with Flex and Bison, with the objective of learning a bit about these tools.

## Features
- Basic arithmetic (+, -, *, /)
- Power operator (**)
- Parentheses
- Negative numbers
- Error handling

## Build
```bash
make
```

## Run
```bash
./build/calc
```

## Test
```bash
make test
```

## Project Structure
```
.
├── src/           # Source files
│   ├── calc.l     # Lexer
│   └── calc.y     # Parser
├── build/         # Generated files
├── test/          # Test files
│   └── cases/     # Test cases by category
└── Makefile
```
