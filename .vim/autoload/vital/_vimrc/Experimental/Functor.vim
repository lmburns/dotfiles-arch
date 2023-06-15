" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_vimrc#Experimental#Functor#import() abort', printf("return map({'wrap': '', 'bind': '', 'call': '', 'curry': '', 'localfunc': ''}, \"vital#_vimrc#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" "Callable thing" in vital.

let s:save_cpo = &cpo
set cpo&vim


" [Callable Object] is one of the following values:
" - function name (String)
" - Funcref value
" - callable object
"
" [Functor] is a Dictionary which has the key "do" of Funcref value.
" Please note that `Functor.wrap([Callable Object]).do` is always Funcref value.
" So you can always call .do() method without checking return value of `Functor.wrap()`.
" e.g.: `Functor.wrap("").do()`


" The same arguments as call()
" but first argument is [Callable Object].
function! s:call(callable, args, ...) abort
  let functor = s:wrap(a:callable)
  return call(functor.do, a:args, (a:0 ? a:1 : functor))
endfunction

" Convert [Callable Object] to [Functor].
" NOTE: `s:wrap(callable).do` must be Funcref value.
let s:TYPE_STRING  = type('')
let s:TYPE_FUNCREF = type(function('tr'))
let s:TYPE_DICT    = type({})
function! s:wrap(callable) abort
  if type(a:callable) ==# s:TYPE_FUNCREF
    return {'do': a:callable}
  elseif type(a:callable) ==# s:TYPE_STRING
    return {'do': function(a:callable)}
  elseif type(a:callable) ==# s:TYPE_DICT
  \   && has_key(a:callable, 'do')
    if type(a:callable.do) ==# s:TYPE_FUNCREF
      return a:callable
    elseif type(a:callable.do) ==# s:TYPE_STRING
      return extend(a:callable, {
      \   'do': function(a:callable.do),
      \}, 'force')
    endif
  endif
  throw 'vital: Experimental.Functor: wrap(): '
  \   . 'a:callable is not callable!'
endfunction

" Bind a:this to a:callable's `self`.
function! s:bind(callable, this) abort
  let this = copy(a:this)
  let this.do = s:wrap(a:callable).do
  return this
endfunction

" Curry a:callable's 1st argument with a:v.
function! s:curry(callable, v) abort
  return {
  \   'do': s:localfunc('__curry_stub', s:__sid()),
  \   '__functor': s:wrap(a:callable),
  \   '__value': a:v,
  \}
endfunction
function! s:__curry_stub(...) dict abort
  return s:call(self.__functor, [self.__value] + a:000)
endfunction
function! s:__sid() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze___sid$')
endfunction

" Convert script-local function to globally callable function.
function! s:localfunc(funcname, sid) abort
  return function(printf('<SNR>%d_%s', a:sid, a:funcname))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
