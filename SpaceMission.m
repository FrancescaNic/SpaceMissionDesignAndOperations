clear all
close all

% Data and assumptions 

dmB = 20*10^3; % [kg] Dry mass B
dmC = 10*10^3; % [kg] Dry mass C
dmD = 5*10^3; % [kg] Dry mass D
Isp = 380; % [s] Propellants: CH4 and LOX
%The dry masses of the different vehicles include the crew and crew provisions and the propellant needed for attitude control
g = 9.81; % [ms^(-2)] Gravitational acceleration on the Earth surface
Reo = 1.496*10^11; % [m] Radius of Earth orbit
Re = 6.378*10^6; % [m] Earth radius
Rmo = 1.524*1.496*10^11; % [m] Radius of Mars orbit
Rm = 3.3895*10^6; % [m] Mars radius
%Mars is assumed to be of spherical shape, with no rotation
mue = 3.986*10^14; % [m^3s^(-2)]
mus =  1.327*10^20; % [m^3s^(-2)]
mum = 4.283*10^13; % [m^3s^(-2)]

aleo = 500*10^3; % [m] altitude LEO
almo = 300*10^3; % [m] altitude LMO

%a0=(Rmo-aleo-almo+Reo)/2;
a0=(Rmo+Reo)/2;

M = [];
deltaV = [];

% 1 LEO to MTO

M = [M, dmB + dmC + dmD]; % [kg]
%pure heliocentric Hohmann transfer

Vd=sqrt(2*mus/Reo-mus/a0);
VE=sqrt(mus/Reo);
vdinf=Vd-VE;
vERd=sqrt(2*mue/(Re+aleo));
vRd=sqrt(mue/(Re+aleo));
vd=sqrt(vdinf^2+vERd^2);
deltaV=[deltaV, (vd-vRd)];

% 2 MTO to LMO

M = [M, dmB + dmC + dmD]; % [kg]

Va=sqrt(2*mus/Rmo-mus/a0);
VM=sqrt(mus/Rmo);
vainf=Va-VM;
vERp=sqrt(2*mum/(Rm+almo));
vp=sqrt(vainf^2+vERp^2);
vRd=sqrt(mum/(Rm+almo));
deltaV=[deltaV,vp-vRd];

% 3 LMO to Surface

M = [M, dmC + dmD]; % [kg]
M = [M, dmC + dmD]; % [kg]

a1 = (2*Rm+almo)/2;
dV=vRd-sqrt(2*mum/(Rm+almo)-mum/a1);
deltaV=[deltaV, dV];
dV=sqrt(2*mum/Rm-mum/a1);
deltaV=[deltaV, dV];

% 4 Surface to LMO

M = [M, dmD]; % [kg]

deltaV=[deltaV, vRd];

% 5 LMO to ETO

M = [M, dmB]; % [kg]

Vd=sqrt(2*mus/Rmo-mus/a0);
VE=sqrt(mus/Rmo);
vdinf=Vd-VE;
vd=sqrt(vdinf^2+vERp^2);
deltaV=[deltaV,vd-vRd];

% 6 ETO to LEO

M = [M, dmB]; % [kg]

Va=sqrt(2*mus/Reo-mus/a0);
VM=sqrt(mus/Reo);
vainf=Va-VM;
vERp=sqrt(2*mue/(Re+aleo));
vp=sqrt(vainf^2+vERp^2);
vRd=sqrt(mue/(Re+aleo));
deltaV=[deltaV,vp-vRd];

% Compute needed propellant

% Scenario 1

Madd=M;
mpt = [];
mf = [];
mi = [];

% 6 ETO to LEO
mp = Madd(7)*(exp(deltaV(7)/(g*Isp))-1);
mf = [Madd(7)];
mi = [Madd(7)+mp];
Madd(6) = Madd(6)+ mp;
mpt = [mpt, mp];

% 5 LMO to ETO
mp = Madd(6)*(exp(deltaV(6)/(g*Isp))-1);
mf = [mf, Madd(6)];
mi = [mi, Madd(6)+mp];
mpt = [mpt, mp];

% 4 Surface to LMO 
mp = Madd(5)*(exp(deltaV(5)/(g*Isp))-1);
mf = [mf, Madd(5)];
mi = [mi, Madd(5)+mp];
Madd(4)=Madd(4)+ mp;
mpt = [mpt, mp];

% 3 LMO to Surface
mp = Madd(4)*(exp(deltaV(4)/(g*Isp))-1);
mf = [mf, Madd(4)];
mi = [mi, Madd(4)+mp];
Madd(3)=Madd(3)+ mp + mpt(end);
mpt = [mpt, mp];
mp = Madd(3)*(exp(deltaV(3)/(g*Isp))-1);
mf = [mf, Madd(3)];
mi = [mi, Madd(3)+mp];
mpt = [mpt, mp];
Madd(2)=Madd(2)+ sum(mpt);

% 2 MTO to LMO
mp = Madd(2)*(exp(deltaV(2)/(g*Isp))-1);
mf = [mf, Madd(2)];
mi = [mi, Madd(2)+mp];
mpt = [mpt, mp];
Madd(1)=Madd(1)+ sum(mpt);

% 1 LEO to MTO
mp = Madd(1)*(exp(deltaV(1)/(g*Isp))-1);
mf = [mf, Madd(1)];
mi = [mi, Madd(1)+mp];
mpt = [mpt, mp];

fprintf("SCENARIO 1\n")
fprintf("\n")
fprintf("Propellant needed\n")
fprintf("%f kg\n", sum(mpt))
fprintf("\n")
fprintf("In the order of the maneuvers:\n")
deltaV
fprintf("\n")
fprintf("Propellant Masses used \n")
flip(mpt)
fprintf("\n")
fprintf("Initial masses\n")
flip(mi)
fprintf("\n")
fprintf("Final masses\n")
flip(mf)
fprintf("\n\n")

% Scenario 2

Madd=M;
mpt = [];
mf = [];
mi = [];

% 3 LMO to Surface
mp = Madd(4)*(exp(deltaV(4)/(g*Isp))-1);
mf = [mf, Madd(4)];
mi = [mi, Madd(4)+mp];
mpt = [mpt, mp];
Madd(3)=Madd(3)+ sum(mpt);


mp = Madd(3)*(exp(deltaV(3)/(g*Isp))-1);
mf = [mf, Madd(3)];
mi = [mi, Madd(3)+mp];
mpt = [mpt, mp];
Madd(2)=Madd(2)+ sum(mpt);

% 2 MTO to LMO
mp = Madd(2)*(exp(deltaV(2)/(g*Isp))-1);
mf = [mf, Madd(2)];
mi = [mi, Madd(2)+mp];
mpt = [mpt, mp];
Madd(1)=Madd(1)+ sum(mpt);

% 1 LEO to MTO
mp = Madd(1)*(exp(deltaV(1)/(g*Isp))-1);
mf = [mf, Madd(1)];
mi = [mi, Madd(1)+mp];
mpt = [mpt, mp];



fprintf("SCENARIO 2 Part1\n")
fprintf("\n")
fprintf("Propellant needed to perform the one-way mission to the surface of Mars\n")
fprintf("%f kg\n", sum(mpt))
fprintf("\n")
fprintf("In the order of the maneuvers from 1 to 3:\n")
deltaV(1:4)
fprintf("\n")
fprintf("Propellant Masses used \n")
flip(mpt)
fprintf("\n")
fprintf("Initial masses\n")
flip(mi)
fprintf("\n")
fprintf("Final masses\n")
flip(mf)
fprintf("\n\n")

Madd=M;
mpt=[];
mf = [];
mi = [];

% 6 ETO to LEO
mp = Madd(7)*(exp(deltaV(7)/(g*Isp))-1);
mf = [mf, Madd(7)];
mi = [mi, Madd(7)+mp];
mpt = [mpt, mp];
Madd(6)=Madd(6)+ sum(mpt);

% 5 LMO to ETO
mp = Madd(6)*(exp(deltaV(6)/(g*Isp))-1);
mf = [mf, Madd(6)];
mi = [mi, Madd(6)+mp];
mpt = [mpt, mp];
Madd(5)=Madd(5)+ sum(mpt);

% 4 Surface to LMO 
mp = Madd(5)*(exp(deltaV(5)/(g*Isp))-1);
mf = [mf, Madd(5)];
mi = [mi, Madd(5)+mp];
mpt = [mpt, mp];

fprintf("SCENARIO 2 part 2\n")
fprintf("\n")
fprintf("Propellant needed to be loaded in the D vehicle on the surface of Mars for the return to Earth\n")
fprintf("%f kg\n", sum(mpt))
fprintf("\n")
fprintf("In the order of the maneuvers from 4 to 6:\n")
deltaV(5:7)
fprintf("\n")
fprintf("Propellant Masses used \n")
flip(mpt)
fprintf("\n")
fprintf("Initial masses\n")
flip(mi)
fprintf("\n")
fprintf("Final masses\n")
flip(mf)


