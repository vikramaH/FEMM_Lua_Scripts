
-- GEN_ZEUS_Fuerza_Motriz

-- Initialize FEMM
newdocument(0)

-- Set problem type to planar and units to millimeters
mi_probdef(0, "millimeters", "planar", 1e-8, 40)

-- Define materials
mi_addmaterial("Air", 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0)
mi_addmaterial("NdFeB 52", 1.05, 1.05, 0, 0, 948000, 948000, 0.556, 0.556, 0, 1.22, 0, 0)
mi_addmaterial("Ferrite", 1, 1, 0, 0, 0, 0, 0.02, 0.02, 0, 1.0, 0, 0)
mi_addmaterial("Copper", 1, 1, 0, 0, 0, 0, 58, 58, 0, 1.0, 0, 0)

-- Draw outer circle (8 cm diameter)
mi_drawarc(0, 40, 40, 0, 90, 1)
mi_drawarc(40, 0, 0, -40, 90, 1)
mi_drawarc(0, -40, -40, 0, 90, 1)
mi_drawarc(-40, 0, 0, 40, 90, 1)

-- Draw central disk (1 cm radius)
mi_drawarc(0, 10, 10, 0, 90, 1)
mi_drawarc(10, 0, 0, -10, 90, 1)
mi_drawarc(0, -10, -10, 0, 90, 1)
mi_drawarc(-10, 0, 0, 10, 90, 1)

-- Function to draw rectangular magnets
function draw_magnet(x, y, width, height, rotation)
    local x0 = x - width/2
    local y0 = y - height/2
    local x1 = x + width/2
    local y1 = y + height/2
    mi_addnode(x0, y0)
    mi_addnode(x1, y0)
    mi_addnode(x1, y1)
    mi_addnode(x0, y1)
    mi_addsegment(x0, y0, x1, y0)
    mi_addsegment(x1, y0, x1, y1)
    mi_addsegment(x1, y1, x0, y1)
    mi_addsegment(x0, y1, x0, y0)
    mi_selectnode(x0, y0)
    mi_selectnode(x1, y0)
    mi_selectnode(x1, y1)
    mi_selectnode(x0, y1)
    mi_moverotate(x, y, rotation)
    mi_clearselected()
end

-- Draw magnets in the outer circle
for i=0, 5 do
    local angle = i * 60
    draw_magnet(30*cos(angle*pi/180), 30*sin(angle*pi/180), 20, 10, angle)
    mi_addblocklabel(30*cos(angle*pi/180), 30*sin(angle*pi/180))
    mi_selectlabel(30*cos(angle*pi/180), 30*sin(angle*pi/180))
    mi_setblockprop("NdFeB 52", 1, 0, 0, 90+angle, 1, 0)
    mi_clearselected()
end

-- Draw central magnets
draw_magnet(0, 10, 10, 1.5, 0)
mi_addblocklabel(0, 10)
mi_selectlabel(0, 10)
mi_setblockprop("NdFeB 52", 1, 0, 0, 90, 1, 0)
mi_clearselected()

draw_magnet(0, -10, 10, 1.5, 0)
mi_addblocklabel(0, -10)
mi_selectlabel(0, -10)
mi_setblockprop("NdFeB 52", 1, 0, 0, 90, 1, 0)
mi_clearselected()

-- Draw ferrite core for generation coils
function draw_coil(x, y, radius)
    mi_drawarc(x, y+radius, x, y-radius, 180, 1)
    mi_drawarc(x, y-radius, x, y+radius, 180, 1)
end

for i=0, 2 do
    local x = 50 * cos(i * 120 * pi / 180)
    local y = 50 * sin(i * 120 * pi / 180)
    draw_coil(x, y, 5)
    mi_addblocklabel(x, y)
    mi_selectlabel(x, y)
    mi_setblockprop("Ferrite", 1, 0, 0, 0, 1, 0)
    mi_clearselected()
end

-- Add boundary conditions
mi_addboundprop("Zero", 0, 0, 0, 0, 0, 0, 0, 0, 0)
mi_selectarcsegment(0, 40)
mi_selectarcsegment(40, 0)
mi_selectarcsegment(0, -40)
mi_selectarcsegment(-40, 0)
mi_setarcsegmentprop(1, "Zero", 0, 0)
mi_clearselected()

-- Create mesh and run simulation
mi_createmesh()
mi_analyze()
mi_loadsolution()
