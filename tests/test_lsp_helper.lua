-- LSP attachment test helper
local M = {}

local attached_clients = {}

-- Hook into LSP attach event
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      table.insert(attached_clients, {
        name = client.name,
        buffer = event.buf,
        file = vim.api.nvim_buf_get_name(event.buf)
      })
    end
  end,
})

function M.get_attached_clients()
  return attached_clients
end

function M.clear_attached_clients()
  attached_clients = {}
end

function M.test_file(filepath)
  -- Clear previous results
  M.clear_attached_clients()
  
  -- Open the file
  vim.cmd('edit ' .. filepath)
  
  -- Wait a bit for LSP to potentially attach
  vim.wait(2000, function()
    return #attached_clients > 0
  end)
  
  -- Return results
  return M.get_attached_clients()
end

function M.run_tests()
  local results = {}
  local test_files = {
    {
      name = "Node.js project",
      file = vim.fn.expand('~/.config/nvim/tests/node-project/index.ts'),
      expected = "ts_ls"
    },
    {
      name = "Deno project", 
      file = vim.fn.expand('~/.config/nvim/tests/deno-project/main.ts'),
      expected = "denols"
    },
    {
      name = "Mixed project (should prefer Deno)",
      file = vim.fn.expand('~/.config/nvim/tests/mixed-project/test.ts'),
      expected = "denols"
    }
  }
  
  for _, test in ipairs(test_files) do
    local clients = M.test_file(test.file)
    local found_expected = false
    local found_unexpected = false
    
    for _, client in ipairs(clients) do
      if client.name == test.expected then
        found_expected = true
      elseif client.name == "ts_ls" or client.name == "denols" then
        found_unexpected = true
      end
    end
    
    table.insert(results, {
      test = test.name,
      file = test.file,
      expected = test.expected,
      found_expected = found_expected,
      found_unexpected = found_unexpected,
      clients = clients,
      status = found_expected and not found_unexpected and "PASS" or "FAIL"
    })
  end
  
  return results
end

return M