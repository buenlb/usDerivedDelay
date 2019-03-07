clear; close all; clc

cb = 2e3;

load Data/head96V_Taylor_longerDistance.mat

t = (0:(Receive(1).endSample-1))/(Receive(1).ADCRate*1e6/Receive(1).decimFactor)*1e6;

indTraces = zeros(length(Receive),length(Receive(1).startSample:Receive(1).endSample));
for ii = 1:length(Receive)
    indTraces(ii,:) = RcvData{1}(Receive(ii).startSample:Receive(ii).endSample,1);
end
sgnl = mean(indTraces,1);

sgnl = abs(hilbert(sgnl));

h  = figure;
plot(t(500:end),sgnl(500:end))

load Data/head96V_Tom_longerDistance.mat

indTraces = zeros(length(Receive),length(Receive(1).startSample:Receive(1).endSample));
for ii = 1:length(Receive)
    indTraces(ii,:) = RcvData{1}(Receive(ii).startSample:Receive(ii).endSample,1);
end
sgnl = mean(indTraces,1);
stdev = std(indTraces,[],1);

figure
errorbar(100*(t)*cb/2,sgnl,stdev/2)
return
sgnl = abs(hilbert(sgnl));

hold on
plot(t(500:end),sgnl(500:end))
xlabel('time (\mus)')
ylabel('Voltage (arb. units)')
% makeFigureBig(h)

sgnl = sgnl(500:end);
stdev = stdev(500:end);
t = t(500:end)*1e-6;

[~,idx] = findpeaks(sgnl);
[~,front] = max(sgnl(idx));
front = idx(front);

figure
plot(100*(t(front:end)-t(front))*cb/2,sgnl(front:end))