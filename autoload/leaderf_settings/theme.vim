" Theme mappings
let s:Lf_ColorschemeMappings = extend({
            \ '^\(solarized\|soluarized\|flattened\)': 'solarized',
            \ '^gruvbox': 'gruvbox_material',
            \ }, get(g:, 'Lf_ColorschemeMappings', {}))

function! s:LoadTheme() abort
    if !exists('s:Lf_Colorschemes')
        let s:Lf_Colorschemes = map(split(globpath(&rtp, 'autoload/leaderf/colorscheme/*.vim')), "fnamemodify(v:val, ':t:r')")
        let s:Lf_Colorschemes = filter(copy(s:Lf_Colorschemes), 'v:val != "popup"')
    endif
endfunction

function! s:FindTheme() abort
    let g:Lf_StlColorscheme = substitute(get(g:, 'colors_name', 'default'), '[ -]', '_', 'g')
    if index(s:Lf_Colorschemes, g:Lf_StlColorscheme) > -1
        return
    endif

    for [l:pattern, l:theme] in items(s:Lf_ColorschemeMappings)
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
    let g:Lf_StlColorscheme = a:theme
    let l:theme_path = findfile(printf('autoload/leaderf/colorscheme/%s.vim', a:theme), &rtp)
    execute 'source ' . l:theme_path
    call leaderf#colorscheme#highlight('File', 0)
    if exists('g:Lf_File_StlMode')
        call leaderf#colorscheme#highlightMode('File', g:Lf_File_StlMode)
    endif
    call leaderf#colorscheme#highlightBlank('File', 0)
endfunction

function! leaderf_settings#theme#Apply() abort
    call s:LoadTheme()
    call s:FindTheme()
    call leaderf_settings#theme#Set(g:Lf_StlColorscheme)
endfunction

function! leaderf_settings#theme#Init() abort
    if has('vim_starting') && exists('g:Lf_StlColorscheme') && g:Lf_StlColorscheme ==# 'default'
        call s:LoadTheme()
        call s:FindTheme()
        if g:Lf_StlColorscheme !=# 'default'
            call leaderf_settings#theme#Set(g:Lf_StlColorscheme)
        endif
    elseif !exists('g:Lf_StlColorscheme')
        call leaderf_settings#theme#Apply()
    endif
endfunction
