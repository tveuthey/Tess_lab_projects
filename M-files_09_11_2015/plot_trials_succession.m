function [Output]=plot_trials_succession(TimeStamps, chan_no,data,wave,Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

times=5*Fs_lfp;

FILTER_ORDER=4;
END_SMOOTHING=100;
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=1;
f_hi=20;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
for n=13
    data_lfp(n,:)=(data(n,:)-mean(data(n,:)))/(2*std(data(n,:)));
    data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
end

for i=1:600
    %     close all;
    figure; hold on;
    range=(1:times)+(10000*(i-1));
    range_n=round(range/Fs_lfp);
    for n=1
        subplot(3,1,1);
        plot(data(n+(2*(n-1)),range)+(1000*n));xlim([0 times]); hold on;
        subplot(3,1,2);
        plot(data_lfpfilt(n+(2*(n-1)),range)+(1000*n));xlim([0 times]); hold on;
    end
    for n=1:length(chan_no)
        tstamps1=TimeStamps{chan_no(n),sc};
        t2=find(tstamps1>range_n(1));
        t3=find(tstamps1>range_n(end));
        if ~isempty(t2) && ~isempty(t3)
            range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
            ts_range2=tstamps1(range2);
            tstamps{n}=ts_range2;
            rastertics{n}=[tstamps{n}; tstamps{n}];
        end
    end
    
    for n=1:length(chan_no)
        
        subplot(3,1,3);
        if isempty(tstamps{n})==1
            disp('not plotting this channels raster')
        else
            c=colormap;
            plot(rastertics{n},[0 1]+n,'Color',c(n+(3*(n-1)),:));ylim([0 17])
        end
        hold on;
    end
    pause
end

Output=times;

