function! leaderf_settings#command#BuildFindCommand() abort
    let Lf_FindCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore-vcs --hidden',
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

function! leaderf_settings#command#BuildFindAllCommand() abort
    let Lf_FindAllCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden --follow',
                \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden --follow',
                \ }

    if g:Lf_FindTool ==# 'rg' && executable('rg')
        let g:Lf_FindAllCommand = Lf_FindAllCommands['rg']
    else
        let g:Lf_FindAllCommand = Lf_FindAllCommands['fd']
    endif

    return g:Lf_FindAllCommand
endfunction

function! leaderf_settings#command#BuildRgConfig() abort
    let g:Lf_RgConfig = [
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

function! leaderf_settings#command#Init() abort
    call leaderf_settings#command#BuildFindCommand()
    call leaderf_settings#command#BuildFindAllCommand()
    call leaderf_settings#command#BuildRgConfig()
endfunction
