return {
  "theprimeagen/harpoon",
  config = function()
    require("harpoon").setup()

    vim.keymap.set("n", "<leader>m", function()
      require("harpoon.mark").add_file()
    end, { desc = "Add file to Harpoon list." })

    vim.keymap.set("n", "<leader>ml", function()
      require("harpoon.ui").toggle_quick_menu()
    end, { desc = "View Harpoon list." })

    -- Set <leader>m1..<leader>m5 to be my shortcuts to moving to the files
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      vim.keymap.set("n", string.format("<leader>m%d", idx), function()
        require("harpoon.ui").nav_file(idx)
      end)
    end
  end,
}
