% layer computes the effect of a layer of material an the US imaging
% signal.
% 
% @INPUTS
%   pIn: input pulse
%   c: speed of sound in the layer
%   g1: reflection coefficient from previous layer into current layer
%   g2: reflection coefficient from current layer into the next layer
%   d: thickness of layer
%   dt: sampling rate of pIn
%   alpha: attenuation in layer (np/distance, distance must have same units
%       as d)
%   nReflections: number of reflections to account for
% 
% @OUTPUTS
%   pOut: imaging signal that comes back
%   pIn: signal going into the next layer (always ignores extra
%       reflections - regardless of nReflections)
% 
% Taylor Webb
% University of Utah

function [pOut,pIn] = layer(pIn,c,g1,g2,d,dt,alpha,nReflections)

if nargin<7
    nReflections = 1;
    alpha = 0;
end

tau = 2*d/c;
pOut = (1+g1)*g2*(1-g1)*exp(-alpha*2*d)*delayPulse(pIn,dt,tau);

pIn = (1+g1)*exp(-alpha*d)*delayPulse(pIn,dt,tau/2);

if nReflections > 1
    for ii = 2:nReflections
        pOut = pOut+(1+g1)*(1-g1)*(-g1)^(ii-1)*g2^ii*exp(-alpha*2*ii*d)*delayPulse(pIn,dt,tau*ii);
    end
end

