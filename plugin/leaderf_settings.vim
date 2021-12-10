if empty(globpath(&rtp, 'plugin/leaderf.vim'))
    echohl WarningMsg | echomsg 'LeaderF is not found.' | echohl none
    finish
endif

if exists('g:loaded_leaderf_settings_vim')
    finish
endif

if get(g:, 'Lf_SolarizedTheme', 0)
    let g:Lf_StlColorscheme = 'solarized'

    function! s:InitSolarizedColorscheme() abort
        call leaderf#colorscheme#solarized#init()
        let g:Lf_PopupPalette = leaderf#colorscheme#solarized#popup_init()
    endfunction

    call s:InitSolarizedColorscheme()

    augroup VimLeaderfSolarizedTheme
        autocmd!
        autocmd ColorschemePre solarized* call <SID>InitSolarizedColorscheme()
    augroup END
endif

" Powerline Separator
if get(g:, 'Lf_Powerline', 0)
    let g:Lf_StlSeparator = leaderf_settings#GetPowerlineSeparator(get(g:, 'Lf_Powerline_Style', 'default'))
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

let g:Lf_WindowHeight  = 0.30
let g:Lf_MruMaxFiles   = 200
let g:Lf_CursorBlink   = 1
let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }

" Popup Settings
let g:Lf_PopupPosition        = [5, 0]
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

let g:Lf_UseCache       = 0  " rg/fd is enough fast, we don't need cache
let g:Lf_NeedCacheTime  = 10 " 10 seconds
let g:Lf_UseMemoryCache = 0

let g:Lf_NoChdir              = 1
let g:Lf_WorkingDirectoryMode = 'c'

let g:Lf_FileRootMarkers = [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod'
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

function! s:FindProjectDir(starting_dir) abort
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

command! -bar LeaderfFileSmartRoot execute 'LeaderfFile' s:FindProjectDir(expand('%:p:h'))

function! s:LeaderfFileRoot() abort
    let current = get(g:, 'Lf_WorkingDirectoryMode', 'c')
    try
        let g:Lf_WorkingDirectoryMode = 'AF'
        :LeaderfFile
    finally
        let g:Lf_WorkingDirectoryMode = current
    endtry
endfunction

command! -bar LeaderfRoot     call <SID>LeaderfFileRoot()
command! -bar LeaderfFileRoot call <SID>LeaderfFileRoot()

let s:Lf_AvailableCommands = filter(['fd', 'rg'], 'executable(v:val)')

if empty(s:Lf_AvailableCommands)
    command! -nargs=? -complete=dir LeaderfFileAll :LeaderfFile <args>
    finish
endif

let g:Lf_FindTool    = get(g:, 'Lf_FindTool', 'fd')
let g:Lf_FollowLinks = get(g:, 'Lf_FollowLinks', 0)
let s:Lf_FollowLinks = g:Lf_FollowLinks
let g:Lf_NoIgnores   = get(g:, 'Lf_NoIgnores', 0)
let s:Lf_NoIgnores   = g:Lf_NoIgnores

let s:Lf_FindCommands = {
            \ 'fd': 'fd "%s" --type file --color never --no-ignore-vcs --hidden',
            \ 'rg': 'rg "%s" --files --color never --no-ignore-vcs --ignore-dot --ignore-parent --hidden',
            \ }

let s:Lf_FindAllCommands = {
            \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden',
            \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden',
            \ }

function! s:BuildFindCommand() abort
    let l:cmd = s:Lf_FindCommands[s:Lf_CurrentCommand]
    if s:Lf_NoIgnores
        let l:cmd = s:Lf_FindAllCommands[s:Lf_CurrentCommand]
    endif
    if s:Lf_FollowLinks
        let l:cmd .= ' --follow'
    endif
    return l:cmd
endfunction

function! s:DetectLeaderfCurrentCommand() abort
    let idx = index(s:Lf_AvailableCommands, g:Lf_FindTool)
    let s:Lf_CurrentCommand = get(s:Lf_AvailableCommands, idx > -1 ? idx : 0)
endfunction

function! s:BuildLeaderfExternalCommand() abort
    let g:Lf_ExternalCommand = s:BuildFindCommand()
endfunction

function! s:PrintLeaderfCurrentCommandInfo() abort
    echo 'LeaderF is using command `' . g:Lf_ExternalCommand . '`!'
endfunction

command! PrintLeaderfCurrentCommandInfo call <SID>PrintLeaderfCurrentCommandInfo()

function! s:ChangeLeaderfExternalCommand(bang, command) abort
    " Reset to default command
    if a:bang
        call s:DetectLeaderfCurrentCommand()
    elseif strlen(a:command)
        if index(s:Lf_AvailableCommands, a:command) == -1
            return
        endif
        let s:Lf_CurrentCommand = a:command
    else
        let idx = index(s:Lf_AvailableCommands, s:Lf_CurrentCommand)
        let s:Lf_CurrentCommand = get(s:Lf_AvailableCommands, idx + 1, s:Lf_AvailableCommands[0])
    endif
    call s:BuildLeaderfExternalCommand()
    call s:PrintLeaderfCurrentCommandInfo()
endfunction

function! s:ListLeaderfAvailableCommands(...) abort
    return s:Lf_AvailableCommands
endfunction

command! -nargs=? -bang -complete=customlist,<SID>ListLeaderfAvailableCommands ChangeLeaderfExternalCommand call <SID>ChangeLeaderfExternalCommand(<bang>0, <q-args>)

function! s:ToggleLeaderfFollowLinks() abort
    if s:Lf_FollowLinks == 0
        let s:Lf_FollowLinks = 1
        echo 'LeaderF follows symlinks!'
    else
        let s:Lf_FollowLinks = 0
        echo 'LeaderF does not follow symlinks!'
    endif
    call s:BuildLeaderfExternalCommand()
endfunction

command! ToggleLeaderfFollowLinks call <SID>ToggleLeaderfFollowLinks()

function! s:ToggleLeaderfNoIgnores() abort
    if s:Lf_NoIgnores == 0
        let s:Lf_NoIgnores = 1
        echo 'LeaderF does not respect ignores!'
    else
        let s:Lf_NoIgnores = 0
        echo 'LeaderF respects ignores!'
    endif
    call s:BuildLeaderfExternalCommand()
endfunction

command! ToggleLeaderfNoIgnores call <SID>ToggleLeaderfNoIgnores()

function! s:LeaderfFileAll(dir) abort
    let current = s:Lf_NoIgnores
    try
        let s:Lf_NoIgnores = 1
        call s:BuildLeaderfExternalCommand()
        execute 'LeaderfFile' a:dir
    finally
        let s:Lf_NoIgnores = current
        call s:BuildLeaderfExternalCommand()
    endtry
endfunction

command! -nargs=? -complete=dir LeaderfFileAll call <SID>LeaderfFileAll(<q-args>)

call s:DetectLeaderfCurrentCommand()
call s:BuildLeaderfExternalCommand()

let g:loaded_leaderf_settings_vim = 1
