if empty(globpath(&rtp, 'plugin/leaderf.vim'))
    echohl WarningMsg | echomsg 'LeaderF is not found.' | echohl none
    finish
endif

if exists('g:loaded_leaderf_settings_vim')
    finish
endif

" FullPath by default
let g:Lf_DefaultMode = get(g:, 'Lf_DefaultMode', 'FullPath')

let g:Lf_ColorschemeMappings = extend({
            \ '^\(solarized\|soluarized\|flattened\)': 'solarized',
            \ '^gruvbox': 'gruvbox_material',
            \ }, get(g:, 'Lf_ColorschemeMappings', {}))

let g:Lf_PopupColorschemeMappings = extend({
            \ '^\(solarized\|soluarized\|flattened\)': 'solarized',
            \ '^gruvbox': 'gruvbox_material',
            \ }, get(g:, 'Lf_PopupColorschemeMappings', {}))

" Powerline Separator
if get(g:, 'Lf_Powerline_Fonts', 0)
    call leaderf_settings#powerline#SetSeparators(get(g:, 'Lf_Powerline_Style', 'default'))
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

let g:Lf_WindowHeight  = 0.30
let g:Lf_CursorBlink   = 1
let g:Lf_PreviewResult = {
            \ 'File':        0,
            \ 'Buffer':      0,
            \ 'Mru':         0,
            \ 'Tag':         0,
            \ 'BufTag':      0,
            \ 'Function':    0,
            \ 'Line':        0,
            \ 'Colorscheme': 0,
            \ 'Rg':          1,
            \ 'Jumps':       1,
            \ }

" Root Markers
let g:Lf_RootMarkers = ['.git', '.hg', '.svn', '.bzr', '_darcs'] + get(g:, 'Lf_FileRootMarkers', [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod',
            \ '.root',
            \ ])

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
if (exists('*popup_create') && has('patch-8.1.1615')) || (exists('*nvim_open_win') && has('nvim-0.4.2'))
    let g:Lf_PreviewInPopup = 1

    if get(g:, 'Lf_Popup', 1)
        let g:Lf_WindowPosition = 'popup'
    else
        let g:Lf_PreviewPosition   = 'left'
        let g:Lf_PreviewPopupWidth = 999
    endif

    if get(g:, 'Lf_GoyoIntegration', 1) && get(g:, 'Lf_WindowPosition', 'bottom') !=# 'popup'
        function! s:OnGoyoEnter() abort
            let s:Lf_WindowPosition = get(g:, 'Lf_WindowPosition', 'bottom')
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

let g:Lf_FindTool        = get(g:, 'Lf_FindTool', 'fd')
let g:Lf_FindNoIgnoreVCS = get(g:, 'Lf_FindNoIgnoreVCS', 0)
let g:Lf_FollowLinks     = get(g:, 'Lf_FollowLinks', 0)
let g:Lf_GrepNoIgnoreVCS = get(g:, 'Lf_GrepNoIgnoreVCS', 0)

call leaderf_settings#command#Init()

command! -bar                   LeaderfFileRoot call leaderf_settings#LeaderfFileRoot()
command! -nargs=? -complete=dir LeaderfFileAll  call leaderf_settings#LeaderfFileAll(<q-args>)
command! ToggleLeaderfFollowLinks call leaderf_settings#ToggleFollowLinks()

augroup LeaderfSettings
    autocmd!
    autocmd VimEnter * call leaderf_settings#theme#Init() | call leaderf_settings#popup#Init()
    autocmd ColorScheme * call leaderf_settings#theme#Apply() | call leaderf_settings#popup#Apply()
    autocmd OptionSet background call leaderf_settings#theme#Apply() | call leaderf_settings#popup#Apply()
augroup END

let g:loaded_leaderf_settings_vim = 1
