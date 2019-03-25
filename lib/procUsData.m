% procUsData takes the Receive struct and the RcvData cell array created
% when running VSX on the verasonics system and computes any averages (the
% code assumes that multiple acquisitions are multiple averages) and finds
% the envelope function
% 
% @INPUTS
%   Receive: Receive struct created by VSX
%   RcvData: Receive data buffer created by VSX
%   plots: If plots is true then the system creates a figure showing the
%     raw computed average with standard deviation and the envelope
% 
% @OUTPUTS
%   env: envelope function
%   stdEnv: standard deviation of enveloped function
%   raw: raw average
%   stdRaw: standard deviation of the raw data at every time point
%   t: time in microseconds

function [env,stdEnv,raw,stdRaw,t] = procUsData(Receive,RcvData,plots)

t = (0:(Receive(1).endSample-1))/(Receive(1).ADCRate*1e6/Receive(1).decimFactor)*1e6;

indTraces = zeros(length(Receive),length(Receive(1).startSample:Receive(1).endSample));
indEnvelopes = indTraces;
for ii = 1:length(Receive)
    indTraces(ii,:) = RcvData{1}(Receive(ii).startSample:Receive(ii).endSample,1);
    indEnvelopes(ii,:) = abs(hilbert(indTraces(ii,:)));
end
raw = mean(indTraces,1);
stdRaw = std(indTraces,[],1);

env = abs(hilbert(raw));
stdEnv = std(indEnvelopes,[],1);

if plots
    h = figure;
    subplot(211)
    errorbar(t,raw,stdRaw/2);
    ylabel('voltage')
    makeFigureBig(h);
    
    subplot(212)
    plot(t,env,'linewidth',2)
    grie on
    xlabel('time (\mus)')
    ylabel('Envelope (voltage)')
    makeFigureBig(h);
end