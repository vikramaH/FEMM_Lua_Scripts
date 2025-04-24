-- Useful functions
function average(a, b)
    return (a + b) / 2
end

function get_x_y(radius, angle)
    x = radius * cos(angle * (pi / 180))
    y = radius * sin(angle * (pi / 180))
    return x, y
end

function create_magnets(r_inner, r_outer, a_start)    
    r_middle = average(r_inner, r_outer)

    n_magnet_segments = (n_teeth / 2) - 1
    a_magnet_segment = (a_magnet * 2) / n_magnet_segments

    xi, yi = get_x_y(r_inner, a_start)
    xo, yo = get_x_y(r_outer, a_start)
    mi_addnode(xi, yi)
    mi_addnode(xo, yo)
    mi_addsegment(xi, yi, xo, yo)
    mi_selectsegment(get_x_y(r_middle, a_start))
    mi_copyrotate(0, 0, a_magnet_segment, n_magnet_segments, 1)

    a_end = 180 - (90 - a_start)
    
    for m = 0, n_magnet_segments - 1, 1 do
        angle = a_start + m * a_magnet_segment + a_magnet_segment / 2
        x, y = get_x_y(r_middle, angle)
        mi_addblocklabel(x, y)
        mi_selectlabel(x, y)
        if angle < 180 then
            mi_setblockprop("NdFeB 40 MGOe",  1,  1,  0,  angle,  0,  0)
        else
            mi_setblockprop("NdFeB 40 MGOe",  1,  1,  0,  angle - 180,  0,  0)
        end
        mi_clearselected()
    end

    -- Make annoying wee bits air, deleting them blows things up
    for r = -r_middle, r_middle, 2 * r_middle do
        mi_addblocklabel(r, 0)
        mi_selectlabel(r, 0)
        mi_setblockprop("Air", 1, 1, 0, 0, 0, 0)
    end
end

--Define the sizes of various things
r_shaft = 10
h_rotor = 25
h_magnet = 6
h_airgap = 2
h_teeth = 32
h_stator = 25
a_magnet = 89 -- Degrees
n_teeth = 12
slot_ratio = 1 - 0.423 -- Teeth to slot ratio (< 1.0)

-- Calculated values
r_rotor = r_shaft + h_rotor
r_magnet = r_rotor + h_magnet
r_airgap = r_magnet + h_airgap
r_teeth = r_airgap + h_teeth
r_stator = r_teeth + h_stator

newdocument(0)
--                                             length of machine
--                                              ~~~
mi_probdef(0, "millimeters", "planar", 1e-008, 300,  30, "succ.approx")

--Draw start node
mi_addnode(0,  0)

-- rotor shaft
mi_addnode(0, r_shaft)
mi_addnode(0, -r_shaft)

mi_addarc(0,r_shaft, 0,-r_shaft,180,1) 
mi_addarc(0,-r_shaft, 0,r_shaft,180,1)

-- rotor
mi_addnode(0, r_rotor)
mi_addnode(0, -r_rotor)

mi_addarc(0,r_rotor, 0,-r_rotor,180,1) 
mi_addarc(0,-r_rotor, 0,r_rotor,180,1)

-- magnets
mi_addnode(0, r_magnet)
mi_addnode(0, -r_magnet)

mi_addarc(0,r_magnet, 0,-r_magnet,180,1) 
mi_addarc(0,-r_magnet, 0,r_magnet,180,1)

-- airgap
mi_addnode(0, r_airgap)
mi_addnode(0, -r_airgap)

mi_addarc(0,r_airgap, 0,-r_airgap,180,1) 
mi_addarc(0,-r_airgap, 0,r_airgap,180,1)

-- teeth
mi_addnode(0, r_teeth)
mi_addnode(0, -r_teeth)

mi_addarc(0,r_teeth, 0,-r_teeth,180,1) 
mi_addarc(0,-r_teeth, 0,r_teeth,180,1)

-- stator yoke
mi_addnode(0, r_stator)
mi_addnode(0, -r_stator)

mi_addarc(0,r_stator, 0,-r_stator,180,1) 
mi_addarc(0,-r_stator, 0,r_stator,180,1) 

--Get some materials
mi_getmaterial("Air")      
mi_getmaterial("M-36 Steel")
mi_getmaterial("NdFeB 40 MGOe")

-- modify magnet coercivity
mi_modifymaterial("NdFeB 40 MGOe",3,962508)

-- modify steel permeability
mi_modifymaterial("M-36 Steel",1,16300)
mi_modifymaterial("M-36 Steel",2,16300) 

-- Draw magnets
create_magnets(r_rotor, r_magnet, 90 - a_magnet)
create_magnets(r_rotor, r_magnet, 180 + (90 - a_magnet))

-- Draw teeth
a_slot = (360 * slot_ratio) / n_teeth
a_tooth = (360 * (1 - slot_ratio)) / n_teeth
r_inner = r_airgap
r_middle = average(r_airgap, r_teeth)
r_outer = r_teeth

-- Teeth
mi_addnode(r_inner, 0)
mi_addnode(r_outer, 0)
mi_add_segment(r_inner, 0, r_outer, 0)
mi_selectsegment(r_middle, 0)
mi_copyrotate(0, 0, (a_slot + a_tooth), n_teeth, 1)

-- Slots
mi_selectsegment(r_middle, 0)
mi_copyrotate(0, 0, a_slot, 1, 1)
mi_selectsegment(get_x_y(r_middle, a_slot))
mi_copyrotate(0, 0, (a_slot + a_tooth), n_teeth, 1)

-- Select inner segments
for angle = a_tooth / 2, 360, (a_tooth + a_slot) do
  mi_selectarcsegment(get_x_y(r_inner, angle))
end

-- Select outer segments
for angle = a_slot + (a_tooth / 2), 360, (a_tooth + a_slot) do
  mi_selectarcsegment(get_x_y(r_outer, angle))
end

-- Delete them
mi_deleteselectedarcsegments()

--Define air and steel regions

-- Shaft as air
r_middle = average(0, r_shaft)
mi_addblocklabel(0,r_middle)
mi_selectlabel(0,r_middle)
mi_setblockprop("Air",  1,  1,  0,  0,  0,  0) 

--airgap
r_middle = average(r_magnet, r_airgap)
mi_clearselected()
mi_addblocklabel(0,r_middle)
mi_selectlabel(0,r_middle)
mi_setblockprop("Air",  1,  1,  0,  0,  0,  0)

-- Rotor Steel
r_middle = average(r_shaft, r_rotor)
mi_clearselected()
mi_addblocklabel(0,r_middle)
mi_selectlabel(0,r_middle)
mi_setblockprop("M-36 Steel",  1,  1,  0,  0,  0,  0)

-- Stator Steel
r_middle = average(r_teeth, r_stator)
mi_clearselected()
mi_addblocklabel(0,r_middle)
mi_selectlabel(0,r_middle)
mi_setblockprop("M-36 Steel",  1,  1,  0,  0,  0,  0)

-- around stator
r_outside = r_stator + 10
mi_clearselected()
mi_addblocklabel(0,r_outside)
mi_selectlabel(0,r_outside)
mi_setblockprop("Air",  1,  1,  0,  0,  0,  0)

mi_clearselected()

--Draw a square around the model
r_outside = r_stator + 20
mi_addnode(r_outside, r_outside)
mi_addnode(-r_outside, r_outside)
mi_addnode(r_outside,-r_outside)
mi_addnode(-r_outside,-r_outside)
mi_addsegment(r_outside,r_outside,-r_outside,r_outside)
mi_addsegment(-r_outside,r_outside,-r_outside,-r_outside)
mi_addsegment(-r_outside,-r_outside,r_outside,-r_outside)
mi_addsegment(r_outside,-r_outside,r_outside,r_outside)

mi_addboundprop("A1",0,0,0,0,0,0,0,0,0)
mi_selectsegment(r_outside,r_outside)
mi_selectsegment(-r_outside,r_outside)
mi_selectsegment(-r_outside,-r_outside)
mi_selectsegment(r_outside,-r_outside)
mi_setsegmentprop("A1", 0,1,0,0)

mi_zoomnatural()

mi_saveas("model.fem")
mi_createmesh()
mi_analyze(0)
mi_loadsolution()

-- show flux density plot
mo_showdensityplot(1,0,1.5,0,"bmag")

-- calculate flux per pole and main airgap flux density and write results to text file
-- Draw a contour at the midpoint of the airgap spanning the width of the magnet
-- calculate line integral
mo_clearcontour()
mo_seteditmode("contour")

r_middle = average(r_magnet, r_airgap)
mo_addcontour(get_x_y(r_middle, 90 - a_magnet))
mo_addcontour(get_x_y(r_middle, 180 - (90 - a_magnet)))
mo_bendcontour(a_magnet * 2,1)
phi,Bn = mo_lineintegral(0)
handle=openfile("Results.txt","w")
write(handle,"Flux per Pole:\n\n",phi,"\n\n","Mean Airgap Flux Density:\n\n",Bn,"\n")
closefile(handle)

--Draw a contour at the midpoint of the airgap covering all 2 poles
r_middle = average(r_magnet, r_airgap)
mo_clearcontour()
mo_seteditmode("contour")
mo_addcontour(0,r_middle)
mo_addcontour(0,-r_middle)
mo_bendcontour(180,1)
mo_addcontour(0,r_middle)
mo_bendcontour(180,1)

mo_makeplot(2,360)
