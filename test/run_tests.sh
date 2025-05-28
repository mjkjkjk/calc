#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CALC="../build/calc"
CASES_DIR="cases"
TOTAL_TESTS=0
PASSED_TESTS=0

if [ ! -f "$CALC" ]; then
    echo -e "${RED}Error: Calculator executable not found at $CALC${NC}"
    echo "Run 'make' first"
    exit 1
fi

run_test_file() {
    local file=$1
    echo -e "\n${YELLOW}Running tests from: $file${NC}"
    echo "------------------------"
    
    while IFS= read -r line || [ -n "$line" ]; do
        # skip comments and empty lines
        [[ $line =~ ^#.*$ || -z $line ]] && continue
        
        # check if line contains expected result
        if [[ $line =~ = ]]; then
            # split input and expected result
            input=$(echo "$line" | cut -d'=' -f1 | xargs)
            expected=$(echo "$line" | cut -d'=' -f2 | xargs)
            
            echo -n "Testing: $line -> "
            result=$(echo "$input" | $CALC 2>&1)
            actual=$(echo "$result" | grep "Result:" | cut -d':' -f2 | xargs)
            
            if [ "$actual" = "$expected" ]; then
                echo -e "${GREEN}PASS${NC}"
                ((PASSED_TESTS++))
            else
                echo -e "${RED}FAIL${NC} (Expected: $expected, Got: $actual)"
            fi
        else
            # error case - no expected result
            echo -n "Testing: $line -> "
            result=$(echo "$line" | $CALC 2>&1)
            
            if echo "$result" | grep -q "Error"; then
                echo -e "${GREEN}PASS${NC} (Expected error)"
                ((PASSED_TESTS++))
            else
                echo -e "${RED}FAIL${NC} (Expected error, got result)"
            fi
        fi
        ((TOTAL_TESTS++))
    done < "$file"
}

echo "Running calculator tests..."
echo "------------------------"

# Run all test files
for test_file in "$CASES_DIR"/*.txt; do
    run_test_file "$test_file"
done

echo -e "\n${YELLOW}Test Summary:${NC}"
echo "------------------------"
echo -e "Total tests: ${TOTAL_TESTS}"
echo -e "Passed: ${GREEN}${PASSED_TESTS}${NC}"
echo -e "Failed: ${RED}$((TOTAL_TESTS - PASSED_TESTS))${NC}"
echo "------------------------" 