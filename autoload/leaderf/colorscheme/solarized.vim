function! leaderf#colorscheme#solarized#init() abort
    if &background == 'dark'
        let s:palette = {
                    \ 'match':           { 'guifg': '#b58900', 'ctermfg': '136'   },
                    \ 'match0':          { 'guifg': '#d33682', 'ctermfg': '168'   },
                    \ 'match1':          { 'guifg': '#6c71c4', 'ctermfg': '62'    },
                    \ 'match2':          { 'guifg': '#268bd2', 'ctermfg': '32'    },
                    \ 'match3':          { 'guifg': '#2aa198', 'ctermfg': '36'    },
                    \ 'match4':          { 'guifg': '#859900', 'ctermfg': '100'   },
                    \ 'matchRefine':     { 'guifg': '#cb4b16', 'ctermfg': '166'   },
                    \ 'cursorline':      { 'guifg': '#fdf6e3', 'ctermfg': '230'   },
                    \ 'stlName':         { 'guifg': '#fdf6e3', 'ctermfg': '230',  'guibg': '#b58900', 'ctermbg': '136', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'stlCategory':     { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#657b83', 'ctermbg': '66',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlNameOnlyMode': { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#268bd2', 'ctermbg': '32',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlFullPathMode': { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#586e75', 'ctermbg': '60',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlFuzzyMode':    { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#586e75', 'ctermbg': '60',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlRegexMode':    { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#dc322f', 'ctermbg': '166', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlCwd':          { 'guifg': '#93a1a1', 'ctermfg': '109',  'guibg': '#073642', 'ctermbg': '23',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlBlank':        { 'guifg': '#93a1a1', 'ctermfg': '109',  'guibg': '#073642', 'ctermbg': '23',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlLineInfo':     { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#657b83', 'ctermbg': '66',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlTotal':        { 'guifg': '#fdf6e3', 'ctermfg': '230',  'guibg': '#93a1a1', 'ctermbg': '109', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ }
    else
        let s:palette = {
                    \ 'match':           { 'guifg': '#b58900', 'ctermfg': '136'   },
                    \ 'match0':          { 'guifg': '#d33682', 'ctermfg': '168'   },
                    \ 'match1':          { 'guifg': '#6c71c4', 'ctermfg': '62'    },
                    \ 'match2':          { 'guifg': '#268bd2', 'ctermfg': '32'    },
                    \ 'match3':          { 'guifg': '#2aa198', 'ctermfg': '36'    },
                    \ 'match4':          { 'guifg': '#859900', 'ctermfg': '100'   },
                    \ 'matchRefine':     { 'guifg': '#cb4b16', 'ctermfg': '166'   },
                    \ 'cursorline':      { 'guifg': '#002b36', 'ctermfg': '17'    },
                    \ 'stlName':         { 'guifg': '#fdf6e3', 'ctermfg': '230',  'guibg': '#b58900', 'ctermbg': '136', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'stlCategory':     { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#839496', 'ctermbg': '102', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlNameOnlyMode': { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#268bd2', 'ctermbg': '32',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlFullPathMode': { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#93a1a1', 'ctermbg': '109', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlFuzzyMode':    { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#93a1a1', 'ctermbg': '109', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlRegexMode':    { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#dc322f', 'ctermbg': '166', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlCwd':          { 'guifg': '#586e75', 'ctermfg': '60',   'guibg': '#eee8d5', 'ctermbg': '224', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlBlank':        { 'guifg': '#586e75', 'ctermfg': '60',   'guibg': '#eee8d5', 'ctermbg': '224', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlLineInfo':     { 'guifg': '#eee8d5', 'ctermfg': '224',  'guibg': '#839496', 'ctermbg': '102', 'gui': 'NONE', 'cterm': 'NONE' },
                    \ 'stlTotal':        { 'guifg': '#fdf6e3', 'ctermfg': '230',  'guibg': '#586e75', 'ctermbg': '60',  'gui': 'NONE', 'cterm': 'NONE' },
                    \ }
    endif

    let g:leaderf#colorscheme#solarized#palette = leaderf#colorscheme#mergePalette(s:palette)
endfunction

call leaderf#colorscheme#solarized#init()

" Solarized theme for LeaderF popup window
function! leaderf#colorscheme#solarized#popup_init() abort
    let s:palette = {
                \ 'dark': {
                \   'Lf_hl_match':              { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match0':             { 'guifg': '#d33682', 'ctermfg': '168', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match1':             { 'guifg': '#6c71c4', 'ctermfg': '62',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match2':             { 'guifg': '#268bd2', 'ctermfg': '32',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match3':             { 'guifg': '#2aa198', 'ctermfg': '36',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match4':             { 'guifg': '#859900', 'ctermfg': '100', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_matchRefine':        { 'guifg': '#cb4b16', 'ctermfg': '166'  },
                \   'Lf_hl_cursorline':         { 'guifg': '#fdf6e3', 'ctermfg': '230'  },
                \   'Lf_hl_popup_inputText':    { 'guifg': '#839496', 'ctermfg': '102', 'guibg': '#002b36', 'ctermbg': '17'    },
                \   'Lf_hl_popup_window':       { 'guifg': '#839496', 'ctermfg': '102', 'guibg': '#002b36', 'ctermbg': '17'    },
                \   'Lf_hl_popup_blank':        { 'guibg': '#073642', 'ctermbg': '23'   },
                \   'Lf_hl_popup_cursor':       { 'guifg': '#657b83', 'ctermfg': '66',  'guibg': '#93a1a1', 'ctermbg': '109'   },
                \   'Lf_hl_popup_prompt':       { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': '#002b36', 'ctermbg': '17',   'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_spin':         { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#002b36', 'ctermbg': '17'    },
                \   'Lf_hl_popup_normalMode':   { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#93a1a1', 'ctermbg': '109',  'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_inputMode':    { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#b58900', 'ctermbg': '136',  'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_category':     { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#657b83', 'ctermbg': '66'    },
                \   'Lf_hl_popup_nameOnlyMode': { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#268bd2', 'ctermbg': '32'    },
                \   'Lf_hl_popup_fullPathMode': { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#586e75', 'ctermbg': '60'    },
                \   'Lf_hl_popup_fuzzyMode':    { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#586e75', 'ctermbg': '60'    },
                \   'Lf_hl_popup_regexMode':    { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#dc322f', 'ctermbg': '166'   },
                \   'Lf_hl_popup_cwd':          { 'guifg': '#93a1a1', 'ctermfg': '109', 'guibg': '#073642', 'ctermbg': '23'    },
                \   'Lf_hl_popup_lineInfo':     { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#657b83', 'ctermbg': '66'    },
                \   'Lf_hl_popup_total':        { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#93a1a1', 'ctermbg': '109'   },
                \ },
                \ 'light': {
                \   'Lf_hl_match':              { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match0':             { 'guifg': '#d33682', 'ctermfg': '168', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match1':             { 'guifg': '#6c71c4', 'ctermfg': '62',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match2':             { 'guifg': '#268bd2', 'ctermfg': '32',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match3':             { 'guifg': '#2aa198', 'ctermfg': '36',  'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_match4':             { 'guifg': '#859900', 'ctermfg': '100', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_matchRefine':        { 'guifg': '#cb4b16', 'ctermfg': '166', 'guibg': 'NONE',    'ctermbg': 'NONE', 'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_cursorline':         { 'guifg': '#002b36', 'ctermfg': '17'   },
                \   'Lf_hl_popup_inputText':    { 'guifg': '#657b83', 'ctermfg': '66',  'guibg': '#fdf6e3', 'ctermbg': '230'   },
                \   'Lf_hl_popup_window':       { 'guifg': '#657b83', 'ctermfg': '66',  'guibg': '#fdf6e3', 'ctermbg': '230'   },
                \   'Lf_hl_popup_blank':        { 'guibg': '#eee8d5', 'ctermbg': '224'  },
                \   'Lf_hl_popup_cursor':       { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': '#586e75', 'ctermbg': '60'    },
                \   'Lf_hl_popup_prompt':       { 'guifg': '#073642', 'ctermfg': '23',  'guibg': '#fdf6e3', 'ctermbg': '230',  'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_spin':         { 'guifg': '#002b36', 'ctermfg': '17',  'guibg': '#fdf6e3', 'ctermbg': '230'   },
                \   'Lf_hl_popup_normalMode':   { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#586e75', 'ctermbg': '60',   'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_inputMode':    { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#b58900', 'ctermbg': '136',  'gui': 'bold', 'cterm': 'bold' },
                \   'Lf_hl_popup_category':     { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#839496', 'ctermbg': '102'   },
                \   'Lf_hl_popup_nameOnlyMode': { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#268bd2', 'ctermbg': '32'    },
                \   'Lf_hl_popup_fullPathMode': { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#93a1a1', 'ctermbg': '109'   },
                \   'Lf_hl_popup_fuzzyMode':    { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#93a1a1', 'ctermbg': '109'   },
                \   'Lf_hl_popup_regexMode':    { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#dc322f', 'ctermbg': '166'   },
                \   'Lf_hl_popup_cwd':          { 'guifg': '#586e75', 'ctermfg': '60',  'guibg': '#eee8d5', 'ctermbg': '224'   },
                \   'Lf_hl_popup_lineInfo':     { 'guifg': '#eee8d5', 'ctermfg': '224', 'guibg': '#839496', 'ctermbg': '102'   },
                \   'Lf_hl_popup_total':        { 'guifg': '#fdf6e3', 'ctermfg': '230', 'guibg': '#586e75', 'ctermbg': '60'    },
                \ },
                \ }
    return s:palette
endfunction
