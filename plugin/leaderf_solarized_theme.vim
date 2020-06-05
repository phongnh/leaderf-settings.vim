if exists('g:loaded_leaderf_solarized_theme')
    finish
endif
let g:loaded_leaderf_solarized_theme = 1


if get(g:, 'leaderf_solarized_theme', 0)
    let g:Lf_StlColorscheme = 'solarized'

    function! s:InitSolarizedColorscheme() abort
        call leaderf#colorscheme#solarized#init()
        let g:Lf_PopupPalette = leaderf#colorscheme#solarized#popup_init()
    endfunction

    call s:InitSolarizedColorscheme()

    augroup VimLeaderFSolarizedTheme
        autocmd!
        autocmd ColorschemePre * call <SID>InitSolarizedColorscheme()
    augroup END
endif
