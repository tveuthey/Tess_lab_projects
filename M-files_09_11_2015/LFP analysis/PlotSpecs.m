function PlotSpecSingle(data,fs,events,varargin)        
%% Tally's average via snippets and removes common median using the preloaded data matrix
%
%Example entry:
%PlotSpecScripts(data{12},fs,events{12})


SAVEIT = 0;
direction = [2 4 4 1 2 1 4 1 2 3 4 2 3 3 3 3 1 1 4 1 1 3 1 4 2 4 2 3 3 2 4 2];

premoveTime = 2;
postmoveTime = 10;     

segLen = floor((premoveTime + postmoveTime) * fs);

params.Fs=fs;
params.fpass = [20 200];
params.trialave = 1;
params.err = 0;
params.pad = 0;
params.tapers = [3 5];

assignopts('ignorecase', who, varargin);

totalM = []; %section x event x time
for section = 0:3
for i = 1:length(events)
        tStart = floor((events(i) - premoveTime) * fs);
        tFinish = tStart + segLen;
        if tStart < 1
            tStart = 1;
        end
        if tFinish > size(data,2)
            tFinish = size(data,2);
        end
        
        trials = [];
        for chan = 1:64 %number of channels to be combined in the section
            temp = data(chan+64*section,tStart:tFinish);
            
            if isempty(trials)
                trials(chan,:) = temp;
            end
            
            trials(chan,:) = temp;
            
            clear temp;
        end
        %now that all channels are accounted for, calculate the mean or
        %median and set in totalM
        
        %totalM(i+current, :) = median(trials,1);
        totalM(section+1,i, :) = mean(trials,1);
end
end

%%
fig = [];
for chan = 1:256
    trials = [];
    for i=1:length(events)
        tStart = floor((events(i) - premoveTime) * fs);
        tFinish = tStart + segLen;
        if tStart < 1
            tStart = 1;
        end
        if tFinish > size(data,2)
            tFinish = size(data,2);
        end
        
        temp = data(chan,tStart:tFinish);
        
        if isempty(trials)
            trials = temp;
        end
        
        temp = temp - totalM(floor((i-1)/64)+1,i,:);
        
        trials(i,:) = temp;
        clear temp;
        
    end

    %all data for the channel has been collected, plot the data
    
    if (mod(chan-1,16)+1) == 1
        fig = figure('Position',get(0,'ScreenSize'),'color','w');
    end
    subplot(4,4,mod(chan-1,16)+1);
    
    [S,t,f] = mtspecgramc(trials',[.15 .15/2],params); % Breaks down into time frequency plot. second param is window size and step size
    
    t=t-premoveTime;
    plot_matrix(S,t,f,'l')
    temp = axis;
    line([0 0],[temp(3) temp(4)],'color','k')
    title(chan)
    
    if chan/16 == floor(chan/16) & SAVEIT %If at the end of the figure, save it
        temp=getframe(fig);
        imwrite(temp.cdata,['Totals Channels ',num2str(chan - 15),'-',num2str(chan),'minus common mean.tif'],'compression','none');
        close(fig)
    end
end



end
