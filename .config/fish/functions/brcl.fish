# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.UtWesa/brcl.fish @ line 1
function brcl
	brew cleanup -s
    brew prune
    brew cask cleanup
end
