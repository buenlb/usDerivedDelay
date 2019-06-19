% Converts the measured pulse echo delay to an estimate of the delay
% measured by the hydrophone
% 
% @INPUTS
%   echoDelay: difference between arrival time with and without the skull
%     present (tau_2 - tau_1)
%   d: thickness of skull
%   c_w: determined speed of sound through water
% 
% @OUTPUTS
%   delay: estimate of delay measured with hydrophone (tau_b-tau_w)
% 
% Taylor Webb
% University of Utah
% taylor.webb@utah.edu

function delay = pulseDelay2hDelay(echoDelay, d, c_w)

delay = echoDelay - ((d)/c_w);