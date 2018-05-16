# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.ai2ngX/d.fish @ line 2
function d --description 'dirs -v equivalent'
	dirs | awk -F ' [~/]' '{for (i=1; i<=NF; i++) {printf("%3d\t%s\n", (i-1), $i);}}'
end
