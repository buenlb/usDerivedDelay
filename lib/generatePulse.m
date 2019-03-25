% generatePulse makes a pulse with nCycles at a center frequency, f. The
% pulse is sampled with sampling samples/period and multiplied by a 
% gaussian to simulate a more realistic result.
% 
% @INPUTS
%   f: desired center frequency
%   nCycles: number of cycles
%   sampling: number of samples per period (optional, defaults to 10)
% 
% @OUTPUTS
%   pulse: the resulting pulse
%   t: the corresponding time points
% 
% Taylor Webb
% University of Utah

function [pulse,t] = generatePulse(f,nCycles,sampling)

if nargin < 3
    sampling = 10;
end

pLength = 2*nCycles/f;

t = linspace(-pLength/2,pLength/2,sampling*nCycles); % Pulse with sampling of 10/wavelength

pulse = exp(-1i*2*pi*f*t).*exp(-1/2*(t/(pLength/10)).^2);


