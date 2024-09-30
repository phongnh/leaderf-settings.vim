function! s:BuildFindCommand() abort
    let l:Lf_FindCommands = {
                \ 'fd': 'fd "%s" --type file --color never --hidden',
                \ 'rg': 'rg "%s" --files --color never --ignore-dot --ignore-parent --hidden',
                \ }
    let g:Lf_FindCommand = l:Lf_FindCommands[g:Lf_FindTool ==# 'rg' ? 'rg' : 'fd']
    let g:Lf_FindCommand .= g:Lf_FollowLinks ? ' --follow' : ''
    let g:Lf_FindCommand .= g:Lf_FindNoIgnoreVCS ? ' --no-ignore-vcs' : ''
    let g:Lf_ExternalCommand = g:Lf_FindCommand
    return g:Lf_FindCommand
endfunction

function! s:BuildFindAllCommand() abort
    let l:Lf_FindAllCommands = {
                \ 'fd': 'fd "%s" --type file --color never --no-ignore --hidden --follow',
                \ 'rg': 'rg "%s" --files --color never --no-ignore --hidden --follow',
                \ }
    let g:Lf_FindAllCommand = l:Lf_FindAllCommands[g:Lf_FindTool ==# 'rg' ? 'rg' : 'fd']
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
