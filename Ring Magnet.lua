

--------------Lua Scripiting for Ring Magnet model, Analysis and Result ---------------


newdocument(0)		-------Creating New Document

-------------------------------setcompatibilitymode(0)	-------Setting the Compatibility mode for FEMM 4.2 as against FEMM 4.1

showconsole()
clearconsole()
hidepointprops()
-----hideconsole()

-----open("general.fem")
------mi_saveas("temp.fem")



-------------Getting Magnet Input and Printing ------------------
od=tonumber(prompt("Outer Diameter of the Magnet"))
print("Outer Diameter of the Magnet  = ",od," mm")


id=tonumber(prompt("Inner Diameter of the Magnet"))
print("Inner Diameter of the Magnet  = ",id," mm")


t=tonumber(prompt("Length of the Magnet"))
print("Length of the Magnet  = ",t," mm")


np=tonumber(prompt("Number of Poles"))
print("Number of Poles of the Magnet  =",np," mm")

cu=prompt("Customer Name or Type Gen")


Mgt=prompt("Enter Magnetization Type OD or ID")

if(Mgt=="OD") then
	Mty="Outer Diameter"
	Mgt="OD"
  elseif(Mgt=="od") then
	Mty="Outer Diameter"
	Mgt="OD"
  elseif(Mgt=="ID") then
	Mty="Inner Diameter"
	Mgt="ID"
  elseif(Mgt=="id") then
	Mty="Inner Diameter"
	Mgt="ID"
end

print("Magnetization Type : 	Circumferentially",Mty)

str=format("%d-%d-%d-%dP-%s-%s.fem",od,id,t,np,Mgt,cu)
print("File Name:",str)
fn=str
pause()


mi_probdef(0,"millimeters","planar",1E-08, t ,20)	------Defining the Problem
mi_saveas(fn)				------Saving the Problem
mi_setfocus(fn)				------Focussing on the Problem
hideconsole()
mi_close()

open(fn)					------Opening the saved file
mi_setfocus(fn)				------Setting the focus on the problem


---------------Verifying Magnet ID & OD------------------
        if (od<id) then
                   messagebox("Could not be solved-Check Input")
                   mi_close()
                   quit()
        end

        if (np<=1) then
                   messagebox("Could not be solved-Check Input")
                   mi_close()
                   quit()
        end

if (np>2) then

    showconsole()

    or1=od/2
    ir1=id/2
    or2=od/2*-1
    ir2=id/2*-1
    ab1=or1*4
    ab2=ab1*-1
    
    ns=360/np
    nss=ns/2
    n=(np+2)/2
    j=n

    mi_seteditmode("nodes")
    mi_addnode(or1,0)
    mi_addnode(ir1,0)
    mi_addnode(or2,0)
    mi_addnode(ir2,0)
    mi_addnode(ab1,0)
    mi_addnode(ab2,0)
    mi_seteditmode("arcsegments")
    mi_addarc(ab1,0,ab2,0,180,10)
    mi_addarc(ab2,0,ab1,0,180,10)

    mi_seteditmode("segments")
    mi_addsegment(or1,0,ir1,0)

    nns=ns
    mi_clearselected()

if (id>0) then

     for i=0,360,ns do
    
         mi_seteditmode("segments")
         mi_selectsegment(ir1,or1)
         mi_copyrotate(0,0,nns,1,1)
         nns=nns+ns
         print(nns,                   i)

     end
end

    mi_seteditmode("arcsegments")
    mi_addarc(or1,0,or2,0,180,1)
    mi_addarc(ir1,0,ir2,0,180,1)
    mi_addarc(or2,0,or1,0,180,1)
    mi_addarc(ir2,0,ir1,0,180,1)

    an=ns/2

    mi_seteditmode("group")
    mi_selectgroup(0)
    mi_moverotate(0,0,an,4)

    mi_seteditmode("blocks")
    bl1=(or1+ir1)/2
    bl2=bl1*-1


    mi_addblocklabel(bl1,0)
    mi_addblocklabel(bl2,0)


------------- Defining the Material Property and Assigning ----------------
    UBr=tonumber(prompt("Select Unit System [1] CGS [2] SI"))				----- Selecting System of Unit
    if (UBr==1) then
       Br=tonumber(prompt("Remenance of the Material in kilo-Gauss - kG"))			----- Getting Material Remenance Value in CGS
       Brr=Br*1000*1e-4
       Hc=tonumber(prompt("Coercivity of the Material in kilo-Oersted - kOe"))		----- Getting Material Coercivity Value in CGS
       Hcr=Hc*79.6*1000
       p=Br/Hc
    else 
       Brr=tonumber(prompt("Remenance of the Material in Tesla(Weber/m^2) - T(Wb/m^2)"))	----- Getting Material Remenance Value in SI
       Hcr=tonumber(prompt("Coercivity of the Material in Ampere/Meter - A/m"))		----- Getting Material Coercivity Value in SI
       p=Br/(Hc*1e-6)
    end

    mn=prompt("Enter Material")
    mi_addbhpoint(mn,Brr,Hcr)
    mi_addmaterial("Air",1,1,0,0,0,0,0,0,0,0,0,0)
    mi_addmaterial(mn,p,p,Hcr)
    ms=tonumber(prompt("Enter Mesh Size for Magnet"))
    mi_selectlabel(bl1,0)
    mi_setblockprop(mn,0,ms,0,0,0)
    mi_clearselected()

    mi_selectlabel(bl2,0)
    mi_setblockprop(mn,0,ms,0,180,0)
    mi_clearselected()

    mi_seteditmode("arcsegments")
    mi_addboundprop("A=0",0)
    mi_selectarcsegment(ab1,0)
    mi_selectarcsegment(ab2,0)
    mi_setarcsegmentprop(10,"A=0",0,0)
    mi_clearselected()

    nns=ns
    n1=180
    n2=0

    j=n

for i=0,j,1 do
    mi_seteditmode("blocks")
    mi_clearselected()
    mi_selectlabel(bl1,0)
    mi_setblockprop(mn,0,ms,0,n1,0)
    n1=n1+180

    if (n1>=360) then
               n1=n1-360
    end

    mi_clearselected()
    mi_selectlabel(bl2,0)
    mi_setblockprop(mn,0,ms,0,n2,0)

    if (n2>=360) then
               n2=n2-360
    end

    mi_clearselected()
    mi_selectlabel(bl1,0)
    mi_selectlabel(bl2,0)
    mi_copyrotate(0,0,nns,1,2)

    mi_clearselected()
    nns=nns+ns
    n2=n2+180
end

    mi_clearselected()
    mi_seteditmode("blocks")
    ar1=ir1/2
    ar2=(or1+ab1)/2
    mi_addblocklabel(ar1,0)
    mi_addblocklabel(ar2,0)

    m1=tonumber(prompt("Enter Mesh Size for Inner Air Block"))
    mi_selectlabel(ar1,0)
    mi_setblockprop("Air",0,m1,0,0,0)
    mi_clearselected()

    m2=tonumber(prompt("Enter Mesh Size for Outer Air Block"))
    mi_selectlabel(ar2,0)
    mi_setblockprop("Air",0,m2,0,0,0)
    mi_clearselected()
    mi_seteditmode("group")
    mi_selectgroup(0)
    mi_moverotate(0,0,-ns,4)
    mi_clearselected()

    mi_seteditmode("group")
    mi_selectgroup(0)
    mi_moverotate(0,0,-an,4)
    mi_clearselected()
    mi_createmesh()
    mi_showmesh()

mi_saveas(str)



----------Analyze the Problem ------------

    mi_analyze(0)
    mi_loadsolution()

x=tonumber(prompt("Hall Probe Measuring Distance in mm"))

if (Mgt =="OD") then
	
    	mo_seteditmode("contour")
    	mo_addcontour(or1+x,0)
    	mo_addcontour(or2-x,0)
    	mo_bendcontour(180,1)
    	mo_addcontour(or1+x,0)
    	mo_bendcontour(180,1)
    	mo_makeplot(2,10000)
    else
 	mo_seteditmode("contour")
    	mo_addcontour(ir1-x,0)
    	mo_addcontour(ir2+x,0)
    	mo_bendcontour(180,1)
    	mo_addcontour(ir1-x,0)
    	mo_bendcontour(180,1)
    	mo_makeplot(2,10000)
end

end
