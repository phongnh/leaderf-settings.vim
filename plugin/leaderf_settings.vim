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

function! s:FindLeaderfColorschemes() abort
    let s:Lf_Colorschemes = map(split(globpath(&rtp, 'autoload/LeaderF/colorscheme/*.vim')), "fnamemodify(v:val, ':t:r')")
    let s:Lf_ColorschemesCompletion = join(s:Lf_Colorschemes, "\n")
    let s:Lf_PopupColorschemes = map(split(globpath(&rtp, 'autoload/LeaderF/colorscheme/popup/*.vim')), "fnamemodify(v:val, ':t:r')")
endfunction

function! s:ListLeaderfColorschemes(...) abort
    return s:Lf_ColorschemesCompletion
endfunction

function! s:SetLeaderfColorscheme(colorscheme) abort
    if index(s:Lf_Colorschemes, a:colorscheme) < 0
        return
    endif

    " Reload colorscheme palette
    let l:colorscheme_path = findfile(printf('autoload/LeaderF/colorscheme/%s.vim', a:colorscheme), &rtp)
    if !empty(l:colorscheme_path) && filereadable(l:colorscheme_path)
        execute 'source ' . l:colorscheme_path
    endif

    let g:Lf_StlColorscheme = a:colorscheme
    call leaderf#colorscheme#highlight('File', 0)
endfunction

function! s:SetLeaderfPopupColorscheme(colorscheme) abort
    if index(s:Lf_PopupColorschemes, a:colorscheme) < 0
        return
    endif

    if !exists('*g:LfDefineDefaultColors')
        let g:Lf_PopupColorscheme = a:colorscheme
        return
    endif

    " Reload popup colorscheme palette
    " let l:colorscheme_path = findfile(printf('autoload/LeaderF/colorscheme/popup/%s.vim', a:colorscheme), &rtp)
    " if !empty(l:colorscheme_path) && filereadable(l:colorscheme_path)
    "     execute 'source ' . l:colorscheme_path
    " endif

    " unlet! g:Lf_PopupPalette
    let g:Lf_PopupColorscheme = a:colorscheme
    call leaderf#colorscheme#popup#load('File', g:Lf_PopupColorscheme)
endfunction

function! s:SetLeaderfTheme(colorscheme, popup_colorscheme) abort
    call s:SetLeaderfColorscheme(a:colorscheme)
    call s:SetLeaderfPopupColorscheme(a:popup_colorscheme)
endfunction

function! s:BuildColorscheme() abort
    let l:colorscheme = get(g:, 'colors_name', '')
    if has('vim_starting') && exists('g:Lf_StlColorscheme')
        let l:colorscheme = g:Lf_StlColorscheme
    endif

    if l:colorscheme =~ 'solarized\|soluarized\|flattened'
        let l:colorscheme = 'solarized'
    endif

    if l:colorscheme ==# 'gruvbox' || l:colorscheme =~ 'gruvbox8'
        " let l:colorscheme = 'gruvbox_material'
        let l:colorscheme = 'default'
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = tolower(l:colorscheme)
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = substitute(l:colorscheme, '-', '_', 'g')
    endif

    if index(s:Lf_Colorschemes, l:colorscheme) < 0
        let l:colorscheme = 'default'
    endif

    return l:colorscheme
endfunction

function! s:BuildPopupColorscheme() abort
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

function! s:ReloadLeaderfTheme() abort
    let l:colorscheme = s:BuildColorscheme()
    let l:popup_colorscheme = s:BuildPopupColorscheme()

    call s:SetLeaderfTheme(l:colorscheme, l:popup_colorscheme)
endfunction

augroup VimLeaderfColorscheme
    autocmd!
    autocmd VimEnter * call <SID>FindLeaderfColorschemes() | call <SID>ReloadLeaderfTheme()
    autocmd ColorScheme * call <SID>ReloadLeaderfTheme()
augroup END

" Powerline Separator
if get(g:, 'Lf_Powerline_Fonts', 0)
    let g:Lf_StlSeparator = leaderf_settings#GetPowerlineSeparator(get(g:, 'Lf_Powerline_Style', 'default'))
else
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
endif

let g:Lf_WindowHeight  = 0.30
let g:Lf_CursorBlink   = 1
let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }

" MRU
let g:Lf_MruMaxFiles    = 200
let g:Lf_MruFileExclude = [
            \ '*.fugitiveblame',
            \ 'COMMIT_EDITMSG',
            \ 'git-rebase-todo',
            \ ]
let g:Lf_MruWildIgnore = {
            \ 'dir': [
            \   '.git',
            \   '.vim/plugged',
            \   'vim/vim82',
            \   'nvim/runtimeee',
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

let g:Lf_UseCache       = 0  " rg/fd is enough fast, we don't need cache
let g:Lf_NeedCacheTime  = 10 " 10 seconds
let g:Lf_UseMemoryCache = 0

let g:Lf_NoChdir              = 1
let g:Lf_WorkingDirectoryMode = 'c'

let g:Lf_RgConfig = [
            \ '-H',
            \ '--no-heading',
            \ '--line-number',
            \ '--smart-case',
            \ '--hidden',
            \ ]

let g:Lf_FollowLinks = get(g:, 'Lf_FollowLinks', 0)
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

command! -bar LeaderfFileSmartRoot execute 'LeaderfFile' leaderf_settings#FindProjectDir(expand('%:p:h'))

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
let s:Lf_FollowLinks = g:Lf_FollowLinks

let s:Lf_FindCommands = {
            \ 'fd': 'fd "%s" --type file --color never --no-ignore-vcs --hidden --strip-cwd-prefix',
            \ 'rg': 'rg "%s" --files --color never --no-ignore-vcs --ignore-dot --ignore-parent --hidden',
            \ }

let s:Lf_FindAllCommands = {
            \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden --follow --strip-cwd-prefix',
            \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden --follow',
            \ }

function! s:BuildFindCommand() abort
    let l:cmd = s:Lf_FindCommands[s:Lf_CurrentCommand]
    if s:Lf_FollowLinks
        let l:cmd .= ' --follow'
    endif
    return l:cmd
endfunction

function! s:BuildFindAllCommand() abort
    let l:cmd = s:Lf_FindAllCommands[s:Lf_CurrentCommand]
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

function! s:LeaderfFileAll(dir) abort
    try
        let g:Lf_ExternalCommand = s:BuildFindAllCommand()
        execute 'LeaderfFile' a:dir
    finally
        call s:BuildLeaderfExternalCommand()
    endtry
endfunction

command! -nargs=? -complete=dir LeaderfFileAll call <SID>LeaderfFileAll(<q-args>)

call s:DetectLeaderfCurrentCommand()
call s:BuildLeaderfExternalCommand()

let g:loaded_leaderf_settings_vim = 1
