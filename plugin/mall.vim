" LICENSE: GPLv3 or later
" AUTHOR: zsugabubus
if !hasmapto('<Plug>(MallAlign)')
	vmap <silent><unique> gl <Plug>(MallAlign)
endif

silent! vnoremap <silent><unique> <Plug>(MallAlign) :<C-U>let mall_count = v:count1<CR>:<C-U>set opfunc=mall#align<CR>g@
silent! vmap <silent><unique> <Plug>(MallAlign)/ <Plug>(MallAlign)v/
silent! vmap <silent><unique> <Plug>(MallAlign): <Plug>(MallAlign)f:
silent! vmap <silent><unique> <Plug>(MallAlign)= <Plug>(MallAlign)f=
silent! vmap <silent><unique> <Plug>(MallAlign), <Plug>(MallAlign)f,
silent! vmap <silent><unique> <Plug>(MallAlign)<Tab> <Plug>(MallAlign)f<Tab>
silent! vmap <silent><unique> <Plug>(MallAlign)<Space> <Plug>(MallAlign)f<Space>
silent! vmap <silent><unique> <Plug>(MallAlign)<bar> <Plug>(MallAlign)f<bar>
silent! vmap <silent><unique> <Plug>(MallAlign)& <Plug>(MallAlign)f&
silent! vmap <silent><unique> <Plug>(MallAlign)\ <Plug>(MallAlign)f\
