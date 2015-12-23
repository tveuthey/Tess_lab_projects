function [out] = artifact_reject (data, breaks, thresh_sd, PLOT);
% data
% breaks --> how many sections to break data, for SD sampling
% thresh_sd --> threshold SD value for rejection
% PLOT = 0 --> does not show data plots

if ~exist('breaks')
    breaks=20;
end

if ~exist('thresh_sd')
    thresh_sd=10;  % threshold x SD (for break SD)
end
 
if ~exist('PLOT')
    PLOT = 1;
end
 
if PLOT
    figure
end

NO_CHANS=size(data,1);
hold_chan_sd=zeros(NO_CHANS,1);

for chan_no=1:NO_CHANS
    disp(chan_no)
    tL=data(chan_no,:);
    
    if PLOT
        subplot(3,1,1)
        plot(tL)  %plot the raw data
    end
    
    sp=linspace(1,length(tL),breaks);
    hold_sd=zeros(1,breaks);
    for n=1:(breaks-1)
        hold_sd(n)=std(tL(sp(n):sp(n+1)));
    end
    sd1=median(hold_sd);  %median SD of the 'breaks'
    
    tL2=tL/sd1;  % z score the data
        
        
    [~,b] = find(abs(tL2)>thresh_sd); %ind of > threshold
    
    if PLOT
        title(['Before artifact rejection, BREAKS SD=',num2str(sd1)])
        subplot(3,1,2)
        plot(tL2,'k')
        hold on;
        ylim ([-thresh_sd thresh_sd])  %lims set to THRESH_SD value
        plot(b,9.9,'r*')
    end
    
    if ~isempty(b)
        tL=data(chan_no,:);
        tL(b)=0;
        sd2=std(tL);
        tL2=tL/sd2;
    else
        sd2=sd1;
    end  
    hold_chan_sd(chan_no)=sd2;
    
    if PLOT
        subplot(3,1,3)
        plot(tL2)
        title(['after artifact rejection, SD=',num2str(sd2)])
        pause (1)
    end
end

%hold_chan_sd
if PLOT
    figure
    plot(hold_chan_sd)
    %ylim([0 200]);
end
out = tL2;