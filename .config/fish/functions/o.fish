# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.pr2Kzv/o.fish @ line 2
function o
	if test (count $argv) -eq 0
        open ./
    else
        open $argv
    end
end
