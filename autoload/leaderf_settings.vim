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

" Powerline
function! s:InitPowerlineStyles() abort
    let s:powerline_separator_styles = {
                \ '><': { 'left': "\ue0b0", 'right': "\ue0b2" },
                \ '>(': { 'left': "\ue0b0", 'right': "\ue0b6" },
                \ '>\': { 'left': "\ue0b0", 'right': "\ue0be" },
                \ '>/': { 'left': "\ue0b0", 'right': "\ue0ba" },
                \ ')(': { 'left': "\ue0b4", 'right': "\ue0b6" },
                \ ')<': { 'left': "\ue0b4", 'right': "\ue0b2" },
                \ ')\': { 'left': "\ue0b4", 'right': "\ue0be" },
                \ ')/': { 'left': "\ue0b4", 'right': "\ue0ba" },
                \ '\\': { 'left': "\ue0b8", 'right': "\ue0be" },
                \ '\/': { 'left': "\ue0b8", 'right': "\ue0ba" },
                \ '\<': { 'left': "\ue0b8", 'right': "\ue0b2" },
                \ '\(': { 'left': "\ue0b8", 'right': "\ue0b6" },
                \ '//': { 'left': "\ue0bc", 'right': "\ue0ba" },
                \ '/\': { 'left': "\ue0bc", 'right': "\ue0be" },
                \ '/<': { 'left': "\ue0bc", 'right': "\ue0b2" },
                \ '/(': { 'left': "\ue0bc", 'right': "\ue0b6" },
                \ '||': { 'left': '', 'right': '' },
                \ }

    call extend(s:powerline_separator_styles, {
                \ 'default': copy(s:powerline_separator_styles['><']),
                \ 'angle':   copy(s:powerline_separator_styles['><']),
                \ 'curvy':   copy(s:powerline_separator_styles[')(']),
                \ 'slant':   copy(s:powerline_separator_styles['//']),
                \ })
endfunction

function! s:Rand() abort
    return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
endfunction

function! s:GetStyle(style) abort
    if type(a:style) == type([])
        let l:style = get(a:style, 0, 'default')
    elseif type(a:style) == type('')
        let l:style = a:style
    else
        let l:style = 'default'
    endif

    if empty(l:style)
        let l:style = 'default'
    endif

    if l:style ==? 'random'
        let l:style = keys(s:powerline_separator_styles)[s:Rand() % len(s:powerline_separator_styles)]
    endif

    return l:style
endfunction

function! leaderf_settings#GetPowerlineSeparator(style) abort
    call s:InitPowerlineStyles()

    let l:style = s:GetStyle(a:style)

    return get(s:powerline_separator_styles, l:style, s:powerline_separator_styles['default'])
endfunction
