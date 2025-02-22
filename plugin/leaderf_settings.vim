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

" Nerdfonts
let g:Lf_ShowDevIcons = get(g:, 'Lf_ShowDevIcons', 0)

if g:Lf_ShowDevIcons
    let g:Lf_DevIconsExactSymbols = {
                \ '.code.ignore':        '',
                \ '.fdignore':           '',
                \ '.ignore':             '',
                \ 'ignore':              '',
                \ '.env.sample':         '',
                \ '.envrc':              '',
                \ '.vimrc.local':        '',
                \ 'vimrc.local':         '',
                \ '.editor.vimrc.local': '',
                \ '.init.lua.local':     '',
                \ 'init.lua.local':      '',
                \ '.editor.lua.local':   '',
                \ }
    let g:Lf_DevIconsExtensionSymbols = {
                \ 'vimrc': '',
                \ 'envrc': '',
                \ }
endif

" Powerline Separator
if get(g:, 'Lf_Powerline_Fonts', g:Lf_ShowDevIcons)
    call leaderf_settings#powerline#SetSeparators(get(g:, 'Lf_Powerline_Style', 'default'))
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

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
            \   'vim/vim91',
            \   'nvim/runtime',
            \   'nvim/lazy',
            \   'nvim/lazy-rocks',
            \ ],
            \ 'file': [
            \   '*.fugitiveblame',
            \ ],
            \ }

" Window Settings
" Autoresize LeaderF window height automattically
let g:Lf_AutoResize        = 1
let g:Lf_WindowPosition    = 'bottom'
let g:Lf_WindowHeight      = 0.30
let g:Lf_CursorBlink       = 1
let g:Lf_PreviewPosition   = 'left'
let g:Lf_PreviewPopupWidth = 999
let g:Lf_PreviewResult     = {
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

" Popup Settings
let g:Lf_PopupPosition         = [7, 0]
let g:Lf_PopupWidth            = get(g:, 'Lf_PopupWidth', 0.8)
let g:Lf_PopupHeight           = get(g:, 'Lf_PopupHeight', 0.375)
let g:Lf_PopupAutoAdjustHeight = 1
let g:Lf_PopupShowStatusline   = 0
let g:Lf_PopupShowBorder       = 0
let g:Lf_PopupPreviewPosition  = 'bottom'

if (exists('*popup_create') && has('patch-8.1.1615')) || (exists('*nvim_open_win') && has('nvim-0.4.2'))
    if get(g:, 'Lf_Popup', 1)
        let g:Lf_WindowPosition = 'popup'
    endif

    if get(g:, 'Lf_GoyoIntegration', 1)
        augroup LeaderfGoyo
            autocmd!
            autocmd! User GoyoEnter nested call leaderf_settings#goyo#OnEnter()
            autocmd! User GoyoLeave nested call leaderf_settings#goyo#OnLeave()
        augroup END
    endif
endif

let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_UseCache       = get(g:, 'Lf_UseCache', 0) " rg/fd is enough fast, we don't need cache
let g:Lf_NeedCacheTime  = 10 " 10 seconds
let g:Lf_UseMemoryCache = 0

let g:Lf_NoChdir              = 1
let g:Lf_WorkingDirectoryMode = 'c'

let g:Lf_Ctags         = get(g:, 'Lf_Ctags', 'ctags')
let g:Lf_CtagsFuncOpts = {
            \ 'ruby': '--ruby-kinds=fFS',
            \ 'crystal': '--language-force=crystal',
            \ }

" Disable Gtags
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsAutoUpdate   = 0

" Customize the mappings inside LeaderF's prompt
let g:Lf_CommandMap = {
            \ '<F5>':     ['<F5>',     '<C-z>'],
            \ '<Esc>':    ['<Esc>',    '<C-g>'],
            \ '<C-Up>':   ['<C-Up>',   '<S-Up>'],
            \ '<C-Down>': ['<C-Down>', '<S-Down>'],
            \ '<C-]>':    ['<C-]>',    '<C-v>'],
            \ }

" These options are passed to external tools (rg, fd and pt, ...)
let g:Lf_ShowHidden  = 0

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg', 'node_modules', '.gems', 'gems'],
            \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
            \ }

let g:Lf_DefaultExternaltool = 'find'

let g:Lf_FindNoIgnoreVCS = get(g:, 'Lf_FindNoIgnoreVCS', 0)
let g:Lf_FollowLinks     = get(g:, 'Lf_FollowLinks', 1)
let g:Lf_GrepNoIgnoreVCS = get(g:, 'Lf_GrepNoIgnoreVCS', 0)

" Setup commands
call leaderf_settings#command#Init()

augroup LeaderfSettings
    autocmd!
    autocmd VimEnter * call leaderf_settings#theme#Init() | call leaderf_settings#popup#Init()
    autocmd ColorScheme * call leaderf_settings#theme#Apply() | call leaderf_settings#popup#Apply()
    autocmd OptionSet background call leaderf_settings#theme#Apply() | call leaderf_settings#popup#Apply()
augroup END

command! ToggleLeaderfFollowLinks call leaderf_settings#ToggleFollowLinks()

command! -bar                   LeaderfFileRoot call leaderf_settings#LeaderfFileRoot()
command! -nargs=? -complete=dir LeaderfFileAll  call leaderf_settings#LeaderfFileAll(<q-args>)

let g:loaded_leaderf_settings_vim = 1
