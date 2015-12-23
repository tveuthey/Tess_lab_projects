%% Data Flow Script for going from raw ECoG Data to processed comparisons with Synergies

%Start with Data in allData structure

%% Removing Artifacts and common median

for i=0:3
    allData.data([(1+64*i) : (64*(i+1))],:) = blockMedian(allData.data([(1+64*i) : (64*(i+1))],:) );
end

%% Downsample to desired freqency
oldFreq = allData.fs;
newFreq = 400;
oldT = allData.t;
newT = min(oldT):(1/newFreq):max(oldT);

tempData = [];
for i=1:size(allData.data,1)
    tempData(i,:) = interp1(oldT,allData.data(i,:),newT,'spline'); %Converts the sample to a downsampled and common sample frequency for better correlation
end
allData.data = tempData;
clear tempData

allData.fs = newFreq;
allData.t=newT;

save('AllData CommonMedian DS.mat','allData')


%Creating a low memory Statistics data variable
temp = allData;
clear allData;
allData.EMGfs = temp.EMGfs;
           allData.fs = temp.fs;
             allData.t= temp.t;
    allData.syncFrames= temp.syncFrames;
    allData.syncSignal= temp.syncSignal;
     allData.startMove= temp.startMove;
         allData.goCue= temp.goCue;
          allData.tKin= temp.tKin;
          allData.tEMG= temp.tEMG;
         allData.break= temp.break;
       allData.holdCue= temp.holdCue;
     allData.direction= temp.direction;
save('statsData.mat','allData')

allData = temp;
clear temp;

%% convert to frequency domain
%[cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(allData.data(9,:),fs,[4 200]);
%[S,t,f] = mtspecgramc(allData.data(9,:),WINDOWRANGE,params)
mkdir('FullHilbert')
hilbdata = [];
for chan=1:size(allData.data,1)
    disp(chan)
    [cfs,sigma_fs,hData]=processingHilbertTransform_filterbankGUI_onechan(allData.data(chan,:),allData.fs,[4 200]);
    hilbdata.data = zscore(abs(squeeze(hData))',0,2);
hilbdata.cfs = cfs;
hilbdata.chan=chan;
save(['FullHilbert\FullHilbert Channel ',num2str(chan),'.mat'],'hilbdata')% index: (freqband,time)
clear hilbdata
end


%% isolate Freq bands of interest

%Now that we have all the band data, we only need the stats from allData
clear all
load('statsData.mat')

freqBand = [76 200; 30 50; 18 26; 8 12; 4 8; ];% Gamma, Low Gamma, Beta, Mu, Theta
bandData.freqBand = freqBand;
bandData.data = [];
mkdir('BandData');
gammaBand = [];
for chan=1:256
    disp(chan);
    bandData.chan = chan;
    load(['FullHilbert\FullHilbert Channel ',num2str(chan),'.mat'])% index: (freqband,time)
    
    figure('position',get(0,'ScreenSize'))
    subaxis=[];
    for i=1:size(freqBand,1)
        bandData.data(i,:) = mean(hilbdata.data(find(hilbdata.cfs>freqBand(i,1) & hilbdata.cfs<freqBand(i,2)),:),1);
        
        subplot(5,1,i)
        plot(allData.t,bandData.data(i,:));
        
        a=axis;
        
        temp = std(bandData.data(i,:))*6;
        a(3) = max([min(bandData.data(i,:)) -temp]);
        a(4) = min([max(bandData.data(i,:)) temp]);
        axis(a)
        clear temp
        
        for j=1:length(allData.startMove)
            line([allData.startMove(j) allData.startMove(j)],[a(3) a(4)],'color','k') %marks start of movement
        end
        subaxis(i) = gca;
        title(['Channel ',num2str(chan),': ',num2str(freqBand(i,1)), ' - ', num2str(freqBand(i,2))]);
    end
    gammaBand(chan,:) = bandData.data(1,:);
    
    linkaxes(subaxis,'x')
    
    saveFigure(['BandData\Channel ',num2str(chan),' Bands']);
    temp=getframe(gcf);
    imwrite(temp.cdata,['BandData\Channel ',num2str(chan),' Bands.tif'],'compression','none');
    
    save(['BandData\BandData Channel ',num2str(chan),'.mat'],'bandData');% freq x time: Gamma, Low Gamma, Beta, Mu, Theta
    
    close(gcf)
    
end

save('GammaBand.mat','gammaBand')% index: (chan,time) 

%% Combine EMG's to get an EMG start of movement
%load('AllData CommonMedian DS.mat')
EMGdata  =allData.EMGdata;
EMGdata = zscore(EMGdata,0,2);
EMGdata = (sum(EMGdata.^2,1)).^.5; %then use startmove as a starting point to look for start of EMG slope, don't forget to zscore each 

for i=1:100
    EMGdata=smooth(EMGdata);
end
    
p = plot(allData.tEMG,EMGdata);
a=axis;
for i=1:length(allData.startMove)
    temp = find(allData.tEMG > allData.startMove(i),1);%index of start of move
    curMean = mean(EMGdata((temp- allData.EMGfs*5):(temp- allData.EMGfs*1)  ));
    curStd = std(EMGdata((temp- allData.EMGfs*5):(temp- allData.EMGfs*1)  ));
    allData.startMoveEMG(i) = allData.tEMG(find(EMGdata(1:(temp+ floor(allData.EMGfs*0.0))) < curMean + curStd*4,1,'last'));
    
    line([1 1]*allData.startMove(i), [a(3) a(4)],'color','k','linewidth',3)
    line([1 1]*allData.startMoveEMG(i), [a(3) a(4)],'color','r','linewidth',3)

end

 


%% parse out events of interest synced on Start of Movement from the EMG



direction = [2 4 4 1 2 1 4 1 2 3 4 2 3 3 3 3 1 1 4 1 1 3 1 4 2 4 2 3 3 2 4 2];

directionTitle = {' Left' ' Up' ' Right' ' Down'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
events = 1:32;% change values here to mod for direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trials = [];

trials.premoveTime = 10;
trials.postmoveTime = 5;
trials.fs = allData.fs;
commonLen = floor((trials.premoveTime + trials.postmoveTime) * trials.fs);
trials.commonT = linspace(-trials.premoveTime,trials.postmoveTime,commonLen);
trials.index = [];
trials.startMove = allData.startMoveEMG(events);
trials.goCue = allData.goCue(events);
trials.holdCue = allData.holdCue(events);
trials.direction = direction(events);
trials.directionTitle = directionTitle;

for i=1:length(trials.startMove)
        tStart = floor((trials.startMove(i) - trials.premoveTime) * trials.fs);
        tFinish = tStart + commonLen-1;
        if tStart < 1
            tStart = 1;
        end

        if tFinish > length(allData.t)
            tFinish = length(allData.t);
        end
    
        trials.index(i,:) = tStart:tFinish;%Segments out the data indexs;
        
end

save('trialIndex.mat','trials');

%% Syncing Trials on Hold Cue


direction = [2 4 4 1 2 1 4 1 2 3 4 2 3 3 3 3 1 1 4 1 1 3 1 4 2 4 2 3 3 2 4 2];

directionTitle = {' Left' ' Up' ' Right' ' Down'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
events = 1:32;% change values here to mod for direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trials = [];

trials.premoveTime = 5;
trials.postmoveTime = 10;
trials.fs = allData.fs;
commonLen = floor((trials.premoveTime + trials.postmoveTime) * trials.fs);
trials.commonT = linspace(-trials.premoveTime,trials.postmoveTime,commonLen);
trials.index = [];
trials.startMove = allData.startMoveEMG(events);
trials.goCue = allData.goCue(events);
trials.holdCue = allData.holdCue(events);
trials.direction = direction(events);
trials.directionTitle = directionTitle;

for i=1:length(trials.startMove)
        tStart = floor((trials.holdCue(i) - trials.premoveTime) * trials.fs);
        tFinish = tStart + commonLen-1;
        if tStart < 1
            tStart = 1;
        end

        if tFinish > length(allData.t)
            tFinish = length(allData.t);
        end
    
        trials.index(i,:) = tStart:tFinish;%Segments out the data indexs;
        
end

save('trialIndexHold.mat','trials');


%% Plotting Spectral Image of all trials and averaged trials smoothed and unsmoothed
load('trialIndex.mat')
mkdir('Spectral\FullTrial');
mkdir('Spectral\Averaged');

smoothing = 101;

for chan=1:256
    disp(chan)  

    load(['FullHilbert\FullHilbert Channel ',num2str(chan),'.mat'])% index: (freqband,time)
    
    if (mod(chan-1,16)+1) == 1
        figAS = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral Average Smoothed');
        figAU = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral Average Unsmoothed');
    end
    if (mod(chan-1,4)+1) == 1
        figTS = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral Total Smoothed');
        figTU = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral Total Unsmoothed');
    end
    
    %Full Trial plot
    x=(1:(length(trials.commonT) * size(trials.index,1))) /trials.fs;
    y = hilbdata.cfs;
    temp = trials.index';
    fullTrials = hilbdata.data(:,temp(:));
    fullTrials = zscore(fullTrials,0,2); %I don't think I need to zscore again but if I did, I'd do it here
    clear temp
    
    figure(figTU)
    
    subplot(4,1,mod(chan-1,4)+1);
    imagesc(x,y,fullTrials)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');

    a=axis;
    for i=1:length(trials.startMove)
        trialstart = length(trials.commonT) * (i-1)/trials.fs + trials.premoveTime;
        line([trialstart trialstart],a(3:4),'color','k','linewidth',3)%start of movement
        temp = (trials.goCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','g','linewidth',2)%Go Cue
        temp = (trials.holdCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','w','linewidth',2)%Target Presented
    end
    
    for i=1:size(fullTrials,1)
        fullTrialsS(i,:) = smooth(fullTrials(i,:),smoothing);%across Time use 1000 for hilbert, 100 for chronix
    end
    x = x+smoothing/(2*trials.fs); %Sliding adjustment to account for averaging
    
    for i=1:size(fullTrials,2)
        fullTrialsS(:,i) = smooth(fullTrialsS(:,i),5);%Across Frequency
    end
    figure(figTS)
    
    subplot(4,1,mod(chan-1,4)+1);
    imagesc(x,y,fullTrialsS)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');
    
    clear fullTrialsS
    
    a=axis;
    for i=1:length(trials.startMove)
        trialstart = length(trials.commonT) * (i-1)/trials.fs + trials.premoveTime;
        line([trialstart trialstart],a(3:4),'color','k','linewidth',3)%start of movement
        temp = (trials.goCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','g','linewidth',2)%Go Cue
        temp = (trials.holdCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','w','linewidth',2)%Target Presented
    end

    
    %Calculating Average Trial
    averageTrial = zeros(size(hilbdata.data,1), length(trials.commonT));
    for i=1:length(trials.startMove)
        averageTrial = averageTrial + fullTrials(:,(1+length(trials.commonT)*(i-1)):(length(trials.commonT) *i));
    end
    averageTrial = averageTrial / length(trials.startMove);
    
    x= trials.commonT;
    
    figure(figAU)
    subplot(4,4,mod(chan-1,16)+1);
    imagesc(x,y,averageTrial)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');
    
    a=axis;
    line([0 0],a(3:4),'color','k','linewidth',2)%start of movement
    lineBoxPlot(allData.goCue - allData.startMove,a(4)-3,'COLOR','g');  
    lineBoxPlot(allData.holdCue - allData.startMove,a(4)-3,'COLOR','w');

    %shift to remove temporal smoothing artifacts from data so premovement
    %activity is genuine
    
    for i=1:size(averageTrial,1)
        averageTrial(i,:) = smooth(averageTrial(i,:),smoothing);%across Time use 1000 for hilbert, 100 for chronix
    end
    
    x = x+smoothing/(2*trials.fs); %Sliding adjustment to account for averaging
    
    
    for i=1:size(averageTrial,2)
        averageTrial(:,i) = smooth(averageTrial(:,i),5);%Across Frequency
    end
    
    
    figure(figAS)
    subplot(4,4,mod(chan-1,16)+1);
    imagesc(x,y,averageTrial)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');
    
    a=axis;
    line([0 0],a(3:4),'color','k','linewidth',2)%start of movement
    lineBoxPlot(allData.goCue - allData.startMove,a(4)-3,'COLOR','g');  
    lineBoxPlot(allData.holdCue - allData.startMove,a(4)-3,'COLOR','w');

    %Saving plots if at the end of the figure

    %Saving total plots
    if chan/4 == floor(chan/4) %If at the end of the figure, save it
        
        figure(figTU)
        temp=getframe(figTU);
        saveFigure(['Spectral\FullTrial\Spectral Total Channels ',num2str(chan - 3),'-',num2str(chan),' Unsmoothed.fig']);
        imwrite(temp.cdata,['Spectral\FullTrial\Spectral Total Channels ',num2str(chan - 3),'-',num2str(chan),' Unsmoothed.tif'],'compression','none');
        close(figTU)
        
        figure(figTS)
        temp=getframe(figTS);
        saveFigure(['Spectral\FullTrial\Spectral Total Channels ',num2str(chan - 3),'-',num2str(chan),' Smoothed.fig']);
        imwrite(temp.cdata,['Spectral\FullTrial\Spectral Total Channels ',num2str(chan - 3),'-',num2str(chan),' Smoothed.tif'],'compression','none');
        close(figTS)
    end
    
    %Saving total plots
    if chan/16 == floor(chan/16) %If at the end of the figure, save it
        
        figure(figAU)
        temp=getframe(figAU);
        saveFigure(['Spectral\Averaged\Spectral Average Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.fig']);
        imwrite(temp.cdata,['Spectral\Averaged\Spectral Average Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.tif'],'compression','none');
        close(figAU)
        
        figure(figAS)
        temp=getframe(figAS);
        saveFigure(['Spectral\Averaged\Spectral Average Channels ',num2str(chan - 15),'-',num2str(chan),' Smoothed.fig']);
        imwrite(temp.cdata,['Spectral\Averaged\Spectral Average Channels ',num2str(chan - 15),'-',num2str(chan),' Smoothed.tif'],'compression','none');
        close(figAS)
    end
    
end

%% Syncing on Hold Period 
load('trialIndexHold.mat')

mkdir('Spectral\HoldPeriod');

smoothing = 201;

for chan=1:256
    disp(chan)  

    load(['FullHilbert\FullHilbert Channel ',num2str(chan),'.mat'])% index: (freqband,time)
    
    if (mod(chan-1,16)+1) == 1
        figAS = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral HoldPeriod Smoothed');
        figAU = figure('position',get(0,'ScreenSize'),'color','w','name','Spectral HoldPeriod Unsmoothed');
    end
    
    %Full Trial plot
    y = hilbdata.cfs;
    temp = trials.index';
    fullTrials = hilbdata.data(:,temp(:));
    fullTrials = zscore(fullTrials,0,2); %I don't think I need to zscore again but if I did, I'd do it here
    clear temp
    
    %Calculating Average Trial
    averageTrial = zeros(size(hilbdata.data,1), length(trials.commonT));
    for i=1:length(trials.holdCue)
        averageTrial = averageTrial + fullTrials(:,(1+length(trials.commonT)*(i-1)):(length(trials.commonT) *i));
    end
    averageTrial = averageTrial / length(trials.startMove);
    
    x= trials.commonT;
    
    figure(figAU)
    subplot(4,4,mod(chan-1,16)+1);
    imagesc(x,y,averageTrial)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');
    
    a=axis;
    line([0 0],a(3:4),'color','k','linewidth',2)%start of movement
    lineBoxPlot(allData.goCue - allData.holdCue,a(4)-3,'COLOR','g');  
    lineBoxPlot(allData.startMove - allData.holdCue,a(4)-3,'COLOR','w');

    %shift to remove temporal smoothing artifacts from data so premovement
    %activity is genuine
    
    for i=1:size(averageTrial,1)
        averageTrial(i,:) = smooth(averageTrial(i,:),smoothing);%across Time use 1000 for hilbert, 100 for chronix
    end
    
    x = x+smoothing/(2*trials.fs); %Sliding adjustment to account for averaging
    
    
    for i=1:size(averageTrial,2)
        averageTrial(:,i) = smooth(averageTrial(:,i),5);%Across Frequency
    end
    
    
    figure(figAS)
    subplot(4,4,mod(chan-1,16)+1);
    imagesc(x,y,averageTrial)
    set(gca,'YDir','norm')
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)');
    
    a=axis;
    line([0 0],a(3:4),'color','k','linewidth',2)%start of movement
    lineBoxPlot(allData.goCue - allData.holdCue,a(4)-3,'COLOR','g');  
    lineBoxPlot(allData.startMove - allData.holdCue,a(4)-3,'COLOR','w');

    %Saving plots if at the end of the figure


    %Saving total plots
    if chan/16 == floor(chan/16) %If at the end of the figure, save it
        
        figure(figAU)
        temp=getframe(figAU);
        saveFigure(['Spectral\HoldPeriod\Spectral HoldPeriod Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.fig']);
        imwrite(temp.cdata,['Spectral\HoldPeriod\Spectral HoldPeriod Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.tif'],'compression','none');
        close(figAU)
        
        figure(figAS)
        temp=getframe(figAS);
        saveFigure(['Spectral\HoldPeriod\Spectral HoldPeriod Channels ',num2str(chan - 15),'-',num2str(chan),' Smoothed.fig']);
        imwrite(temp.cdata,['Spectral\HoldPeriod\Spectral HoldPeriod Channels ',num2str(chan - 15),'-',num2str(chan),' Smoothed.tif'],'compression','none');
        close(figAS)
    end
    
end

%% Power Line Plots for the Start of Movement with tests for significance.
%Plots just the gamma power line and performs a T test  
load('trialIndex.mat')
load('GammaBand.mat')
mkdir('PowerLine\StartMove');
mkdir('PowerLine\FullTrial');

for chan=1:256
    disp(chan)  

    
    if (mod(chan-1,16)+1) == 1
        figAU = figure('position',get(0,'ScreenSize'),'color','w','name','Powerline Average StartMove');
    end
    if (mod(chan-1,4)+1) == 1
        figTU = figure('position',get(0,'ScreenSize'),'color','w','name','Powerline Total');
    end
    
    %Full Trial plot
    x=(1:(length(trials.commonT) * size(trials.index,1))) /trials.fs;
    
    temp = trials.index';
    fullTrials = gammaBand(chan,temp(:));
    fullTrials = zscore(fullTrials); %I don't think I need to zscore again but if I did, I'd do it here
    clear temp
    
    figure(figTU)
    
    subplot(4,1,mod(chan-1,4)+1);
    plot(x,fullTrials)
    title(['Channel ',num2str(chan)])
    xlabel('Time (s)')
    ylabel('Gamma Intensity');

    a=axis;
    for i=1:length(trials.startMove)
        trialstart = length(trials.commonT) * (i-1)/trials.fs + trials.premoveTime;
        line([trialstart trialstart],a(3:4),'color','k','linewidth',3)%start of movement
        temp = (trials.goCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','g','linewidth',2)%Go Cue
        temp = (trials.holdCue(i) - trials.startMove(i)) + trialstart;
        line([temp temp],a(3:4),'color','r','linewidth',2)%Target Presented
    end
    
    
    %Calculating Average Trial
    averageTrial = zeros(1, length(trials.commonT));
    for i=1:length(trials.startMove)
        averageTrial = averageTrial + fullTrials((1+length(trials.commonT)*(i-1)):(length(trials.commonT) *i));
    end
    averageTrial = averageTrial / length(trials.startMove);
    
    x= trials.commonT;
    
    temp = find(x>-1,1);
    
    threshold = mean(averageTrial(1:temp))+std(averageTrial(1:temp))*6;
    
    temp = find(averageTrial>threshold,1);
    if isempty(temp)
        trials.activity(chan) = nan;
    else
        trials.activity(chan) = x(find(averageTrial>threshold,1));
    end
    
    
    figure(figAU)
    subplot(4,4,mod(chan-1,16)+1);
    plot(x,averageTrial)
    if isnan(trials.activity(chan))
        title(['Channel ',num2str(chan)])
    else
        title(['Channel ',num2str(chan),'  ',num2str(trials.activity(chan),'%3.3f'),'s'])
    end
    xlabel('Time (s)')
    ylabel('Gamma Intensity');
    
    a=axis;
    line([0 0],a(3:4),'color','k','linewidth',2)%start of movement
    lineBoxPlot(allData.goCue - allData.startMove,a(4)-.1*(a(4)-a(3)),'COLOR','g');  
    lineBoxPlot(allData.holdCue - allData.startMove,a(4)-.1*(a(4)-a(3)),'COLOR','r');

    %shift to remove temporal smoothing artifacts from data so premovement
    %activity is genuine
    
    %Saving plots if at the end of the figure

    %Saving total plots
    if chan/4 == floor(chan/4) %If at the end of the figure, save it
        
        figure(figTU)
        temp=getframe(figTU);
        saveFigure(['PowerLine\FullTrial\Powerline Total Channels ',num2str(chan - 3),'-',num2str(chan),' Unsmoothed.fig']);
        imwrite(temp.cdata,['PowerLine\FullTrial\Powerline Total Channels ',num2str(chan - 3),'-',num2str(chan),' Unsmoothed.tif'],'compression','none');
        close(figTU)
     end
    
    %Saving total plots
    if chan/16 == floor(chan/16) %If at the end of the figure, save it
        
        figure(figAU)
        temp=getframe(figAU);
        saveFigure(['PowerLine\StartMove\Powerline Average StartMove Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.fig']);
        imwrite(temp.cdata,['PowerLine\StartMove\Powerline Average StartMove Channels ',num2str(chan - 15),'-',num2str(chan),' Unsmoothed.tif'],'compression','none');
        close(figAU)
    end
    
end

save('trialIndex.mat','trials');


%%
%Start here, finish writing script to plot:
%1) average trials of all freqency smoothed with boxwhisker
%2) string of trials trials gammaband with events marked
%3) average trials gamma band with boxwhisker
%4) directional?




%% Compare Freq bands to Muscle Synergies


