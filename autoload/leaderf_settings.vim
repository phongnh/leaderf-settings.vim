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

function! s:BuildFindCommand() abort
    let Lf_FindCommands = {
                \ 'fd': 'fd "%s" --type file --color never --hidden',
                \ 'rg': 'rg "%s" --files --color never --ignore-dot --ignore-parent --hidden',
                \ }

    if g:Lf_FindTool ==# 'rg'
        let g:Lf_FindCommand = Lf_FindCommands['rg']
    else
        let g:Lf_FindCommand = Lf_FindCommands['fd']
    endif

    let g:Lf_FindCommand .= g:Lf_FollowLinks ? ' --follow' : ''
    let g:Lf_FindCommand .= g:Lf_FindNoIgnoreVCS ? ' --no-ignore-vcs' : ''

    let g:Lf_ExternalCommand = g:Lf_FindCommand

    return g:Lf_FindCommand
endfunction

function! s:BuildFindAllCommand() abort
    let Lf_FindAllCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden --follow',
                \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden --follow',
                \ }

    if g:Lf_FindTool ==# 'rg'
        let g:Lf_FindAllCommand = Lf_FindAllCommands['rg']
    else
        let g:Lf_FindAllCommand = Lf_FindAllCommands['fd']
    endif

    return g:Lf_FindAllCommand
endfunction

function! s:BuildRgConfig() abort
    let g:Lf_RgConfig = [
                \ '--smart-case',
                \ '--hidden',
                \ ]

    let g:Lf_RgConfig += g:Lf_FollowLinks ? ['--follow'] : []
    let g:Lf_RgConfig += g:Lf_GrepNoIgnoreVCS ? ['--no-ignore-vcs'] : []

    return g:Lf_RgConfig
endfunction

function! leaderf_settings#SetupCommands() abort
    call s:BuildFindCommand()
    call s:BuildFindAllCommand()
    call s:BuildRgConfig()
endfunction

function! leaderf_settings#ToggleFollowLinks() abort
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
