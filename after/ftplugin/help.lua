vim.api.nvim_create_autocmd( "BufEnter", {
  group = vim.api.nvim_create_augroup("HelpFiletype", { clear = true }),
  callback = function(ev)
    local opts = {}

    vim.api.nvim_buf_set_keymap(ev.buf, "n", "q", ":bdelete<CR>", opts)
  end
})