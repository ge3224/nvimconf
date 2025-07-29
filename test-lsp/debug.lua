local util = require('lspconfig.util')

print("=== Debugging LSP Root Dir Detection ===")

-- Test from deno project
local deno_file = "/home/ge/Projects/nvimconf/main/test-lsp/deno-project/index.ts"
local deno_pattern = util.root_pattern('deno.json', 'deno.jsonc')(deno_file)
local ts_pattern_from_deno = util.root_pattern('package.json', 'tsconfig.json')(deno_file)

print("Deno project file:", deno_file)
print("Deno pattern result:", deno_pattern)
print("TS pattern result from deno:", ts_pattern_from_deno)
print("")

-- Test from typescript project
local ts_file = "/home/ge/Projects/nvimconf/main/test-lsp/typescript-project/index.ts"
local deno_pattern_from_ts = util.root_pattern('deno.json', 'deno.jsonc')(ts_file)
local ts_pattern = util.root_pattern('package.json', 'tsconfig.json')(ts_file)

print("TypeScript project file:", ts_file)
print("Deno pattern result from ts:", deno_pattern_from_ts)
print("TS pattern result:", ts_pattern)

vim.cmd('qa!')