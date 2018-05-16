# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.pAlyjC/u.fish @ line 2
function u --description 'go up N directories'
	set -l i

    if test -z $argv[1]
        set i 1
    else
        set i $argv[1]
    end

    for n in (seq $i)
        cd ..
    end
end
