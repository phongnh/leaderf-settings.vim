function! s:LoadTheme() abort
    if !exists('s:Lf_PopupColorschemes')
        let s:Lf_PopupColorschemes = map(split(globpath(&rtp, 'autoload/leaderf/colorscheme/popup/*.vim')), "fnamemodify(v:val, ':t:r')")
    endif
endfunction

function! s:FindTheme() abort
    let g:Lf_PopupColorscheme = substitute(get(g:, 'colors_name', 'default'), '[ -]', '_', 'g')
    if index(s:Lf_PopupColorschemes, g:Lf_PopupColorscheme) > -1
        return
    endif

    for [l:pattern, l:theme] in items(g:Lf_PopupColorschemeMappings)
        if match(g:Lf_PopupColorscheme, l:pattern) > -1 && index(s:Lf_PopupColorschemes, l:theme) > -1
            let g:Lf_PopupColorscheme = l:theme
            return
        endif
    endfor

    let g:Lf_PopupColorscheme = 'default'
endfunction

function! leaderf_settings#popup#List(...) abort
    return join(s:Lf_PopupColorschemes, "\n")
endfunction

function! leaderf_settings#popup#Set(theme) abort
    let g:Lf_PopupColorscheme = a:theme
    call leaderf#colorscheme#popup#load('File', g:Lf_PopupColorscheme)
endfunction

function! leaderf_settings#popup#Apply() abort
    call s:LoadTheme()
    call s:FindTheme()
    call leaderf_settings#popup#Set(g:Lf_PopupColorscheme)
endfunction

function! leaderf_settings#popup#Init() abort
    if has('vim_starting') && exists('g:Lf_PopupColorscheme') && g:Lf_PopupColorscheme ==# 'default'
        call s:LoadTheme()
        call s:FindTheme()
        if g:Lf_PopupColorscheme !=# 'default'
            call leaderf_settings#popup#Set(g:Lf_PopupColorscheme)
        endif
    elseif !exists('g:Lf_PopupColorscheme')
        call leaderf_settings#popup#Apply()
    endif
endfunction
