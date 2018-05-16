function hs --description 'Open the Common Lisp Hyperspec in browser'
	set -l cell (brew --cellar)
    open $cell/hyperspec/7.0/share/doc/hyperspec/Hyperspec/Front/index.htm
end
