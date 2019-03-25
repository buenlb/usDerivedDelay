path = 'C:\Users\Taylor\Box Sync\Taylor_verasonics\foreheads\';

% heads = {'jan','Taylor','Zach','Tom_delta'};
heads = {'jan','Jan2_2','Jan_bubblesCleared'}
heads = {'Jan_bubblesCleared';}
if ~exist('procUsData.m','file')
    addpath('lib')
end

h = figure;
hold on

for ii = 1:length(heads)
    curHead = load([path,heads{ii}]);
    [env,stdEnv,raw,rawStd,t] = procUsData(curHead.Receive,curHead.RcvData,0);

    cB = 2.5e6;
    d = t*1e-6*cB;
    
%     subplot(length(heads),1,ii)
    ax = gca;
    shadedErrorBar(d,env,stdEnv,'lineprops',{'Color',ax.ColorOrder(ii,:)})
%     title(heads{ii})
end

grid on
xlabel('distance (mm)')
% legend('Jan','Taylor','Zach','Tom (delta)')
legend(heads)
% axis([230,290,0,15000])
makeFigureBig(h)
set(h,'position',[ 0.0010   -0.1750    1.9200    0.9648]*1e3)