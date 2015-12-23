close all

clear rastertics data_lfp temp_strobe data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta binned bin_rate hold val data_filt1 label data_hil;
trials_NO=length(Reach);
y_max=0;
block_len=2441;
before_zero=1220; % looking 1.2 sec before and after grab time at 1017 samples/sec
figure;
chan_no=27;
sortcode=2; %use 1 for MU activity, and subsequently 2/3/4 depending on sorted unit yield per channel
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];

FILTER_ORDER_t=4;
END_SMOOTHING_t=100;

srate_t = Fs_lfp;
nyq_sample_t=srate_t/2;
f_lo_t=300;
f_hi_t=100;
[bt,at]=butter(FILTER_ORDER_t,f_hi_t/nyq_sample_t,'high');
%[dt,ct]=butter(FILTER_ORDER_t,10/nyq_sample,'high');
hil_hi=25
hil_lo=10


lfp_chan=chan_no;
time_before=1000;
time_after=6000;
bin_rate=[];
bin_rate2=[];


for chan_no=[chan_no]
    for n=1:trials_NO
        temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero); % plotting waves 1.2 s before and after with door and grasp signal
        range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]); % range of lfp for same time window as above
        data_lfp=data(chan_no,range_lfp); % lfp data unfiltered
        data_hil(:,:,n)=abs(hilbert2(data_lfp,1017,hil_lo,hil_hi));
        
        %mean_data_lfp(chan_no,:)=mean(data_lfp,2)
        
        % filter parameters
        %     nf=Fs_lfp/2;
        %     f_lo=100;
        %     f_hi=253;
        %     [b,a]=butter(6,[f_lo/nf,f_hi/nf]);
        
        %newfilter
        FILTER_ORDER=4;
        END_SMOOTHING=100;
        
        srate = Fs_lfp;
        nyq_sample=srate/2;
        f_lo=10;
        f_hi=20;
        [b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
        %[d,c]=butter(FILTER_ORDER,10/nyq_sample,'high');
        data_lfp=data_lfp./(2*std(data_lfp));
        
        data_lfpfilt(:,:,n)=filter(b,a,data_lfp);
        %data_lfpfilt(:,:,n)=smooth(abs(data_lfpfilt));
        %old filter GiszterLab
        %         data_lfpfilt2(n,:)=RMSMovAvg(data(chan_no,range_lfp),80,8);
        %         data_lfpfilt2(n,:)=inv(diag(std(data_lfpfilt2(n,:),[],2)))*data_lfpfilt2(n,:);
        
        disp(n)
        figure(3)
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
        
        t=[Reach(n)-before_zero:Reach(n)+block_len-before_zero]/Fs_wave;
        disp(t-t(1));
        
        tstamps=TimeStamps{chan_no,sortcode};
        t2=find(tstamps>t(1));
        t3=find(tstamps>t(end));
        
        if ~isempty(t2) && ~isempty(t3)
            range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
            ts_range2=tstamps(range2);
            ts_range4{n}=[ts_range2-t(1)];
            bin_vector = [(t(1):0.05:t(end))-t(1)];
            %bin_rate = zeros (length (bin_vector),trials_NO);
            % spikes = Trial_spike_times {trials_NO,spike_no};
            if ~isempty (ts_range4{n})
                if length(ts_range4{n}) == 1
                    binned = histc(ts_range4{n},bin_vector);
                else
                    binned = histc(ts_range4{n},bin_vector)';
                end
                if ismember(n,corr)
                    bin_rate =[bin_rate binned]
                    data_hil_corr(:,:,n)=data_hil(:,:,n);
                else
                    bin_rate2 =[bin_rate2 binned]
                    data_hil_incorr(:,:,n)=data_hil(:,:,n);
                end
            end
            
        end
        
        %     ph = psth(times, binsize, fs, ntrials, triallen, varargin)
        %pause
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
mean_data_lfp=mean(data_lfp,3);
mean_data_hil_corr=mean(data_hil_corr,3);
mean_data_hil_incorr=mean(data_hil_incorr,3);

%mean_data_lfpfilt=mean(data_lfpfilt,3);
%mean_data_lfpfilt2=mean(data_lfpfilt2,1);

label=kmeans(hold_val,2,'Distance','sqEuclidean','Replicates',10),'Matrix',[min(hold_val) max(hold_val)];
corr=find(label==2);
incorr=find(label==1);
hold on
plot(3,hold_val(incorr),'k+');
plot(3,hold_val(corr),'r+')


PEH_rate = sum(bin_rate,2)/length(corr)/0.05; % average firing rate for the the rate

PEH_rate2 = sum(bin_rate2,2)/length(incorr)/0.05; % average firing rate for the the rate

if max(PEH_rate)>max(PEH_rate2) && y_max < max(PEH_rate )  % finds the maximum rate for all targets
    y_max = max(PEH_rate );
elseif y_max < max(PEH_rate2)
    y_max = max(PEH_rate2 );
end
% maxLength=max(cellfun(@(x)numel(x),ts_range4));
% times=cell2mat(cellfun(@(x)cat(2,x,NaN(1,maxLength-length(x))),ts_range4,'UniformOutput',false));
% times2=times(:,(isfinite(times(1,:))));
% end
figure(1)
max_ax=length(mean_temp_strobe);
f=max_ax/6;
axh=subplot(5,1,1);
plot(mean_temp_strobe,'c'); XLim([0 max_ax]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold on;
a=axis;
line([before_zero before_zero],a(3:4),'Color','g')
hold off
title('Centered to Reach-end')
for n7=1:trials_NO
    disp(n7)
    %axi=subplot(5,1,2);
    figure(2);
    %axi=subplot('Position',[0.13 0.45 0.77 0.35])
    
    plot(data_lfpfilt(:,:,n7)+(n7-1));XLim([0 max_ax]); Ylim([-1 trials_NO+1]);set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
    hold on
end

figure
for n=1:length(Reach)
    %subplot('Position',[0.13 0.3 0.77 0.45])
    hold on;
    range_lfp2=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    temp=data(lfp_chan,round(range_lfp2));
    temp=(temp-mean(temp))/std(temp);
    data_filt1=(abs(filter(bt,at,temp))).^2;
    data_filt1=conv(data_filt1,ones(50,1))/50;
    
    if ismember(n,corr)
        plot(data_filt1/0.5+n,'r')
    else
        plot(data_filt1/0.5+n,'k')
    end
end
ylim([0 trials_NO+1])

title(length(corr)/trials_NO)
figure(1)
% axi_a=min(mean_data_lfp(:,:));
% axi_b=max(mean_data_lfp(:,:));
% plot(mean_data_lfp(:,:),'b');; XLim([0 max_ax]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
%%
% ax3=subplot(5,1,4);
%     mean_data_lfpfilt2=smooth(abs(mean_data_lfpfilt(:,:,chan_no)))';
% axi_3min=min(mean_data_lfpfilt);
% axi_3max=max(mean_data_lfpfilt);
% plot(mean_data_lfpfilt(:,:),'r-'); ; XLim([0 max_ax]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5 f*6]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
%     hold on;
%     axi_3min=min(mean_data_lfpfilt2);
%     axi_3max=max(mean_data_lfpfilt2);
%     plot(mean_data_lfpfilt2(:,:),'g-'); %axis(round([0 152 axi_3min axi_3max])); set(ax3, 'XGrid', 'on');set(gca,'XTick',[0   25.3750   50.7500   76.1250  101.5000  126.8750  152.2500]);set(gca,'XTickLabel',{'-120','-80','-40','0','40','80','120'})
%     hold off;
ax3=subplot(5,1,2)
plot(mean_data_hil_corr)
ax3=subplot(5,1,3)
plot(mean_data_hil_incorr)
ax4=subplot(5,1,4)
hold on;
%     ts_max=max(mean_ts)+1
%     bar(mean_ts);axis([0 48 0 ts_max]);set(gca,'XTick',[0 8 16 24 32 40 48]); set(ax4, 'XGrid', 'on');set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
% ax4 = psth(times2, 50, Fs_SPK, trials_NO, 58594,ax4)
max_trials=trials_NO
plot ([(t(1):0.050:t(end))-t(1)],1*PEH_rate/y_max,'r','LineWidth',2);XLim([0 2.4]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold on;
plot ([(t(1):0.050:t(end))-t(1)],1*PEH_rate2/y_max,'k','LineWidth',2);XLim([0 2.4]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
hold off;
% ts_cat2=cat(3,ts_cat)
% subplot(5,1,5)
% rasterplot(ts_cat2,[trials_NO-1],4000,[],508)

for n4=1:trials_NO-1
    [doordelta,ind]=sort(doorind,3);
    rastertics2{n4}=rastertics{ind(n4)};
    rastertics3{n4}=[rastertics2{n4};rastertics2{n4}];
    subplot(5,1,5)
    if ismember(n4,corr)
        plot(rastertics3{n4},[0 1]+n4,'r','LineWidth',2);plot(doordelta(n4),[0 1]+n4,'gx');XLim([0 2.4]);YLim([0 max_trials]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    else
        plot(rastertics3{n4},[0 1]+n4,'k','LineWidth',2);plot(doordelta(n4),[0 1]+n4,'gx');XLim([0 2.4]);YLim([0 max_trials]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    end
    hold on
end
XLabel('time (sec)')

%saveas(gcf,'Mat_files/Result_figs/Block317_Chan6_SC2','pdf')


% mean_temp_strobe=mean(temp_strobe,3);
% %mean_data_lfp=mean(data_lfp,3);
% mean_data_lfp=mean(data_lfp,1);
% mean_ts=mean(ts_bin(:,:),1);
% figure(chan_no)
% subplot(5,1,1);
% plot(mean_temp_strobe,'c')
% hold on;
% a=axis;
% line([before_zero before_zero],a(3:4),'Color','g')
% hold off
% subplot(5,1,2)
% plot(mean_data_lfp(:,:,chan_no,:))
% subplot(5,1,4)
% bar(mean_ts)
% ts_cat2=cat(3,ts_cat)
% subplot(5,1,5)
% rasterplot(ts_cat2,[trials_NO-1],4000,[],508)

