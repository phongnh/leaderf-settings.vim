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

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg', 'node_modules', '.gems', 'gems'],
            \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
            \ }

let s:Lf_AvailableCommands = filter(['rg', 'fd'], 'executable(v:val)')

if empty(s:Lf_AvailableCommands)
    finish
endif

let g:Lf_FindTool    = get(g:, 'Lf_FindTool', 'rg')
let g:Lf_FollowLinks = get(g:, 'Lf_FollowLinks', 0)
let s:Lf_FollowLinks = g:Lf_FollowLinks

let s:Lf_FindCommands = {
            \ 'rg': 'rg "%s" --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --files',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --type file "%s"',
            \ }

let s:Lf_FindWithFollowsCommand = {
            \ 'rg': 'rg --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --follow --files "%s"',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --follow --type file "%s"',
            \ }

function! s:DetectCurrentCommand() abort
    let idx = index(s:Lf_AvailableCommands, g:Lf_FindTool)
    let s:Lf_CurrentCommand = get(s:Lf_AvailableCommands, idx > -1 ? idx : 0)
endfunction

function! s:BuildExternalCommand() abort
    if s:Lf_FollowLinks
        let l:external_command = s:Lf_FindWithFollowsCommand[s:Lf_CurrentCommand]
    else
        let l:external_command = s:Lf_FindCommands[s:Lf_CurrentCommand]
    endif
    let g:Lf_ExternalCommand = l:external_command
endfunction

function! s:PrintCurrentCommandInfo() abort
    echo 'LeaderF is using command `' . g:Lf_ExternalCommand . '`!'
endfunction

command! PrintLeaderfCurrentCommandInfo call <SID>PrintCurrentCommandInfo()

function! s:ChangeExternalCommand(bang, command) abort
    " Reset to default command
    if a:bang
        call s:DetectCurrentCommand()
    elseif strlen(a:command)
        if index(s:Lf_AvailableCommands, a:command) == -1
            return
        endif
        let s:Lf_CurrentCommand = a:command
    else
        let idx = index(s:Lf_AvailableCommands, s:Lf_CurrentCommand)
        let s:Lf_CurrentCommand = get(s:Lf_AvailableCommands, idx + 1, s:Lf_AvailableCommands[0])
    endif
    call s:BuildExternalCommand()
    call s:PrintCurrentCommandInfo()
endfunction

function! s:ListAvailableCommands(...) abort
    return s:Lf_AvailableCommands
endfunction

command! -nargs=? -bang -complete=customlist,<SID>ListAvailableCommands ChangeLeaderfExternalCommand call <SID>ChangeExternalCommand(<bang>0, <q-args>)

function! s:ToggleFollowLinks() abort
    if s:Lf_FollowLinks == 0
        let s:Lf_FollowLinks = 1
        echo 'LeaderF follows symlinks!'
    else
        let s:Lf_FollowLinks = 0
        echo 'LeaderF does not follow symlinks!'
    endif
    call s:BuildExternalCommand()
endfunction

command! ToggleLeaderfFollowLinks call <SID>ToggleFollowLinks()

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

call s:DetectCurrentCommand()
call s:BuildExternalCommand()

let g:loaded_leaderf_settings_vim = 1
