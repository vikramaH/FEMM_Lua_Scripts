 clear all
more off
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

Current = [0 125 250] %[0 5 25 50 75 100 125 150 200 250] % Amps for high temperature
Strands = 9;
ParallelWires = 13;
Turns = 117 % 9 strands x 13 wires in parallel 
Phase_init = [80 132 142]; %[80 90 110 120 124 128 132 136 140 142] % deg electrical angle of max torque
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

niterat=15*6; % 15*6; % current phase iterations and rotor position
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
PhA_vec=[];
PhB_vec=[];
PhC_vec=[];
Mag_B_vec=[];
Mag_H_vec=[];
legend_text=[];

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
    PhA_vec=[];
    PhB_vec=[];
    PhC_vec=[];
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
  
  step_vec=[step_vec,InitialAngle+StepAngle*i];
  torq_vec=[torq_vec,Torque];
  time_vec=[time_vec,time];
  Phase_vec=[Phase_vec,Phase];
  PhA_vec=[PhA_vec,Curr_PhA];
  PhB_vec=[PhB_vec,Curr_PhB];
  PhC_vec=[PhC_vec,Curr_PhC];
  
  time = time + 1/Freq/niterat
  Phase = Phase + Phase_step; % deg
  InitialAngle =0;
  i
  j

endfor

  figure(1)
  %subplot(2,1,1)
  hold on
  plot(time_vec,PhA_vec,'linewidth',2,'.-r')
  plot(time_vec,PhB_vec,'linewidth',2,'.-g')
  plot(time_vec,PhC_vec,'linewidth',2,'.-b')
%  plot(Phase_vec,PhA_vec,'.-')
%  plot(Phase_vec,PhB_vec,'.-')
%  plot(Phase_vec,PhC_vec,'.-')
%  xlabel('Electric angle [deg]')
  xlabel('Time [sec]')
  ylabel('Current [A]')
  legend('PhA','PhB','PhC')
  grid minor on
%  axis([0 180])
  %hold off
  
  [Torque]=mean(torq_vec);
  Torque_max = [Torque_max,Torque];
  Phase_max = [Phase_max,Phase];
  
  figure(2)
  hold on
  %subplot(2,1,2)
%  plot(step_vec,torq_vec,'.-','color',j)
%  xlabel('Angle [deg]')
%  ylabel('Torque [Nm]')
%  legend('Torque [Nm]')
%  plot(Phase_vec,torq_vec,'.-','color',j)
  plot(time_vec,torq_vec,'linewidth',2,'.-',j)
  xlabel('Time [sec]')
%  xlabel('Electric angle [deg]')
  ylabel('Torque [Nm]')
  legend(num2str(Current'))
  grid minor on
%  axis([0 180])
%  hold off
  
%  text=[Phase_vec',torq_vec'];
  text=[time_vec',torq_vec'];
  csvwrite(['simresult_',num2str(j),'.csv'],text)
  
  Mag_B_min = min(Mag_B_vec);
  Mag_H_min = max(Mag_H_vec);
  Pc = Mag_B_min/Mag_H_min/mu0;
  legend_text = [legend_text; ['Current = ',num2str(Current(j)), ' Apk']]
% legend_text = [legend_text; ['Pc = ',num2str(Pc)]]
  
   figure(3)
   hold on
%   plot(time_vec,Mag_B_vec)
   plot(-Mag_H_vec,Mag_B_vec,'.-g',...
   'markersize',12)
   xlabel('H [A/m]')
   ylabel('B [T]')
   grid minor on
   axis([-1e6 0 0 1.4])
   title('Magnet Pc')
%   hold off

   time = 0;
   time_vec=[];

endfor

%  figure(2)
%  hold on
%  plot(Phase_max,Torque_max)
%  hold off

  legend_text = [legend_text; num2str(T0)];
  legend_text = [legend_text; num2str(T1)];

  figure(3)
  hold on
  plot([-Hcoerciv, 0],[0, Br],'linewidth',2,'-b') % T0
  plot([-Hcoerciv_temp, 0],[0, Br_temp],'linewidth',2,'-r') % T1
  xlabel('H [A/m]')
  ylabel('B [T]')
  grid minor on
  axis([-1e6 0 0 1.4])
  legend(legend_text, 'location','northwest')
  hold off
  
  text=[Current',Phase_max',Torque_max'];
  csvwrite('simresult_kt.csv',text)
  
disp('========================')
disp(Time)
toc

disp('========================')
