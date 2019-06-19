% Finds the hydrophone measured delay through the skull using waveforms
% recorded with and without the skull present. The hydrophone measured
% delay is the arrival time of the signal without the skull minus the
% arrival time without the skull present.
% 
% @INPUTS
%   t: time at which samples were acquired
%   sk: waveform acquired with the skull present
%   nSk: waveform acquired without the skull present
% 
% @OUTPUTS
%   delay: computed delay between the arrival with and without the skull
%     present. Units match the units of t.
% 
% Taylor Webb
% University of Utay
% taylor.webb@utah.edu

function delay = hydrophoneDelay(t,sk,nSk)
VERBOSE = 1;
sk = smooth(sk);
nSk = smooth(nSk);

idxSk = findFrontEdge(sk);
idxNoSk = findFrontEdge(nSk);
delay = t(idxNoSk)-t(idxSk);

if VERBOSE
    figure(99)
    clf
    plot(t,sk,'-',t,nSk,'--',t(idxNoSk),nSk(idxNoSk),'*',t(idxSk),sk(idxSk),'*')
    pause(0.5)
end
if delay < 0
    warning('The signal with the skull present appears to be arriving later than the signal in just water.')
end