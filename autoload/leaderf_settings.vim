" Find Project Dir
let g:Lf_FileRootMarkers = [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod',
            \ ]

let g:Lf_RootMarkers = ['.git', '.hg', '.svn', '.bzr', '_darcs'] + g:Lf_FileRootMarkers

let s:Lf_IgnoredRootDirs = [
            \ '/',
            \ '/root',
            \ '/Users',
            \ '/home',
            \ '/usr',
            \ '/usr/local',
            \ '/opt',
            \ '/etc',
            \ '/var',
            \ expand('~'),
            \ ]

function! leaderf_settings#FindProjectDir(starting_dir) abort
    if empty(a:starting_dir)
        return ''
    endif

    let l:root_dir = ''

    for l:root_marker in g:Lf_RootMarkers
        if index(g:Lf_FileRootMarkers, l:root_marker) > -1
            let l:root_dir = findfile(l:root_marker, a:starting_dir . ';')
        else
            let l:root_dir = finddir(l:root_marker, a:starting_dir . ';')
        endif
        let l:root_dir = substitute(l:root_dir, l:root_marker . '$', '', '')

        if strlen(l:root_dir)
            let l:root_dir = fnamemodify(l:root_dir, ':p:h')
            break
        endif
    endfor

    if empty(l:root_dir) || index(s:Lf_IgnoredRootDirs, l:root_dir) > -1
        if index(s:Lf_IgnoredRootDirs, getcwd()) > -1
            let l:root_dir = a:starting_dir
        elseif stridx(a:starting_dir, getcwd()) == 0
            let l:root_dir = getcwd()
        else
            let l:root_dir = a:starting_dir
        endif
    endif

    return fnamemodify(l:root_dir, ':p:~')
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

