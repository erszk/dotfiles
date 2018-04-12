" Vim syntax file
" Language: Recfiles (GNU recutils plain-text database format)
" Maintainer: Louis Thompson
" Latest Revision: 2016 6 October

" exit if syntax already exists (boilerplate)
if exists("b:current_syntax")
  finish
endif

syn match recField "^[a-zA-z][a-zA-Z0-9_]*:"
syn match recComment "^#.*$"
syn match recTodo "^# TODO:"
syn match recDescriptor "^%\w\+:"
syn match recLongline "^+\|\\$"
syn match recString '".*"'
syn match recString "'.*'"
" syn region recDescRegion start="^%" end="^$" transparent contains=recKwds
syn match recKwds "\<(regexp|enum|email|size|int|bool|real|line|date|uuid)\>"

hi def link recComment      Comment
hi def link recDescriptor   Include
hi def link recField        Identifier
hi def link recLongline     Statement
hi def link recKwds         Identifier
hi def link recString       String
hi def link recTodo         Todo

" set current_syntax
let b:current_syntax = "rec"
