%function [output]=spike_entrainment(chan_no,sortcode, start1,cycle_duration,cycles,data, Fs_lfp,TimeStamps, Waves)
clear bin_rate data_hilf data_lfpfiltf wavesf data_hil data_hil1 data_lfp data_lfp1 data_lfpfilt waves tstamps 
Fs_wave=Fs_lfp;
start1=start(1);
chan_no=1;
sortcode=1;
cycle_duration=125;
cycles=50;

%time for 8Hz and 1.7Hz
length_before=cycle_duration;
length_after=cycle_duration;


bin_rate=[];
data_hilf=[];
data_lfpfiltf=[];
wavesf=[];
hil_hi=25;
hil_lo=10;
  FILTER_ORDER=4;
    END_SMOOTHING=100;
    srate = Fs_lfp;
    nyq_sample=srate/2;
f_lo=10;
    f_hi=20;
    [b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);



for n=0:cycles
    range1=round(((start1+(n*125))+(length_before/2))-(length_before):((start1+(n*125))+(length_after/2))+(length_after)); % range of lfp for same time window as above
    data_lfp1=data(chan_no,range1)'; % lfp data unfiltered
    data_hil1=abs(hilbert2([data_lfp1]',1017,hil_lo,hil_hi));
    data_lfp=(data_lfp1-mean(data_lfp1))/(2*std(data_lfp1));
    data_hil(:,:,n+1)=(data_hil1-mean(data_hil1))/(2*std(data_hil1));
    data_lfpfilt(:,:,n+1)=filter(b,a,data_lfp);
    t=(((start1+(n*125))+(length_before/2))-(length_before):((start1+(n*125))+(length_after/2))+(length_after))/Fs_wave;
    disp(t-t(1));
    tstamps=TimeStamps{chan_no,sortcode};
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    
    waves=Waves{chan_no,sortcode};
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
        ts_range2=tstamps(range2);
        ts_range4{n}=[ts_range2-t(1)];
        bin_vector = [(t(1):0.01:t(end))-t(1)];
        rastertics{n}=[ts_range4{n}];
        waves_range2{n}=waves(:,range2);
        
        if ~isempty (ts_range4{n})
            if length(ts_range4{n}) == 1
                binned = histc(ts_range4{n},bin_vector);
            else
                binned = histc(ts_range4{n},bin_vector)';
            end
            bin_rate =[bin_rate binned];
            data_hilf=[data_hilf; data_hil(:,:,n)];
            data_lfpfiltf=[data_lfpfiltf; data_lfpfilt(:,:,n)];
            wavesf=[wavesf waves_range2{n}];
        end
        
    end
end
    
    mean_data_hilf=mean(data_hilf);
    
    mean_data_lfpfiltf=mean(data_lfpfiltf);
    PEH_rate = smooth((sum(bin_rate,2)/(cycles-1)/0.01),3); % average firing rate for the the rate corr
    
    y_max=max(PEH_rate);
%     bin_vector2=((start1+(0*125))+(length_before/2))-(length_before):((start1+(0*125))+(length_after/2))+(length_after);
%     bin_vector3=[bin_vector2(1):0.01:bin_vector2(end)-bin_vector2(1))];
    max_ax2=length(bin_vector)/20;
    f2=cycle_duration/4;
    output=PEH_rate;
    
    plot ([(t(1):0.01:t(end))-t(1)],1*PEH_rate/y_max,'r','LineWidth',3);XLim([0 max_ax2]);YLim([0 1]);set(gca,'XTick',[0 f2 f2*2 f2*3 f2*4]);set(gca,'XTickLabel',{'0','90','180','270', '360'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(gcf,'XGrid', 'on');set(gcf,'YGrid', 'on');
    
    
    
    
    