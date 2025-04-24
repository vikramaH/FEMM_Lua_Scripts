-- Creates a new preprocessor document (magnetics problem)
newdocument(0)
-- Main problem parameters
-- 0 frequency
-- mm units
-- planar problem
-- solver precision
-- depth, set to 1 m so to have results per m length
mi_probdef(0, "millimeters", "planar", 1e-8, 1000)

-- A few variables
w_coil = 99
h_coil = 22
x_bck = 800
y_bck = 400
workfolder = "C:\\temp\\"
filename = "dipole"

-- Current and number of turns per coil block
-- Current at lowest rigidity
-- current = 106.8
-- Current at higest rigidity
current = 439.7
turns = 54

-- Mesh parameters
mshf = 1
msh_yoke = 10*mshf
msh_coil = 8*mshf
msh_gap = 1*mshf
msh_bck = 25*mshf

-- Material properties, from the available library
mi_getmaterial("Air")
mi_getmaterial("Pure Iron")
mi_getmaterial("Copper")

-- Boundary conditions
mi_addboundprop("B parallel", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
mi_addboundprop("B perpendicular", 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0)

-- A circuit, multiple ones are possible
mi_addcircprop("Coil", current, 1)

-- Yoke (array of points, for convenience)
x_yoke, y_yoke  = { }, { }
x_yoke[1], y_yoke[1] = 0, 24.5
x_yoke[2], y_yoke[2] = 67.5, 24.5
x_yoke[3], y_yoke[3] = 67.5, 24
x_yoke[4], y_yoke[4] = 92.5, 24
x_yoke[5], y_yoke[5] = 92.5, 24.5
x_yoke[6], y_yoke[6] = 107.5, 59.5
x_yoke[7], y_yoke[7] = 107.5, 268.5
x_yoke[8], y_yoke[8] = 67.5, 308.5
x_yoke[9], y_yoke[9] = -384.5, 308.5
x_yoke[10], y_yoke[10] = -424.5, 268.5
x_yoke[11], y_yoke[11] = -424.5, 0
x_yoke[12], y_yoke[12] = -216.5, 0
x_yoke[13], y_yoke[13] = -216.5, 100.5
x_yoke[14], y_yoke[14] = -107.5, 100.5
x_yoke[15], y_yoke[15] = -107.5, 59.5
x_yoke[16], y_yoke[16] = -92.5, 24.5
x_yoke[17], y_yoke[17] = -92.5, 24
x_yoke[18], y_yoke[18] = -67.5, 24
x_yoke[19], y_yoke[19] = -67.5, 24.5
x_yoke[20], y_yoke[20] = 0, 24.5

np_yoke = getn(x_yoke)
for ip_yoke = 1, np_yoke do
mi_addnode(x_yoke[ip_yoke], y_yoke[ip_yoke]) 
end
for ip_yoke = 1, np_yoke-1 do
mi_addsegment(x_yoke[ip_yoke], y_yoke[ip_yoke], x_yoke[ip_yoke+1], y_yoke[ip_yoke+1]) 
end
mi_addsegment(x_yoke[np_yoke], y_yoke[np_yoke], x_yoke[1], y_yoke[1])

-- Block label, assign material, properties, mesh size
mi_addblocklabel(0, 150)
mi_selectlabel(0, 150)
mi_setblockprop("Pure Iron", 0, msh_yoke)
mi_clearselected()

-- Coil inner
mi_addnode (-112.5, 29.5)
mi_addnode (-211.5, 29.5)
mi_addnode (-211.5, 95.5)
mi_addnode (-112.5, 95.5)
mi_addnode (-112.5, 29.5)

mi_addsegment (-112.5, 29.5, -211.5, 29.5)
mi_addsegment (-211.5, 29.5, -211.5, 95.5)
mi_addsegment (-211.5, 95.5, -112.5, 95.5)
mi_addsegment (-112.5, 95.5, -112.5, 29.5)

mi_addblocklabel (-162, 62.5)
mi_selectlabel (-162, 62.5)
mi_setblockprop("Copper", 0, msh_coil, "Coil", 0, 0, turns)

-- Coil outer
mi_addnode (223.5, 29.5)
mi_addnode (124.5, 29.5)
mi_addnode (124.5, 95.5)
mi_addnode (223.5, 95.5)
mi_addnode (223.5, 29.5)

mi_addsegment (223.5, 29.5, 124.5, 29.5)
mi_addsegment (124.5, 29.5, 124.5, 95.5)
mi_addsegment (124.5, 95.5, 223.5, 95.5)
mi_addsegment (223.5, 95.5, 223.5, 29.5)

mi_addblocklabel (174, 62.5)
mi_selectlabel (174, 62.5)
mi_setblockprop("Copper", 0, msh_coil, "Coil", 0, 0, turns)

-- change sign of current on one side
mi_selectrectangle(127, 100-2*(h_coil+5), 127+w_coil, 100+h_coil, 2)
mi_setblockprop("Copper", 0, msh_coil, "Coil", 0, 0, -turns)
mi_clearselected()

-- Air region (background and gap)
mi_addnode(0, 0)
mi_addnode(130, 0)
mi_addnode(-130, 0)
mi_addsegment(130, 0, x_yoke[5], y_yoke[5])
mi_addsegment(-130, 0, x_yoke[16], y_yoke[16])
--
mi_addnode(-500, 0)
mi_addnode(x_bck, 0)
mi_addnode(x_bck, y_bck)
mi_addnode(-500, y_bck)
mi_addsegment(-500, 0, x_bck, 0)
mi_addsegment(x_bck, 0, x_bck, y_bck)
mi_addsegment(x_bck, y_bck, -500, y_bck)
mi_addsegment(-x_bck, y_bck, -500, 0)
--
mi_addblocklabel(0, 10)
mi_selectlabel(0, 10)
mi_setblockprop("Air", 0, msh_gap)
mi_clearselected()
--
mi_addblocklabel(150, 150)
mi_selectlabel(150, 150)
mi_setblockprop("Air", 0, msh_bck)
mi_clearselected()
--
mi_addblocklabel(-150, 20)
mi_selectlabel(-150, 20)
mi_setblockprop("Air", 0, 6*msh_gap)
mi_clearselected()

-- hide lines in post-processor
mi_selectsegment((130+x_yoke[5])/2, y_yoke[5]/2)
mi_selectsegment((-130+x_yoke[16])/2, y_yoke[16]/2)
mi_setsegmentprop("", 0, 1, 1)
mi_clearselected()

-- Boundary conditions on segments
mi_selectrectangle(-500, 0, x_bck, 0, 1)
mi_setsegmentprop("B perpendicular")
mi_clearselected()
mi_selectsegment(x_bck, y_bck/2)
mi_selectsegment((x_bck-500)/2, y_bck)
mi_selectsegment(-500, y_bck/2)
mi_setsegmentprop("B parallel")
mi_clearselected()

-- Zoom out
mi_zoomnatural()

-- Save
mi_saveas("C:\Users\jbauche\cernbox\WINDOWS\Desktop\Connaissance\CAS magnets 2023\Case study\NC magnet design\FEMM\RT_magnet_solution_FEMM.fem")

-- Mesh
mi_createmesh()

-- Solve
mi_analyze()

-- Post-processing
mi_loadsolution()

-- mo_savebitmap("C:\Users\jbauche\cernbox\WINDOWS\Desktop\Connaissance\CAS magnets 2023\Case study\NC magnet design\FEMM\RT_magnet_solution_FEMM_flux.bmp")
mo_savemetafile("C:\Users\jbauche\cernbox\WINDOWS\Desktop\Connaissance\CAS magnets 2023\Case study\NC magnet design\FEMM\RT_magnet_solution_FEMM_flux.emf")

-- Field density plot
B_min = 0
B_max = 1.6
mo_showdensityplot(1,B_min,B_max,0,"bmag") 

-- Field at 0,0
A, B1, B2 = mo_getpointvalues(0, 0)
print("B @ x=0; y=0")
print("Bx = ", B1, " T")
print("By = ", B2, " T")

-- Plot field in the aperture
w_GFR = 120
mo_addcontour(-w_GFR/2, 0)
mo_addcontour(w_GFR/2, 0)

-- mo_makeplot(2, 200) -- plot in FEMM
mo_makeplot(2, 50, "C:\Users\jbauche\cernbox\WINDOWS\Desktop\Connaissance\CAS magnets 2023\Case study\NC magnet design\FEMM\RT_magnet_solution_FEMM_By_midplane.emf") -- save image
mo_makeplot(2, 50, "C:\Users\jbauche\cernbox\WINDOWS\Desktop\Connaissance\CAS magnets 2023\Case study\NC magnet design\FEMM\RT_magnet_solution_FEMM_By_midplane.txt", 0) -- print it to a file
mo_clearcontour()





-- LUA script to compute multipoles in FEMM
--
-- Few standard cases are considered:
--  * dipole 180 deg (ex. C shape)
--  * dipole 90 deg (ex. H shape)
--  * quadrupole 45 deg (ex. standard symmetric quadrupole)
--
-- In all cases, the center is 0, 0 and the skew coefficients are 0 
-- 
-- The script computes two sets of multipoles:
--  * one from A (the vector potential)
--  * another one from a radial projection of B
-- They should be the same, so the difference in a way shows 
-- how much to trust these numbers; the ones from A should be better, 
-- as this is the finite element solution without further manipulations
-- (derivation, radial projection) while B is rougher (linear elements, 
-- so B is constant over each triangle), but then it's smoothed out in the postprocessor
--

case_index = 1
-- 1 ===> dipole 180 deg (ex. C shape)
-- 2 ===> dipole 90 deg (ex. H shape)
-- 3 ===> quadrupole 45 deg (ex. standard symmetric quadrupole)

nh = 15 -- number of harmonics
np = 256 -- number of samples points (remember Nyquist...)
R = 2*20/3 -- reference radius
Rs = 0.95*20 -- sampling radius, can be the same as R or the largest still in the air

if case_index == 1 then
   thmax = pi
   ihmin, ihstep, ihfund = 1, 1, 1
elseif case_index == 2 then
   thmax = pi/2
   ihmin, ihstep, ihfund = 1, 2, 1
elseif case_index == 3 then
   thmax = pi/4
   ihmin, ihstep, ihfund = 2, 4, 2
end

-- multiplication factor, to include mirror copies
fact = 2*pi/thmax 

-- angular increment
dth = thmax/(np-1)

-- sampling Br and A
Br, Ath = {}, {}
A, B1, B2 = mo_getpointvalues(0, 0)
Actr = A
for ip = 1, np do
   th = (ip-1)*dth
   xs, ys = Rs*cos(th), Rs*sin(th)
   A, B1, B2 = mo_getpointvalues(xs, ys)
   Br[ip] = B1*cos(th) + B2*sin(th)
   Ath[ip] = A - Actr
end

-- print header, with reference and sampling radii
print('Reference radius ', R)
print('Sampling radius ', Rs)

-- harmonics from Br
B, b = {}, {}
for ih = 1, nh do
   B[ih] = 0
end
for ih = ihmin, nh, ihstep do
   B[ih] = Br[1]*sin(0)/2
   for ip = 2, np-1 do
      B[ih] = B[ih] + Br[ip]*sin(ih*((ip-1)*dth))
   end
   B[ih] = B[ih] + Br[np]*sin(ih*thmax)/2
   B[ih] = fact*B[ih]*dth/pi
   B[ih] = (R/Rs)^(ih-1)*B[ih]
end
print('from Br')
print(B[ihfund])
for ih = ihmin, nh, ihstep do
   b[ih] = B[ih]/B[ihfund]*10000
   print(ih, b[ih])
end

-- harmonics from A
B, b = {}, {}
for ih = 1, nh do
   B[ih] = 0
end
for ih = ihmin, nh, ihstep do
   B[ih] = Ath[1]*cos(0)/2
   for ip = 2, np-1 do
      B[ih] = B[ih] + Ath[ip]*cos(ih*((ip-1)*dth))
   end
   B[ih] = B[ih] + Ath[np]*cos(ih*thmax)/2
   B[ih] = fact*B[ih]*dth/pi*(-ih/Rs)*1000
   B[ih] = (R/Rs)^(ih-1)*B[ih]
end
print('from A')
print(B[ihfund])
for ih = ihmin, nh, ihstep do
   b[ih] = B[ih]/B[ihfund]*10000
   print(ih, b[ih])
end


