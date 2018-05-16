# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.OMT3ob/fishue.fish @ line 2
function fishue
	clear
    echo "version = $FISH_VERSION"
    echo
    uname -a | sed "s/"(hostname)"/hostname/"
    echo
    echo "TERM = $TERM"
end
