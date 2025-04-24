showconsole()
mydir="./"
open(mydir .. "trafo_EDT39_three_windings_test_with_script.FEM")
mi_saveas(mydir .. "temp.fem")
mi_seteditmode("group")

clearconsole()

F=100000--transformer frequency 
IPRI=1--primary current, should be !=0
NPRI=6--primary number of turns, initially here is physical (real)
NSEC1=24--secondary1 number of turns, initially here is physical (real)
NSEC2=1--secondary2 number of turns, initially here is physical (real)
K1=0.5
K2=0.5
ISEC1=-IPRI*NPRI/NSEC1*K1
ISEC2=-IPRI*NPRI/NSEC2*K2

--set problem parameters
mi_probdef(F)

--calculation of NSEC1:NSEC2 turn ratio

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,0)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,0)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wleak=mo_blockintegral(2)

I2,V2,Flux2=mo_getcircuitproperties("SEC1")
I3,V3,Flux3=mo_getcircuitproperties("SEC2")

NSEC1_NSEC2=re(V2/V3)

--calculation of NPRI:NSEC2 turn ratio

mi_modifycircprop("PRI",1,0)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,ISEC2)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,0)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wleak=mo_blockintegral(2)

I1,V1,Flux2=mo_getcircuitproperties("PRI")
I3,V3,Flux3=mo_getcircuitproperties("SEC2")

NPRI_NSEC2=re(V1/V3)

--number of turns now can be calculated and reestimated- they are not physical turns ration anymore
NPRI=1
NSEC2=NPRI/NPRI_NSEC2
NSEC1=NSEC2*NSEC1_NSEC2
K1=0.5--shoudl be K1+K2=1
K2=0.5
ISEC1=-IPRI*NPRI/NSEC1*K1
ISEC2=-IPRI*NPRI/NSEC2*K2

--calculation leak stored energy, primary and secondary1 and secondary2 are driven with currenst IPRI and ISEC1 and ISEC2

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,ISEC1)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,ISEC2)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wleak=mo_blockintegral(2)

--resistances calcultion (should be performed when all windings are excited with currents IPRI and ISEC1 and ISEC2, normal transformer (not a flyback!))

I1,V1,Flux1=mo_getcircuitproperties("PRI")
I2,V2,Flux2=mo_getcircuitproperties("SEC1")
I3,V3,Flux3=mo_getcircuitproperties("SEC2")
Rpri=re(V1/I1)
Rsec1=re(V2/I2)
Rsec2=re(V3/I3)

--calculation primary stored energy when secondary1 and secondary2 are open

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,0)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,0)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wpri=mo_blockintegral(2)

--I1,V1,Flux1=mo_getcircuitproperties("PRI")--if a flyback transformer
--Rpri=re(V1/I1)--if a flyback transformer

--calculation secondary1 stored energy when primary and secondary2 are open

mi_modifycircprop("PRI",1,0)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,ISEC1)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,0)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wsec1=mo_blockintegral(2)

--I2,V2,Flux2=mo_getcircuitproperties("SEC1")--if a flyback transformer
--Rsec1=re(V2/I2)--if a flyback transformer

--calculation secondary2 stored energy when primary and secondary1 are open

mi_modifycircprop("PRI",1,0)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,0)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,ISEC2)
mi_modifycircprop("SEC2",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wsec2=mo_blockintegral(2)

--I3,V3,Flux3=mo_getcircuitproperties("SEC2")--if a flyback transformer
--Rsec2=re(V3/I3)--if a flyback transformer

--parameters calculation
--energy correction (FEMM feature)

if F>0 then
	wleak=2*wleak
	wpri=2*wpri
	wsec1=2*wsec1
	wsec2=2*wsec2
else
	wleak=wleak
	wpri=wpri
	wsec1=wsec1
	wsec2=wsec2
end

--Inductance calculation for the T-model (Lleak1, Lleak2, Lleak3,Lm, NPRI:NSEC1:NSEC2 with leakage inductances on primary and secondaries and actual physical turn ratios)
Lleak1=-(2*wsec2+2*wsec1+(-2*K2^2-2*K1^2)*wpri-2*wleak)/(IPRI^2*K2^2+IPRI^2*K1^2+IPRI^2)
Lleak2=-(2*K1^2*NSEC1^2*wsec2+(-2*K2^2-2)*NSEC1^2*wsec1+2*K1^2*NSEC1^2*wpri-2*K1^2*NSEC1^2*wleak)/((IPRI^2*K1^2*K2^2+IPRI^2*K1^4+IPRI^2*K1^2)*NPRI^2)
Lleak3=((2*K1^2+2)*NSEC2^2*wsec2-2*K2^2*NSEC2^2*wsec1-2*K2^2*NSEC2^2*wpri+2*K2^2*NSEC2^2*wleak)/((IPRI^2*K2^4+(IPRI^2*K1^2+IPRI^2)*K2^2)*NPRI^2)
Lm=(2*wsec2+2*wsec1+2*wpri-2*wleak)/(IPRI^2*K2^2+IPRI^2*K1^2+IPRI^2)

--Resistances for all models
print('Resistances for all models')
print('Rpri=',Rpri)
print('Rsec1=',Rsec1)
print('Rsec2=',Rsec2)

print('Parameters for T-model:')
print('Lleak1=',Lleak1)
print('Lleak2=',Lleak2)
print('Lleak3=',Lleak3)
print('Lm=',Lm)
print('n1=',NSEC1/NPRI)
print('n2=',NSEC2/NPRI)

--model file writing
model1_file=openfile("three_winding_transformer_from_femm_t_model.lib","w")
write(model1_file,'.subckt three_winding_transformer_from_femm_t_model 1 2 3 4 5 6\n')
write(model1_file,'.params Rpri=',Rpri," Rsec1=",Rsec1," Rsec2=",Rsec2," Lleak1=",Lleak1," Lleak2=",Lleak2," Lleak3=",Lleak3," Lm=",Lm," n1=",NSEC1/NPRI," n2=",NSEC2/NPRI,"\n")
write(model1_file,'R1 15 1 {Rpri} \n')
write(model1_file,'L1 15 7 {Lleak1} \n')
write(model1_file,'R2 11 3 {Rsec1} \n')
write(model1_file,'L2 11 9 {Lleak2} \n')
write(model1_file,'Gp1 2 7 value={n1*i(Es1)} \n')
write(model1_file,'Es1 9 4 value={n1*v(7,2)} \n')
write(model1_file,'L3 7 2 {Lm} \n')
write(model1_file,'R3 14 5 {Rsec2} \n')
write(model1_file,'L4 14 12 {Lleak3} \n')
write(model1_file,'Es2 12 6 value={n2*v(7,2)} \n')
write(model1_file,'Gp2 2 7 value={n2*i(Es2)} \n')
write(model1_file,'.end three_winding_transformer_from_femm_t_model \n')
closefile(model1_file)

--back to both currents excitation

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC1",1,ISEC1)
mi_modifycircprop("SEC1",2,1)
mi_modifycircprop("SEC2",1,ISEC2)
mi_modifycircprop("SEC2",2,1)
mi_saveas(mydir .. "temp.fem")

mo_close()
mi_close()
print('done')