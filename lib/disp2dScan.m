% disp2dScan shows the 2d image acquired by a 1d Verasonics/Soniq scan.
% 
% @INPUTS
%   Resource: resourse struct from VSX
%   Receive: receive struct from VSX
%   RData: Recveived data matrix from VSX (RcvData{idx})
% 
% @OUTPUTS
%   beam: receive data after rectification
%   depth: depth data assuming speed of sound in Resource.Parameters
%   rawBeam: receive data before rectification
% 
% Taylor Webb
% University of Utah

function [beam,beamStd,depth,locs,rawBeam,rawBeamStd] = disp2dScan(Resource,Receive,RData)

c = 2200;

depth = 1000*(0:(Receive(1).endSample-1))/...
    (Receive(1).ADCRate*1e6/Receive(1).decimFactor)*...
    c/2;

nPoints = Resource.RcvBuffer.numFrames;
NA = length(Receive)/nPoints;
beam = zeros(length(double(RData(Receive(1).startSample:Receive(1).endSample))),nPoints);
beamStd = beam;
rawBeam = beam;
rawBeamStd = beam;
for ii = 1:nPoints
    accum = zeros(length(depth),NA);
    accumEnv = accum;
    for jj = 1:NA
        idx = (ii-1)*NA+jj;
        accum(:,jj) = double(RData(Receive(idx).startSample:Receive(idx).endSample,1,ii));
        accumEnv(:,jj) = abs(hilbert(accum(:,jj)));
    end
    beamStd(:,ii) = std(accumEnv,[],2);
    beam(:,ii) = mean(accumEnv,2);
    rawBeam(:,ii) = mean(accum,2);
    rawBeamStd(:,ii) = std(accum,[],2);
end

% Show the image
h = figure;
lines2skip = 10;
imagesc(Resource.Parameters.locs,depth(lines2skip:end),(beam(lines2skip:end,:)))
axis('equal')
axis([Resource.Parameters.locs(1),Resource.Parameters.locs(end),depth(lines2skip),depth(end)])
colormap('gray')
colorbar
xlabel('Tx Location (mm)')
ylabel('Depth (mm)')
makeFigureBig(h);
set(h,'position',[2    42   958   954]);
drawnow

locs = Resource.Parameters.locs;