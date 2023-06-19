if empty(globpath(&rtp, 'plugin/leaderf.vim'))
    echohl WarningMsg | echomsg 'LeaderF is not found.' | echohl none
    finish
endif

if exists('g:loaded_leaderf_settings_vim')
    finish
endif

" FullPath by default
let g:Lf_DefaultMode = get(g:, 'Lf_DefaultMode', 'FullPath')

if get(g:, 'Lf_SolarizedTheme', 0)
    let g:Lf_StlColorscheme   = 'solarized'
    let g:Lf_PopupColorscheme = 'solarized'
endif

" Powerline Separator
if get(g:, 'Lf_Powerline_Fonts', 0)
    let g:Lf_StlSeparator = leaderf_settings#GetPowerlineSeparator(get(g:, 'Lf_Powerline_Style', 'default'))
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

let g:Lf_WindowHeight  = 0.30
let g:Lf_CursorBlink   = 1
let g:Lf_PreviewResult = {
            \ 'File': 0,
            \ 'Buffer': 0,
            \ 'Mru': 0,
            \ 'Tag': 0,
            \ 'BufTag': 0,
            \ 'Function': 0,
            \ 'Line': 0,
            \ 'Colorscheme': 0,
            \ 'Jumps': 1
            \ }

" MRU
let g:Lf_MruMaxFiles    = 250
let g:Lf_MruFileExclude = [
            \ '*.fugitiveblame',
            \ 'COMMIT_EDITMSG',
            \ 'git-rebase-todo',
            \ ]
let g:Lf_MruWildIgnore = {
            \ 'dir': [
            \   '.git',
            \   '.gems',
            \   '.vim/plugged',
            \   'vim/vim82',
            \   'vim/vim90',
            \   'nvim/runtime',
            \ ],
            \ 'file': [
            \   '*.fugitiveblame',
            \ ],
            \ }

" Popup Settings
let g:Lf_PopupPosition        = [5, 0]
let g:Lf_PopupWidth           = get(g:, 'Lf_PopupWidth', 0.8)
let g:Lf_PopupHeight          = 0.40
let g:Lf_PopupShowStatusline  = 0
let g:Lf_PreviewInPopup       = 0
let g:Lf_PopupPreviewPosition = 'bottom'
if (exists('*popup_create') && has('patch-8.1.1615')) || (exists('*nvim_win_set_config') && has('nvim-0.4.2'))
    let g:Lf_PreviewInPopup = 1

    if get(g:, 'Lf_Popup', 1)
        let g:Lf_WindowPosition = 'popup'
    else
        let g:Lf_PreviewHorizontalPosition = 'left'
        let g:Lf_PreviewPopupWidth         = 999
    endif

    let s:Lf_WindowPosition = get(g:, 'Lf_WindowPosition', 'bottom')

    if get(g:, 'Lf_GoyoIntegration', 1) && s:Lf_WindowPosition !=# 'popup'
        function! s:OnGoyoEnter() abort
            " Use popup in Goyo mode
            let g:Lf_WindowPosition = 'popup'
        endfunction

        function! s:OnGoyoLeave() abort
            let g:Lf_WindowPosition = s:Lf_WindowPosition
        endfunction

        augroup LeaderfGoyo
            autocmd!
            autocmd! User GoyoEnter nested call <SID>OnGoyoEnter()
            autocmd! User GoyoLeave nested call <SID>OnGoyoLeave()
        augroup END
    endif
endif

let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_UseCache       = 0  " rg/fd is enough fast, we don't need cache
let g:Lf_NeedCacheTime  = 10 " 10 seconds
let g:Lf_UseMemoryCache = 0

let g:Lf_NoChdir              = 1
let g:Lf_WorkingDirectoryMode = 'c'

let g:Lf_Ctags         = get(g:, 'Lf_Ctags', 'ctags')
let g:Lf_CtagsFuncOpts = {
            \ 'ruby': '--ruby-kinds=fFS',
            \ }

let g:Lf_CommandMap = {
            \ '<F5>':     ['<F5>',     '<C-z>'],
            \ '<Esc>':    ['<Esc>',    '<C-g>'],
            \ '<C-Up>':   ['<C-Up>',   '<S-Up>'],
            \ '<C-Down>': ['<C-Down>', '<S-Down>'],
            \ }

" These options are passed to external tools (rg, fd and pt, ...)
let g:Lf_ShowHidden  = 0

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg', 'node_modules', '.gems', 'gems'],
            \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
            \ }

let g:Lf_FindTool    = get(g:, 'Lf_FindTool', 'fd')
let g:Lf_FollowLinks = get(g:, 'Lf_FollowLinks', 0)

function! s:BuildFindCommand() abort
    let Lf_FindCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore-vcs --hidden --strip-cwd-prefix',
                \ 'rg': 'rg "%s" --files --color never --no-ignore-vcs --ignore-dot --ignore-parent --hidden',
                \ }

    if g:Lf_FindTool ==# 'rg' && executable('rg')
        let g:Lf_FindCommand = Lf_FindCommands['rg']
    else
        let g:Lf_FindCommand = Lf_FindCommands['fd']
    endif

    if g:Lf_FollowLinks
        let g:Lf_FindCommand .= ' --follow'
    endif

    let g:Lf_ExternalCommand = g:Lf_FindCommand

    return g:Lf_FindCommand
endfunction

function! s:BuildFindAllCommand() abort
    let Lf_FindAllCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden --follow --strip-cwd-prefix',
                \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden --follow',
                \ }

    if g:Lf_FindTool ==# 'rg' && executable('rg')
        let g:Lf_FindAllCommand = Lf_FindAllCommands['rg']
    else
        let g:Lf_FindAllCommand = Lf_FindAllCommands['fd']
    endif

    return g:Lf_FindAllCommand
endfunction

function! s:BuildRgConfig() abort
    let g:Lf_RgConfig = [
                \ '-H',
                \ '--no-heading',
                \ '--line-number',
                \ '--smart-case',
                \ '--hidden',
                \ ]

    if g:Lf_FollowLinks
        call add(g:Lf_RgConfig, '--follow')
    endif

    if get(g:, 'Lf_GrepIngoreVCS', 0)
        call add(g:Lf_RgConfig, '--no-ignore-vcs')
    endif

    return g:Lf_RgConfig
endfunction

command! -bar                   LeaderfFileRoot call leaderf_settings#LeaderfFileRoot()
command! -nargs=? -complete=dir LeaderfFileAll  call leaderf_settings#LeaderfFileAll(<q-args>)

function! s:ToggleLeaderfFollowLinks() abort
    if g:Lf_FollowLinks == 0
        let g:Lf_FollowLinks = 1
        echo 'LeaderF follows symlinks!'
    else
        let g:Lf_FollowLinks = 0
        echo 'LeaderF does not follow symlinks!'
    endif
    call s:BuildFindCommand()
    call s:BuildRgConfig()
endfunction

command! ToggleLeaderfFollowLinks call <SID>ToggleLeaderfFollowLinks()

function! s:SetupLeaderfSettings() abort
    call s:BuildFindCommand()
    call s:BuildFindAllCommand()
    call s:BuildRgConfig()
endfunction

command! -nargs=1 -complete=custom,leaderf_settings#ListLeaderfColorschemes      LeaderfSetColorscheme call leaderf_settings#SetLeaderfColorscheme(<q-args>)
command! -nargs=1 -complete=custom,leaderf_settings#ListLeaderfPopupColorschemes LeaderfSetPopupColorscheme call leaderf_settings#SetLeaderfPopupColorscheme(<q-args>)

augroup LeaderfSettings
    autocmd!
    autocmd VimEnter * call <SID>SetupLeaderfSettings()
    autocmd VimEnter * call leaderf_settings#FindLeaderfColorschemes() | call leaderf_settings#ReloadLeaderfTheme()
    autocmd ColorScheme * call leaderf_settings#ReloadLeaderfTheme()
augroup END

let g:loaded_leaderf_settings_vim = 1
