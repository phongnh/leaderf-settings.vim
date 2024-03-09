function! leaderf_settings#LeaderfFileRoot() abort
    try
        let current = get(g:, 'Lf_WorkingDirectoryMode', 'c')
        let g:Lf_WorkingDirectoryMode = 'AF'
        :LeaderfFile
    finally
        let g:Lf_WorkingDirectoryMode = current
    endtry
endfunction

function! leaderf_settings#LeaderfFileAll(dir) abort
    try
        let g:Lf_ExternalCommand = g:Lf_FindAllCommand
        execute 'LeaderfFile' a:dir
    finally
        let g:Lf_ExternalCommand = g:Lf_FindCommand
    endtry
endfunction

" Themes
function! leaderf_settings#FindLeaderfColorschemes() abort
    let s:Lf_Colorschemes = map(split(globpath(&rtp, 'autoload/leaderf/colorscheme/*.vim')), "fnamemodify(v:val, ':t:r')")
    let s:Lf_ColorschemesCompletion = join(s:Lf_Colorschemes, "\n")
    let s:Lf_PopupColorschemes = map(split(globpath(&rtp, 'autoload/leaderf/colorscheme/popup/*.vim')), "fnamemodify(v:val, ':t:r')")
    let s:Lf_PopupColorschemesCompletion = join(s:Lf_PopupColorschemes, "\n")
endfunction

function! leaderf_settings#ListLeaderfColorschemes(...) abort
    return s:Lf_ColorschemesCompletion
endfunction

function! leaderf_settings#ListLeaderfPopupColorschemes(...) abort
    return s:Lf_PopupColorschemesCompletion
endfunction

function! leaderf_settings#SetLeaderfColorscheme(colorscheme) abort
    if index(s:Lf_Colorschemes, a:colorscheme) < 0
        return
    endif

    " Reload colorscheme palette
    let l:colorscheme_path = findfile(printf('autoload/leaderf/colorscheme/%s.vim', a:colorscheme), &rtp)
    if !empty(l:colorscheme_path) && filereadable(l:colorscheme_path)
        execute 'source ' . l:colorscheme_path
    endif

    let g:Lf_StlColorscheme = a:colorscheme
    call leaderf#colorscheme#highlight('File', 0)
endfunction

function! leaderf_settings#SetLeaderfPopupColorscheme(colorscheme) abort
    if index(s:Lf_PopupColorschemes, a:colorscheme) < 0
        return
    endif

    if !exists('*g:LfDefineDefaultColors')
        let g:Lf_PopupColorscheme = a:colorscheme
        return
    endif

    " Reload popup colorscheme palette
    " let l:colorscheme_path = findfile(printf('autoload/leaderf/colorscheme/popup/%s.vim', a:colorscheme), &rtp)
    " if !empty(l:colorscheme_path) && filereadable(l:colorscheme_path)
    "     " echomsg 'source ' . l:colorscheme_path
    "     " execute 'source ' . l:colorscheme_path
    " endif

    let g:Lf_PopupColorscheme = a:colorscheme
    call leaderf#colorscheme#popup#load('File', g:Lf_PopupColorscheme)
endfunction

function! leaderf_settings#SetLeaderfTheme(colorscheme, popup_colorscheme) abort
    call leaderf_settings#SetLeaderfColorscheme(a:colorscheme)
    call leaderf_settings#SetLeaderfPopupColorscheme(a:popup_colorscheme)
endfunction

function! leaderf_settings#BuildColorscheme() abort
    let l:original_colorscheme = get(g:, 'colors_name', '')
    if has('vim_starting') && exists('g:Lf_StlColorscheme')
        let l:original_colorscheme = g:Lf_StlColorscheme
    endif

    if l:original_colorscheme =~ 'solarized\|soluarized\|flattened'
        let l:original_colorscheme = 'solarized'
    endif

    let l:colorscheme = l:original_colorscheme

    if l:colorscheme ==# 'gruvbox' || l:colorscheme =~ 'gruvbox8'
        " let l:colorscheme = 'gruvbox_material'
        let l:colorscheme = 'default'
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = tolower(l:original_colorscheme)
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = substitute(l:original_colorscheme, '-', '_', 'g')
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = substitute(l:original_colorscheme, '-', '', 'g')
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = 'default'
    endif

    return l:colorscheme
endfunction

function! leaderf_settings#BuildPopupColorscheme() abort
    let l:colorscheme = get(g:, 'colors_name', '')
    if has('vim_starting') && exists('g:Lf_PopupColorscheme')
        let l:colorscheme = g:Lf_PopupColorscheme
    endif

    if l:colorscheme =~ 'solarized\|soluarized\|flattened'
        let l:colorscheme = 'solarized'
    endif

    if l:colorscheme ==# 'gruvbox' || l:colorscheme =~ 'gruvbox8'
        " let l:colorscheme = 'gruvbox_default'
        " let l:colorscheme = 'gruvbox_material'
        let l:colorscheme = 'default'
    endif

    if index(s:Lf_PopupColorschemes, l:colorscheme) < 0
        let l:colorscheme = tolower(l:colorscheme)
    endif

    if index(s:Lf_PopupColorschemes, l:colorscheme) < 0
        let l:colorscheme = substitute(l:colorscheme, '-', '_', 'g')
    endif

    if index(s:Lf_PopupColorschemes, l:colorscheme) < 0
        let l:colorscheme = 'default'
    endif

    return l:colorscheme
endfunction

function! leaderf_settings#ReloadLeaderfTheme() abort
    let l:colorscheme = leaderf_settings#BuildColorscheme()
    let l:popup_colorscheme = leaderf_settings#BuildPopupColorscheme()

    call leaderf_settings#SetLeaderfTheme(l:colorscheme, l:popup_colorscheme)
endfunction
