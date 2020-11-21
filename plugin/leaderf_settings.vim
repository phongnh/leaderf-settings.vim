if empty(globpath(&rtp, 'plugin/leaderf.vim'))
    echohl WarningMsg | echomsg 'LeaderF is not found.' | echohl none
    finish
endif

if exists('g:loaded_leaderf_settings_vim')
    finish
endif

let g:Lf_SolarizedTheme = get(g:, 'Lf_SolarizedTheme', 0)
if g:Lf_SolarizedTheme
    let g:Lf_StlColorscheme = 'solarized'

    function! s:InitSolarizedColorscheme() abort
        call leaderf#colorscheme#solarized#init()
        let g:Lf_PopupPalette = leaderf#colorscheme#solarized#popup_init()
    endfunction

    call s:InitSolarizedColorscheme()

    augroup VimLeaderfSolarizedTheme
        autocmd!
        autocmd ColorschemePre * call <SID>InitSolarizedColorscheme()
    augroup END
endif

let g:Lf_Powerline     = get(g:, 'Lf_Powerline', 0)
let g:Lf_Popup         = get(g:, 'Lf_Popup', 0)
let g:Lf_GrepIngoreVCS = get(g:, 'Lf_GrepIngoreVCS', 0)
let g:Lf_WindowHeight  = 0.30
let g:Lf_MruMaxFiles   = 200
let g:Lf_CursorBlink   = 1
let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }

" Powerline Separator
if g:Lf_Powerline
    let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2" }
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

" Popup Settings
if g:Lf_Popup && ((exists('*popup_create') && has('patch-8.1.1615')) || (exists('*nvim_win_set_config') && has('nvim-0.4.2')))
    let g:Lf_PopupShowStatusline  = 0
    let g:Lf_PreviewInPopup       = 1
    let g:Lf_PopupPreviewPosition = 'bottom'
    let g:Lf_WindowPosition       = 'popup'
endif

let g:Lf_UseCache       = 0  " rg/fd is enough fast, we don't need cache
let g:Lf_NeedCacheTime  = 10 " 10 seconds
let g:Lf_UseMemoryCache = 0

let g:Lf_NoChdir              = 1
let g:Lf_WorkingDirectoryMode = 'c'

let g:Lf_RgConfig = [
            \ '-H',
            \ '--line-number',
            \ '--no-heading',
            \ '--hidden',
            \ '--smart-case'
            \ ]

if g:Lf_GrepIngoreVCS
    call add(g:Lf_RgConfig, '--no-ignore-vcs')
endif

let g:Lf_Ctags         = get(g:, 'Lf_Ctags', 'ctags')
let g:Lf_CtagsFuncOpts = {
            \ 'ruby': '--ruby-kinds=fFS',
            \ }

let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsAutoUpdate   = 0
let g:Lf_GtagsGutentags    = 0

let g:Lf_GtagsGutentags = ''
let g:Lf_Gtagslabel     = 'default'

let g:Lf_CommandMap = {
            \ '<F5>':  ['<F5>', '<C-z>'],
            \ '<Esc>': ['<Esc>', '<C-g>'],
            \ }

" These options are passed to external tools (rg, fd and pt, ...)
let g:Lf_ShowHidden  = 0

let g:Lf_FindTool    = get(g:, 'Lf_FindTool', 'rg')
let g:Lf_FollowLinks = get(g:, 'Lf_FollowLinks', 0)
let s:Lf_FollowLinks = g:Lf_FollowLinks

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg', 'node_modules', '.gems', 'gems'],
            \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
            \ }

let s:Lf_FindTools = {
            \ 'rg': 'rg "%s" --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --files',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --type file "%s"',
            \ }

let s:Lf_FindWithFollowsTools = {
            \ 'rg': 'rg --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --follow --files "%s"',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --follow --type file "%s"',
            \ }

function! s:DetectLeaderfAvailableFindTools() abort
    let s:Lf_AvailableFindTools = []
    for cmd in ['rg', 'fd']
        if executable(cmd)
            call add(s:Lf_AvailableFindTools, cmd)
        endif
    endfor
endfunction

call s:DetectLeaderfAvailableFindTools()

function! s:SetupLeaderfExternalCommand() abort
    let l:tools = s:Lf_FollowLinks ? s:Lf_FindWithFollowsTools : s:Lf_FindTools
    let idx = index(s:Lf_AvailableFindTools, g:Lf_FindTool)
    let cmd = get(s:Lf_AvailableFindTools, idx > -1 ? idx : 0)
    let s:Lf_FindTool = get(l:tools, cmd, '')
    if strlen(s:Lf_FindTool)
        let g:Lf_ExternalCommand = s:Lf_FindTool
    else
        unlet! g:Lf_ExternalCommand
    endif
endfunction

call s:SetupLeaderfExternalCommand()

function! s:ToggleLeaderfFollowLinks() abort
    if s:Lf_FollowLinks == 0
        let s:Lf_FollowLinks = 1
        echo 'LeaderF follows symlinks!'
    else
        let s:Lf_FollowLinks = 0
        echo 'LeaderF does not follow symlinks!'
    endif
    call s:SetupLeaderfExternalCommand()
endfunction

command! ToggleLeaderfFollowLinks call <SID>ToggleLeaderfFollowLinks()

function! s:LeaderfRoot() abort
    let current = get(g:, 'Lf_WorkingDirectoryMode', 'c')
    try
        let g:Lf_WorkingDirectoryMode = 'Ac'
        :LeaderfFile
    finally
        let g:Lf_WorkingDirectoryMode = current
    endtry
endfunction

command! -bar LeaderfRoot call <SID>LeaderfRoot()

let g:loaded_leaderf_settings_vim = 1
