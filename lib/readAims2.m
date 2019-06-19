function [data,axes,t,wvForms] = readAims2(fileName)

% get number of parameters measured
text = fileread(fileName);

% Find dimensionality of scan
begScanData = regexp(text,'.D Scan Data');
dimensions = str2double(text(begScanData));

if dimensions == 1
    
    scanInfo = regexp(text,'\[1D Scan\]');
    
    axis = regexp(text,'Axis');
    axis = axis(axis>scanInfo);
    axis = axis(1);
    axis = findNextNumber(text,axis);
    
    stPos = regexp(text,'Start Position');
    stPos = findNextNumber(text,stPos);
    
    endPos = regexp(text,'End Position');
    endPos = findNextNumber(text,endPos);
    
    np = regexp(text,'Points');
    np = np(np>scanInfo);
    np = np(1);
    np = findNextNumber(text,np);
    
    for ii = 1:6
        if ii == axis+1
            axes{ii}.Position = linspace(stPos,endPos,np);
        else
            tmp = regexp(text,['Axis ',num2str(ii-1), ' Position']);
            axes{ii}.Position = findNextNumber(text,tmp+7);
        end
    end
    
    % Find the raw data
    numParameters = regexp(text,'Parameter');
    if length(numParameters) > 1
        error('I haven''t dealt with more than one parameter yet. Feel free to add the functionality!')
    end
    
    curIdx = begScanData;
    [~,curIdx] = findNextNumber(text,curIdx+1);
    data = zeros(1,np);
    for ii = 1:np
        [scanLoc,curIdx] = findNextNumber(text,curIdx+1);
        if scanLoc ~= axes{axis+1}.Position(ii)
            error('Something is wrong. The scan locations on the data are not lining up with the scan locations I read out of the header.')
        end
        [data(ii),curIdx] = findNextNumber(text,curIdx+1);
    end
    
    scopeInfo = regexp(text,'\[Oscilloscope\]');
    scopePoints = regexp(text,'Points');
    scopePoints = scopePoints(scopeInfo<scopePoints);
    scopePoints = scopePoints(1);
    scopePoints = findNextNumber(text,scopePoints);
    
    startWvForms = regexp(text,'\[1D Scan Waveforms\]');
    startWvForms = startWvForms + length('[1D Scan Waveforms]');

    fid = fopen(fileName,'r');
    fseek(fid,startWvForms,'bof');
    fscanf(fid,'%f',np);
    wvData = fscanf(fid,'%f',[np+1,scopePoints]);
    t = wvData(1,:);
    wvForms = wvData(2:end,:);
else
    error('This code currently only works for 1 dimensional scans. Taylor would love it if you expanded it though!')
end