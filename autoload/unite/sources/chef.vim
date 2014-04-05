" unite source: chef
" Version: 1.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'hooks': {},
\ }

function! s:source.hooks.on_init(args, context)
  let a:context._base = finddir('site-cookbooks', getcwd() . ';')
endfunction

function! s:source.gather_candidates(args, context)
  let pat = a:context._base . '/*/' . self.source__type . '/*'
  let files = map(split(glob(pat), "\n"),
  \               'unite#util#substitute_path_separator(v:val)')
  return map(files, '{
  \   "word": s:word(v:val, self.source__type),
  \   "kind": isdirectory(v:val) ? "directory" : "file",
  \   "action__path": v:val,
  \   "action__directory": v:val,
  \ }')
endfunction

function! s:word(path, type)
  let pat = '\([^/]\+\)/' . a:type . '/\(.*\)\%(\.rb\)\?$'
  let list = matchlist(a:path, pat)
  return list[1] . '/' . list[2]
endfunction

function! unite#sources#chef#define()
  return map(['attributes', 'files', 'recipes', 'resources', 'templates'],
  \      'extend(deepcopy(s:source),
  \       {
  \         "name": "chef/" . v:val,
  \         "description": "candidates from chef of " . v:val,
  \         "source__type": v:val,
  \       })')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
