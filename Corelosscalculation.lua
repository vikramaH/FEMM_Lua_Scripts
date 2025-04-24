clear all
more off
linecolor1 = ['k','b','c','g','y','r','m'];
linecolor2 = ['k','b','m','r','y','c','g'];
linecolor3 = ['m','k','b','c','g','y','r'];
linecolor6 = ['c','g','b','k','m','r'];
%closefemm()
openfemm
newdocument(0)
Time = ctime(time());
disp('========================')
disp(Time)
tic
disp('========================')
disp('Geometry')

Length = 83.6; %mm motor length
mi_probdef(0,'millimeters','planar',1e-8,Length,15,1)

% Stator Geometry
Nslots = 48;
StatorOD = 269;
StatorID = 161.93;
ShoeHeight = 1.02;% Hs0
ShoeRadius = 0.50;% Hs1
SlotHeight = 29.16;% Hs2
SlotDia = 5.64; % 2Rs
PostHeight = SlotDia/2+SlotHeight+ShoeRadius+ShoeHeight;
SlotOpen = 1.93; %Bs0
SlotWidthTop = 3.15;
SlotWidthBot = SlotDia;
StatorPitchAirgap = pi*StatorID/Nslots;
StatorPitchSlotTop = pi*(StatorID+2*ShoeHeight)/Nslots;
StatorPitchSlotBot = pi*(StatorID+2*ShoeHeight+2*ShoeRadius+2*SlotHeight)/Nslots;
PostThickTop = StatorPitchSlotTop-SlotWidthTop;
PostThickBot = StatorPitchSlotBot-SlotWidthBot;

% Rotor Geometry
Npoles = 8;
RotorOD = 160.47;
RotorID = 111;
BridgeID = 9.4;
DuctMinDia = RotorID+2*BridgeID;
DuctThick = 4.7;
RibHeight = 3;
RibWidth = 14;
DistMinMag = 3;
MagThick = 6.5;
MagWidth = 18.9;
Bridge = 1.42;
DuctMaxDia = RotorOD-2*Bridge;
alpha = 72.5;
theta = 360/Npoles/2;

mi_zoom(-StatorOD/2,-StatorOD/2,StatorOD/2,StatorOD/2)
mi_addnode(StatorOD/2,0)
mi_addnode(-StatorOD/2,0)
mi_addarc(StatorOD/2,0,-StatorOD/2,0,180,5)
mi_addarc(-StatorOD/2,0,StatorOD/2,0,180,5)

mi_addnode(RotorOD/2,0)
mi_addnode(-RotorOD/2,0)
mi_addarc(RotorOD/2,0,-RotorOD/2,0,180,1)
mi_addarc(-RotorOD/2,0,RotorOD/2,0,180,1)

mi_addnode(RotorID/2,0)
mi_addnode(-RotorID/2,0)
mi_addarc(RotorID/2,0,-RotorID/2,0,180,5)
mi_addarc(-RotorID/2,0,RotorID/2,0,180,5)

x1 = StatorID/2*cos(asin((StatorPitchAirgap-SlotOpen)/StatorID));
y1 = (StatorPitchAirgap-SlotOpen)/2;
x2 = StatorID/2*cos(asin((StatorPitchAirgap-SlotOpen)/StatorID));
y2 = -(StatorPitchAirgap-SlotOpen)/2;

mi_addnode(x1,y1)
mi_addnode(x2,y2)
mi_addarc(x2,y2,x1,y1,2*asin((StatorPitchAirgap-SlotOpen)/StatorID)*180/pi,1)

x3 = StatorID/2+ShoeHeight;
y3 = (StatorPitchAirgap-SlotOpen)/2;
mi_addnode(x3,y3)
mi_addsegment(x1,y1,x3,y3)

x4 = StatorID/2+ShoeHeight;
y4 = -(StatorPitchAirgap-SlotOpen)/2;
mi_addnode(x4,y4)
mi_addsegment(x2,y2,x4,y4)

x5 = StatorID/2+ShoeHeight+ShoeRadius;
y5 = (StatorPitchSlotTop-SlotWidthTop)/2;
mi_addnode(x5,y5)
mi_addarc(x3,y3,x5,y5,90,45)

x6 = StatorID/2+ShoeHeight+ShoeRadius;
y6 = -(StatorPitchSlotTop-SlotWidthTop)/2;
mi_addnode(x6,y6)
mi_addarc(x6,y6,x4,y4,90,45)

x7 = StatorID/2+ShoeHeight+ShoeRadius+SlotHeight;
y7 = (StatorPitchSlotBot-SlotWidthBot)/2;
mi_addnode(x7,y7)
mi_addsegment(x5,y5,x7,y7)

x8 = StatorID/2+ShoeHeight+ShoeRadius+SlotHeight;
y8 = -(StatorPitchSlotBot-SlotWidthBot)/2;
mi_addnode(x8,y8)
mi_addsegment(x6,y6,x8,y8)



x9 = (StatorID/2+ShoeHeight+ShoeRadius+SlotHeight)*cosd(360/Nslots)...
    +(StatorPitchSlotBot-SlotWidthBot)/2*sind(360/Nslots);
y9 = (StatorID/2+ShoeHeight+ShoeRadius+SlotHeight)*sind(360/Nslots)...
    -(StatorPitchSlotBot-SlotWidthBot)/2*cosd(360/Nslots);
mi_addnode(x9,y9)
mi_addarc(x7,y7,x9,y9,180,15)

x10= (StatorID/2+ShoeHeight+ShoeRadius)*cosd(360/Nslots)...
    +(StatorPitchSlotTop-SlotWidthTop)/2*sind(360/Nslots);
y10= (StatorID/2+ShoeHeight+ShoeRadius)*sind(360/Nslots)...
    -(StatorPitchSlotTop-SlotWidthTop)/2*cosd(360/Nslots);
mi_addnode(x10,y10)
mi_addsegment(x5,y5,x10,y10)


%lining = 0.140;
%
%mi_addnode(x9,y9-lining)
%mi_addnode(x10,y10-lining)
%mi_addsegment(x9,y9-lining,x10,y10-lining)
%mi_addnode(x5,y5+lining)
%mi_addnode(x7,y7+lining)
%mi_addsegment(x5,y5+lining,x7,y7+lining)
%mi_addarc(x7,y7+lining,x9,y9-lining,180,15)
%
%d=0.912+2*0.03
%X=90
%Y=5
%
%mi_addnode(X,Y)
%mi_addnode(X,Y+d)
%mi_addarc(X,Y,X,Y+d,180,15)
%mi_addarc(X,Y+d,X,Y,180,15)
          
mi_selectarcsegment((x1+x2)/2,(y1+y2)/2);
mi_selectsegment((x1+x3)/2,(y1+y3)/2);
mi_selectsegment((x2+x4)/2,(y2+y4)/2);
mi_selectarcsegment((x3+x5)/2,(y3+y5)/2);
mi_selectarcsegment((x4+x6)/2,(y4+y6)/2);
mi_selectsegment((x5+x7)/2,(y5+y7)/2);
mi_selectsegment((x6+x8)/2,(y6+y8)/2);
mi_selectarcsegment((x7+x9)/2,(y7+y9)/2);
mi_selectsegment((x5+x10)/2,(y5+y10)/2);
mi_setgroup(1);
mi_selectgroup(1);
mi_copyrotate2(0,0,360/Nslots,Nslots,4);
mi_selectarcsegment(0,StatorOD/2);
mi_selectarcsegment(0,-StatorOD/2);
mi_setgroup(1);

x11 = DuctMinDia/2;
y11 = 0;
x12 = x11+DuctThick/sind(alpha);
y12 = 0;
mi_addnode(x11,y11)
mi_addnode(x12,y12)
x13 = x12+DistMinMag/2/tand(alpha);
y13 = DistMinMag/2;
mi_addnode(x13,y13)
mi_addsegment(x12,y12,x13,y13)
x14 = x13-DuctThick*cosd(90-alpha);
y14 = y13+DuctThick*sind(90-alpha);
mi_addnode(x14,y14)
mi_addsegment(x11,y11,x14,y14)
mi_addsegment(x13,y13,x14,y14)
x15 = x14+MagWidth*cosd(alpha);
y15 = y14+MagWidth*sind(alpha);
mi_addnode(x15,y15)

x16 = x13+MagWidth*cosd(alpha);
y16 = y13+MagWidth*sind(alpha);
mi_addnode(x16,y16)
mi_addsegment(x15,y15,x16,y16)
mi_addsegment(x13,y13,x16,y16)
mi_addarc(x16,y16,x15,y15,180,15)
x17 = x13-MagThick*cosd(90-alpha);
y17 = y13+MagThick*sind(90-alpha);
mi_addnode(x17,y17)
x18 = x16-MagThick*cosd(90-alpha);
y18 = y16+MagThick*sind(90-alpha);
mi_addnode(x18,y18)
mi_addsegment(x14,y14,x17,y17)
mi_addsegment(x18,y18,x15,y15)
mi_addsegment(x18,y18,x17,y17)

%%% Uncomment the following to position the magnet
%%% by finding the alpha angle and MagWidth through trial-error

%x19 = DuctMaxDia/2;
%y19 = 0;
%x20 = DuctMaxDia/2*cosd(theta);
%y20 = DuctMaxDia/2*sind(theta);
%mi_addnode(x19,y19)
%mi_addnode(x20,y20)
%mi_addarc(x19,y19,x20,y20,theta,1)
%
%x21 = x20-RibHeight*cosd(theta)+RibWidth/2*sind(theta);
%y21 = y20-RibHeight*sind(theta)-RibWidth/2*cosd(theta);
%x22 = DuctMinDia/2*cosd(theta)+RibWidth/2*sind(theta);
%y22 = DuctMinDia/2*sind(theta)-RibWidth/2*cosd(theta);
%mi_addnode(x21,y21)
%mi_addnode(x22,y22)
%mi_addsegment(x21,y21,x22,y22)

%%% Uncomment until here

mi_selectsegment((x11+x14)/2,(y11+y14)/2);
mi_selectsegment((x12+x13)/2,(y12+y13)/2);
mi_selectsegment((x13+x14)/2,(y13+y14)/2);
mi_selectsegment((x14+x17)/2,(y14+y17)/2);
mi_selectsegment((x13+x16)/2,(y13+y16)/2);
mi_selectsegment((x15+x16)/2,(y15+y16)/2);
mi_selectsegment((x15+x18)/2,(y15+y18)/2);
mi_selectarcsegment((x15+x16)/2,(y15+y16)/2);
mi_selectsegment((x17+x18)/2,(y17+y18)/2);
mi_setgroup(2);
mi_selectgroup(2);
mi_mirror2(0,0,1,0,4);
mi_selectgroup(2);
mi_copyrotate2(0,0,2*theta,Npoles,4);
mi_selectarcsegment(0,RotorOD/2);
mi_selectarcsegment(0,-RotorOD/2);
mi_selectarcsegment(0,RotorID/2);
mi_selectarcsegment(0,-RotorID/2);
mi_setgroup(2);

disp('Material Assignments')

mi_addboundprop('AirBound',0,0,0,0,0,0,0,0,0)
mi_selectarcsegment(0,StatorOD/2);
mi_selectarcsegment(0,-StatorOD/2);
mi_selectarcsegment(0,RotorID/2);
mi_selectarcsegment(0,-RotorID/2);
mi_setarcsegmentprop(5,'AirBound',0,1);
mi_clearselected
%mi_makeABC(7,0.7*StatorOD,0,0,0)
mi_getmaterial('Air')
mi_getmaterial('20 AWG')
mi_addmaterial('19 AWG',1.0,1.0,0,0,58,0,0,0,3,0,0,1,0.912)
T0 = 20;
T1 = 50;
Temp_diff = T1-T0; %deg C temp diff between actual temp and 20C
Hcoerciv = 920000;% A/m magnet coercivity
Hcj = -0.5;%/degC
Hcoerciv_temp = Hcoerciv*(1+Hcj/100*Temp_diff);
mur = 1.03;
mu0 = 4e-7*pi; % A/m
Br = mu0*mur*Hcoerciv;
Br_temp = mu0*mur*Hcoerciv_temp;
mi_addmaterial('N36Z_20',mur,mur,Hcoerciv_temp,0,0.667)
mi_addmaterial('M19_29G',0,0,0,0,1.9,0.34,0,0.94,0)
mi_addbhpoints('M19_29G',...
[0,0.04700,0.09400,0.14100,0.33840,0.50760,0.61101,0.93061,1.12802,...
1.20324,1.25025,1.27846,1.35372,1.42904,1.48556,1.53268,1.57040,...
1.69320,1.78840,1.88840,1.98840,2.18840,2.38840,2.45239,3.66829],...  
%[0,0.05,0.1,0.15,0.36,0.54,0.65,0.99,1.2,1.28,1.33,1.36,1.44,1.52,...
%1.58,1.63,1.67,1.8,1.9,2,2.1,2.3,2.5,2.563994494,3.779889874],...
[0,22.28,25.46,31.83,47.74,63.66,79.57,159.15,318.3,477.46,636.61,...
795.77,1591.5,3183,4774.6,6366.1,7957.7,15915,31830,111407,190984,...
350135,509252,560177.2,1527756])

mi_addblocklabel(0,0.6*StatorOD)
mi_selectlabel(0,0.6*StatorOD);
mi_setblockprop('<No Mesh>',1,0,'None',0,0,0)
mi_clearselected

mi_addblocklabel(0,0.5*(StatorOD/2+x7))
mi_selectlabel(0,0.5*(StatorOD/2+x7));
mi_setblockprop('M19_29G',1,0,'None',0,1,0)
mi_clearselected

mi_addblocklabel(0,0.25*(StatorID+RotorOD))
mi_selectlabel(0,0.25*(StatorID+RotorOD));
mi_setblockprop('Air',1,0,'None',0,0,0)
mi_clearselected

mi_addblocklabel(0,0.5*(RotorOD/2+x12))
mi_selectlabel(0,0.5*(RotorOD/2+x12));
mi_setblockprop('M19_29G',1,0,'None',0,2,0)
mi_clearselected

mi_addblocklabel(0,0.5*(x11+x12))
mi_selectlabel(0,0.5*(x11+x12));
mi_setblockprop('Air',1,0,'None',0,2,0)
mi_addblocklabel(0.5*(x15+x16)+DuctThick/4*cosd(alpha),...
0.5*(y15+y16)+DuctThick/4*sind(alpha))
mi_selectlabel(0.5*(x15+x16)+DuctThick/4*cosd(alpha),...
0.5*(y15+y16)+DuctThick/4*sind(alpha));
mi_setblockprop('Air',1,0,'None',0,2,0)
mi_addblocklabel(0.5*(x15+x16)+DuctThick/4*cosd(alpha),...
-0.5*(y15+y16)-DuctThick/4*sind(alpha))
mi_selectlabel(0.5*(x15+x16)+DuctThick/4*cosd(alpha),...
-0.5*(y15+y16)-DuctThick/4*sind(alpha));
mi_setblockprop('Air',1,0,'None',0,2,0)
mi_copyrotate2(0,0,2*theta,Npoles,2);
mi_clearselected

mag_x = 0.25*(x13+x17+x16+x18)
mag_y = 0.25*(y13+y17+y16+y18)

mi_addblocklabel(0.25*(x13+x17+x16+x18),0.25*(y13+y17+y16+y18))
mi_selectlabel(0.25*(x13+x17+x16+x18),0.25*(y13+y17+y16+y18));
mi_setblockprop('N36Z_20',1,0,'None',-90+alpha,3,0)
mi_moverotate(0,0,2*theta)
mi_clearselected
mi_addblocklabel(0.25*(x13+x17+x16+x18),-0.25*(y13+y17+y16+y18))
mi_selectlabel(0.25*(x13+x17+x16+x18),-0.25*(y13+y17+y16+y18));
mi_setblockprop('N36Z_20',1,0,'None',90-alpha,3,0)
mi_moverotate(0,0,2*theta)
mi_clearselected
mi_addblocklabel(0.25*(x13+x17+x16+x18),0.25*(y13+y17+y16+y18))
mi_selectlabel(0.25*(x13+x17+x16+x18),0.25*(y13+y17+y16+y18));
mi_setblockprop('N36Z_20',1,0,'None',180-90+alpha,3,0)
mi_clearselected
mi_addblocklabel(0.25*(x13+x17+x16+x18),-0.25*(y13+y17+y16+y18))
mi_selectlabel(0.25*(x13+x17+x16+x18),-0.25*(y13+y17+y16+y18));
mi_setblockprop('N36Z_20',1,0,'None',180+90-alpha,3,0)
mi_clearselected
mi_selectgroup(3)
mi_copyrotate(0,0,4*theta,Npoles/2)
mi_clearselected

mi_addblocklabel(0,0.25*RotorID)
mi_selectlabel(0,0.25*RotorID);
mi_setblockprop('<No Mesh>',1,0,'None',0,0,0)
mi_clearselected

disp('Circuit Properties')

%mi_addblocklabel(0.5*(x5+x7)*cosd(360/Nslots/2),...
%0.5*(x5+x7)*sind(360/Nslots/2))
%mi_selectlabel(0.5*(x5+x7)*cosd(360/Nslots/2),...
%0.5*(x5+x7)*sind(360/Nslots/2));
%mi_setblockprop('20 AWG',1,0,'None',0,1,1)
%mi_copyrotate(0,0,360/Nslots,Nslots)
%mi_clearselected

Current = [0 50 75 100 125 150 200 250] % Amps
Strands = 9;
ParallelWires = 13;
Turns = 117 % 9 strands x 13 wires in parallel 
Phase_init = [90 120 124 128 132 136 140 142]; %120 % deg electrical angle
Phase = Phase_init(1); % Initial phase of current
SpeedRPM = 1000 %RPM
Freq = Npoles*SpeedRPM/120 % Hz
time = 0;
mi_addcircprop('A',Current(1)*sin(2*pi*Freq*time+Phase*pi/180),1)
mi_addcircprop('B',Current(1)*sin(2*pi*Freq*time+Phase*pi/180+2*pi/3),1)
mi_addcircprop('C',Current(1)*sin(2*pi*Freq*time+Phase*pi/180+4*pi/3),1)

Circuit = {'A';'A';'B';'B';'C';'C';'A';'A';'B';'B';'C';'C'};
CoilDir = {+1;+1;-1;-1;+1;+1;-1;-1;+1;+1;-1;-1};

[m,n]=size(Circuit);
M = Nslots/m;

for i = 1 : M
  for j = 1 : m
    n=m*(i-1)+j
    mi_addblocklabel(0.5*(x5+x7)*cosd(360/Nslots*(n-1/2)),...
                     0.5*(x5+x7)*sind(360/Nslots*(n-1/2)));
    mi_selectlabel(0.5*(x5+x7)*cosd(360/Nslots*(n-1/2)),...
                   0.5*(x5+x7)*sind(360/Nslots*(n-1/2)));
    mi_setblockprop('19 AWG',1,0,Circuit{j},0,1,CoilDir{j}*Strands);
    mi_clearselected
  endfor
endfor

mi_zoomnatural

niterat=90; % 15*6;
InitialAngle=360/Nslots;
StepAngle= 360/Npoles*2/niterat;
Phase_step = 0; %360/niterat;
k=0;
Torque=0;
step_vec=[];
torq_vec=[];
time_vec=[];
Phase_vec=[];
Phase_max=[];
Torque_max=[];
Torque_avg=[];
Torque_min=[];
PhA_vec_amps=[];
PhB_vec_amps=[];
PhC_vec_amps=[];
PhA_vec_volts=[];
PhB_vec_volts=[];
PhC_vec_volts=[];
PhA_vec_webs=[];
PhB_vec_webs=[];
PhC_vec_webs=[];
B_tooth_T=[];
B_bkiron_T=[];
Mag_B_vec=[];
Mag_H_vec=[];
legend_text=[];
mi_addnode(StatorID/2+PostHeight/2,0);
mi_addnode(StatorID/4+PostHeight/2+StatorOD/4,0);


for j=1:length(Current)
for i=0:niterat
  if i==0
    mi_selectgroup(2)
    mi_selectgroup(3)
    mi_moverotate(0,0,InitialAngle)
    mag_x1 = mag_x*cosd(InitialAngle)-mag_y*sind(InitialAngle);
    mag_y1 = mag_x*sind(InitialAngle)+mag_y*cosd(InitialAngle);
    mag_x = mag_x1;
    mag_y = mag_y1;
    Phase=Phase_init(j);
    step_vec=[];
    torq_vec=[];
    time_vec=[];
    Phase_vec=[];
    PhA_vec_amps=[];
    PhB_vec_amps=[];
    PhC_vec_amps=[];
    PhA_vec_volts=[];
    PhB_vec_volts=[];
    PhC_vec_volts=[];
    PhA_vec_webs=[];
    PhB_vec_webs=[];
    PhC_vec_webs=[];
    B_tooth_T=[];
    B_bkiron_T=[];
    Mag_B_vec=[];
    Mag_H_vec=[];
  else
    mi_selectgroup(2)
    mi_selectgroup(3)
    mi_moverotate(0,0,StepAngle)
    mag_x1 = mag_x*cosd(StepAngle)-mag_y*sind(StepAngle);
    mag_y1 = mag_x*sind(StepAngle)+mag_y*cosd(StepAngle);
    mag_x = mag_x1;
    mag_y = mag_y1;
  endif
  
  Curr_PhA = Current(j)*sin(2*pi*Freq*time+Phase*pi/180);
  Curr_PhB = Current(j)*sin(2*pi*Freq*time+Phase*pi/180+2*pi/3);
  Curr_PhC = Current(j)*sin(2*pi*Freq*time+Phase*pi/180+4*pi/3);
  mi_modifycircprop('A',1,Curr_PhA)
  mi_modifycircprop('B',1,Curr_PhB)
  mi_modifycircprop('C',1,Curr_PhC)
  
  mi_saveas('/home/andrei/Data/MotorDesign_ToyotaPrius/ToyotaPrius.FEM')
  mi_clearselected
  mi_createmesh;
  mi_analyze(0);
  mi_loadsolution;
  mo_showdensityplot(1,0,2,0.0,'mag');
  mo_setgrid(10,'cart');
  mo_showvectorplot(1,1);
  mo_hidepoints;
  %mo_showmesh;
  %mo_zoom(1.5,-1.2,6.5,1.0)
  mo_savebitmap(['/home/andrei/Data/MotorDesign_ToyotaPrius/IMG/torque_',...
    num2str(j),'_',num2str(i),'.bmp']);
    
  mo_groupselectblock(2);
  mo_groupselectblock(3);
  Torque = mo_blockintegral(22);
  mo_clearblock

  Magnet_B = mo_getb(mag_x1,mag_y1);
  Magnet_H = mo_geth(mag_x1,mag_y1);
  Mag_B = sqrt(Magnet_B(1)^2+Magnet_B(2)^2);
  Mag_H = sqrt(Magnet_H(1)^2+Magnet_H(2)^2);
  Mag_B_vec=[Mag_B_vec,Mag_B];
  Mag_H_vec=[Mag_H_vec,Mag_H];
  
  PhA = mo_getcircuitproperties('A');
  PhB = mo_getcircuitproperties('B');
  PhC = mo_getcircuitproperties('C');
  
%  mo_seteditmode('contour');
%  mo_addcontour(StatorID/2,0);
%  mo_addcontour(StatorOD/2,0);
%  mo_makeplot(1,360*2);
%  mo_makeplot(1,360*2,['/home/andrei/Data/MotorDesign_ToyotaPrius/IMG/B_field_',...
%  num2str(j),'_',num2str(i),'.csv'],0);
%  mo_clearcontour;  
  
  B_th= mo_getb(StatorID/2+PostHeight/2,0);
  B_bi= mo_getb(StatorID/4+PostHeight/2+StatorOD/4,0);
  B_th_T = sign(B_th(1))*sqrt(B_th(1)^2+B_th(2)^2);
  B_bi_T = sign(B_bi(2))*sqrt(B_bi(1)^2+B_bi(2)^2);
  B_tooth_T=[B_tooth_T,B_th_T];
  B_bkiron_T=[B_bkiron_T,B_bi_T];    
    
  step_vec=[step_vec,InitialAngle+StepAngle*i];
  torq_vec=[torq_vec,Torque];
  time_vec=[time_vec,time];
  Phase_vec=[Phase_vec,Phase];
  PhA_vec_amps=[PhA_vec_amps,PhA(1,1)];
  PhB_vec_amps=[PhB_vec_amps,PhB(1,1)];
  PhC_vec_amps=[PhC_vec_amps,PhC(1,1)];
  PhA_vec_volts=[PhA_vec_volts,PhA(1,2)];
  PhB_vec_volts=[PhB_vec_volts,PhB(1,2)];
  PhC_vec_volts=[PhC_vec_volts,PhC(1,2)];
  PhA_vec_webs=[PhA_vec_webs,PhA(1,3)];
  PhB_vec_webs=[PhB_vec_webs,PhB(1,3)];
  PhC_vec_webs=[PhC_vec_webs,PhC(1,3)];
  
  time = time + 1/Freq/niterat
  Phase = Phase + Phase_step; % deg
  InitialAngle =0;
  j
  i

endfor %next time step

  [Torque]=max(torq_vec);
  Torque_max = [Torque_max,Torque];
  [Torque]=mean(torq_vec);
  Torque_avg = [Torque_avg,Torque];
  [Torque]=min(torq_vec);
  Torque_min = [Torque_min,Torque];
  Phase_max = [Phase_max,Phase];

  figure(1)
  hold on
  plot(time_vec,PhA_vec_amps,'linewidth',2,'.-r')
  plot(time_vec,PhB_vec_amps,'linewidth',2,'.-g')
  plot(time_vec,PhC_vec_amps,'linewidth',2,'.-b')
  xlabel('Time [sec]')
  ylabel('Current [A]')
  legend('PhA','PhB','PhC')
  title('Phase currents')
  grid minor on
  axis([0 max(time_vec)])
  
  figure(2)
  hold on
  plot(time_vec,PhA_vec_volts,'linewidth',2,'.-r')
  plot(time_vec,PhB_vec_volts,'linewidth',2,'.-g')
  plot(time_vec,PhC_vec_volts,'linewidth',2,'.-b')
  xlabel('Time [sec]')
  ylabel('Induced Voltage [V]')
  legend('PhA','PhB','PhC')
  title('Induced Phase Voltages')
  grid minor on
  axis([0 max(time_vec)])
  
  figure(3)
  hold on
  plot(time_vec,PhA_vec_webs,'linewidth',2,'.-r')
  plot(time_vec,PhB_vec_webs,'linewidth',2,'.-g')
  plot(time_vec,PhC_vec_webs,'linewidth',2,'.-b')
  xlabel('Time [sec]')
  ylabel('Flux Linkage [Wb]')
  legend('PhA','PhB','PhC')
  title('Phase Flux Linkages')
  grid minor on
  axis([0 max(time_vec)])
  
  figure(4)
  hold on
  plot(time_vec,torq_vec,'linewidth',2,'.-','color',linecolor1(mod(j,7)+1))
  xlabel('Time [sec]')
  ylabel('Torque [Nm]')
  legend(num2str(Current'))
  title('Transient Torque')
  grid minor on
  axis([0 max(time_vec)])

  figure(5)
  hold on
  plot(time_vec,B_tooth_T,'linewidth',2,'.-','color',linecolor1(mod(j,7)+1))
  xlabel('Time [sec]')
  ylabel('B field tooth [T]')
  legend(num2str(Current'))
  title('Stator Tooth B Field')
  grid minor on
  axis([0 max(time_vec)])
  
  figure(6)
  hold on
  plot(time_vec,B_bkiron_T,'linewidth',2,'.-','color',linecolor1(mod(j,7)+1))
  xlabel('Time [sec]')
  ylabel('B max field back-iron [T]')
  legend(num2str(Current'))
  title('Stator Back-Iron B Field')
  grid minor on
  axis([0 max(time_vec)])
  
  figure(7)
  hold on
%   plot(time_vec,Mag_B_vec)
  plot(-Mag_H_vec,Mag_B_vec,'.-','markersize',12,'color',linecolor1(mod(j,7)+1))
  legend_text = [legend_text; num2str(Current(j)),' A'];
  legend(legend_text)
  
  text1=[step_vec',time_vec',PhA_vec_amps',PhB_vec_amps',PhC_vec_amps',...
  PhA_vec_volts',PhB_vec_volts',PhC_vec_volts',...
  PhA_vec_webs',PhB_vec_webs',PhC_vec_webs',...
  torq_vec',B_tooth_T',B_bkiron_T',Mag_B_vec',-Mag_H_vec'];
  csvwrite(['simresult_',num2str(j),'.csv'],text1)

  time = 0; %reset time to zero
    
endfor %next current value

  legend_text = [legend_text; 'N35SH 20 C'];
  legend_text = [legend_text; 'N35SH 140 C'];

  figure(7)
  hold on
  plot([-Hcoerciv, 0],[0, Br],'linewidth',2,'-b') % T0
  plot([-Hcoerciv_temp, 0],[0, Br_temp],'linewidth',2,'-r') % T1
  xlabel('H [A/m]')
  ylabel('B [T]')
  grid minor on
  axis([-1e6 0 0 1.4])
  legend(legend_text, 'location','northwest')
  title('Magnet Pc')
  hold off


Current_test=[50,75,100,125,150,200,250];
Torque_test =[74,118,154,199,221,286,337];

  figure(8)
  plot(Current_test,Torque_test,'linewidth',2,'.-','color','b',...
  Current,Torque_max,'linewidth',2,'--','color','r',...
  Current,Torque_avg,'linewidth',2,'.-','color','r',...
  Current,Torque_min,'linewidth',2,'--','color','r')
  xlabel('Current [A]')
  ylabel('Torque [Nm]')
  legend(['Test';'Simulation Max';'Simulation Avg';'Simulation Min'],'location','northwest')
  title('Torque Test vs Simulation')
  grid minor on
  axis([0 max(Current_test) 0 400])
  
  text2=[Current',Phase_max',Torque_max',Torque_avg',Torque_min'];
  csvwrite('simresult_kt.csv',text2)
  
disp('========================')
disp(Time)
toc
disp('========================')
