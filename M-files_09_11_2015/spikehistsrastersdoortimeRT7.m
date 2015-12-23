close all

clear rastertics data_lfp data_lfp1 temp_strobe data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta binned bin_rate bin_rate2 hold val data_filt1 label data_hil data_hil_corr data_hil_incorr data_lfpfilt_corr;
clear data_lfpfilt_incorr data_hil data_hil1 waves_corr waves_incorr waves_range2
trials_NO=length(Reach);
y_max=0;
%time for LFPs, rasters, PETHs
block_len=1220;
before_zero=8136; % looking 1.2 sec before and after grab time at 1017 samples/sec
figure;
chan_no=1;
sortcode=1; %use 1 for MU activity, and subsequently 2/3/4 depending on sorted unit yield per channel
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];

% Filter for Chewing Vs Non-Chewing trials (High pass)
FILTER_ORDER_t=4;
END_SMOOTHING_t=100;
srate_t = Fs_lfp;
nyq_sample_t=srate_t/2;
f_lo_t=300;
f_hi_t=100;
[bt,at]=butter(FILTER_ORDER_t,f_hi_t/nyq_sample_t,'high');
%[dt,ct]=butter(FILTER_ORDER_t,10/nyq_sample,'high');
hil_hi=25;
hil_lo=10;

%Filter for LFPs with beta band

FILTER_ORDER=4;
END_SMOOTHING=100;
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=10;
f_hi=20;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
%[d,c]=butter(FILTER_ORDER,10/nyq_sample,'high');


lfp_chan=chan_no;
% time window for chewing (has to be longer)
time_before=1000;
time_after=6000;
bin_rate=[];
bin_rate2=[];
data_hil_corr=[];
data_hil_incorr=[];
data_lfpfilt_corr=[];
data_lfpfilt_incorr=[];
waves_corr=[];
waves_incorr=[];


for chan_no=[chan_no]
    for n=1:trials_NO
        temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len); % plotting waves 1.2 s before and after with door and grasp signal
        
        
        disp(n)
        figure(1)% figure for chewing classifier
        subplot(4,1,1);
        plot(strobe(1,(Reach(n)-time_before):(Reach(n)+time_after)))
        hold on
        
        subplot('Position',[0.13 0.3 0.77 0.45])
        hold on;
        temp=data(lfp_chan,round((Reach(n)-time_before):(Reach(n)+time_after)));
        temp=(temp-mean(temp))/std(temp);
        data_filt1=(abs(filter(bt,at,temp))).^2;
        %data_filt1=smooth(data_filt1,END_SMOOTHING);
        data_filt1=conv(data_filt1,ones(50,1))/50;
        %data_filt1=(data_filt1-mean(data_filt1))/(10*std(data_filt1));
        
        plot(data_filt1/0.5+n)
        %ylim ([0 0.5])
        tL=data_filt1;
        tL=tL-mean(tL);
        tL=tL(2000:7000);
        
        subplot(4,1,4)
        Fs = Fs_lfp;                    % Sampling frequency
        T = 1/Fs;                     % Sample time
        L = 5000;                     % Length of signal
        t = (0:L-1)*T;                % Time vector
        
        
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(tL,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        %subplot(2,1,2)
        % Plot single-sided amplitude spectrum.
        
        sm_power=conv(2*abs(Y(1:NFFT/2+1)),ones(10,1));
        plot(f(1:200),sm_power(1:200))
        hold on;
        hold_val(n)=mean(sm_power(36:44));
        plot(2.5,mean(sm_power(35:45)),'rx');
        %plot(f,2*abs(Y(1:NFFT/2+1)))
        title('Single-Sided Amplitude Spectrum of y(t) --> 2,5, 100 Hz signals')
        xlabel('Frequency (Hz)')
    end
end
label=kmeans(hold_val,2,'Distance','sqEuclidean','Replicates',10),'Matrix',[min(hold_val) max(hold_val)];
corr=find(label==2);
incorr=find(label==1);
hold on
plot(3,hold_val(incorr),'k+');
plot(3,hold_val(corr),'r+')
for chan_no= [chan_no]
    for n=1:trials_NO
        range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len]); % range of lfp for same time window as above
        data_lfp1(n,:)=data(chan_no,range_lfp); % lfp data unfiltered
        data_hil1(n,:)=abs(hilbert2(data_lfp1(n,:),1017,hil_lo,hil_hi));
        data_lfp(n,:)=(data_lfp1(n,:)-mean(data_lfp1(n,:)))/(2*std(data_lfp1(n,:)));
        data_hil(n,:)=(data_hil1(n,:)-mean(data_hil1(n,:)))/(2*std(data_hil1(n,:)));
        data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
        t=[Reach(n)-before_zero:Reach(n)+block_len]/Fs_wave;
        disp(t-t(1));
        tstamps=TimeStamps{chan_no,sortcode};
        t2=find(tstamps>t(1));
        t3=find(tstamps>t(end));
        
%         waves=Waves{chan_no,sortcode};
        
        if ~isempty(t2) && ~isempty(t3)
            range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
            ts_range2=tstamps(range2);
            ts_range4{n}=[ts_range2-t(1)];
            bin_vector = [(t(1):0.05:t(end))-t(1)];
            
%             waves_range2{n}=waves(:,range2);
            
            %bin_rate = zeros (length (bin_vector),trials_NO);
            % spikes = Trial_spike_times {trials_NO,spike_no};
            if ~isempty (ts_range4{n})
                if length(ts_range4{n}) == 1
                    binned = histc(ts_range4{n},bin_vector);
                else
                    binned = histc(ts_range4{n},bin_vector)';
                end
               
               
                if ismember(n,corr)
                    bin_rate =[bin_rate binned];
                    data_hil_corr=[data_hil_corr;data_hil];
                    data_lfpfilt_corr=[data_lfpfilt_corr; data_lfpfilt];
%                     waves_corr=[waves_corr waves_range2];
                else
                    bin_rate2 =[bin_rate2 binned];
                    data_hil_incorr=[data_hil_incorr;data_hil];
                    data_lfpfilt_incorr=[data_lfpfilt_incorr; data_lfpfilt];
%                     waves_incorr=[waves_incorr waves_range2];
                end
                end
        end
        
        if ~isempty(t2) && ~isempty(t3)
            range3=[t2(1):(t3(1)-1)];
            ts_range3=tstamps(range3);
            ts_norm=ts_range3-t(1);
            disp([chan_no length(find(tstamps(range3)>0))])
            rastertics{n}=[ts_norm];%; tstamps(range3)];
            doorind(:,:,n)=Reward(n)/Fs_wave- t(1);
        end
        
        
    end
end
mean_temp_strobe=mean(temp_strobe,3);
mean_data_hil_corr=mean(data_hil_corr,1);
mean_data_hil_incorr=mean(data_hil_incorr,1);
mean_data_lfpfilt_corr=mean(data_lfpfilt_corr,1);
mean_data_lfpfilt_incorr=mean(data_lfpfilt_incorr,1);



PEH_rate = sum(bin_rate,2)/length(corr)/0.05; % average firing rate for the the rate corr
PEH_rate2 = sum(bin_rate2,2)/length(incorr)/0.05; % average firing rate for the the rate incorr

if max(PEH_rate)>max(PEH_rate2) & y_max < max(PEH_rate)  % finds the maximum rate for all targets
    y_max = max(PEH_rate);
else    y_max = max(PEH_rate2) ;
end
% maxLength=max(cellfun(@(x)numel(x),ts_range4));
% times=cell2mat(cellfun(@(x)cat(2,x,NaN(1,maxLength-length(x))),ts_range4,'UniformOutput',false));
% times2=times(:,(isfinite(times(1,:))));
% end

% for n7=1:trials_NO
%     disp(n7)
%     %axi=subplot(5,1,2);
%     figure(2);
%     %axi=subplot('Position',[0.13 0.45 0.77 0.35])
%
%     plot(data_lfpfilt(:,:,n7)+(n7-1));XLim([0 max_ax]); Ylim([-1 trials_NO+1]);set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
%     hold on
% end

% figure (2)
% for n=1:length(Reach)
%     %subplot('Position',[0.13 0.3 0.77 0.45])
% %     hold on;
% %     range_lfp2=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
% %     temp=data(lfp_chan,round(range_lfp2));
% %     temp=(temp-mean(temp))/std(temp);
% %     data_filt1=(abs(filter(b,a,temp))).^2;
% %     data_filt1=conv(data_filt1,ones(50,1))/50;
% %     data_hil=abs(hilbert2(data,1017,hil_lo,hil_hi));
% 
%     subplot(1,2,2);
%     if ismember(n,corr)
%         plot(data_hil(n,:),'r');
%     else
%         plot(data_hil(n,:),'k');
%     end
%     hold on;
% end
%figure(2)
% for n=1:length(Reach)
%     %subplot('Position',[0.13 0.3 0.77 0.45])
% %     hold on;
% %     range_lfp2=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
% %     temp=data(lfp_chan,round(range_lfp2));
% %     temp=(temp-mean(temp))/std(temp);
% %     data_filt1=(abs(filter(b,a,temp))).^2;
% %     data_filt1=conv(data_filt1,ones(50,1))/50;
% %     data_hil=abs(hilbert2(data,1017,hil_lo,hil_hi));
%     figure(n+4)
%     if ismember(n,corr)
%         plot(data_lfpfilt(n,:),'r'); hold on; plot(data_hil1(n,:));hold off
%     else
%         plot(data_lfpfilt(n,:),'k'); hold on; plot(data_hil1(n,:));hold off
%     end
%     hold on;
% 
% end
ylim([0 trials_NO+1])

title(length(corr)/trials_NO)

figure(3)

max_ax=length(mean_temp_strobe);
f=max_ax/6;
axh=subplot(4,1,1);
plot(mean_temp_strobe,'c'); XLim([0 max_ax]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold on;
a=axis;
line([before_zero before_zero],a(3:4),'Color','g')
hold off
title('Centered to Reach-end')

ax3=subplot(4,1,2)
plot(smooth(mean_data_hil_corr,10),'r-')
hold on;
plot(smooth(mean_data_hil_incorr,10),'k-');XLim([0 max_ax]); set(ax3, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold off;
ax4=subplot(4,1,3)
hold on;
%     ts_max=max(mean_ts)+1
%     bar(mean_ts);axis([0 48 0 ts_max]);set(gca,'XTick',[0 8 16 24 32 40 48]); set(ax4, 'XGrid', 'on');set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
% ax4 = psth(times2, 50, Fs_SPK, trials_NO, 58594,ax4)
max_trials=trials_NO
plot ([(t(1):0.050:t(end))-t(1)],1*PEH_rate/y_max,'r','LineWidth',2);XLim([0 9.4]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold on;
plot ([(t(1):0.050:t(end))-t(1)],1*PEH_rate2/y_max,'k','LineWidth',2);XLim([0 9.4]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold off;


for n4=1:trials_NO-1
    [doordelta,ind]=sort(doorind,3);
    rastertics2{n4}=rastertics{ind(n4)};
    rastertics3{n4}=[rastertics2{n4};rastertics2{n4}];
    subplot(4,1,4)
    if ismember(n4,corr)
        plot(rastertics3{n4},[0 1]+n4,'r','LineWidth',2);plot(doordelta(n4),[0 1]+n4,'gx');XLim([0 9.4]);YLim([0 max_trials]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    else
        plot(rastertics3{n4},[0 1]+n4,'k','LineWidth',2);plot(doordelta(n4),[0 1]+n4,'gx');XLim([0 9.4]);YLim([0 max_trials]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    end
    hold on
end
XLabel('time (sec)')
% figure(4)
% subplot(2,1,1)
% plot(cell2mat(waves_corr),'r-'); hold on; 
% subplot(2,1,2)
% plot(cell2mat(waves_incorr),'k-')
% %saveas(gcf,'Mat_files/Result_figs/Block317_Chan6_SC2','pdf')



