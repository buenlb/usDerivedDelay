% Finds the front edge of a signal, s.
% 
% @INPUTS
%   s: signal of interest
% 
% @OUTPUTS
%   idx: index location of the front edge 
% 
% Taylor Webb
% University of Utah
% taylor.webb@utah.edu

function idx = findFrontEdge(s)

meanS = mean(s);
stdS = std(s);

idx = find(s>meanS+stdS);
idx = idx(1);

decreasing = 1;
df = diff(s);
while decreasing
    if df(idx)<10
        decreasing = 0;
    else
        idx = idx-1;
    end
end

% figure
% plot(1:length(s),s,'-',idx,s(idx),'*')
% keyboard

% found = 0;
% idx = 1;
% while ~found
%     curIdx = tSk(idx);
%     if mean(sk((curIdx+1):(curIdx+10)))>sk(curIdx)
%         idx = idx+1;
%         continue
%     end
%     found = 1;
% end
% tSk = curIdx;