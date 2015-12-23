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


%%
% for n=0:cycles
%     range1=round(((start1+(n*125))+(length_before/2))-(length_before):((start1+(n*125))+(length_after/2))+(length_after)); % range of lfp for same time window as above
%     data_lfp1=data(chan_no,range1)'; % lfp data unfiltered
%     data_hil1=abs(hilbert2([data_lfp1]',1017,hil_lo,hil_hi));
%     data_lfp=(data_lfp1-mean(data_lfp1))/(2*std(data_lfp1));
%     data_hil(:,:,n+1)=(data_hil1-mean(data_hil1))/(2*std(data_hil1));
%     data_lfpfilt(:,:,n+1)=filter(b,a,data_lfp);
%     t=(((start1+(n*125))+(length_before/2))-(length_before):((start1+(n*125))+(length_after/2))+(length_after))/Fs_wave;
%     disp(t-t(1));
clear first_stamp first_stamp_epochs time_points hold_index_neural time_center ratertics rastertics3 ts_range2 range1  t tstamps t2 t3 ts_range4
first_stamp=TimeStamps{4,3};
first_stamp_epochs=diff(first_stamp);
time_points=find(first_stamp_epochs>(0.1));
hold_index_neural=[];
for n=1:length(time_points)
    hold_index_neural=[hold_index_neural (first_stamp(time_points(n)))];
end
plot((hold_index_neural),[1],'kx')
time_center=hold_index_neural(2:end-1);


%%
for n=1:length(time_center)
    range1=round(time_center(n)-(Fs_lfp*2):time_center(n)-(Fs_lfp*2));
    t=range1/Fs_lfp;
    for chan_no=[4 7 14 21]
        tstamps=TimeStamps{chan_no,3};
        t2=find(tstamps>t(1));
        t3=find(tstamps>t(end));
        if ~isempty(t2) && ~isempty(t3)
            range2=[t2(1):(t3(1)-1)];
            ts_range2=tstamps(range2);
            ts_range4{chan_no}=[ts_range2-t(1)];
            rastertics{chan_no}=[ts_range4{n,chan_no}];
            
            rastertics3{chan_no}=[rastertics{chan_no};rastertics{chan_no}];
            
        end
    end
end


%%
for n=1:length(time_center)-70
    figure(n)
    for chan_no=[4 7 14 21]
        plot(rastertics3{chan_no},[0 1]+chan_no,'k','LineWidth',2);%plot(doordelta(chan_no),[0 1]+lcorr,'gx');XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
        hold on
    end
end



