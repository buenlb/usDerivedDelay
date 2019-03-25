% delayPulse delays pulseIn by tau by shifting indices.
% 
% @INPUTS
%   pulseIn: the pulse to shift
%   dt: delta t in the sampling of pulseIn
%   tau: amount to shift pulse in by. dt and tau must be in the same units
% 
% @OUTPUTS
%   pulseOut: shifted pulse
% 
% Taylor Webb
% University of Utah

function pulseOut = delayPulse(pulseIn,dt,tau)

if size(pulseIn,1) > 1
    error('pulseIn must be a row vector!')
end

dIdx = round(tau/dt);

pulseOut = circshift(pulseIn,dIdx,2);
if dIdx > 0
    pulseOut(1:dIdx) = 0;
else
    pulseOut(end-(dIdx-1):end) = 0;
end