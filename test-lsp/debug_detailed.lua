vim.defer_fn(function()
  print('=== LSP DEBUG ===')
  print('Working directory: ' .. vim.fn.getcwd())
  
  -- Check if root pattern matches
  local root_pattern = require('lspconfig').util.root_pattern({'deno.json', 'deno.jsonc'})
  local root_result = root_pattern(vim.fn.getcwd())
  print('Deno root pattern result: ' .. vim.inspect(root_result))
  
  local ts_root_pattern = require('lspconfig').util.root_pattern({'package.json', 'tsconfig.json'})
  local ts_root_result = ts_root_pattern(vim.fn.getcwd())
  print('TypeScript root pattern result: ' .. vim.inspect(ts_root_result))
  
  -- Check active clients
  local clients = vim.lsp.get_clients({bufnr = 0})
  print('Active LSP clients: ' .. #clients)
  for _, client in ipairs(clients) do
    print('  - ' .. client.name)
  end
  
  vim.cmd('qa!')
end, 3000)