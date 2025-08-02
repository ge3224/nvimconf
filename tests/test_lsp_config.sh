#!/bin/bash

# Test script for LSP configuration (denols vs ts_ls)
# This script tests that denols only attaches to Deno projects
# and ts_ls only attaches to Node.js projects

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

echo "🧪 Testing LSP Configuration (denols vs ts_ls)"
echo "================================================"
echo "Config directory: $NVIM_CONFIG_DIR"
echo "Test directory: $SCRIPT_DIR"
echo ""

# Function to run test
run_test() {
    local test_name="$1"
    local test_file="$2"
    local expected_lsp="$3"
    
    echo "Testing: $test_name"
    echo "File: $test_file"
    echo "Expected LSP: $expected_lsp"
    
    # Create a temporary lua script to test LSP attachment
    local temp_test_script="/tmp/lsp_test_$$.lua"
    cat > "$temp_test_script" << EOF
-- Wait for LSP to potentially attach, checking multiple times
local attached_lsps = {}
local check_count = 0
local max_checks = 25  -- Check for 5 seconds (25 * 200ms)

local function check_lsp_status()
    check_count = check_count + 1
    local clients = vim.lsp.get_clients({bufnr = 0})
    
    -- Update attached LSPs list
    attached_lsps = {}
    for _, client in ipairs(clients) do
        if client.name == "ts_ls" or client.name == "denols" then
            table.insert(attached_lsps, client.name)
        end
    end
    
    -- If we have LSPs or reached max checks, finish
    if #attached_lsps > 0 or check_count >= max_checks then
        -- Print results in a parseable format  
        if #attached_lsps == 0 then
            print("RESULT:NO_LSP_ATTACHED")
        else
            for _, lsp_name in ipairs(attached_lsps) do
                print("RESULT:LSP_ATTACHED:" .. lsp_name)
            end
        end
        vim.cmd('qall!')
    else
        -- Check again in 200ms
        vim.defer_fn(check_lsp_status, 200)
    end
end

-- Start checking after initial delay
vim.defer_fn(check_lsp_status, 500)

-- Open the test file
vim.cmd('edit $test_file')
EOF
    
    # Run neovim in headless mode with PATH set for Mason binaries  
    local output
    output=$(PATH="$HOME/.local/share/nvim/mason/bin:$PATH" timeout 15s nvim --headless -u "$NVIM_CONFIG_DIR/init.lua" -S "$temp_test_script" 2>&1 || true)
    
    # Clean up temp file
    rm -f "$temp_test_script"
    
    # Parse results
    local attached_lsps=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^RESULT:LSP_ATTACHED:(.+)$ ]]; then
            attached_lsps+=("${BASH_REMATCH[1]}")
        elif [[ "$line" =~ ^RESULT:NO_LSP_ATTACHED$ ]]; then
            echo "  ❌ No LSP attached (expected: $expected_lsp)"
            return 1
        fi
    done <<< "$output"
    
    # Check results
    local found_expected=false
    local found_unexpected=false
    
    for lsp in "${attached_lsps[@]}"; do
        echo "  📎 Attached LSP: $lsp"
        if [[ "$lsp" == "$expected_lsp" ]]; then
            found_expected=true
        elif [[ "$lsp" == "ts_ls" || "$lsp" == "denols" ]]; then
            found_unexpected=true
        fi
    done
    
    if [[ "$found_expected" == true && "$found_unexpected" == false ]]; then
        echo "  ✅ PASS: Only $expected_lsp attached as expected"
        return 0
    elif [[ "$found_expected" == true && "$found_unexpected" == true ]]; then
        echo "  ❌ FAIL: $expected_lsp attached but so did unexpected LSP"
        return 1
    elif [[ "$found_expected" == false ]]; then
        echo "  ❌ FAIL: Expected $expected_lsp but it didn't attach"
        return 1
    fi
}

# Run tests
echo "Starting tests..."
echo ""

total_tests=0
passed_tests=0

# Test 1: Node.js project should use ts_ls
total_tests=$((total_tests + 1))
if run_test "Node.js Project" "$SCRIPT_DIR/node-project/index.ts" "ts_ls"; then
    passed_tests=$((passed_tests + 1))
fi
echo ""

# Test 2: Deno project should use denols  
total_tests=$((total_tests + 1))
if run_test "Deno Project" "$SCRIPT_DIR/deno-project/main.ts" "denols"; then
    passed_tests=$((passed_tests + 1))
fi
echo ""

# Test 3: Mixed project should prefer denols
total_tests=$((total_tests + 1))
if run_test "Mixed Project (should prefer Deno)" "$SCRIPT_DIR/mixed-project/test.ts" "denols"; then
    passed_tests=$((passed_tests + 1))
fi
echo ""

# Summary
echo "================================================"
echo "📊 Test Results: $passed_tests/$total_tests tests passed"

if [[ $passed_tests -eq $total_tests ]]; then
    echo "🎉 All tests passed! LSP configuration is working correctly."
    exit 0
else
    echo "❌ Some tests failed. Check the LSP configuration."
    exit 1
fi