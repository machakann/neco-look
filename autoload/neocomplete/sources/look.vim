let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name': 'look',
      \ 'kind': 'plugin',
      \ 'mark': '[look]',
      \ 'max_candidates': 15,
      \ 'min_pattern_length' : 4,
      \ 'is_volatile' : 1,
      \ }

function! s:source.gather_candidates(context)
  if neocomplete#is_auto_complete() &&
        \ !(&spell || neocomplete#is_text_mode()
        \   || neocomplete#within_comment())
        \ || a:context.complete_str !~ '^[[:alpha:]]\+$'
    return []
  endif

  let list = split(s:get_words(
        \ a:context.complete_str, self.max_candidates), "\n")
  if neocomplete#util#get_last_status()
    return []
  endif

  return map(list, "substitute(v:val,
        \ '^' . tolower(a:context.complete_str),
        \ a:context.complete_str, '')")
endfunction

function! neocomplete#sources#look#define()
  return executable('look') ? s:source : {}
endfunction

if has('win32')
  function! s:get_words(str, max_candidates) abort
    return neocomplete#util#system(
        \ 'look ' . a:str)
  endfunction
else
  function! s:get_words(str, max_candidates) abort
    return neocomplete#util#system(
        \ 'look ' . a:str . ' | head -n ' . a:max_candidates)
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
