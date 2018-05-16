# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.71aDmx/maus.fish @ line 2
function maus --description 'Get X,Y coordinates of mousepoint'
	cliclick p | cut -c 25-
end
