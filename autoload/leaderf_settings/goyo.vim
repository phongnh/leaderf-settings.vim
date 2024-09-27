function! leaderf_settings#goyo#OnEnter() abort
    if g:Lf_WindowPosition !=# 'popup'
        let s:Lf_WindowPosition = g:Lf_WindowPosition
        " Use popup in Goyo mode
        let g:Lf_WindowPosition = 'popup'
    else
        unlet! s:Lf_WindowPosition
    endif
endfunction

function! leaderf_settings#goyo#OnLeave() abort
    " Restore previous window position
    if exists('s:Lf_WindowPosition')
        let g:Lf_WindowPosition = s:Lf_WindowPosition
    endif
endfunction

