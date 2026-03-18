function! s:BuildFindCommand() abort
    if executable('fd')
        let g:Lf_FindCommand = 'fd "%s" --type file --color never --hidden'
        let g:Lf_FindCommand ..= g:Lf_FollowLinks ? ' --follow' : ''
        let g:Lf_ExternalCommand = g:Lf_FindCommand
    elseif executable('rg')
        let g:Lf_FindCommand = 'rg "%s" --files --color never --ignore-dot --ignore-parent --hidden'
        let g:Lf_FindCommand ..= g:Lf_FollowLinks ? ' --follow' : ''
        let g:Lf_ExternalCommand = g:Lf_FindCommand
    endif
endfunction

function! s:BuildFindAllCommand() abort
    if executable('fd')
        let g:Lf_FindAllCommand = 'fd "%s" --type file --color never --no-ignore --hidden --follow'
    elseif executable('rg')
        let g:Lf_FindAllCommand = 'rg "%s" --files --color never --no-ignore --hidden --follow'
    endif
endfunction

function! s:BuildRgConfig() abort
    let g:Lf_RgConfig = [
                \ '--smart-case',
                \ '--hidden',
                \ ]
    let g:Lf_RgConfig += g:Lf_FollowLinks ? ['--follow'] : []
endfunction

function! leaderf_settings#command#Init() abort
    call s:BuildFindCommand()
    call s:BuildFindAllCommand()
    call s:BuildRgConfig()
endfunction
