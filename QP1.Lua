-- Define parameters
aperture = 25  -- mm
pole_width = 20 -- mm
pole_length = 100 -- mm
coil_width = 10 -- mm
coil_thickness = 5 -- mm
coil_gap = 5 -- mm
iron_thickness = 50 -- mm

-- Define materials
mi_addmaterial("Iron", 1e6, 0) -- High permeability for iron

-- Create geometry
mi_clearselected()
mi_addblocklabel(0, 0)
mi_selectlabel(0, 0)
mi_addblock(0, "Iron")

-- Create iron core
mi_addsegment(0, -aperture, 0, aperture)
mi_addsegment(aperture, 0, pole_length, 0)
mi_addsegment(pole_length, 0, pole_length + pole_width, -pole_width)
mi_addsegment(pole_length + pole_width, -pole_width, pole_length + pole_width + iron_thickness, -pole_width)
mi_addsegment(pole_length + pole_width + iron_thickness, -pole_width, pole_length + pole_width + iron_thickness, -aperture)
mi_addsegment(pole_length + pole_width + iron_thickness, -aperture, pole_length + pole_width, -aperture)
mi_addsegment(pole_length + pole_width, -aperture, pole_length, 0)
mi_addsegment(pole_length, 0, 0, 0)

-- Create coils
mi_addblocklabel(coil_gap, 0)
mi_selectlabel(coil_gap, 0)
mi_addblock(0, "Air")

mi_addsegment(coil_gap, -coil_thickness/2, coil_gap + coil_width, -coil_thickness/2)
mi_addsegment(coil_gap + coil_width, -coil_thickness/2, coil_gap + coil_width, coil_thickness/2)
mi_addsegment(coil_gap + coil_width, coil_thickness/2, coil_gap, coil_thickness/2)
mi_addsegment(coil_gap, coil_thickness/2, coil_gap, -coil_thickness/2)

mi_addblocklabel(pole_length + pole_width/2, -pole_width/2 - coil_gap)
mi_selectlabel(pole_length + pole_width/2, -pole_width/2 - coil_gap)
mi_addblock(0, "Air")

mi_addsegment(pole_length + pole_width/2 - coil_width/2, -pole_width/2 - coil_gap - coil_thickness/2, pole_length + pole_width/2 + coil_width/2, -pole_width/2 - coil_gap - coil_thickness/2)
mi_addsegment(pole_length + pole_width/2 + coil_width/2, -pole_width/2 - coil_gap - coil_thickness/2, pole_length + pole_width/2 + coil_width/2, -pole_width/2 - coil_gap + coil_thickness/2)
mi_addsegment(pole_length + pole_width/2 + coil_width/2, -pole_width/2 - coil_gap + coil_thickness/2, pole_length + pole_width/2 - coil_width/2, -pole_width/2 - coil_gap + coil_thickness/2)
mi_addsegment(pole_length + pole_width/2 - coil_width/2, -pole_width/2 - coil_gap + coil_thickness/2, pole_length + pole_width/2 - coil_width/2, -pole_width/2 - coil_gap - coil_thickness/2)

-- Add more coils and segments for the remaining poles
-- ...

-- Define circuit properties
mi_addcircprop("Coil1", 0, 100) -- 100 A for the first coil
mi_addcircprop("Coil2", 0, -100) -- -100 A for the second coil
-- ...

-- Assign circuits to coils
mi_selectblock(coil_gap, 0)
mi_setblockprop("None", 1, 0, "Coil1", 0, 0)

mi_selectblock(pole_length + pole_width/2, -pole_width/2 - coil_gap)
mi_setblockprop("None", 1, 0, "Coil2", 0, 0)
-- ...

-- Mesh and solve
mi_mesh(1)
mi_analyze()
mi_loadsolution()

-- Post-processing (optional)
-- mi_postprocess

-- Save the file
mi_saveas("qp1.fem")

Explanation:
 * Define Parameters:
   * Set the dimensions of the magnet, including aperture, pole width, coil dimensions, and iron thickness.
 * Define Materials:
   * Add a material for the iron core with high permeability.
 * Create Geometry:
   * Use mi_addblocklabel, mi_selectlabel, and mi_addblock to create the iron core and air regions.
   * Use mi_addsegment to define the boundaries of each region.
   * Repeat for each coil and pole.
 * Define Circuit Properties:
   * Use mi_addcircprop to define the current and direction for each coil.
 * Assign Circuits to Coils:
   * Use mi_selectblock and mi_setblockprop to assign the defined circuits to the coil regions.
 * Mesh and Solve:
   * Use mi_mesh to generate the finite element mesh.
   * Use mi_analyze to solve the magnetic field problem.
   * Use mi_loadsolution to load the solution for post-processing.
 * Post-processing (Optional):
   * Use mi_postprocess to visualize the magnetic field distribution, calculate field gradients, and perform other analyses.
 * Save:
   * Use mi_saveas to save the FEMM project as "qp1.fem".
Note:
 * This is a basic example and may require adjustments for specific design requirements.
 * You can modify the parameters, add more coils, and refine the mesh to achieve the desired field gradient and accuracy.
 * Refer to the FEMM documentation for detailed information on all available commands and their usage.
This Lua script provides a starting point for your quadrupole magnet design in FEMM. Remember to adapt it based on your specific needs and iterate on the design to optimize its performance.
