function mk_planarABC(rad_work, airmesh, B_uni)
-- Define a circular work area with an ABC boundary and a
-- uniform horizontal field of B_uni Tesla
-- Define the problem type. Magnetostatic Planar, Units of mm
-- Precision of 10^(-8) for the linear solver, 10 for
-- the depth dimension and an angle constraint of 30 degrees

-- Create a new Magnetostatics document to work on.

B_uni = B_uni or 0 -- can be called without B_uni
_rw = rad_work
newdocument(0)
mi_probdef(0, 'millimeters', 'planar', 1.e-8, 10, 30)
mi_makeABC(10,_rw,0,0,0)
mi_addblocklabel(0,_rw - 1)
mi_getmaterial('Air')
mi_selectlabel(0, rad_work - 1)
mi_setblockprop('Air', 0, airmesh, '<None>', 0, 0, 0)
mi_clearselected()

if(B_uni ~= 0) then
	local mu_0 = 1.256637e-6
	local Hc = 2 * B_uni/mu_0
	mi_modifymaterial('u1',3,Hc)
	mi_modifymaterial('u2',3,Hc)
	mi_modifymaterial('u3',3,Hc)
	mi_modifymaterial('u4',3,Hc)
	mi_modifymaterial('u5',3,Hc)
	mi_modifymaterial('u6',3,Hc)
	mi_modifymaterial('u7',3,Hc)
	mi_modifymaterial('u8',3,Hc)
	mi_modifymaterial('u9',3,Hc)
	mi_modifymaterial('u10',3,Hc)
end
end

function rot_uf(angle)
-- rotate the inclination of the uniform field created in
-- mk_planarUF() to angle
mi_selectlabel(_rw * 1.00, _rw * 0.15)
mi_setblockprop('u1',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.96, _rw * 0.29)
mi_setblockprop('u2',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.93, _rw * 0.42)
mi_setblockprop('u3',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.87, _rw * 0.56)
mi_setblockprop('u4',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.78, _rw * 0.67)
mi_setblockprop('u5',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.69, _rw * 0.80)
mi_setblockprop('u6',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.58, _rw * 0.89)
mi_setblockprop('u7',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.44, _rw * 0.98)
mi_setblockprop('u8',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.31, _rw * 1.04)
mi_setblockprop('u9',0,0,'<None>',angle,0,1)
mi_clearselected()
mi_selectlabel(_rw * 0.15, _rw * 1.07)
mi_setblockprop('u10',0,0,'<None>',angle,0,1)
mi_clearselected()
end
