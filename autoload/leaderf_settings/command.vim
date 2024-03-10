function! s:BuildFindCommand() abort
    let Lf_FindCommands = {
                \ 'fd': 'fd "%s" --type file --color never --hidden',
                \ 'rg': 'rg "%s" --files --color never --ignore-dot --ignore-parent --hidden',
                \ }

    if g:Lf_FindTool ==# 'rg' && executable('rg')
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

    if g:Lf_FindTool ==# 'rg' && executable('rg')
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

function! leaderf_settings#command#Init() abort
    call s:BuildFindCommand()
    call s:BuildFindAllCommand()
    call s:BuildRgConfig()
endfunction
