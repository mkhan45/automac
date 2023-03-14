if exists("g:loaded_automac")
    finish
endif
let g:loaded_automac = 1

command! AutomacSynthesize lua require'automac'.synthesize()
command! AutomacAddInput lua require'automac'.add_input(vim.fn.getreg('"'))
command! AutomacAddOutput lua require'automac'.add_output(vim.fn.getreg('"'))
command! AutomacRun lua vim.fn.setreg('"', require'automac'.run(vim.fn.getreg('"')))
command! AutomacClear lua require'automac'.clear()

vnoremap <leader>ai y:AutomacAddInput<cr>
vnoremap <leader>ao y:AutomacAddOutput<cr>
nnoremap <leader>S :AutomacSynthesize<cr>
nnoremap <leader>C :AutomacClear<cr>
vnoremap <leader>ar y:AutomacRun<cr>
vnoremap <leader>arr y:AutomacRun<cr>gvp
