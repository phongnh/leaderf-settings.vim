function! s:FindTheme() abort
    let g:Lf_StlColorscheme = substitute(g:colors_name, '[ -]', '_', 'g')
    if index(s:Lf_Colorschemes, g:Lf_StlColorscheme) > -1
        return
    endif

    for [l:pattern, l:theme] in items(g:Lf_ColorschemeMappings)
        if match(g:Lf_StlColorscheme, l:pattern) > -1 && index(s:Lf_Colorschemes, l:theme) > -1
            let g:Lf_StlColorscheme = l:theme
            return
        endif
    endfor

    let g:Lf_StlColorscheme = 'default'
endfunction

function! leaderf_settings#theme#List(...) abort
    return join(s:Lf_Colorschemes, "\n")
endfunction

function! leaderf_settings#theme#Set(theme) abort
    let l:theme_path = findfile(printf('autoload/leaderf/colorscheme/%s.vim', a:theme), &rtp)
    execute 'source ' . l:theme_path
    let g:Lf_StlColorscheme = a:theme
    call leaderf#colorscheme#highlight('File', bufname('LeaderF') > -1 ? bufname('LeaderF') : 0)
endfunction

function! leaderf_settings#theme#Apply() abort
    call s:FindTheme()
    call leaderf_settings#theme#Set(g:Lf_StlColorscheme)
endfunction

function! leaderf_settings#theme#Init() abort
    if !exists('s:Lf_Colorschemes')
        let s:Lf_Colorschemes = map(split(globpath(&rtp, 'autoload/leaderf/colorscheme/*.vim')), "fnamemodify(v:val, ':t:r')")
        let s:Lf_Colorschemes = filter(copy(s:Lf_Colorschemes), 'v:val != "popup"')
    endif

    if !exists('g:Lf_StlColorscheme')
        call s:FindTheme()
        if g:Lf_StlColorscheme !=# 'default'
            call leaderf_settings#theme#Set(g:Lf_StlColorscheme)
        endif
    endif
endfunction
