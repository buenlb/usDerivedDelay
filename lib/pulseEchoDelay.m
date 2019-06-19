% Estimate the time that passes during traversal of the skull
% 
% @INPUTS
%   t: time at which samples are acquired
%   beam: measured acoustic echo
% 
% @OUTPUTS
%   delay: estimated amount of time to pass through the skull. Units are
%       the same as t.
% 
% Taylor Webb
% University of Utah
% taylor.webb@utah.edu

function delay = pulseEchoDelay(t,beam)

% This is because there is that big signal at the beginning and end of
% these things. Probably need to find a more elegant way of dealing with
% that...
beam = beam(200:end-200);
t = t(200:end-200);

beam = abs(hilbert(beam));
beam = log(beam);

[pks,idxPeaks] = findpeaks(beam);
[val,idxVal] = findpeaks(-beam);

% Find relevant area of the beam
tmp = find(pks>mean(beam)+2*std(beam));
pks = pks(tmp);
idxPeaks = idxPeaks(tmp);

tmp = find(idxVal < max(idxPeaks) & idxVal > min(idxPeaks));
if isempty(tmp)
    keyboard
end
idxVal = idxVal(tmp(1)-1:tmp(end)+1);
val = -val(tmp(1)-1:tmp(end)+1);

figure(99)
clf
plot(t,beam)
hold on
plot(t(idxPeaks),pks,'*')
plot(t(idxVal),val,'^')
% pause(0.5)

% Provide delay
delay = (t(idxVal(end))-t(idxVal(1)))/2;

if 0
    keyboard
end