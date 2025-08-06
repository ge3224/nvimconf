#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"

test_lsp_attachment() {
    local project_type="$1"
    local test_file="$2"
    local expected_lsp="$3"

    echo "Testing $project_type..."

    # Create temp script to check LSP attachment
    local temp_script="/tmp/lsp_check_$$.lua"
    cat > "$temp_script" << 'EOF'
local buf = vim.api.nvim_get_current_buf()
local clients = {}

local function check_clients()
    clients = vim.lsp.get_clients({bufnr = buf})
    local lsp_names = {}
    for _, client in ipairs(clients) do
        if client.name == "ts_ls" or client.name == "denols" then
            table.insert(lsp_names, client.name)
        end
    end

    if #lsp_names > 0 then
        for _, name in ipairs(lsp_names) do
            print("LSP_ATTACHED:" .. name)
        end
        vim.cmd('qall!')
    else
        -- Check again in 500ms, max 20 times (10 seconds)
        if (vim.g.check_count or 0) < 20 then
            vim.g.check_count = (vim.g.check_count or 0) + 1
            vim.defer_fn(check_clients, 500)
        else
            print("LSP_ATTACHED:NONE")
            vim.cmd('qall!')
        end
    end
end

vim.defer_fn(check_clients, 1000)
EOF

    # Run nvim with the test file (ensure Mason binaries are in PATH)
    local output
    cd "$SCRIPT_DIR/.."
    PATH="$HOME/.local/share/nvim/mason/bin:$PATH" output=$(timeout 15s nvim --headless -u init.lua "$test_file" -S "$temp_script" 2>&1 || true)
    rm -f "$temp_script"

    # Check results
    if echo "$output" | grep -q "LSP_ATTACHED:$expected_lsp"; then
        echo "  ✅ $expected_lsp attached correctly"
        return 0
    else
        echo "  ❌ Expected $expected_lsp"
        echo "  Debug output: $output"
        return 1
    fi
}

echo "🧪 LSP Attachment Tests"
echo "======================"

total=0
passed=0

# Test Deno project
total=$((total + 1))
if test_lsp_attachment "Deno project" "$FIXTURES_DIR/deno-project/main.ts" "denols"; then
    passed=$((passed + 1))
fi

# Test Node project
total=$((total + 1))
if test_lsp_attachment "Node project" "$FIXTURES_DIR/node-project/index.ts" "ts_ls"; then
    passed=$((passed + 1))
fi

# Test Mixed project (should prefer Deno when both configs exist)
total=$((total + 1))
if test_lsp_attachment "Mixed project" "$FIXTURES_DIR/mixed-project/test.ts" "denols"; then
    passed=$((passed + 1))
fi

echo "======================"
echo "Result: $passed/$total tests passed"

if [ $passed -eq $total ]; then
    echo "✅ All tests passed!"
    exit 0
else
    echo "❌ Some tests failed"
    exit 1
fi
