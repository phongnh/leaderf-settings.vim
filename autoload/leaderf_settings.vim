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

function! leaderf_settings#ToggleFollowLinks() abort
    if g:Lf_FollowLinks == 0
        let g:Lf_FollowLinks = 1
        echo 'LeaderF follows symlinks!'
    else
        let g:Lf_FollowLinks = 0
        echo 'LeaderF does not follow symlinks!'
    endif
    call leaderf_settings#command#BuildFindCommand()
    call leaderf_settings#command#BuildRgConfig()
endfunction
