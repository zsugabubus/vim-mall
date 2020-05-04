" LICENSE: GPLv3 or later
" AUTHOR: zsugabubus
function! s:noop(mode) abort
endfunction
function! mall#align(mode) abort
	let view = winsaveview()
	let start_lnum = line("'<")
	let end_lnum = line("'>")
	let pos = {}
	let prevpos = {}

	for lnum in range(start_lnum, end_lnum)
		let prevpos[lnum] = [0, 0, 0, 1]
	endfor

	set opfunc=<SID>noop

	let g:mall_count = 3
	for iter in range(1, get(g:, 'mall_count', 1))
		echom iter ' >>> ' string(prevpos)
		for [lnum, lpos] in items(prevpos)
			let col = lpos[3]
			while 1
				call cursor(lnum, col)
				if col('.') !=# col
					break
				endif

				let ok = 0
				execute "normal! .:let ok = 1\<CR>"
				let [olnum, ocol] = [line("']"), col("']")]

				echom '  ' lnum ':' col ' -> ' olnum ':' ocol  ' ' ok
				if !ok || olnum !=# lnum
					break
				endif

				" Not moved, but succeed.
				if ocol ==# col
					let col += 1
					continue
				endif
				let col = ocol

				let skip = synIDattr(synIDtrans(synID(lnum, col, 1)), "name") =~? 'comment|string'
				if skip
					continue
				endif

				let line = strpart(getline(lnum), 0, col - 1)
				let lastchar = matchstr(line, '\m\W$')
				if !empty(lastchar)
					if !exists('fillchar')
						let fillchar = lastchar
					elseif fillchar !=# lastchar
						let fillchar = !&expandtab ? ' ' : "\t"
					endif
				endif

				" [position of text, text, negative text offset (over target col), target col]
				let pos[lnum] = [0, line, 0, col]
				break
			endwhile
		endfor
		if !exists('fillchar')
			let fillchar = !&expandtab ? ' ' : "\t"
		endif

		echom iter ' <<< ' string(pos)

		let pat = '\v^(.{-})(['.escape("\t ".fillchar, '\').']*)$'
		for [lnum, info] in items(pos)
			let [_, left, fill; _] = matchlist(info[1], pat)
			echom string(info)
			let info[0] = strdisplaywidth(left, 0) + 1 " The left most column where [3] can be.
			let info[1] = fill
			let info[3] = info[0] + strdisplaywidth(fill, info[0] - 1) " Column number (1-based)
			echom left . 'x'.fill.'y' .string(info)

			if !exists('mostleft')
				let mostleft = info[0]
			elseif mostleft <# info[0]
				let mostleft = info[0]
			endif
		endfor

		let ok = !exists('mostleft')
		while !ok
			echom 'Before' mostleft string(pos)
			let ok = 1
			for [lnum, info] in items(pos)
				while info[0] <# mostleft
					let [_, head, tail; _] = matchlist(info[1].fillchar, '\v\C^(.)(.*)$')
					let info[0] += strdisplaywidth(head, info[0] - 1)
					let info[1] = tail
					if info[3] <# info[0]
						let info[2] += 1
					endif
				endwhile
				if mostleft <# info[0]
					let mostleft = info[0]
					let ok = 0
					break
				endif
			endfor
		endwhile

		echom 'After' string(pos)
		let cmd = ''
		for [lnum, info] in items(pos)
			if info[3] <# info[0]
				let cmd .= lnum.'G'.info[3].'|'.info[2].'i'.fillchar."\<Esc>"
			elseif info[0] <# info[3]
				let cmd .= lnum.'G'.info[3].'|d'.info[0].'|'
			endif
		endfor
		let prevpos = pos
		let pos = {}
		unlet fillchar
	endfor

	noautocmd silent! execute "normal! :set noro\<CR>" cmd ':let &ro='.&ro."\<CR>"

	set opfunc=g:Mall
	call winrestview(view)
endfunction
