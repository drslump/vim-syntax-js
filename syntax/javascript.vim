" Vim syntax file
" Language:   JavaScript
" Version:    0.1.0
" Author:     Iván -DrSlump- Montes <drslump@pollinimini.net>
" License:    MIT
"
" This syntax supports pretty decent folding which you can activate by:
"
"   set foldmethod=syntax
"
" To activate conceals place this commands in your vimrc:
"
"   set conceallevel=2
"   set concealcursor=nc
"
" You'll also need to indicate which conceals you want to apply by using the
" g:syntax_js variable.
"
"   let g:syntax_js=['function', 'return']
"
" The availabe options are
"
"   - function   replace 'function' keywords with 𝑓
"   - semicolon  hide semicolons if they are the last char in a line
"   - comma      hide commas if the are the last char in a line
"   - return     replace 'return' keywords with ↩
"   - this       use Ruby style @prop instead of this.prop
"   - proto      replace '.prototype.' with →
"   - solarized  fine-tunes the highlighing for the solarize color scheme
"                with a light background
"   - debug      Shows the syntax groups stack in the status line
"


"" Define this as the main syntax if not done already
if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif


"" Ensure the options array is defined
if !exists('g:syntax_js')
  let g:syntax_js=[]
endif


"" Javascript allows the dollar symbol anywhere in an identifier
setlocal iskeyword+=$

"" Javascript is case sensitive
syntax case match



"" Keywords
syntax keyword jsKeywordDecl        const undefined var let yield void
syntax keyword jsKeywordOperator    delete new in instanceof let typeof
syntax keyword jsKeywordBool        true false
syntax keyword jsKeywordNull        null
syntax keyword jsKeywordThis        this
syntax keyword jsKeywordReserved    debugger class enum export import extends import super implements interface 
syntax keyword jsKeywordReserved    package private protected public static
syntax cluster jsKeyword            contains=jsKeywordDecl,jsKeywordOperator,jsKeywordBool,jsKeywordNull,jsKeywordThis,jsKeywordReserved

"" Control keywords
syntax keyword jsControlLoop        do while for
syntax keyword jsControlBranch      if else switch case default break continue return
syntax keyword jsControlStatement   try catch throw with finally
syntax cluster jsControl            contains=jsControlLoop,jsControlBranch,jsControlStatement

"" Idents
" Identifier (keywords take precedence so they are already filtered)
syntax match   jsIdentName          /\<\k\+\>/ display
" Const (ie: CONST_NAME)
syntax match   jsConstant           /\<\u\+[A-Z0-9_]*\>/ display
" Constructor (assume CammelCase)
syntax match   jsConstructor        /\<\u\l\+\k*\>/ display

syntax cluster jsIdent              contains=jsIdentName,jsConstant,jsConstructor

"" Comments
syntax keyword jsTodo           contained TODO FIXME XXX TBD HACK WTF DEBUG
syntax region  jsEnvComment     start="\%^#!" end="$"
syntax region  jsLineComment    start=+\/\/+ end=+$+ keepend contains=jsTodo,@Spell
syntax region  jsLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=jsTodo,@Spell fold
syntax region  jsMultiComment   start="/\*" end="\*/" contains=jsTodo,@Spell fold

"" JSDoc
syntax region  jsDocComment     matchgroup=jsMultiComment start="/\*\*" end="\*/" contains=jsDocTag,jsTodo,@Spell fold
" tags without params
syntax match   jsDocTag         contained /@\w\+/ display
" tags with a param
syntax match   jsDocTag         contained "@\(augments\|base\|borrows\|class\|constructs\|default\|exception\|exports\|extends\|file\|member\|memgerOf\|module\|name\|namespace\|optional\|requires\|title\|throws\|version\)\>" nextgroup=jsDocParam skipwhite display
syntax match   jsDocParam       contained "\%(#\|\"\|{\|}\|\w\|\.\|:\|\/\)\+" display
" tags with a type
syntax match   jsDocTag         contained "@\(argument\|param\|property\|return\|returns\)\>" nextgroup=jsDocType skipwhite display
syntax region  jsDocType        contained start="{" end="}" nextgroup=jsDocParam skipwhite display oneline
syntax cluster jsComment        contains=jsEnvComment,jsLineComment,jsMultiComment,jsDocComment

"" Strings
syntax match   jsStringEscape   contained "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\."
syntax region  jsStringDouble   matchgroup=jsStringDelims start=/"/ skip=/\\\\\|\\$/ end=/"/ contains=jsStringEscape,@Spell
syntax region  jsStringSingle   matchgroup=jsStringDelims start=/'/ skip=/\\\\\|\\$/ end=/'/ contains=jsStringEscape,@Spell
syntax cluster jsString         contains=jsStringDouble,jsStringSingle

"" Regexp
syntax region  jsRegex          matchgroup=jsRegexDelims start=+/\(/\)\@!+ skip=+\\\\\|\\$+ end=+/[gim]\{,3}+ contains=jsStringEscape,jsRegexClass,jsRegexCapture oneline
syntax region  jsRegexClass     contained start=/\[/ end=/\]/ contains=jsStringEscape,jsRegexCapture,jsRegexClass oneline
syntax region  jsRegexCapture   contained start=/(/ end=/)/ contains=jsStringEscape,jsRegexClass,jsRegexCapture oneline

"" Numbers
syntax match   jsNumberInt      /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/ display
syntax match   jsNumberFloat    /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/ display
syntax cluster jsNumber         contains=jsNumberInt,jsNumberFloat

"" Object literals
" Note: It will match control blocks if they are placed below:  if (x)\n{ ... }
syntax region  jsObject         matchgroup=jsObjectDelims start=/{/ end=/}/ contains=@jsStatement,@jsComment,jsObjectLabel,jsObjectColon fold
syntax match   jsObjectLabel    contained /\<\k\+\(\s*:\)\@=/ display
syntax match   jsObjectColon    contained /:/ display

"" Array literals
syntax region  jsArray          matchgroup=jsArrayDelims start=/\[/ end=/\]/ contains=@jsStatement,@jsComment fold

"" Functions
" Note: Defined as a match instead of keyword so it can be easily modified
syntax match   jsFunc           /\<function\>/ nextgroup=jsFuncName,jsFuncParams skipwhite display
syntax match   jsFuncName       contained /\<\k\+\>/ nextgroup=jsFuncParams skipwhite display
syntax region  jsFuncParams     contained matchgroup=jsFuncParens start=/(/ end=/)/ nextgroup=jsFuncBlock contains=@jsComment,jsFuncParam skipwhite skipempty
syntax match   jsFuncParam      contained /\<\k\+\>/ display
syntax region  jsFuncBlock      contained matchgroup=jsFuncBraces start=/{/ end=/}/ contains=@jsAll fold

"" Punctuation
syntax match   jsPunctDot           /\./ display
syntax match   jsPunctComma         /,/ display
syntax match   jsPunctColon         /:/ display
syntax match   jsPunctSemiColon     /;/ display
syntax cluster jsPunct              contains=jsPunctDot,jsPunctComma,jsPunctColon,jsPunctSemiColon

"" Operators
syntax match   jsOpAssign           /=/ display
syntax match   jsOpEqual            /===\=/ display
syntax match   jsOpComp             />\|</ display
syntax match   jsOpLogic            /|\|&\|\^/ display
syntax match   jsOpNot              /!/ display
syntax match   jsOpTernary          /?/ display
syntax match   jsOpArithmetic       /+\|-\|\*\|%/ display
" Try to tell apart division from regexp and single line comment
syntax match   jsOpArithmetic       +\%(\%(\k\|\d\|)\)\s*\)\@<=/\%(/\)\@!+ display
syntax cluster jsOp                 contains=jsOpEqual,jsOpAssign,jsOpComp,jsOpLogic,jsOpNot,jsOpTernary,jsOpArithmetic


"" Blocks
syntax region  jsBlockParens        transparent matchgroup=jsParens start="(" end=")" contains=@jsAll
" Do not match arrays, only property access
syntax region  jsBlockBrackets      transparent matchgroup=jsBrackets start=/\%(\k\s*\)\@<=\[/ end=/\]/ contains=@jsAll
" Only match control structures
syntax region  jsBlockBraces        transparent matchgroup=jsBraces start=/\%(\%(else\|do\|)\)\s*\)\@<={/ end="}" contains=@jsAll fold
syntax cluster jsBlock              contains=jsBlockBrackets,jsBlockParens,jsBlockBraces


"" Catch errors caused by wrong pairing
syntax match   jsError              /)\|}\|\]/


"" Clusters
syntax cluster jsPrimitives         contains=@jsString,jsRegex,@jsNumber,jsObject,jsArray,jsFunc
syntax cluster jsStatement          contains=@jsPrimitives,@jsKeyword,@jsControl,@jsIdent,@jsOp
syntax cluster jsAll                contains=@jsStatement,@jsPunct,@jsComment,@jsBlock,@jsError



"" Syntax synchronization
" TODO: Investigate if we can optimize this
syntax sync clear
syntax sync fromstart
"syntax sync match jsMatch grouphere jsBlockBraces /{/



"" If conceal is available modify some rules
if (has('conceal') && &enc=="utf-8")

  "" Replace the function keyword with a 𝑓
  if count(g:syntax_js, 'function')
    syntax match   jsConcealFunction  contained /function/ containedin=jsFunc conceal cchar=ƒ "𝑓
    "syntax cluster jsPrimitives add=jsConcealFunction
    hi def link jsConcealFunction jsFunc
  endif

  "" Hide semicolons found at end of line
  if count(g:syntax_js, 'semicolon')
    syntax match   jsPunctSemiColon   /;\s*$/ containedin=@jsAll display conceal
  endif

  "" Hide commas found at end of line
  if count(g:syntax_js, 'comma')
    syntax match   jsPunctComma       /,\s*$/ containedin=@jsAll display conceal
  endif
  

  "" Replace the return keyword with ↵ , ⇤  or ↩ symbol
  "" Clear and create again the branch removing the return keyword
  if count(g:syntax_js, 'return')
    syntax clear   jsControlBranch
    syntax keyword jsControlBranch  if else switch case default break continue
    syntax match   jsConcealReturn  /\<return\>/ containedin=jsIdentName conceal cchar=↩
    hi def link jsConcealReturn jsControlBranch
  endif

  "" Replace this. with @ ala Ruby
  "" We need to clear the original style to override it with a match instead of keyword
  if count(g:syntax_js, 'this')
    syntax clear   jsKeywordThis
    syntax match   jsKeywordThis  /\<this\>/ containedin=@jsStatement,@jsBlock
    syntax match   jsConcealThis  /\<this\./ containedin=@jsStatement,@jsBlock conceal cchar=@
    hi def link jsConcealThis jsKeywordThis
  endif

  "" Replace .prototype. with →or ∷
  "" Use containedin=@jsAll to give it more priority
  if count(g:syntax_js, 'proto') || count(g:syntax_js, 'prototype')
    syntax match   jsConcealProto /\.prototype\./ containedin=@jsStatement,@jsBlock conceal cchar=→
    hi def link jsConcealProto jsIdent
  endif

endif


"" Define groups for embedding in the html.vim syntax
syntax cluster  htmlJavaScript       contains=@jsAll
syntax cluster  javaScriptExpression contains=@jsStatement,@htmlPreproc



"" Define default highlighting

hi def link jsString            String
hi def link jsStringDouble      jsString
hi def link jsStringSingle      jsString
hi def link jsStringDelims      jsString
hi def link jsStringEscape      SpecialChar

hi def link jsRegex             String
hi def link jsRegexDelims       jsRegex
hi def link jsRegexClass        SpecialChar
hi def link jsRegexCapture      SpecialChar

hi def link jsNumber            Number
hi def link jsNumberInt         jsNumber
hi def link jsNumberFloat       jsNumber

hi def link jsKeyword           Keyword
hi def link jsKeywordDecl       jsKeyword
hi def link jsKeywordOperator   jsKeyword
hi def link jsKeywordBool       jsKeyword
hi def link jsKeywordNull       jsKeyword
hi def link jsKeywordThis       jsKeyword
hi def link jsKeywordReserved   jsKeyword

hi def link jsControl           Keyword
hi def link jsControlLoop       Repeat
hi def link jsControlBranch     Conditional
hi def link jsControlStatement  jsControl

hi def link jsIdent             Identifier
hi def link jsConstant          Number
hi def link jsConstructor       jsIdent

hi def link jsComment           Comment
hi def link jsEnvComment        PreProc 
hi def link jsLineComment       jsComment
hi def link jsMultiComment      jsComment 

hi def link jsDocComment        jsComment
hi def link jsDocTag            SpecialChar
hi def link jsDocParam          Normal
hi def link jsDocType           Type

" Note: Use jsObject to style the comma between elements
hi def link jsObject            Statement
hi def link jsObjectDelims      jsBraces
hi def link jsObjectLabel       Label
hi def link jsObjectColon       Statement

" Note: Use jsArray to style the comma between elements
hi def link jsArray             Statement
hi def link jsArrayDelims       jsBrackets

" Note: Use jsFuncParams to style the comma between parameters
hi def link jsFunc              Keyword 
hi def link jsFuncName          Identifier
hi def link jsFuncParens        jsParens
hi def link jsFuncParams        Operator
hi def link jsFuncParam         Statement
hi def link jsFuncBraces        jsBraces
hi def link jsConcealFunction   jsFunc

hi def link jsOp                Operator
hi def link jsOpEqual           jsOp
hi def link jsOpAssign          jsOp
hi def link jsOpComp            jsOp
hi def link jsOpLogic           jsOp
hi def link jsOpNot             jsOp
hi def link jsOpTernary         jsOp
hi def link jsOpArithmethic     jsOp

hi def link jsPunct             Normal
hi def link jsPunctDot          jsPunct
hi def link jsPunctComma        jsPunct
hi def link jsPunctColon        jsPunct
hi def link jsPunctSemiColon    jsPunct

hi def link jsParens            jsPunct 
hi def link jsBraces            jsPunct
hi def link jsBrackets          jsPunct

hi def link jsError             Error

hi def link jsTodo              Todo



"" Link styles for Solarized color scheme
"" Specially suited for the following settings:
""   set background=light
""   let g:solarized_contrast='normal'
""   let g:solarized_visibility='low'
if count(g:syntax_js, 'solarized') && exists('g:solarized_vars')

  "" Alias the dictionary
  let s = g:solarized_vars

  "" Make conceal characters more prominent
  exe "hi! Conceal        " . s.fmt_bold

  "" Matching parens/braces hint
  exe "hi! MatchParen     " . s.fmt_bold . s.fg_base3 . s.bg_base02

  "" JsDoc should be more subtle imho
  exe "hi! jsDocTag       " . s.fg_base01 . s.fmt_bold
  exe "hi! jsDocType      " . s.fg_base01 . s.fmt_bold
  exe "hi! jsDocParam     " . s.fg_base01 . s.fmt_undr

  "" Make the punctuation more subtle even when not concealed
  exe "hi! jsPunct          " . s.fg_base01
  exe "hi! jsPunctSemiColon " . s.fg_base02 . s.fmt_bold

  "" Arrays and Object literals should stand out a bit
  exe "hi! jsArrayDelims  " . s.fg_base00 s.fmt_bold
  exe "hi! jsObjectDelims " . s.fg_base00 s.fmt_bold
  exe "hi! jsObjectLabel  " . s.fg_base0 s.fmt_bold
  exe "hi! jsObjectColon  " . s.fg_green

  "" Keywords just in bold, avoid too much color :)
  exe "hi! jsKeyword      " . s.fg_base0 s.fmt_bold
  hi link jsControl       jsKeyword
  hi link jsControlBranch jsControl
  hi link jsControlLoop   jsControl

  "" Operators
  exe "hi! jsOp           " . s.fg_violet
  exe "hi! jsOpArithmetic " . s.fg_violet s.fmt_bold
  exe "hi! jsOpAssign     " . s.fg_green s.fmt_bold
  exe "hi! jsOpNot        " . s.fg_magenta
  " ternary operator is sometimes specially difficult to notice
  exe "hi! jsOpTernary    " . s.fg_violet . s.fmt_bold
  exe "hi! jsPunctColon   " . s.fg_violet . s.fmt_bold  

  "" Functions
  exe "hi! jsFunc         " . s.fg_base00
  exe "hi! jsFuncName     " . s.fg_base0 s.fmt_bold
  exe "hi! jsFuncParam    " . s.fg_base0 s.fmt_undr
  exe "hi! jsFuncParens   " . s.fg_base02 . s.fmt_bold

  "" Blocks
  exe "hi! jsBraces       " . s.fg_base01
  exe "hi! jsFuncBraces   " . s.fg_blue

  "" Strings
  exe "hi! jsString       " . s.fg_yellow
  exe "hi! jsStringEscape " . s.fg_orange s.fmt_bold
  exe "hi! jsStringDelims " . s.fg_yellow s.fmt_bold

  "" Regexp
  exe "hi! jsRegex        " . s.fg_yellow
  exe "hi! jsRegexDelims  " . s.fg_yellow s.fmt_bold
  exe "hi! jsRegexCapture " . s.fg_yellow s.fmt_bold
  exe "hi! jsRegexClass   " . s.fg_yellow s.fmt_bold

endif



"" If debug mode is enabled show the syntax groups stack
if count(g:syntax_js, 'debug')
  function! SyntaxItem()
    "return synIDattr(synID(line("."),col("."),1),"name")
    let result=''
    for id in synstack(line("."), col("."))
      let result = result . ' > ' . synIDattr(id, "name")
    endfor
    return result
  endfunction
  set statusline=%{SyntaxItem()}
endif



let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=2
