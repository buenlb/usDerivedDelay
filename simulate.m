if ~exist('procUsData.m','file')
    addpath('lib')
end

%% Skull Properties
cMed = 2200;
cCor = 2800;
cSt = 1600;

rhoMed = 1178;
rhoCort = 1908;
rhoSt = 1046;

zMed = cMed*rhoMed;
zCor = cCor*rhoCort;
zSt = cSt*rhoSt;

dIt = 2.5e-3;
dMed = 2e-3;
dOt = 2.5e-3;

% Attenuation in np/m
alphaCor = 200;
alphaMed = 500;

%% Sonication Properties
f = 2.25e6;
nCycles = 3;

nReflections = 3;

%% Make the initial pulse
[pulse,t] = generatePulse(f,nCycles,1e2);
dt = t(2)-t(1);
pulse = [pulse,zeros(1,5*length(pulse))];
t = 0:dt:(dt*(length(pulse)-1));
%% Reflection Coefficients
% gamma moving from soft tissue to cortical bone
gamma1 = (zCor-zSt)/(zCor+zSt);

% gamma moving from cortical bone to medullary bone
gamma2 = (zMed-zCor)/(zMed+zCor);

%% Inner Table Layer
[pOut_innerTable,pIn1] = layer(pulse,cCor,gamma1,gamma2,dIt,dt,alphaCor,nReflections);

%% Medullary Layer
% After figuring out the effects of the layer we have to propogate back
% through previous layers
returnLoss = (1-gamma1)*exp(-dIt*alphaCor);
returnDelay = dIt/cCor;

[pOut_Med,pIn2] = layer(pIn1,cMed,gamma2,-gamma2,dMed,dt,alphaMed,nReflections);

pOut_Med = returnLoss*delayPulse(pOut_Med,dt,returnDelay);
%% Outer Table Layer
% After figuring out the effects of the layer we have to propogate back
% through previous layers
returnLoss = returnLoss*(1-gamma2)*exp(-dMed*alphaMed);
returnDelay = returnDelay+dMed/cMed;

[pOut_outerTable,pIn3] = layer(pIn2,cCor,-gamma2,-gamma1,dOt,dt,alphaCor,nReflections);
pOut_outerTable = returnLoss*delayPulse(pOut_outerTable,dt,returnDelay);
%% Result
pOut = pulse+pOut_innerTable+pOut_Med+pOut_outerTable;

%% Plot
h = figure;
subplot(211)
plot(t*1e6,real(pOut))

subplot(212)
plot(t*1e6,abs(hilbert(real(pOut))))