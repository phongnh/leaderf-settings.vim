function! s:InitPowerlineStyles() abort
    if exists('s:powerline_separator_styles')
        return
    endif

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

function! leaderf_settings#powerline#SetSeparators(style) abort
    call s:InitPowerlineStyles()

    let l:style = 'default'

    if type(a:style) == v:t_string && strlen(a:style)
        let l:style = a:style
    endif

    if l:style ==? 'random'
        let l:rand = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
        let l:style = keys(s:powerline_separator_styles)[l:rand % len(s:powerline_separator_styles)]
    endif

    let g:Lf_StlSeparator = deepcopy(get(s:powerline_separator_styles, l:style, s:powerline_separator_styles['default']))
endfunction
