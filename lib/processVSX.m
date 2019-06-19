% Process the data left in the worskpace after running VSX by returning the
% time at which samples are acquired and each beam in an M x N vector where
% M is the number of beams and N is the number of samples in each beam
% 
% @INPUTS
%   vsxFile: mat file containing the results of VSX
% 
% @OUTPUTS
%   t: sample times in microseconds
%   beam: receive data
% 
% Taylor Webb
% University of Utah

function [t,beam] = processVSX(vsxFile)
load(vsxFile,'RcvData','Receive','Resource');
RData = double(RcvData{1});

t = 1e6*(0:(Receive(1).endSample-1))/...
    (Receive(1).ADCRate*1e6/Receive(1).decimFactor);

numAvg = Resource.Parameters.numAvg;
totBeam = zeros(length(Receive(1).startSample:Receive(1).endSample),1);
for ii = 1:numAvg
    beam_n = RData(Receive(ii).startSample:Receive(ii).endSample,1);
    totBeam = beam_n+totBeam;
end

beam = totBeam/numAvg;