showconsole()
mydir="./"
open(mydir .. "trafo_EDT39_test_with_script.FEM")
mi_saveas(mydir .. "temp.fem")
mi_seteditmode("group")

clearconsole()

F=100000--transformer frequecny 
IPRI=1--primary current, should be !=0
NPRI=6--primary number of turns
NSEC=24--secondary number of turns
ISEC=-IPRI*NPRI/NSEC

--set problem parameters
mi_probdef(F)

--calculation leak stored energy, primary and secondary are driven with currenst IPRI and ISEC

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC",1,ISEC)
mi_modifycircprop("SEC",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wleak=mo_blockintegral(2)

--resistances calcultion (should be performed when both windings are excited with currents IPRI and ISEC)

I1,V1,Flux1=mo_getcircuitproperties("PRI")
I2,V2,Flux2=mo_getcircuitproperties("SEC")

Rpri=re(V1/I1)--works for AC and DC
Rsec=re(V2/I2)--works for AC and DC

if F>0 then
	Lleak1_alt=im(V1/I1)/(2*pi*F)--alternative way to calculate inductances but works only on AC
	Lleak2_alt=im(V2/I2)/(2*pi*F)--alternative way to calculate inductances but works only on AC
end


--calculation primary stored energy when secondary is open

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC",1,0)
mi_modifycircprop("SEC",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wpri=mo_blockintegral(2)

--calculation secondary stored energy when primary is open

mi_modifycircprop("PRI",1,0)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC",1,ISEC)
mi_modifycircprop("SEC",2,1)

mi_analyze()
mi_loadsolution()
mo_groupselectblock()
wsec=mo_blockintegral(2)

--parameters calculation
--energy correction (FEMM feature)

if F>0 then
	wleak=2*wleak
	wpri=2*wpri
	wsec=2*wsec
else
	wleak=wleak
	wpri=wpri
	wsec=wsec
end

--Inductance calculation for the T-model (Lleak1, Lleak2, Lm, N1:N2: with leakage inductances on primary and secondary and actual physical turn ratio NPRI:NSEC)
Lleak1=-(wsec-wpri-wleak)/IPRI^2
Lleak2=NSEC^2*(wsec-wpri+wleak)/(IPRI^2*NPRI^2)
Lm=(wsec+wpri-wleak)/IPRI^2

--Resistances for all models
print('Resistances for all models')
print('Rpri=',Rpri)
print('Rsec=',Rsec)

print('Parameters for T-model:')
print('Lleak1=',Lleak1)
print('Lleak2=',Lleak2)
print('Lm=',Lm)
print('n=',NSEC/NPRI)

--Parameters calculation for the standard SPICE modeling (L1 L2 and mutual inductance M=k*sqrt(L1*L2))
L1=Lleak1+Lm
L2=Lleak2+Lm*(NSEC/NPRI)^2
M=Lm*NSEC/NPRI
k=M/sqrt(L1*L2)

print('Parameters for standard SPICE model:')
print('L1=',L1)
print('L2=',L2)
print('M=',M)
print('k=',k)

--Parameters calculation for the Cantilever model (Lleak Lpri at primary side and effecttive turn ratio 1:Ne)
Lleak=(Lleak1*Lm*NSEC^2+(Lleak2*Lm+Lleak1*Lleak2)*NPRI^2)/(Lm*NSEC^2+Lleak2*NPRI^2)
Lpri=(Lm^2*NSEC^2)/(Lm*NSEC^2+Lleak2*NPRI^2)
Ne=(Lm*NSEC^2+Lleak2*NPRI^2)/(Lm*NPRI*NSEC)

print('Parameters for Cantilever model:')
print('Lleak=',Lleak)
print('Lpri=',Lpri)
print('Ne=',Ne)

--model files writing
model1_file=openfile("transformer_from_femm_t_model.lib","w")
write(model1_file,'.subckt transformer_from_femm_t_model 1 2 3 4 \n')
write(model1_file,'.params Rpri=',Rpri," Rsec=",Rsec," Lleak1=",Lleak1," Lleak2=",Lleak2," Lm=",Lm," n=",NSEC/NPRI,"\n")
write(model1_file,'R1 9 1 {Rpri} \n')
write(model1_file,'L1 9 5 {Lleak1} \n')
write(model1_file,'R2 10 3 {Rsec} \n')
write(model1_file,'L2 10 7 {Lleak2}\n')
write(model1_file,'Gp 2 5 value={n*i(Es)}\n')
write(model1_file,'Es 7 4 value={n*V(5,2)}\n')
write(model1_file,'L3 5 2 {Lm}\n')
write(model1_file,'.end transformer_from_femm_t_model \n')
closefile(model1_file)

model2_file=openfile("transformer_from_femm_standard_SPICE.lib","w")
write(model2_file,'.subckt transformer_from_femm_standard_SPICE 1 2 3 4 \n')
write(model2_file,'.params Rpri=',Rpri," Rsec=",Rsec," L1=",L1," L2=",L2," k=",k,"\n")
write(model2_file,'L1 5 2 {L1}\n')
write(model2_file,'L2 6 4 {L2}\n')
write(model2_file,'R1 5 1 {Rpri}\n')
write(model2_file,'R2 3 6 {Rsec}\n')
write(model2_file,'K1 L1 L2 {k}\n')
write(model2_file,'.end transformer_from_femm_standard_SPICE \n')
closefile(model2_file)

model3_file=openfile("transformer_from_femm_cantilever_model.lib","w")
write(model3_file,'.subckt transformer_from_femm_cantilever_model 1 2 3 4 \n')
write(model3_file,'.params Rpri=',Rpri," Rsec=",Rsec," Lleak=",Lleak," Lpri=",Lpri," Ne=",Ne,"\n")
write(model3_file,'R1 9 1 {Rpri}\n')
write(model3_file,'L1 9 5 {Lleak}\n')
write(model3_file,'R2 7 3 {Rsec}\n')
write(model3_file,'Gp 2 5 value={Ne*i(Es)}\n')
write(model3_file,'Es 7 4 value={Ne*v(5,2)}\n')
write(model3_file,'L3 5 2 {Lpri}\n')
write(model3_file,'.end transformer_from_femm_cantilever_model \n')
closefile(model3_file)

--back to both currents excitation

mi_modifycircprop("PRI",1,IPRI)
mi_modifycircprop("PRI",2,1)
mi_modifycircprop("SEC",1,ISEC)
mi_modifycircprop("SEC",2,1)
mi_saveas(mydir .. "temp.fem")

mo_close()
mi_close()
print('done')