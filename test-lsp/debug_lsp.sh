#!/bin/bash

echo "=== Testing Deno project ==="
cd "/home/ge/Projects/nvimconf/main/test-lsp/deno-project"
pwd
echo "Files in directory:"
ls -la
echo "Running nvim..."
nvim --headless -c 'lua 
vim.defer_fn(function() 
  print("Current working directory: " .. vim.fn.getcwd())
  local clients = vim.lsp.get_clients()
  print("Number of LSP clients: " .. #clients)
  for _, client in ipairs(clients) do 
    print("LSP Client: " .. client.name .. " (root: " .. (client.config.root_dir or "none") .. ")")
  end
  vim.cmd("qa!")
end, 3000)' index.ts

echo ""
echo "=== Testing TypeScript project ==="
cd "/home/ge/Projects/nvimconf/main/test-lsp/typescript-project"
pwd
echo "Files in directory:"
ls -la
echo "Running nvim..."
nvim --headless -c 'lua 
vim.defer_fn(function() 
  print("Current working directory: " .. vim.fn.getcwd())
  local clients = vim.lsp.get_clients()
  print("Number of LSP clients: " .. #clients)
  for _, client in ipairs(clients) do 
    print("LSP Client: " .. client.name .. " (root: " .. (client.config.root_dir or "none") .. ")")
  end
  vim.cmd("qa!")
end, 3000)' index.ts