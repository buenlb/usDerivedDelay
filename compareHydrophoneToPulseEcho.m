% This runs library functions to find the pulse echo and hydrophone
% measured delays based on the files set at the beginning.
clear; close all; clc;

%% Setup input files
hPhoneSkullFile = 'C:\Users\Taylor\Box Sync\PulseEchoExperiments\13841\20190610\waveform_withSkull.snq';
hPhoneNoSkullFile = 'C:\Users\Taylor\Box Sync\PulseEchoExperiments\13841\20190610\waveform_withoutSkull.snq';

pulseEchoFile = 'C:\Users\Taylor\Box Sync\PulseEchoExperiments\13841\20190610\pulseEchoData.mat';

%% Thickness measured on CT, Speed of sound in water
d = 5e-3;
cw = 1492e-6; % Speed of sound in m/microseconds to match units of t

%% Find true phase correction (Hydrophone Data)
[t_hPhone,skullData] = readWaveform(hPhoneSkullFile);
[~,noSkullData] = readWaveform(hPhoneNoSkullFile);

hDelay = hydrophoneDelay(t_hPhone,skullData,noSkullData);

%% Estimate the delay from pulse echo data
[t,beams] = processVSX(pulseEchoFile);

pDelay = pulseEchoDelay(t,beams);

%% Results
disp(['Gold Standard:', num2str(hDelay), ' microseconds']);
disp(['Pulsed Echo Estimate: ', num2str(pulseDelay2hDelay(pDelay,d,cw)), ' microseconds'])