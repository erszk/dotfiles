# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.XdmGqU/shuf.fish @ line 1
function shuf --description 'randomly shuffle lines from STDIN'
	perl -MList::Util -e "print List::Util::shuffle <>;"
end
