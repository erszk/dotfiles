# Defined in /var/folders/xg/zwy1qx2n64z4hnvp55pfjj9m0000gn/T//fish.zgI4Eb/newpm.fish @ line 1
function newpm --description 'Produce skeleton for a new perl project'
	h2xs -AX --skip-exporter --use-new-tests -n
end
