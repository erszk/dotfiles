# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.x2q3dX/cdf.fish @ line 2
function cdf
	cd (osascript -e 'tell application "Finder" to POSIX path of (target of window 1 as alias)')
end
