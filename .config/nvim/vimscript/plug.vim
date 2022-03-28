"============================================================================
"    Author: Lucas Burns                                                   
"     Email: burnsac@me.com                                                
"      Home: https://github.com/lmburns                                    
"============================================================================

call plug#begin("~/.vim/plugged")

" <++> Extra
" bennypowers/nvim-regexplainer

" ============= options ============= {{{
" }}} === Options ===

" Not needed, here for manual pages
Plug 'junegunn/vim-plug'

" ============= Icons ============= {{{
" Plug 'ryanoasis/vim-devicons'
" Plug 'wfxr/vizunicode.vim'
" augroup vizunicode_custom
"     autocmd!
"     autocmd BufEnter coc-settings.json VizUnicodeAll
" augroup END
" }}} === Icons ===

" ============== easy align ============== {{{
" Plug 'junegunn/vim-easy-align'
  " let g:easy_align_delimiters = {
  "   \ '>': { 'pattern': '>>\|=>\|>' },
  "   \ '\': { 'pattern': '\\' },
  "   \ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
  "   \ ']': {
  "   \     'pattern':       '\]\zs',
  "   \     'left_margin':   0,
  "   \     'right_margin':  1,
  "   \     'stick_to_left': 0
  "   \   },
  "   \ ')': {
  "   \     'pattern':       ')\zs',
  "   \     'left_margin':   0,
  "   \     'right_margin':  1,
  "   \     'stick_to_left': 0
  "   \   },
  "   \ 'f': {
  "   \     'pattern': ' \(\S\+(\)\@=',
  "   \     'left_margin': 0,
  "   \     'right_margin': 0
  "   \   },
  "   \ 'd': {
  "   \     'pattern': ' \ze\S\+\s*[;=]',
  "   \     'left_margin': 0,
  "   \     'right_margin': 0
  "   \   }
  "   \ }
  " xmap ga <Plug>(EasyAlign)
  " nmap ga <Plug>(EasyAlign)
  " xmap <Leader>ga <Plug>(LiveEasyAlign)
  " xmap <Leader>gi :EasyAlign//ig['Comment']<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  " xmap <Leader>gs :EasyAlign//ig['String']<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" }}} === easy align ===

" ============== limelight ============== {{{
" Plug 'junegunn/goyo.vim'         | nnoremap <Leader>G :Goyo<CR>
" Plug 'junegunn/limelight.vim'
"   " let g:limelight_conceal_ctermfg = 'gray'
"   " let g:limelight_conceal_guifg = 'DarkGray'
"   " let g:limelight_paragraph_span = 1
"   " let g:limelight_priority = -1
"   function! s:goyo_enter()
"     " silent :execute 'normal! mL'
"     if exists('$TMUX')
"       silent !tmux set status off
"       " silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
"     endif
"     " setl noshowmode
"     " setl noshowcmd
"     " setl scrolloff=999
"     setl foldlevel=99
"     let &background = &background
"     Limelight
"     " setl statusline = '%M'
"     setl statusline=...%(\ [%M%R%H]%)
"     hi StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
"     silent :execute 'normal! <C-W>h'
"   endfunction
"   function! s:goyo_leave()
"     if exists('$TMUX')
"       silent !tmux set status on
"       " silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
"     endif
"     Limelight!
"     let &background = &background
"   endfunction
"
"   autocmd! User GoyoEnter nested call <SID>goyo_enter()
"   autocmd! User GoyoLeave nested call <SID>goyo_leave()
"
"   " nnoremap <Leader>G :Goyo \| set linebreak<CR>
"   nnoremap <Leader>G :Goyo<CR>
"   nnoremap <silent> <Leader>Li :Limelight!!<cr>
" }}} === limelight ===

" ============== vimtex ============== {{{
" Plug 'lervag/vimtex'
  " let g:vimtex_view_method = 'zathura'
  " let g:tex_flavor='latex'
  " let g:vimtex_compiler_latexmk = {
  "       \ 'executable' : 'latexmk',
  "       \ 'options' : [
  "       \   '-xelatex',
  "       \   '-file-line-error',
  "       \   '-synctex=1',
  "       \   '-interaction=nonstopmode',
  "       \ ],
  "       \}
  " let g:vimtex_compiler_latexmk = {
  "         \ 'build_dir' : '',
  "         \ 'callback' : 1,
  "         \ 'continuous' : 1,
  "         \ 'executable' : 'latexmk',
  "         \ 'hooks' : [function('UpdateSkim')],
  "         \   'options' : [
  "         \       '-file-line-error',
  "         \       '-synctex=1',
  "         \       '-interaction=nonstopmode',
  "         \     ],
  "         \}
  " augroup vimtex
  "   autocmd!
  "   autocmd InsertEnter *.tex set conceallevel=0
  "   autocmd InsertLeave *.tex set conceallevel=2
  "   autocmd BufEnter *.tex set concealcursor-=n
  "   autocmd VimLeave *.tex !texclear %
  " augroup END
"}}} === vimtex ===

" ============== lightline-buffer ============== {{{
" Plug 'tyru/open-browser.vim'
"   nmap <buffer> <silent> <cr> <Plug>(openbrowser-open)

" Plug 'sainnhe/tmuxline.vim', {'on': ['Tmuxline', 'TmuxlineSnapshot']}
" Plug 'mengelbrecht/lightline-bufferline'
"   " jump mapping
"   nmap ,1 <Plug>lightline#bufferline#go(1)
"   nmap ,2 <Plug>lightline#bufferline#go(2)
"   nmap ,3 <Plug>lightline#bufferline#go(3)
"   nmap ,4 <Plug>lightline#bufferline#go(4)
"   nmap ,5 <Plug>lightline#bufferline#go(5)
"   nmap ,6 <Plug>lightline#bufferline#go(6)
"   nmap ,7 <Plug>lightline#bufferline#go(7)
"   nmap ,8 <Plug>lightline#bufferline#go(8)
"   nmap ,9 <Plug>lightline#bufferline#go(9)
"   nmap ,0 <Plug>lightline#bufferline#go(10)
"
"   " kill mapping
"   nmap ;1 <Plug>lightline#bufferline#delete(1)
"   nmap ;2 <Plug>lightline#bufferline#delete(2)
"   nmap ;3 <Plug>lightline#bufferline#delete(3)
"   nmap ;4 <Plug>lightline#bufferline#delete(4)
"   nmap ;5 <Plug>lightline#bufferline#delete(5)
"   nmap ;6 <Plug>lightline#bufferline#delete(6)
"   nmap ;7 <Plug>lightline#bufferline#delete(7)
"   nmap ;8 <Plug>lightline#bufferline#delete(8)
"   nmap ;9 <Plug>lightline#bufferline#delete(9)
"   nmap ;0 <Plug>lightline#bufferline#delete(10)
"
"   let s:nbsp = ' '
"   let g:lightline#bufferline#filename_modifier = ":t".s:nbsp
"   let g:lightline#bufferline#shorten_path      = 1
"   let g:lightline#bufferline#show_number       = 2
"   let g:lightline#bufferline#min_buffer_count  = 0
"   let g:lightline#bufferline#unnamed           = '[No Name]'
"   let g:lightline#bufferline#read_only         = '  '
"   let g:lightline#bufferline#modified          = " + "
"   let g:lightline#bufferline#enable_devicons = 1
"   let g:lightline#bufferline#unicode_symbols = 1
"   let g:lightline#bufferline#number_map = {
"   \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
"   \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}
"   " \ 0: '₀', 1: '₁', 2: '₂', 3: '₃', 4: '₄',
"   " \ 5: '₅', 6: '₆', 7: '₇', 8: '₈', 9: '₉'}
"   let g:lightline#bufferline#unicode_symbols = 1
"
"   let g:lightline#gitdiff#indicator_added = ': '
"   let g:lightline#gitdiff#indicator_deleted = ': '
"   let g:lightline#gitdiff#indicator_modified = 'ﰲ: '
"   let g:lightline#gitdiff#separator = ' '
  " let g:lightline#gitdiff#show_empty_indicators = 1
" }}} === lightline-buffer ===

" ============== lightline ============== {{{
" Plug 'itchyny/lightline.vim'
" Plug 'josa42/vim-lightline-coc'
" Plug 'niklaas/lightline-gitdiff'
" function! CocDiagnosticError() abort "{{{
"   let info = get(b:, 'coc_diagnostic_info', {})
"   return get(info, 'error', 0) ==# 0 ? '' : ' ' . info['error'] "   
" endfunction "}}}
"
" function! CocDiagnosticWarning() abort "{{{
"   let info = get(b:, 'coc_diagnostic_info', {})
"   return get(info, 'warning', 0) ==# 0 ? '' : ' ' . info['warning'] "      !
" endfunction "}}}
"
" function! CocDiagnosticOK() abort "{{{
"   let info = get(b:, 'coc_diagnostic_info', {})
"   return get(info, 'error', 0) ==# 0 && get(info, 'warning', 0) ==# 0 ? '' : '' "  
" endfunction "}}}
"
" function! CocStatus() abort "{{{
"   return get(g:, 'coc_status', '')
" endfunction "}}}

function! GitGlobal() abort "{{{
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    if branch ==# ''
      return ' ' . fnamemodify(getcwd(), ':t')
    else
      return branch . ' '
    endif
  endif
  return ''
endfunction "}}}

" function! FileSize() abort "{{{
"   let [ bytes, units, i ] = [ getfsize(expand(@%)), ['', 'Ki', 'Mi', 'Gi'], 0 ]
"   while bytes >= 1024 | let bytes = bytes / 1024.0 | let i += 1 | endwhile
"   return printf((i ? "~%.1f" : "%d")." %sB", bytes, units[i])
" endfunction "}}}

let g:ll_blacklist = '\v(help|nerdtree|quickmenu|startify|undotree|neoterm|'
  \ . 'fugitive|netrw|vim-plug|floaterm|qf)'

function! FileSize() abort " {{{
  let l:bytes = getfsize(expand('%:p'))
  if (l:bytes >= 1024)
    let l:kbytes = l:bytes / 1024
  endif
  if (exists('l:kbytes') && l:kbytes >= 1000)
    let l:mbytes = l:kbytes / 1000
  endif

  if l:bytes <= 0
    return &filetype !~# g:ll_blacklist ? ('0 B') : ''
  endif

  if (exists('l:mbytes'))
    return &filetype !~# g:ll_blacklist && winwidth(0) > 70 ? (l:mbytes . ' MB') : ''
  elseif (exists('l:kbytes'))
    return &filetype !~# g:ll_blacklist && winwidth(0) > 70 ? (l:kbytes . ' KB') : ''
  else
    return &filetype !~# g:ll_blacklist && winwidth(0) > 70 ? (l:bytes . ' B') : ''
  endif
endfunction "}}}


" function! NearestMethodOrFunction() abort "{{{
"   return get(b:, 'vista_nearest_method_or_function', '')
" endfunction "}}}
"
" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

set showtabline=2
let g:lightline = {}
let g:lightline.colorscheme = 'kimbox'
" let g:lightline.colorscheme = 'overcast'
" let g:lightline.colorscheme = 'gruvbox_material'
" let g:lightline.colorscheme = 'everforest'
" let g:lightline.colorscheme = 'miramare'
" let g:lightline.colorscheme = 'nightowl'
" let g:lightline.colorscheme = 'spaceduck'
" let g:lightline.colorscheme = 'sonokai'
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
" 'fileformat'
let g:lightline.active = {
    \ 'left':  [['mode', 'paste'],
    \           ['readonly', 'modified', 'devicons_filetype', 'fsize', 'fileencoding'],
    \           ['gitdiff', 'coc_status']],
    \ 'right': [['lineinfo'],
    \           ['linter_errors', 'linter_warnings', 'linter_ok']]
    \ }
let g:lightline.inactive = {
        \ 'left': [['filename', 'modified', 'fileformat']],
        \ 'right': [[ 'lineinfo' ]]
        \ }
" 'tabs'
let g:lightline.tabline = {
        \ 'right': [[ 'method', 'git_status' ]],
        \ 'left': [['vim_logo', 'nbufs', 'buffers']],
        \ }
let g:lightline.tab = {
        \ 'active': ['bufnum', 'filename'],
        \ 'inactive': ['bufnum', 'filename']
        \ }
" \ 'readonly': 'lightline#tab#readonly',
" \ 'filename': 'lightline#tab#filename',
" \ 'modified': 'lightline#tab#modified',
let g:lightline.tab_component_function = {
      \ 'tabnum': 'TabNum',
      \ 'filename': 'LightlineFilename',
      \ }
" \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
let g:lightline.component = {
      \ 'git_status' : '%{GitGlobal()}',
      \ 'nbufs': '%{NumBufs()}',
      \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
      \ 'vim_logo': "\ue7c5",
      \ 'mode': '%{lightline#mode()}',
      \ 'absolutepath': '%F',
      \ 'relativepath': '%f',
      \ 'filename': '%t',
      \ 'fileformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
      \ 'modified': '%M',
      \ 'bufnum': '%n',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'readonly': '%R',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'percent': '%2p%%',
      \ 'percentwin': '%P',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'lineinfo': '%2p%% %3l:%-2v',
      \ 'line': '%l',
      \ 'column': '%c',
      \ 'close': '%999X X ',
      \ 'winnr': '%{winnr()}',
      \ 'method': '%{NearestMethodOrFunction()}',
      \ }
let g:lightline.component_function = {
      \ 'devicons_filetype': 'DeviconsFiletype',
      \ 'coc_status': 'CocStatus',
      \ 'fsize': 'FileSize',
      \ 'fileencoding': 'LightlineFileEncoding',
      \ }
let g:lightline.component_expand = {
      \ 'linter_warnings': 'CocDiagnosticWarning',
      \ 'linter_errors': 'CocDiagnosticError',
      \ 'linter_ok': 'CocDiagnosticOK',
      \ 'buffers': 'lightline#bufferline#buffers',
      \ 'readonly': 'LightLineReadonly',
      \ 'gitdiff': 'lightline#gitdiff#get',
      \ }
let g:lightline.component_type = {
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ 'linter_info': 'info',
      \ 'linter_hints': 'hints',
      \ 'buffers': 'tabsel',
      \ 'gitdiff': 'middle',
      \ }
let g:lightline.mode_map = {
            \ 'n':      'N',
            \ 'i':      'I',
            \ 'R':      'R',
            \ 'v':      'V',
            \ 'V':      'V-L',
            \ "\<C-v>": 'V-B',
            \ 'c':      'C',
            \ 's':      'S',
            \ 'S':      'S-L',
            \ "\<C-s>": 'S-B',
            \ 't':      'T',
            \ }
" }}} === lightline ===

" ============== vim surround ============== {{{
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-endwise'
"   nmap <Leader>ci cs`*
"   nmap <Leader>o ysiw
"   nmap mlw yss`
"}}} === vim surround ===

" ============== vim-startify ============== {{{
" Plug 'mhinz/vim-startify'
  " Don't change to directory when selecting a file
"   let g:webdevicons_enable_startify = 1
"   let g:startify_files_number = 5
"   let g:startify_change_to_dir = 1
"   let g:startify_custom_header = [ ]
"   let g:startify_relative_path = 1
"   let g:startify_use_env = 1
"   let g:startify_update_oldfiles = 1
"   let g:startify_session_sort = 1
"   let g:startify_session_delete_buffers = 1
"   let g:startify_fortune_use_unicode = 1
"   let g:startify_padding_left = 3
"   let g:startify_session_remove_lines = ['setlocal', 'winheight']
"   let g:startify_session_dir = fnamemodify(stdpath('data'), ':p') . 'sessions'
"
"   if has('nvim')
"     let g:startify_commands = [
"           \ {'1': 'CocList'},
"           \ {'2': 'terminal'},
"           \ ]
"   endif
"
"   function! s:gitModified()
"     let files = systemlist('git ls-files -m 2>/dev/null')
"     return map(files, "{'line': v:val, 'path': v:val}")
"   endfunction
"
" " same as above, but show untracked files, honouring .gitignore
"   function! s:gitTracked()
"     let files = systemlist('git --exclude-standard 2>/dev/null')
"     return map(files, "{'line': v:val, 'path': v:val}")
"   endfunction
"
"   function! s:explore()
"     sleep 350m
"     call execute('CocCommand explorer')
"   endfunction
"
"   function! StartifyEntryFormat()
"     return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
"   endfunction
"
"   "   \  { 'type':  function('s:explore'), 'header':    ['coc']},
"
"   " Custom startup list, only show MRU from current directory/project
"   let g:startify_lists = [
"   \  { 'type': 'sessions',  'header': [ " \ue62e Sessions" ]       },
"   \  { 'type': 'bookmarks', 'header': [ " \uf5c2 Bookmarks" ]      },
"   \  { 'type': 'commands',  'header': [ " \ufb32 Commands" ]       },
"   \  { 'type': 'files',     'header': [ " \ufa1eMRU"] },
"   \  { 'type': 'dir',       'header': [ " \ufa1eFiles ". getcwd() ] },
"   \  { 'type':  function('s:gitModified'),  'header': ['git modified']},
"   \  { 'type':  function('s:gitTracked'), 'header': ['git untracked']}
"   \ ]
"
"   let g:startify_commands = [
"   \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
"   \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
"   \   { 'uc': [ 'Update CoC Plugins', ':CocUpdate' ] },
"   \   { 'vd': [ 'Make Wiki Entry', ':VimwikiMakeDiaryNote' ] },
"   \ ]
"
"   let g:startify_bookmarks = [
"       \ { 'co': '~/.config/nvim/init.vim' },
"       \ { 'gc': '~/.config/git/config' },
"       \ { 'lc': '~/.config/lf/lfrc' },
"       \ { 'zs': '~/.config/zsh/zshrc' },
"       \ { 'za': '~/.config/zsh/zsh-aliases' },
"       \ { 'vi': '~/vimwiki/index.md' },
"       \ { 'vib': '~/vimwiki/scripting/index.md'}
"   \ ]
"
"   nmap <Leader>st :Startify<cr>
  " autoload startify
  " autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | Startify | endif
" }}} === vim-startify ===


" ============== gutentag | vista ============== {{{ "
" Plug 'ludovicchabant/vim-gutentags'
" }}} === gutentag | vista === "

if has('nvim')
  Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
  " Plug 'norcalli/nvim-colorizer.lua'
endif

" ============== nerdtree ============== {{{
Plug 'scrooloose/nerdtree'
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeIgnore = []
  let g:NERDTreeStatusline = ''
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeDirArrowExpandable = '❱'
  let g:NERDTreeDirArrowCollapsible = '❰'

  let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

  let NERDTreeMapActivateNode = 'l'         " default o
  let NERDTreeMapOpenInTab = 't'            " default t
  let NERDTreeMapOpenSplit = 'gs'           " default i
  let NERDTreeMapOpenVSplit = 'gv'          " default s
  let NERDTreeMapOpenExpl = 'e'             " default e
  let NERDTreeMapUpdir = 'h'                " default u
  let NERDTreeMapUpdirKeepOpen = 'H'        " default U
  let NERDTreeMapToggleHidden = '.'         " default I

  " automaticaly close nvim if NERDTree is only thing left open
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " toggle
  map <Leader>nn :NERDTreeToggle<CR>
  map <Leader>nb :NERDTreeFromBookmark
  map <Leader>nf :NERDTreeFind<CR>
" }}}  === nerdtree ===

" ============== Neoterm ============== {{{
" Plug 'kassio/neoterm'
"   let g:neoterm_default_mod='belowright' " open terminal in bottom split
"   let g:neoterm_size=14                  " terminal split size
"   let g:neoterm_autoscroll=1             " scroll to the bottom

  " nnoremap <Leader>rf :T ptipython<CR>
  " some modules do not work in ptpython
  nnoremap <Leader>rr :Tclear<CR>
  nnoremap <Leader>rt :Ttoggle<CR>
  nnoremap <Leader>ro :Ttoggle<CR> :Ttoggle<CR>
"}}} === Neoterm ===

" ============== Floaterm | lf | lazygit ============== {{{
" Plug 'ptzz/lf.vim'
" Plug 'voldikss/vim-floaterm'
" Plug 'voldikss/fzf-floaterm'
" Plug 'kdheepak/lazygit.nvim'
" }}}  === Floaterm | lf ===

" ============== git  ============== {{{
" ============== fugitive ============== {{{
" Plug 'tpope/vim-fugitive'
"   nnoremap <Leader>gu :G<CR>3j
"   nnoremap <Leader>gq :G<CR>:q<CR>
"   nnoremap <Leader>gw :Gwrite<CR>
"   nnoremap <Leader>gr :Gread<CR>
"   nnoremap <Leader>gh :diffget //2<CR>
"   nnoremap <Leader>gl :diffget //3<CR>
"   nnoremap <Leader>gp :Git push<CR>
"
"   nmap <Leader>d :Gdiff<CR>
" }}} === fugitive ===

" }}} === git ===

" ============== UndoTree ============== {{{
  " Plug 'mbbill/undotree', { 'on':  'UndotreeToggle' }
  " nnoremap <Leader>ut :UndotreeToggle<CR>
  " let g:undotree_RelativeTimestamp = 1
  " let g:undotree_ShortIndicators = 1
  " let g:undotree_HelpLine = 0
  " let g:undotree_WindowLayout = 2
"}}} === UndoTree ===

" ============== nerdcommenter ============== {{{
" Plug 'preservim/nerdcommenter'
  " let NERDSpaceDelims = 1
  " let g:NERDCreateDefaultMappings = 0
  " let g:NERDTrimTrailingWhitespace = 1
  " let g:NERDToggleCheckAllLines = 1
  " let g:NERDCompactSexyComs = 1
  " let g:NERDCommentEmptyLines = 1
  " let g:NERDDefaultAlign = 'left'
  " let g:NERDCustomDelimiters = { 'just': { 'left': '#'}}
  " " vim registers <C-/> as <C-_>
  " nnoremap <C-_> :call nerdcommenter#Comment(0, "toggle")<CR>j
  " vnoremap <C-_> :call nerdcommenter#Comment(0, "toggle")<CR>'>j
  " " copy & comment
  " nnoremap <Leader>yc yyP<C-_>
  " vnoremap <Leader>yc yPgp<C-_>
  " map gc :call nerdcommenter#Comment(0, "toggle")<CR>
  " " nmap gcc :call nerdcommenter#Comment(0, "toggle")<CR>
  " map gcy :call nerdcommenter#Comment(0, "yank")<CR>
  " " nmap <Leader>gcy :call nerdcommenter#Comment(0, "yank")<CR>
" }}} === nerdcomment ===

" ============== indentline ============== {{{
  " Plug 'yggdroot/indentline'
"   source ~/.config/nvim/vimscript/plugins/indentline.vim
" }}}

" ============ coc-nvim ============ {{{
" Plug 'vim-perl/vim-perl', { 'for': 'perl' }
" Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
" Plug 'antoinemadec/coc-fzf'

  " nnoremap <silent> <A-;> :Telescope neoclip<CR>

  " nnoremap <LocalLeader>c :Telescope coc<CR>
  " nnoremap <A-c> :Telescope coc commands<CR>

  " nnoremap ;n :Telescope coc locations<CR>
  " type_definitions

  " FIX: Rust Analyzer does not provide hover or code completion

  " inoremap <silent><expr> <C-j>
  "       \ coc#jumpable() ? "\<C-R>=coc#rpc#request('snippetNext', [])\<cr>" :
  "       \ pumvisible() ? coc#_select_confirm() :
  "       \ "\<Down>"
  " inoremap <silent><expr> <C-k>
  "       \ coc#jumpable() ? "\<C-R>=coc#rpc#request('snippetPrev', [])\<cr>" :
  "       \ "\<Up>"

  " inoremap <silent><expr> <TAB>
  "     \ pumvisible() ? "\<C-n>" :
  "     \ <SID>check_back_space() ? "\<TAB>" :
  "     \ coc#refresh()
  "
  " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

  " augroup cocgroup
  "     au!
  "     au FileType rust,scala,python,ruby,perl,lua,c,cpp,zig,d,javascript,typescript nmap <silent> <c-]> <Plug>(coc-definition)
  "     " Highlight symbol under cursor on CursorHold
  "     au CursorHold * silent call CocActionAsync('highlight')
  "     " Setup formatexpr specified filetype(s).
  "     au FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "     " Update signature help on jump placeholder
  "     au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  "     au FileType log :let b:coc_enabled = 0
  " augroup end

  " coc-snippets
  " imap <C-j> <Plug>(coc-snippets-expand-jump)

  " " use `:Format` to format current buffer
  " command! -nargs=0 Format :call CocAction('format')
  " " use `:Fold` to fold current buffer
  " command! -nargs=? Fold :call CocAction('fold', <f-args>)
  " " use `:OR` for organize import of current buffer
  " command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')


  " inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<tab>"

  " let g:endwise_no_mappings = v:true
  " " inoremap <expr> <Plug>CustomCocCR "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  " imap <CR> <Plug>CustomCocCR<Plug>DiscretionaryEnd

  " use K to show documentation in preview window.
  " function! s:show_documentation()
  "   if (index(['vim','help'], &filetype) >= 0)
  "     execute 'h '.expand('<cword>')
  "   elseif (coc#rpc#ready())
  "     call CocActionAsync('doHover')
  "   else
  "     execute '!' . &keywordprg . " " . expand('<cword>')
  "   endif
  " endfunction

    " elseif (index(['rust'], &filetype) >= 0)
    "   execute 'set winblend=0 | FloatermNew --autoclose=0 rusty-man --viewer tui' . " " . expand('<cword>')

  " nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Make <CR> auto-select the first completion item
  " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Make <tab> auto-select the first completion item
  " inoremap <silent><expr> <tab> pumvisible()
  "     \ ? coc#_select_confirm() : "\<C-g>u\<tab>"

  " Use <c-space> to trigger completion
  " inoremap <silent><expr> <C-'> coc#refresh()

  " position. Coc only does snippet and additional edit on confirm.
  " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " <++>not in it
  " coc-pairs
  " augroup CocPairs
  "   autocmd!
  "   autocmd FileType markdown let b:coc_pairs_disabled = ['`', "'"]
  "   autocmd FileType vim,vifm let b:coc_pairs_disabled = ['"']
  "   autocmd FileType *        let b:coc_pairs_disabled = ['<']
  " augroup end

  " Highlight the symbol and its references when holding the cursor.
" }}} === coc-nvim ===

" ============ formatting ============ {{{
" Plug 'karb94/neoscroll.nvim'
" Plug 'mhartington/formatter.nvim'

" Plug 'sbdchd/neoformat'
" let g:neoformat_basic_format_retab = 1
" let g:neoformat_basic_format_trim = 1
" let g:neoformat_basic_format_align = 1
"
"  " Formatting options that are better than coc's :Format
"   nnoremap ;ff :Format<CR>
"   augroup formatting
"       autocmd!
"       autocmd FileType lua        nmap ;ff :Neoformat! lua    luaformat<CR>
"       autocmd FileType java       nmap ;ff :Neoformat! java   prettier<CR>
"       autocmd FileType perl       nmap ;ff :Neoformat! perl<CR>
"       autocmd FileType sh         nmap ;ff :Neoformat! sh<CR>
"       autocmd FileType python     nmap ;ff :Neoformat! python black<CR>
"       autocmd FileType md,vimwiki nmap ;ff :Neoformat!<CR>
"       autocmd FileType zsh        nmap ;ff :Neoformat  expand<CR>
"   augroup end
" }}} === formatting ===

" ============= targets ============== {{{
" Plug 'wellle/targets.vim'
"   augroup define_object
"     autocmd User targets#mappings#user call targets#mappings#extend({
"           \ 'a': {'argument': [{'o':'(', 'c':')', 's': ','}]}
"           \ })
"   augroup END

" }}} === targets ===

" ============== nvim-r ============== {{{
" FIX: This buffer is cleared
" autocmd BufEnter,BufNew r execute "silent! CocDisable"
" Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
"   " Run ;RStop // :RKill to quit
"   let R_auto_start = 1                                   " Autostart R when opening .R
"   let R_assign_map = ';'                                 " Convert ';' into ' <-
"   let r_syntax_folding = 1
"   let r_indent_op_pattern = '\(+\|-\|\*\|/\|=\|\~\|%\)$' " Indent automatically
"   let R_rconsole_height = 10                             " Console height
"   let R_csv_app = 'terminal:vd'                          " Use visidata to view dataframes
"   let R_nvimpager = 'tab'                                " Use Vim to see R documentation
"   let R_open_example = 1                                 " Use Vim to display R examples
"   let g:Rout_prompt_str = '$ '                           " Start of R command prompt
"   let g:Rout_continue_str = '... '                       " Symbol for R string continuation
"   " let R_specialplot = 1                                " nvim.plot() instead of plot()
"   let R_commented_lines = 0                              " Don't send commented lines to term
"   let R_openpdf = 1                                      " Automatically open PDFs
"   let R_pdfviewer = "zathura"                            " PDF viewer
"   let R_close_term = 1                                   " Close terminal when closing vim
"   let R_objbr_place = 'RIGHT'                            " Location of object browser
"   " let R_external_term = 1                              " OSX use R.app graphical
"   " let R_applescript = 1                                " OSX use R.app graphical
"   let Rout_more_colors = 1                               " Make terminal output more colorful
"   let r_indent_align_args = 0                            " ?? where this come from
"   let rout_follow_colorscheme = 0
"
"   " Press the space bar to send lines and selection to R console
"   " vmap <Space> <Plug>RDSendSelection
"   " nmap <Space> <Plug>RDSendLine
"
"   " automatic line break
"   " autocmd FileType r setlocal formatoptions+=t
"
"   " The symbol '✠' is from pressing Shift+Enter
" augroup r_env
"   autocmd!
"   autocmd FileType r,rmd,rnoweb
"     \ if string(g:SendCmdToR) == "function('SendCmdToR_fake')"
"       \ | call StartR("R") | endif|
"     \ nnoremap <silent> ✠ :call SendLineToR("stay")<CR><Esc><Home><Down>|
"     \ inoremap <silent> ✠ <Esc>:call SendLineToR("stay")<CR><Esc>A|
"     \ vnoremap <silent> ✠ :call SendSelectionToR("silent", "stay")<CR><Esc><Esc>|
"     \ inoremap <buffer> > <Esc>:normal! a %>%<CR>a|
"     \ nnoremap <Leader>rs :vs ~/projects/rstudio/nvim-r.md<CR>|
"     \ nnoremap <silent> <LocalLeader>t: call RAction("tail")<CR>|
"     \ nnoremap <silent> <LocalLeader>H: call RAction("head")<CR>|
"     \ vnoremap <silent> ;ff           :Rformat<cr>|
"     \ nnoremap <buffer> ;fF           :Rformat<cr>|
"     \ call     <SID>IndentSize(2)|
"     if has('gui_running') || &termguicolors
"       let rout_color_input    = 'guifg=#9e9e9e'
"       let rout_color_normal   = 'guifg=#f79a32'
"       let rout_color_number   = 'guifg=#889b4a'
"       let rout_color_integer  = 'guifg=#a3b95a'
"       let rout_color_float    = 'guifg=#98676a'
"       let rout_color_complex  = 'guifg=#fcaf00'
"       let rout_color_negnum   = 'guifg=#d7afff'
"       let rout_color_negfloat = 'guifg=#d6afff'
"       let rout_color_date     = 'guifg=#4c96a8'
"       let rout_color_true     = 'guifg=#088649'
"       let rout_color_false    = 'guifg=#ff5d5e'
"       let rout_color_inf      = 'guifg=#f06431'
"       let rout_color_constant = 'guifg=#5fafcf'
"       let rout_color_string   = 'guifg=#502166'
"       let rout_color_error    = 'guifg=#ffffff guibg=#dc3958'
"       let rout_color_warn     = 'guifg=#f14a68'
"       let rout_color_index    = 'guifg=#d3af86'
"     endif
" augroup END
" }}} === nvim-r ===

" ============== vim-slime | python ============== {{{
" Plug 'jpalardy/vim-slime', { 'for': 'python' }
" " Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"   let g:slime_target = "neovim"
"   let g:syntastic_python_pylint_post_args="--max-line-length=120"
"   if !empty(glob('$XDG_DATA_HOME/pyenv/shims/python3'))
"     let g:python3_host_prog = glob('$XDG_DATA_HOME/pyenv/shims/python')
"   endif
"
"   augroup repl
"     autocmd!
"     autocmd FileType python
"       \ xmap <buffer> ,l <Plug>SlimeRegionSend|
"       \ nmap <buffer> ,l <Plug>SlimeLineSend|
"       \ nmap <buffer> ,p <Plug>SlimeParagraphSend|
"       \ nnoremap <silent> ✠ :TREPLSendLine<CR><Esc><Home><Down>|
"       \ inoremap <silent> ✠ <Esc>:TREPLSendLine<CR><Esc>A|
"       \ xnoremap <silent> ✠ :TREPLSendSelection<CR><Esc><Esc>
"       \ nnoremap <Leader>rF :T ptpython<CR>|
"       \ nnoremap <Leader>rf :T ipython --no-autoindent --colors=Linux --matplotlib<CR>|
"       \ nmap <buffer> <Leader>r<CR> :VT python %<CR>|
"       \ nnoremap ,rp :SlimeSend1 <C-r><C-w><CR>|
"       \ nnoremap ,rP :SlimeSend1 print(<C-r><C-w>)<CR>|
"       \ nnoremap ,rs :SlimeSend1 print(len(<C-r><C-w>), type(<C-r><C-w>))<CR>|
"       \ nnoremap ,rt :SlimeSend1 <C-r><C-w>.dtype<CR>|
"       \ nnoremap 223 ::%s/^\(\s*print\)\s\+\(.*\)/\1(\2)<CR>|
"       \ nnoremap ,rr :FloatermNew --autoclose=0 python %<space>|
"       \ call <SID>IndentSize(4)
"     autocmd FileType perl nmap <buffer> ,l <Plug>SlimeLineSend
"   augroup END
" }}} === vim-slime | python ===

" ============== vim-rust ============== {{{
" Plug 'nastevens/vim-cargo-make'
" Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" FIX: visual selection
" \ nmap     <buffer> <Leader>d<CR> :VT cargo play $(pwd)/**.rs<CR>|
" Trying to decide which one is the best (play, eval, rust-script)
" augroup rust_env
"   autocmd!
"   autocmd FileType rust
"     \ nmap     <buffer> <Leader>h<CR> :VT cargo clippy<CR>|
"     \ nmap     <buffer> <Leader>n<CR> :VT cargo run   -q<CR>|
"     \ nmap     <buffer> <Leader><Leader>n :VT cargo run -q<space>|
"     \ nmap     <buffer> <Leader>t<CR> :RustTest<CR>|
"     \ nmap     <buffer> <Leader>b<CR> :VT cargo build -q<CR>|
"     \ nmap     <buffer> <Leader>r<CR> :VT cargo play  %<CR>|
"     \ nmap     <buffer> <Leader><Leader>r :VT cargo play % -- |
"     \ nmap     <buffer> <Leader>v<CR> :VT rust-script %<CR>|
"     \ nmap     <buffer> <Leader><Leader>v :VT rust-script % -- |
"     \ nmap     <buffer> <Leader>e<CR> :VT cargo eval  %<CR>|
"     \ vnoremap <a-f> <esc>`<O<esc>Sfn main() {<esc>`>o<esc>S}<esc>k$|
"     \ nnoremap <Leader>K : set winblend=0 \| FloatermNew --autoclose=0 rusty-man --viewer tui<space>|
"     \ nnoremap <Leader>k : set winblend=0 \| FloatermNew --autoclose=0 rusty-man <C-r><C-w> --viewer tui<CR>|
"     \ nnoremap <buffer> ;ff           :RustFmt<cr>
" augroup END
" \ nnoremap ;k : set winblend=0 \| FloatermNew --autoclose=0 rusty-man <C-R>0<CR>|
" }}} === vim-rust ===

" ================ zig ================= {{{
augroup zig_env
  autocmd!
  autocmd FileType zig
    \ nnoremap <Leader>r<CR> : FloatermNew --autoclose=0 zig run ./%<CR>|
    \ nnoremap <buffer> ;ff           :Format<cr>
augroup END
" }}} === zig ===

" ============== vim-go ============== {{{
" Plug 'fatih/vim-go', { 'for': 'go' }
" " run and view go output in floating or split window
"   function! s:run_go(...)
"     if filereadable(expand("%:r"))
"       call delete(expand("%:r"))
"     endif
"     write
"     let arg = get(a:, 1, 0)
"     if arg == "split"
"       execute 'FloatermNew --autoclose=0 --wintype=vsplit --width=0.5 '
"         \ . ' go build ./% && ./%:r'
"     elseif arg == "float"
"       execute 'FloatermNew --autoclose=0 go build ./% && ./%:r'
"     endif
"   endfunction
"   command! GORUNS :call s:run_go("split")
"   command! GORUN :call s:run_go("float")
"   augroup GoRunCust
"     autocmd!
"     autocmd FileType go nnoremap <Leader>rv :GORUNS<CR>
"     autocmd FileType go nnoremap <Leader>ru :GORUN<CR>
"   augroup END
"   " au FileType go nmap <Leader>rp <Plug>(go-run)
"   " au FileType go nmap <Leader>rv <Plug>(go-run-vertical)
"
"   function! s:build_go_files()
"     let l:file = expand('%')
"     if l:file =~# '^\f\+_test\.go$'
"         call go#test#Test(0, 1)
"     elseif l:file =~# '^\f\+\.go$'
"         call go#cmd#Build(0)
"     endif
"   endfunction
"
"   augroup go_env
"     autocmd!
"     " Note: Do not change the order!
"     " Note: Do not comment lines inplace
"     " nmap <buffer> <Leader>K <Plug>(go-doc)|
"     " let g:go_doc_popup_window = 1
"     let g:go_rename_command = 'gopls'
"     autocmd FileType go
"       \ setl nolist|
"       \ nmap <buffer> <Leader>b<CR> :call <SID>build_go_files()<CR>|
"       \ nmap <buffer> <Leader>r<CR> <Plug>(go-run)|
"       \ nmap <buffer> <Leader>rr    :GoRun %<CR>|
"       \ nmap <buffer> <Leader>ri    :GoRun %<space>|
"       \ nmap <buffer> <Leader>t<CR> <Plug>(go-test)|
"       \ nmap <buffer> <Leader>c<CR> <Plug>(go-coverage-toggle)|
"       \ nmap <buffer> <Leader>gae <Plug>(go-alternate-edit)|
"       \ nmap <buffer> <Leader>i <Plug>(go-info)|
"       \ nmap <buffer> <Leader>sm :GoSameIdsToggle<CR>|
"       \ nmap <buffer> <C-A-n> :cnext<CR>|
"       \ nmap <buffer> <C-A-m> :cprevious<CR>|
"       \ nmap <buffer> <Leader>f :GoDeclsDir<cr>|
"       \ nmap <buffer> ;ff :GoFmt<CR>|
"       \ let g:go_fmt_command = "goimports"|
"       \ let g:go_list_type = "quickfix"|
"       \ let g:go_highlight_types = 1|
"       \ let g:go_highlight_fields = 1|
"       \ let g:go_highlight_functions = 1|
"       \ let g:go_highlight_methods = 1|
"       \ let g:go_highlight_operators = 1|
"       \ let g:go_highlight_build_constraints = 1|
"       \ let g:go_highlight_generate_tags = 1|
"       \ let g:go_gocode_propose_builtins = 1|
"       \ let g:go_gocode_unimported_packages = 1|
"       \ let g:go_doc_keywordprg_enabled = 0|
"       \ let g:go_fmt_fail_silently = 1|
"       \ command! -bang A call go#alternate#Switch(<bang>0, 'edit')|
"       \ command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')|
"       \ command! -bang AS call go#alternate#Switch(<bang>0, 'split')|
"       "\ let g:go_auto_type_info = 1|
"       "\ let g:go_updatetime = 100|
"       "\ let g:go_auto_sameids = 1|
"       "\ let g:go_play_open_browser = 1|
"   augroup END
" }}} === vim-go ===

" ============== vim-markdown ============== {{{
" Plug 'vim-pandoc/vim-rmarkdown'
" Plug 'vim-pandoc/vim-pandoc-syntax'
"   let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
"   let g:pandoc#after#modules#enabled = ['vim-table-mode']
"   let g:pandoc#syntax#codeblocks#embeds#langs=['c', 'python', 'sh', 'html', 'css']
"   let g:pandoc#formatting#mode = 'h'
"   let g:pandoc#modules#disabled = ['folding','formatting']
"   let g:pandoc#syntax#conceal#cchar_overrides = {'codelang': ' '}

" Plug 'plasticboy/vim-markdown'
  " let g:markdown_fenced_languages = [
  "       \ 'vim',
  "       \ 'html',
  "       \ 'c',
  "       \ 'py=python',
  "       \ 'python',
  "       \ 'go',
  "       \ 'rust',
  "       \ 'rs=rust',
  "       \ 'sh',
  "       \ 'shell=sh',
  "       \ 'bash=sh',
  "       \ 'json',
  "       \ 'yaml',
  "       \ 'toml',
  "       \ 'help'
  "       \]
  " let g:vim_markdown_follow_anchor = 1
"}}} === vim-markdown ===

" =================== clojure ================ {{{ "
" TODO: Use or delete
" Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
" Plug 'tpope/vim-fireplace',     { 'for': 'clojure' }
" Plug 'vim-scripts/paredit.vim', { 'for': 'clojure' }
" Plug 'luochen1990/rainbow',     { 'for': 'clojure' }
" let g:rainbow_active = 1
" " Plug 'venantius/vim-cljfmt', { 'for': 'clojure' }
" " Plug 'junegunn/rainbow_parentheses.vim'
" augroup clojure_env
"     autocmd!
"     autocmd FileType clojure
"         \ nmap <buffer> <silent> <c-l> <leader>>|
"         \ nmap <buffer> <silent> <c-h> <leader><|
"         \ silent! nunmap <c-l><c-l>|
"         \ silent! nunmap <c-h><c-h>
" augroup END
" }}} === clojure === "

" ============== vim-table-mode ============== {{{
" Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
"   " let g:table_mode_corner_corner='+'
"   " let g:table_mode_header_fillchar='='
"   augroup tablemode
"     autocmd!
"     autocmd FileType markdown,vimwiki
"       \ let g:table_mode_map_prefix = '<Leader>t'|
"       \ let g:table_mode_realign_map = '<Leader>tr'|
"       \ let g:table_mode_delete_row_map = '<Leader>tdd'|
"       \ let g:table_mode_delete_column_map = '<Leader>tdc'|
"       \ let g:table_mode_insert_column_after_map = '<Leader>tic'|
"       \ let g:table_mode_echo_cell_map = '<Leader>t?'|
"       \ let g:table_mode_sort_map = '<Leader>ts'|
"       \ let g:table_mode_tableize_map = '<Leader>tt'|
"       \ let g:table_mode_tableize_d_map = '<Leader>T' |
"       \ let g:table_mode_tableize_auto_border = 1|
"       \ let g:table_mode_corner='|'|
"       \ let g:table_mode_fillchar = '-'|
"       \ let g:table_mode_separator = '|'|
"   augroup END
" }}} === vim-table-mode ===

" ============== mkdx ============== {{{
" Plug 'SidOfc/mkdx', { 'for': 'markdown' }
  " let g:mkdx#settings     = {
  "       \ 'restore_visual': 1,
  "       \ 'gf_on_steroids': 1,
  "       \ 'highlight': { 'enable':   1 },
  "       \ 'enter':     { 'shift':    1 },
  "       \ 'map':       { 'prefix': 'm', 'enable': 1 },
  "       \ 'links':     { 'external': { 'enable': 1 } },
  "       \ 'checkbox':  {'toggles': [' ', 'x', '-'] },
  "       \ 'tokens':    { 'strike': '~~',
  "       \                'list': '*' },
  "       \ 'fold':      { 'enable':   1,
  "       \                'components': ['toc', 'fence'] },
  "       \ 'toc': {
  "       \    'text': 'Table of Contents',
  "       \    'update_on_write': 1,
  "       \    'details': { 'nesting_level': 0 }
  "       \ }
  "       \ }
  "
  " function! <SID>MkdxGoToHeader(header)
  "   call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
  " endfunction
  "
  " function! <SID>MkdxFormatHeader(key, val)
  "   let text = get(a:val, 'text', '')
  "   let lnum = get(a:val, 'lnum', '')
  "
  "   if (empty(text) || empty(lnum)) | return text | endif
  "   return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
  " endfunction
  "
  " function! <SID>MkdxFzfQuickfixHeaders()
  "   let headers = filter(
  "     \ map(mkdx#QuickfixHeaders(0),function('<SID>MkdxFormatHeader')),
  "     \ 'v:val != ""'
  "     \ )
  "
  "   call fzf#run(fzf#wrap({
  "     \ 'source': headers,
  "     \ 'sink': function('<SID>MkdxGoToHeader')
  "     \ }))
  " endfunction

  " inoremap <buffer><silent><unique> ``` ```<Enter>```<C-o>k<C-o>A
  " autocmd FileType markdown inoremap <expr> <C-x> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " augroup markdown
  "   autocmd!
  "   autocmd FileType markdown,vimwiki
  "     \ setl iskeyword+=-|
  "     \ vnoremap ``` <esc>`<O<esc>S```<esc>`>o<esc>S```<esc>k$|
  "     \ nnoremap <buffer> <F4> !pandoc % --pdf-engine=xelatex -o %:r.pdf|
  "     \ inoremap ** ****<Left><Left>|
  "     \ inoremap <expr> <right> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"|
  "     \ nnoremap <Leader>tg itags:<Space>macOS<CR>title:<CR>author:<Space>Lucas<Space>Burns<CR>date:<Space><C-r>=strftime('%F')<CR><CR>aside:<CR><CR>#|
  "     \ vnoremap <Leader>si :s/`/*/g<CR>
  " augroup END

      " autocmd! FileType vimwiki
      " autocmd FileType vimwiki :noremap <buffer> <Leader>z :! nohup zathura '%<.pdf' 2>&1 >/dev/null & disown<CR><CR>
      " autocmd FileType vimwiki :noremap <buffer> <Leader>c :! pandoc --self-contained -t pdf '%' -o '%<.pdf'<CR>

  autocmd FileType python vnoremap scw <esc>`<O<esc>S"""<esc>`>o<esc>S"""<esc>k$

  if (!$VIM_DEV)
    " when not developing mkdx, use fancier <leader>I which uses fzf
    " instead of qf to jump to headers in markdown documents.
  endif

" }}} === mkdx ===

" ============== UltiSnips ============== {{{
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
  " autocmd Filetype snippet set shiftwidth=4

Plug 'vim-scripts/RltvNmbr.vim'
nmap <Leader>rl :RltvNmbr<CR>

" }}} ==== UltiSnips ===

" ============== Vim Wiki ============== {{{
" Plug 'vimwiki/vimwiki'
  " let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
  " let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
  " let g:vimwiki_table_mappings = 0
  "
  " map <Leader>vw :VimwikiIndex<CR>
"}}} === Vim Wiki ===

" ========= Syntax Highlighting ======== {{{
" Plug 'sheerun/vim-polyglot'
" let g:polyglot_disabled = ['markdown', 'python', 'rust', 'java', 'lua', 'ruby', 'zig', 'd']

" Plug 'wfxr/dockerfile.vim'  | let g:polyglot_disabled += ['dockerfile']
" Plug 'rhysd/vim-rustpeg'    | let g:polyglot_disabled += ['rustpeg']
" Plug 'NoahTheDuke/vim-just' | let g:polyglot_disabled += ['just']
" Plug 'camnw/lf-vim'         | let g:polyglot_disabled += ['lf']
" Plug 'ron-rs/ron.vim'       | let g:polyglot_disabled += ['ron']

" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'RRethy/nvim-treesitter-endwise'
" Plug 'nvim-treesitter/playground'
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'
"}}} === Syntax Highlighting ===

" ========== File Viewer ========== {{{
" Plug 'mattn/vim-xxdcursor'  | Plug 'fidian/hexmode'     | let g:hexmode_patterns = '*.o,*.so,*.a,*.out,*.bin,*.exe'
" Plug 'jamessan/vim-gnupg'
" Plug 'AndrewRadev/id3.vim'

" Plug 'alx741/vinfo'
" Plug 'HiPhish/info.vim'

" if &buftype =~? 'info'
"     nmap <buffer> gu <Plug>(InfoUp)
"     nmap <buffer> gn <Plug>(InfoNext)
"     nmap <buffer> gp <Plug>(InfoPrev)
"     nmap <buffer> gm <Plug>(InfoMenu)
"     nmap <buffer> gf <Plug>(InfoFollow)
" endif
" }}} === File Viewer ===

" ============= telescope ============= {{{
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'tami5/sqlite.lua'
" Plug 'AckslD/nvim-neoclip.lua'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'nvim-telescope/telescope-frecency.nvim'
" Plug 'fhill2/telescope-ultisnips.nvim'
" Plug 'fannheyward/telescope-coc.nvim'
" Plug 'dhruvmanila/telescope-bookmarks.nvim'
"
" Plug 'sindrets/diffview.nvim'
"
" Plug 'lewis6991/gitsigns.nvim'
" Plug 'folke/todo-comments.nvim'
" Plug 'Pocco81/HighStr.nvim'

" Plug 'numToStr/Comment.nvim'
" Plug 'folke/which-key.nvim'

" }}} === telescope ===

" ============== minimap ============== {{{
" Plug 'wfxr/minimap.vim'
"   nnoremap <Leader>mi :MinimapToggle<CR>
"   let g:minimap_width = 10
"   let g:minimap_auto_start = 0
"   let g:minimap_auto_start_win_enter = 1
"   let g:minimap_highlight_range = 1
"   let g:minimap_block_filetypes =
"     \ ['fugitive', 'nerdtree', 'help', 'vista']
"   let g:minimap_close_filetypes = ['startify', 'netrw', 'vim-plug', 'floaterm']
"   let g:minimap_block_buftypes = ['nofile', 'nowrite', 'quickfix', 'terminal', 'prompt']
" }}} === minimap ===

" ============== FZF & Ripgrep ============== {{{
" Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
" Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'

  nmap <silent> <Leader>T  :Tags<CR>
  nmap <silent> <A-t> :BTags<CR>

  command! -bang Colors
    \ call fzf#vim#colors(g:fzf_vim_opts, <bang>0)
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>,
    \ fzf#vim#with_preview(g:fzf_vim_opts, 'right:60%:default'), <bang>0)
  command! -bang Buffers
    \ call fzf#vim#buffers(
    \ fzf#vim#with_preview(g:fzf_vim_opts, 'right:60%:default'), <bang>0)
  command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap({'source': 'ls', 'dir': <q-args>}, <bang>0))
  command! -bang Conf
    \ call fzf#vim#files('~/.config', <bang>0)
  command! -bang Proj
    \ call fzf#vim#files('~/projects', fzf#vim#with_preview(), <bang>0)
  command! -nargs=? -complete=dir AF
    \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \ 'source': 'fd --type f --hidden --follow --exclude .git --no-ignore
      \ . '.expand(<q-args>) })))

  " command! -bang -nargs=* Rg
  "   \ call fzf#vim#grep(
  "   \   'rg --column --line-number --no-heading '
  "     \ . '--color=always --smart-case -- '.shellescape(<q-args>), 1,
  "   \   fzf#vim#with_preview(g:fzf_vim_opts, 'right:60%:default'), <bang>0)

    " prevent from searching for file names as well
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
      \ 'rg --column --line-number --hidden --smart-case '
        \ . '--no-heading --color=always '
        \ . shellescape(<q-args>),
        \ 1,
        \ {'options':  '--delimiter : --nth 4..'},
        \ 0)

  " TODO: add option for trans -d
  " TODO: add option for uni-fzf
  " FIX: open line in current buffer only
    command! -bang -nargs=* Rgf call RGF()
    function! RGF()
      " . ' -F '.expand('%:t')"
      let fixmestr =
        \ '(FIXME|FIX|DISCOVER|NOTE|NOTES|INFO|OPTIMIZE|XXX|EXPLAIN|TODO|HACK|BUG|BUGS):'
      call fzf#vim#grep(
        \ 'rg --column --no-heading --line-number --color=always '.shellescape(fixmestr),
        \ 1,
        \ {'options':  '--delimiter : --nth 4..'}, 0)
    endfunction

  " RG with preview
  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading '
      \ . '--color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options':
      \ ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1,
      \ fzf#vim#with_preview(spec, 'right:60%:default'), a:fullscreen)
  endfunction

  " dotbare (dotfile manager) - edit file
  command! Dots call fzf#run(fzf#wrap({
  \ 'source': 'dotbare ls-files --full-name --directory "${DOTBARE_TREE}" '
    \ . '| awk -v home="${DOTBARE_TREE}/" "{print home \$0}"',
  \ 'sink': 'e',
  \ 'options': [ '--multi', '--preview', 'cat {}' ]
  \ }))

  function! s:plug_help_sink(line)
    let dir = g:plugs[a:line].dir
    for pat in ['doc/*.txt', 'README.md']
      let match = get(split(globpath(dir, pat), "\n"), 0, '')
      if len(match)
        execute 'tabedit' match
        return
      endif
    endfor
    tabnew
    execute 'Explore' dir
  endfunction

  command! PlugHelp call fzf#run(fzf#wrap({
    \ 'source': sort(keys(g:plugs)),
    \ 'sink':   function('s:plug_help_sink')}))

  " TODO: Make like macho
  " nmap ... :Telescope man_pages
  command! -nargs=? Apropos call fzf#run(fzf#wrap({
      \ 'source': 'apropos '
          \ . (len(<q-args>) > 0 ? shellescape(<q-args>) : ".")
          \ .' | cut -d " " -f 1',
      \ 'sink': 'tab Man',
      \ 'options': [
          \ '--preview', 'MANPAGER=cat MANWIDTH='.(&columns/2-4).' man {}']}))

  " \ . '| grep -vE "^.+ \(0\)" | awk ''{print $2 "    " $1}'' | sed -E "s/^\((.+)\)/\1/"',

  " Line completion (same as :Bline)
  " imap <C-a> <C-x><C-l>
  imap <C-x><C-z> <Plug>(fzf-complete-line)
  " inoremap <expr> <C-x><c-d> fzf#vim#complete('cat /usr/share/dict/words')

    " word completion popup
  inoremap <expr> <C-x><C-w> fzf#vim#complete#word({
    \ 'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

  " word completion window
  inoremap <expr> <C-x><C-a> fzf#vim#complete({
    \ 'source':  'cat /usr/share/dict/words',
    \ 'options': '--multi --reverse --margin 15%,0',
    \ 'left':    20})

  " clipboard manager -- unsure why a direct mapping doesn't work
  inoremap <expr> <a-.> fzf#vim#complete({
    \ 'source': 'copyq eval -- "tab(\"&clipboard\"); for(i=size(); i>0; --i) print(str(read(i-1)) + \"\n\");" \| tac',
    \ 'options': '--no-border',
    \ 'reducer': { line -> substitute(line[0], '^ *[0-9]\+ ', '', '') },
    \ 'window': 'call FloatingFZF()'})

  inoremap <expr> <a-;> fzf#complete({
      \ 'source': 'greenclip print 2>/dev/null \| grep -v "^\s*$" \| nl -w2 -s" "',
      \ 'options': '--no-border',
      \ 'reducer': { line -> substitute(line[0], '^ *[0-9]\+ ', '', '') },
      \ 'window': 'call FloatingFZF()'})

  function! s:create_float(hl, opts)
    let buf = nvim_create_buf(v:false, v:true)
    let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:'.a:hl)
    call setwinvar(win, '&colorcolumn', '')
    return buf
  endfunction

  function! FloatingFZF()
    " Size and position
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let row = float2nr((&lines - height) / 2)
    let col = float2nr((&columns - width) / 2)

    " Border
    let top = '┏━' . repeat('─', width - 4) . '━┓'
    let mid = '│'  . repeat(' ', width - 2) .  '│'
    let bot = '┗━' . repeat('─', width - 4) . '━┛'
    let border = [top] + repeat([mid], height - 2) + [bot]

    " Draw frame
    let s:frame = s:create_float('Comment',
      \ {'row': row, 'col': col, 'width': width, 'height': height})
    call nvim_buf_set_lines(s:frame, 0, -1, v:true, border)

    " Draw viewport
    call s:create_float('Normal',
      \ {'row': row + 1, 'col': col + 2, 'width': width - 4, 'height': height - 2})

    augroup fzf_floating
      au!
      au BufWipeout <buffer> execute 'bwipeout' s:frame
    augroup END
  endfunction

  " :Commands -- :GFiles? -- :Commits
  " change directory to buffers dir
  nmap <Leader>cd :lcd %:p:h<CR>
  nmap <Leader>Lo :Locate .<CR>
  nmap <C-f> :Rg<CR>


  nmap <silent> <Leader>ab  :CocCommand fzf-preview.AllBuffers<CR>
  nmap <silent> <Leader>A  :Windows<CR>

  nmap <silent> <Leader>C  :CocCommand fzf-preview.Changes<CR>

  " == Lines
  " nmap <silent> <Leader>;  :BLines<CR>
  " nmap <silent> <Leader>;  :CocCommand fzf-preview.BufferLines<CR>
  nmap <silent> <LocalLeader>;  :CocCommand fzf-preview.Lines<CR>


  " == Grep
  nmap <LocalLeader>r :RG<CR>

  " == Files
  nmap <silent> <A-f>  :Files<CR>
  nmap <silent> <LocalLeader>d  :CocCommand fzf-preview.ProjectFiles<CR>
  " nmap <silent> ,d  :CocCommand fzf-preview.DirectoryFiles<CR>
  " nmap <silent> <LocalLeader>r  :CocCommand fzf-preview.MruFiles<CR>
  nmap <silent> <LocalLeader>g  :CocCommand fzf-preview.GitFiles<CR>

  " nmap <silent> <LocalLeader>T  :CocCommand fzf-preview.TodoComments<CR>
  nmap <silent> <LocalLeader>T  :TodoTelescope<CR>

  nmap <silent> <Leader>gf :GFiles<CR>
  " nmap <silent> <Leader>hc :History:<CR>
  nmap <silent> <Leader>hf :History<CR>
  " nmap <silent> <Leader>hh :History/<CR>
  " nmap <silent> <Leader>cs :Colors<CR>

  " nmap <silent> <leader><space><space>so :<C-u>CocCommand snippets.openSnippetFiles<cr>
  " nmap <silent> <Leader>se :<C-u>CocCommand snippets.editSnippets<cr>
  " nmap <silent> <Leader>si :Snippets<CR>
  nmap <silent> <Leader>se :CocFzfList snippets<CR>
  nmap <silent> <Leader>si :Telescope ultisnips<CR>
  nmap <silent> <Leader>ls :LS<CR>
  nmap <silent> <Leader>cm :Commands<CR>
  nmap <silent> <Leader>ht :Helptags<CR>

  " nmap <silent> <Leader>mk :Marks<CR>
  nmap <silent> <m-/>  :CocCommand fzf-preview.Marks<CR>
  nmap <Leader>mlm :marks<CR>
  nmap <Leader>mfd :delm! | delm A-Z0-9<CR>
  nmap <Leader>mld :delmarks a-z<CR>

  " nmap <silent> <Leader>mm :Maps<CR>
  nnoremap ;k <cmd>Telescope keymaps<CR>
  nmap <C-l>m <plug>(fzf-maps-n)
  xmap <C-l>m <plug>(fzf-maps-x)
  imap <C-l>m <plug>(fzf-maps-i)
  omap <C-l>m <plug>(fzf-maps-o)

  " hide status and ruler for fzf
  au FileType fzf
    \ set laststatus& laststatus=0 |
    \ au BufLeave <buffer> set laststatus&

  " let $SKIM_DEFAULT_COMMAND = "git ls-tree -r --name-only HEAD || rg --files
  " let g:rg_command = 'rg --vimgrep --hidden'
  let g:rg_highlight = 'true'
  let g:rg_format = '%f:%l:%c:%m,%f:%l:%m'

  " let g:fzf_preview_window = ''
  let g:fzf_preview_quit_map = 1
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  " let g:fzf_layout         = { 'down': '~40%' }
  let g:fzf_vim_opts = {'options': ['--no-border']} "
  let g:fzf_buffers_jump = 1
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-m': 'edit',
    \ 'alt-v':  'vsplit',
    \ 'alt-t':  'nabnew',
    \ 'alt-x':  'split',
    \}

  let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'kimbro'
  let g:fzf_preview_use_dev_icons = 1
  let g:fzf_preview_dev_icon_prefix_string_length = 3
  let g:fzf_preview_dev_icons_limit = 2000
  " let g:fzf_preview_fzf_preview_window_option = 'nohidden'
  let g:fzf_preview_default_fzf_options = {
    \ '--no-border': v:true,
    \ '--reverse': v:true,
    \ '--preview-window': 'wrap' ,
    \}
" }}} === FZF & Ripgrep ===

  " HTML/CSS
  Plug 'alvan/vim-closetag'

" ============== Themes ============== {{{
  " Plug 'Rigellute/rigel'
  " Plug 'lifepillar/vim-gruvbox8'
  " Plug 'morhetz/gruvbox'
  " Plug 'gavinok/spaceway.vim'
  Plug 'AlessandroYorba/Alduin'
  Plug 'franbach/miramare'
  Plug 'wojciechkepka/bogster'
  Plug 'wojciechkepka/vim-github-dark'
  Plug 'haishanh/night-owl.vim'
  Plug 'ackyshake/Spacegray.vim'
  Plug 'bluz71/vim-nightfly-guicolors'
  Plug 'savq/melange'
  Plug 'ajmwagar/vim-deus'
  Plug 'habamax/vim-gruvbit'
  Plug 'lmburns/kimbox'
  Plug 'lmburns/overcast'
  Plug 'nanotech/jellybeans.vim'
  Plug 'cocopon/iceberg.vim'
  Plug 'sainnhe/gruvbox-material'
  Plug 'sainnhe/edge'
  Plug 'sainnhe/everforest'
  Plug 'b4skyx/serenade'
  Plug 'joshdick/onedark.vim'
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'srcery-colors/srcery-vim'
  Plug 'wadackel/vim-dogrun'
  Plug 'glepnir/oceanic-material'
  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'KeitaNakamura/neodark.vim'
  Plug 'tyrannicaltoucan/vim-deep-space'

  " Lua
  Plug 'marko-cerovac/material.nvim'
  Plug 'sainnhe/sonokai'

  " Plug 'kaicataldo/material.vim', { 'branch': 'main' }
  " Plug 'embark-theme/vim', { 'as': 'embark' }
  " Plug 'mhartington/oceanic-next'
  " Plug 'aswathkk/DarkScene.vim'
" }}} === Themes ===

call plug#end()

" ============== Theme Settings ============== {{{
  " let g:gruvbox_material_background = 'medium'
  let g:gruvbox_material_palette = 'mix'
  " let g:gruvbox_material_palette = 'material'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_enable_bold = 1
  let g:gruvbox_material_disable_italic_comment = 1
  let g:gruvbox_material_current_word = 'grey background'
  let g:gruvbox_material_visual = 'grey background'
  let g:gruvbox_material_cursor = 'green'
  let g:gruvbox_material_sign_column_background = 'none'
  let g:gruvbox_material_statusline_style = 'mix'
  let g:gruvbox_material_better_performance = 1
  let g:gruvbox_material_diagnostic_text_highlight = 0
  let g:gruvbox_material_diagnostic_line_highlight = 0
  let g:gruvbox_material_diagnostic_virtual_text = 'colored'

  " let g:kimbox_background = 'deep'
  " let g:kimbox_background = 'medium' " brown
  " let g:kimbox_background = 'darker' " dark dark purple
  " let g:kimbox_background = 'ocean' " dark purple
  let g:kimbox_allow_bold = 1
  let g:overcast_allow_bold = 1

  let g:oceanic_material_background = "ocean"
  " let g:oceanic_material_background = "deep"
  " let g:oceanic_material_background = "medium"
  " let g:oceanic_material_background = "darker"
  let g:oceanic_material_allow_bold = 1
  let g:oceanic_material_allow_italic = 1
  let g:oceanic_material_allow_underline = 1

  let g:everforest_disable_italic_comment = 1
  let g:everforest_background = 'hard'
  let g:everforest_enable_italic = 0
  let g:everforest_sign_column_background = 'none'
  let g:everforest_better_performance = 1

  let g:edge_style = 'aura'
  let g:edge_cursor = 'blue'
  let g:edge_sign_column_background = 'none'
  let g:edge_better_performance = 1

  " let g:material_theme_style = 'darker-community'
  let g:material_theme_style = 'ocean-community'
  let g:material_terminal_italics = 1

  " maia atlantis era
  " let g:sonokai_style = 'andromeda'
  let g:sonokai_style = 'shusia'
  let g:sonokai_enable_italic = 1
  let g:sonokai_disable_italic_comment = 1
  let g:sonokai_cursor = 'blue'
  let g:sonokai_sign_column_background = 'none'
  let g:sonokai_better_performance = 1
  let g:sonokai_diagnostic_text_highlight = 0

  " let g:miramare_enable_italic = 1
  let g:miramare_enable_bold = 1
  let g:miramare_disable_italic_comment = 1
  let g:miramare_cursor = 'purple'
  let g:miramare_current_word = 'grey background'

  let g:gruvbox_contrast_dark = 'medium'
  let g:spacegray_use_italics = 1

  func! s:gruvbit_setup() abort
    hi Comment gui=italic cterm=italic
    hi Statement gui=bold cterm=bold
    hi Comment gui=italic cterm=italic
  endfunc

  augroup colorscheme_change | au!
    au ColorScheme gruvbit call s:gruvbit_setup()
  augroup END

  set guioptions-=m
  set guioptions-=r
  set guioptions-=L

  if exists('g:neovide')
    set guifont=FiraMono\ Nerd\ Font\ Mono:style=Medium:h12
    nnoremap <D-v> "+p
    inoremap <D-v> <c-r>+
  endif

  " let g:neovide_cursor_animation_length = 0.15
  " let g:neovide_remember_window_size = v:true
  let g:neovide_input_use_logo = v:true
  let g:neovide_transparency=0.9
  let g:neovide_cursor_vfx_particle_lifetime=2.0
  let g:neovide_cursor_vfx_particle_density=12.0
  let g:neovide_cursor_vfx_mode = 'torpedo'
  " let g:neovide_cursor_vfx_mode = "pixiedust"

  syntax enable
  colorscheme kimbox
  " colorscheme overcast
  " colorscheme serenade
  " colorscheme everforest
  " colorscheme gruvbox-material
  " colorscheme sonokai
  " colorscheme oceanic_material
  " colorscheme spaceduck
  " colorscheme bogster
  " colorscheme material
  " colorscheme miramare
  " colorscheme night-owl
  " colorscheme jellybeans
  " colorscheme gruvbit
  " colorscheme deep-space
  " colorscheme melange
  " colorscheme iceberg
  " coloscheme OceanicNext
  " colorscheme deus
  " colorscheme onedark
  " colorscheme neodark
  " colorscheme spaceway    " needs work
  " colorscheme alduin      " needs work
  " colorscheme spacegray
  " colorscheme tokyonight

  " colorscheme material
  " edge daycula srcery dogrun palenight

" }}} === Theme Settings ===

" ============== General Mappings ============== {{{

  " }}} === General Mappings ===

" ============== docs ============== {{{
  let g:zipPlugin_ext = '*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.celzip,*.oxt,*.kmz,*.wsz,*.xap,*.docm,*.dotx,*.dotm,*.potx,*.potm,*.ppsx,*.ppsm,*.pptx,*.pptm,*.ppam,*.sldx,*.thmx,*.xlam,*.xlsx,*.xlsm,*.xlsb,*.xltx,*.xltm,*.xlam,*.crtx,*.vdw,*.glox,*.gcsx,*.gqsx'

  " autocmd BufReadPost *.odt :%!odt2txt %

  " autocmd BufReadPost *.odt silent %!pandoc "%" -tmarkdown -o /dev/stdout
  " autocmd BufWritePost *.odt :%!pandoc -f markdown "%" -o "%:r".odt

  " NOTE: `,kp` compiles RMarkdown to PDF using NVim-R
  autocmd Filetype rmd map <F5> :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<enter>

  nmap <Leader>cp :w! <bar> !compiler %<CR>
  nmap <Leader>pr :!opout <c-r>%<CR><CR>
" }}} === General Mappings ===

" ============== Syntax ============== {{{
" }}} === Syntax ===

" ============== Other Functions ============== {{{


  " open in browser {{{
  function! s:go_github()
      let s:repo = matchstr(expand('<cWORD>'), '\v[0-9A-Za-z\-\.\_]+/[0-9A-Za-z\-\.\_]+')
      if empty(s:repo)
          echo 'GoGithub: No repository found.'
      else
          let s:url = 'https://github.com/' . s:repo
          " call netrw#BrowseX(s:url, 0)
          call openbrowser#open(s:url)
      end
  endfunction

  augroup gogithub
      au!
      au FileType *vim,*bash,*tmux,zsh,lua nnoremap <buffer> <silent> <leader><cr> :call <sid>go_github()<cr>
  augroup END

  " Sources neovim first
  command! PluginUpdate source $VIMRC | :PlugUpdate
  command! PluginClean  source $VIMRC | :PlugClean
  " }}}

  " ============== wilder.nvim ============== {{{ "
  function! s:shouldDisable(x)
    let l:cmd = wilder#cmdline#parse(a:x).cmd
    return l:cmd ==# 'Man' || a:x =~# 'Git fetch origin '
  endfunction

  call wilder#enable_cmdline_enter()
  set wildcharm=<Tab>
  cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
  cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

  call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<Tab>',
      \ 'previous_key': '<S-Tab>',
      \ 'accept_key': '<A-,>',
      \ 'reject_key': '<A-.>',
      \ })

  " call wilder#set_option('modes', ['/', '?', ':'])
  " call wilder#set_option('renderer', wilder#popupmenu_renderer({
  "             \ 'highlighter': wilder#basic_highlighter(),
  "             \ 'left': [
  "             \   wilder#popupmenu_devicons(),
  "             \ ],
  "             \ }))
  " call wilder#set_option('pipeline', [
  "             \   wilder#branch(
  "             \     wilder#cmdline_pipeline({
  "             \       'language': 'python',
  "             \       'fuzzy': 1,
  "             \     }),
  "             \     wilder#python_search_pipeline({
  "             \       'pattern': wilder#python_fuzzy_pattern(),
  "             \       'sorter': wilder#python_difflib_sorter(),
  "             \       'engine': 're',
  "             \     }),
  "             \   ),
  "             \ ])

  call wilder#set_option('renderer', wilder#renderer_mux({
        \ ':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
        \   'highlighter': wilder#basic_highlighter(),
        \   'border': 'rounded',
        \   'max_height': 15,
        \   'highlights': {
        \     'border': 'Normal',
        \     'default': 'Normal',
        \     'accent': wilder#make_hl(
        \       'PopupmenuAccent', 'Normal', [{}, {}, {'foreground': '#A06469'}]),
        \   },
        \   'left': [
        \     ' ', wilder#popupmenu_devicons(),
        \   ],
        \   'right': [
        \     ' ', wilder#popupmenu_scrollbar(),
        \   ],
        \ })),
        \
        \ '/': wilder#wildmenu_renderer({
        \   'highlighter': wilder#basic_highlighter(),
        \   'highlights': {
        \     'accent': wilder#make_hl(
        \       'WildmenuAccent', 'StatusLine', [{}, {}, {'foreground': '#A06469'}]),
        \   },
        \ }),
        \ }))

  call wilder#set_option('pipeline', [
             \  wilder#branch(
             \    [
             \      wilder#check({-> getcmdtype() ==# ':'}),
             \      {ctx, x -> s:shouldDisable(x) ? v:true : v:false},
             \    ],
             \    wilder#python_file_finder_pipeline({
             \      'file_command': {_, arg -> arg[0] ==# '.' ? ['rg', '--files', '--hidden'] : ['rg', '--files']},
             \      'dir_command':  {_, arg -> arg[0] ==# '.' ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
             \      'filters': ['fuzzy_filter', 'difflib_sorter'],
             \    }),
             \    wilder#cmdline_pipeline({
             \      'language': 'python',
             \      'fuzzy': 1,
             \      'set_pcre2_pattern': 1,
             \    }),
             \    wilder#python_search_pipeline({
             \      'pattern': wilder#python_fuzzy_pattern(),
             \      'sorter': wilder#python_difflib_sorter(),
             \      'engine': 're',
             \    }),
             \   ),
             \ ])
 " }}} === wilder ===

  " IndentSize: Change indent size depending on file type {{{
  function! <SID>IndentSize(amount)
    exe "setlocal expandtab"
       \ . " ts="  . a:amount
       \ . " sts=" . a:amount
  endfunction
  " }}} IndentSize

  " ExecuteBuffer: execute current buffer === {{{ "
  function! s:execute_buffer()
    if !empty(expand('%'))
        write
        call system('chmod +x '.expand('%'))
        silent e
        vsplit | terminal ./%
    else
        echohl WarningMsg
        echo 'Save the file first'
        echohl None
    endif
  endfunction
  command! RUN :call s:execute_buffer()
  augroup ExecuteBuffer
      au!
      au FileType sh,bash,zsh,python,ruby,perl,lua nnoremap <Leader>r<CR> :RUN<cr>
      au FileType sh,bash,zsh,python,ruby,perl,lua nnoremap <Leader>lru
        \ :FloatermNew --autoclose=0 ./%<cr>
  augroup END
  " }}} ExecuteBuffer

  " filetype specific indents
  autocmd FileType typescript nnoremap <Leader>r<CR> :FloatermNew tsc % && node %:r.js <CR>
  autocmd FileType javascript nnoremap <Leader>r<CR> :FloatermNew node % <CR>
  autocmd FileType markdown,json,javascript call <SID>IndentSize(4)
  autocmd BufRead,BufNewFile *.htm,*.html call <SID>IndentSize(2)
"}}} === Other Functions ===

" ============== vim-clang ============== {{{
autocmd FileType c nnoremap <Leader>r<CR> :FloatermNew --autoclose=0 gcc % -o %< && ./%< <CR>

augroup cpp_env
  autocmd!
  autocmd FileType cpp
    \ nnoremap <Leader>r<CR> :FloatermNew --autoclose=0 g++ % -o %:r && ./%:r <CR>|
    \ nnoremap <buffer> <Leader>kk :Fcman<CR>
augroup END

function! s:FullCppMan()
    let old_isk = &iskeyword
    setl iskeyword+=:
    let str = expand("<cword>")
    let &l:iskeyword = old_isk
    execute 'Man ' . str
endfunction
command! Fcman :call s:FullCppMan()
" }}} === vim-clang ===

" ============== Default Terminal ============== {{{
  command! -nargs=* TP botright sp | resize 20 | term <args>
  command! -nargs=* VT vsp | term <args>
  noremap <A-i> :TP<cr>A

  let g:term_buf = 0
  let g:term_win = 0
  function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen("zsh", {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
  endfunction

  " Toggle terminal on/off (neovim)
  nnoremap <C-t> :call TermToggle(12)<CR>
  inoremap <C-t> <Esc>:call TermToggle(12)<CR>
  tnoremap <C-t> <C-\><C-n>:call TermToggle(12)<CR>

  " Terminal go back to normal mode
  tnoremap <Esc> <C-\><C-n>
  tnoremap :q! <C-\><C-n>:q!<CR>
" }}} === Default Terminal ===


" ===================== Lua ====================== {{{
" lua require('plugins/which-key')
" lua require('plugins/comment')
" lua require('neoscroll').setup()

" lua require('base')
" lua require('lutils')
" lua require('options')
" lua require('plugins')

lua require('plugs/tree-sitter')
" lua require('plugins-d/nvim-neoclip')
" lua require('plugins-d/diffview')
" lua require('plugins-d/gitsigns')
" lua require('plugins-d/telescope')
" lua require('plugins-d/todo-comments')

" ============== highlight line ============== {{{
" lua require('plugins-d/HighStr')

vnoremap <silent> <Leader>hi :<c-u>HSHighlight<space>
vnoremap <silent> <Leader>hr :<c-u>HSRmHighlight<CR>
" }}} === highlight line ===

" }}} === Lua ===

" ============== background transparent / colors ============== {{{
  highlight DiffAdd      ctermfg=white ctermbg=NONE guifg=#5F875F guibg=NONE
  highlight DiffChange   ctermfg=white ctermbg=NONE guifg=#5F5F87 guibg=NONE
  highlight DiffDelete   ctermfg=white ctermbg=NONE guifg=#cc6666 guibg=NONE
  highlight DiffText     cterm=bold ctermfg=white ctermbg=DarkRed

  hi HighlightedyankRegion ctermbg=Red   guibg=#fb4934
  hi GitBlameVirtualText   cterm=italic  ctermfg=245   gui=italic guifg=#665c54


  hi VimwikiBold    guifg=#a25bc4 gui=bold
  hi VimwikiCode    guifg=#d3869b
  hi VimwikiItalic  guifg=#83a598 gui=italic

  hi VimwikiHeader1 guifg=#F14A68 gui=bold
  hi VimwikiHeader2 guifg=#F06431 gui=bold
  hi VimwikiHeader3 guifg=#689d6a gui=bold
  hi VimwikiHeader4 guifg=#819C3B gui=bold
  hi VimwikiHeader5 guifg=#98676A gui=bold
  hi VimwikiHeader6 guifg=#458588 gui=bold

" }}} === transparent ===

" vim: ft=vim:et:sw=0:ts=2:sts=2:tw=78:fdm=marker:fmr={{{,}}}:
