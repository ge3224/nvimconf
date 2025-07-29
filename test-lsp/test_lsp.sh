#!/bin/bash

# ts_ls should only start for projects with package.json/tsconfig.json and not
# for projects with deno.json, while denols should only start for projects with
# deno.json/deno.jsonc.

echo "Testing Deno project LSP attachment..."
cd "/home/ge/Projects/nvimconf/main/test-lsp/deno-project"
nvim --headless -c 'lua vim.defer_fn(function() local clients = vim.lsp.get_clients({bufnr = 0}); for _, client in ipairs(clients) do print("LSP Client attached to buffer: " .. client.name) end; vim.cmd("qa!") end, 2000)' index.ts

echo ""
echo "Testing TypeScript project LSP attachment..."
cd "/home/ge/Projects/nvimconf/main/test-lsp/typescript-project"
nvim --headless -c 'lua vim.defer_fn(function() local clients = vim.lsp.get_clients({bufnr = 0}); for _, client in ipairs(clients) do print("LSP Client attached to buffer: " .. client.name) end; vim.cmd("qa!") end, 2000)' index.ts
