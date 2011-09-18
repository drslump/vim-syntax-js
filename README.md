# Vim syntax file for JavaScript

A brand new Vim syntax for JavaScript with fine tuned grouping and optional
conceal features.

> It has only tested been tested with Vim 7.2 so it might not fully work on 
  previous versions.


## Folding

This syntax supports pretty decent folding which you can activate with:

    set foldmethod=syntax

You can add the above line to your `ftplugin` or in your _vimrc_ using:

    au FileType javascript setl foldmethod=syntax


## Conceals

To activate conceals with these commands:

    set conceallevel=2
    set concealcursor=nc  " don't reveal the conceals unless on insert or visual modes

Add the above lines to your `ftplugin` or in your _vimrc_ with:

    au FileType javascript setl conceallevel=2 concelcursor=nc

You'll also need to indicate which conceals you want to apply by using the 
`g:syntax_js` list variable in your _vimrc_ file:

    let g:syntax_js=['function', 'return']

The availabe options are

  - **function**   replace `function` keywords with 𝑓
  - **semicolon**  hide semicolons if they are the last char in a line
  - **comma**      hide commas if the are the last char in a line
  - **return**     replace `return` keywords with ↩
  - **this**       use Ruby style `@prop` instead of `this.prop`
  - **proto**      replace `.prototype.` with →
  - **solarized**  fine-tunes the highlighing for the [solarized](https://github.com/altercation/vim-colors-solarized) 
                   color scheme with a light background
  - **debug**      Shows the syntax groups stack in the status line


## Screenshot

This is how it looks on MacVim when enabling all the options on a light background [solarized](https://github.com/altercation/vim-colors-solarized) 
and Inconsolata as type face.

![Screenshot](http://github.com/drslump/vim-syntax-js/raw/master/screenshot.png)


## License

    The MIT License

    Copyright (c) 2011 Iván -DrSlump- Montes

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    'Software'), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
