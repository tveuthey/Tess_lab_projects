function [data totalM]=blockMedian(data,varargin)        
%[data totalM]=blockMean(data,varargin)   
%Calculates the block's normalized signal mean and subtracts it from the signal. 
%Treats the entire data set as a block. To calculate multiple blocks, call
%this function once for each block.
%ECoG Data is [Chan x Data]
%e.g. blockMedian(data,'THRESHOLD',10)

THRESHOLD = 6;

assignopts('ignorecase', who, varargin);


totalM = []; %section x event x time

%First zscore the data by trial and remove Artifacts
for i=1:size(data,1)
    temp = data(i,:);
    temp = zscore(temp);
    while ~isempty(find(abs(temp)>THRESHOLD))
        temp(find(abs(temp)>THRESHOLD)) = median(temp);
        temp = zscore(temp);
    end
    data(i,:) = temp;
end

%Now go across each time point and calculate the mean/median
totalM = median(data,1);

end

