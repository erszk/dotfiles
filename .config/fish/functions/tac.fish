# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.yCEXL2/tac.fish @ line 1
function tac --description 'Reverse lines of file/stdin'
	tail -r $argv
end
