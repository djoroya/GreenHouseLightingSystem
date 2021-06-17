clear 

% import functions to compute sunset
%%
% unzip('https://github.com/djoroya/MechanisticSolarRadiationModel/archive/refs/heads/main.zip')
% addpath('RadiationModel')
%%

%
time0=600*(0:52559)';
%
time = time0/(3600*24);
%%
data=xlsread('año2019completo.xlsx');
%
%% Temperature Exterior
tt.time = (time);
tt.signals.values = data((1:52560),1);
%% Radiation
Si.time = (time);
Si.signals.values = data((1:52560),3);
%% Wind
vv.time = (time);
vv.signals.values = data((1:52560),5);
%%
Tref=16.5;
%% Compute change days
DateTime = datetime('2019-01-01 00:00:00') + seconds(time0);

DateTime_duration = days(DateTime - DateTime(1));

CD = (DateTime_duration - floor(DateTime_duration)) > 1e-4;
% Signal
ChangeDay.time = (time);
ChangeDay.signals.values = CD;

%% Compute Sunsets
% Meñaka

Latitud  = 43.349024834327; 
Longitud = -2.797651290893;
DGMT = 2;
%
iter  = 0;
sset = zeros(1,length(DateTime));
for iLT = DateTime'
    iter = iter + 1;
    sset(iter) = Date2Sunset(iLT,Latitud,Longitud,DGMT);
end
%
TurnOnHour = abs((hour(DateTime ) + minute(DateTime)/60) - sset') < 0.3 ; % 

% Signal Sunset hours
Hours.time = (time);
Hours.signals.values = TurnOnHour;

%% Simulation
T = '200'; % <= Final Time in Days
rl = sim('calefaccion_control_prueba','StopTime',T);
%rl = sim('calefaccion_control_prueba_R2020a','StopTime',T);

%
on_off = rl.logsout.getElement('on_off').Values.Data;
tspan  = rl.tout;

dt = (10/(60*24));
new_tspan = 0:dt:str2double(T);

new_on_off = interp1(tspan,on_off,new_tspan,'nearest'); % <= Interpolation in 10 minutes
