close all

clear rastertics data_lfp data_lfp1 temp_strobe data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta binned bin_rate bin_rate2 hold val data_filt1 label data_hil data_hil_corr data_hil_incorr data_lfpfilt_corr;
clear data_lfpfilt_incorr data_hil data_hil1 waves_corr waves_incorr waves_range2 rastertics2 doorind2 ind ind2 rastertics3 rastertics4 rastertics5 corr incorr ind_corr ind_incorr data_filt1
clear data_filt1_corr data_filt1_incorr
clear hold_x hold_y hold_xy1


trials_NO=length(Reach);

%time for LFPs, rasters, PETHs
block_len=1220;
before_zero=2034; % looking 2.0 sec before and 1.0 sec after grab time at 1017 samples/sec
figure;
chan_no_forchew=22;
chan_no=[22 23]
sortcode=2; %use 1 for MU activity, and subsequently 2/3/4 depending on sorted unit yield per channel
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
% file_path='Mat_files/Result_figs/Block346_Chan';
% format='.tiff';

% Filter for Chewing Vs Non-Chewing trials (High pass)
FILTER_ORDER_t=4;
END_SMOOTHING_t=100;
srate_t = Fs_lfp;
nyq_sample_t=srate_t/2;
f_lo_t=300;
f_hi_t=100;
[bt,at]=butter(FILTER_ORDER_t,f_hi_t/nyq_sample_t,'high');
hil_hi=25;
hil_lo=10;


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
data_filt1_incorr=[];
data_filt1_corr=[];


for chan_no_forchew=[chan_no_forchew]
        for n=1:trials_NO
        temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len); % plotting waves 1.2 s before and after with door and grasp signal            
        disp(n)
        figure(1)% figure for chewing classifier
        subplot(4,1,1);
        plot(strobe(1,(Reach(n)-time_before):(Reach(n)+time_after)))
        hold on
        
        subplot('Position',[0.13 0.3 0.77 0.45])
        hold on;
        temp=data(chan_no_forchew,round((Reach(n)-time_before):(Reach(n)+time_after)));
        temp=(temp-mean(temp))/std(temp);
        data_filt1=(abs(filter(bt,at,temp))).^2;
        %data_filt1=smooth(data_filt1,END_SMOOTHING);
        data_filt1=conv(data_filt1,ones(50,1))/50;
        data_filt_hold(n,:)=data_filt1;
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
        hold_val(n)=mean(sm_power(47:54));      %<=====change this window if classifier is not looking in correct areas of power difference
        plot(2.5,mean(sm_power(47:54)),'rx');
        %plot(f,2*abs(Y(1:NFFT/2+1)))
        title('Single-Sided Amplitude Spectrum of y(t) --> 2,5, 100 Hz signals')
        xlabel('Frequency (Hz)')
    end
end
[label,ctrs]=kmeans(hold_val,2,'Distance','sqEuclidean','Replicates',10),'Matrix',[min(hold_val) max(hold_val)];
% corr=find(label==2);
% incorr=find(label==1);
% [x,y]=ginput
% pause
corr=[find(hold_val>0.15)]';
incorr=[find(hold_val<0.15)]';
hold on
plot(3,hold_val(incorr),'k+');
plot(3,hold_val(corr),'r+');
hold off;
figure;
for np=1:trials_NO
    if ismember(np,corr)==1
       plot(data_filt_hold(np,:)/0.5+np,'r')        
    else
        plot(data_filt_hold(np,:)/0.5+np,'k')
    end
    hold on;
end

figure;
for chan_no= [chan_no]
    
    clear rastertics data_lfp data_lfp1 data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta binned bin_rate bin_rate2 hold val data_filt1 label data_hil data_hil_corr data_hil_incorr data_lfpfilt_corr;
    clear data_lfpfilt_incorr data_hil data_hil1 waves_corr waves_incorr waves_range2 rastertics2 doorind2 ind ind2 rastertics3 rastertics4 rastertics5  ind_corr ind_incorr data_filt1
    clear data_filt1_corr data_filt1_incorr PEH_rate PEH_rate2 y_max y_max2 rastertics6 rastertics7
    clear hold_x_corr hold_x_incorr win_prior drop_frame
    
    y_max=0;
    y_max2=0;
    bin_rate=[];
    bin_rate2=[];
    data_hil_corr=[];
    data_hil_incorr=[];
    data_lfpfilt_corr=[];
    data_lfpfilt_incorr=[];
    waves_corr=[];
    waves_incorr=[];
    data_filt1_incorr=[];
    data_filt1_corr=[];
    hold_x_corr=[];
    hold_x_incorr=[];
    %Filter for LFPs with beta band
    
    
    
    FILTER_ORDER=4;
    END_SMOOTHING=100;
    srate = Fs_lfp;
    nyq_sample=srate/2;
    f_lo=10;
    f_hi=20;
    [b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
    for n=1:trials_NO
        range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len]); % range of lfp for same time window as above
        data_lfp1=data(chan_no,range_lfp)'; % lfp data unfiltered
        data_hil1=abs(hilbert2([data_lfp1]',1017,hil_lo,hil_hi));
        data_lfp=(data_lfp1-mean(data_lfp1))/(2*std(data_lfp1));
        data_hil(:,:,n)=(data_hil1-mean(data_hil1))/(2*std(data_hil1));
        data_lfpfilt(:,:,n)=filter(b,a,data_lfp);
        t=[Reach(n)-before_zero:Reach(n)+block_len]/Fs_wave;
        disp(t-t(1));
        tstamps=TimeStamps{chan_no,sortcode};
        t2=find(tstamps>t(1));
        t3=find(tstamps>t(end));
        
        waves=Waves{chan_no,sortcode};
        win_prior=15;
        drop_frame=26;
        
        
        hold_xy1=hold_paths{n};
        
        hold_x(:,:,n)=smooth(hold_xy1(:,1),6,  'loess'   );
        hold_y(:,:,n)=smooth(hold_xy1(:,2),6 , 'loess'   );
        
        
        if ~isempty(t2) && ~isempty(t3)
            range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
            ts_range2=tstamps(range2);
            ts_range4{n}=[ts_range2-t(1)];
            bin_vector = [(t(1):0.05:t(end))-t(1)];
            
            waves_range2{n}=waves(:,range2);
            
            %bin_rate = zeros (length (bin_vector),trials_NO);
            % spikes = Trial_spike_times {trials_NO,spike_no};
            if ~isempty (ts_range4{n})
                if length(ts_range4{n}) == 1
                    binned = histc(ts_range4{n},bin_vector);
                else
                    binned = histc(ts_range4{n},bin_vector)';
                end
                
                
                if ismember(n,corr)==1
                    bin_rate =[bin_rate binned];
                    data_hil_corr=[data_hil_corr; data_hil(:,:,n)];
                    data_lfpfilt_corr=[data_lfpfilt_corr; data_lfpfilt(:,:,n)];
                    waves_corr=[waves_corr waves_range2{n}];
                    hold_x_corr=[hold_x_corr hold_x(:,:,n)];
                    
                else
                    bin_rate2 =[bin_rate2 binned];
                    data_hil_incorr=[data_hil_incorr; data_hil(:,:,n)];
                    data_lfpfilt_incorr=[data_lfpfilt_incorr; data_lfpfilt(:,:,n)];
                    waves_incorr=[waves_incorr waves_range2{n}];
                    hold_x_incorr=[hold_x_incorr hold_x(:,:,n)];
                    
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
    
    for l_incorr1=1:length(incorr)
        
        doorind3(:,:,l_incorr1)=doorind(:,:,incorr(l_incorr1));
        [doordelta_incorr,ind_incorr]=sort(doorind3,3);
        rastertics4{l_incorr1}=rastertics{incorr(l_incorr1)};
    end
    for lcorr1=1:length(corr)
        doorind2(:,:,lcorr1)=doorind(:,:,corr(lcorr1));
        [doordelta,ind]=sort(doorind2,3);
        rastertics2{lcorr1}=rastertics{corr(lcorr1)};
    end
    
    mean_temp_strobe=mean(temp_strobe,3);
    mean_data_hil_corr=mean(data_hil_corr);
    mean_data_hil_incorr=mean(data_hil_incorr);
    mean_data_lfpfilt_corr=mean(data_lfpfilt_corr);
    mean_data_lfpfilt_incorr=mean(data_lfpfilt_incorr);
    mean_hold_x_corr=mean(hold_x_corr,2);
    mean_hold_x_incorr=mean(hold_x_incorr,2);
    
    
    PEH_rate = smooth((sum(bin_rate,2)/length(corr)/0.05),3); % average firing rate for the the rate corr
    PEH_rate2 = smooth((sum(bin_rate2,2)/length(incorr)/0.05),3); % average firing rate for the the rate incorr
    
%     if max(PEH_rate)>max(PEH_rate2) & y_max < max(PEH_rate)  % finds the maximum rate for all targets
        y_max = max(PEH_rate);
        y_max2 = max(PEH_rate2) ;
  
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
    %         plot(smooth(data_hil(:,:,n),80),'r');
    %     else
    %         plot(smooth(data_hil(:,:,n),80),'k');
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
    % ylim([0 trials_NO+1])
    %
    % title(length(corr)/trials_NO)
    
    figure(chan_no)
    
%     max_ax=length(mean_temp_strobe);
%     f=1017;
%     axh=subplot(5,4,[3 4]);
%     plot(mean_temp_strobe,'c'); XLim([0 max_ax]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5]);set(gca,'XTickLabel',{'-4','-3','-2','-1','Reach ON','1'})
%     hold on;
%     a=axis;
%     line([before_zero before_zero],a(3:4),'Color','g')
%     hold off
%      titlename=['Block 381 Reach ON SC2 Ch ' num2str(chan_no)];
%      title(titlename)
%
    
%     ax3=subplot(5,1,2)
%     plot(smooth(mean_data_hil_corr,50),'r-','LineWidth',2)
%     hold on;
%     plot(smooth(mean_data_hil_incorr,50),'k-','LineWidth',2);XLim([0 max_ax]); YLim([-0.4 0.4]);set(ax3, 'XGrid', 'on'); set(ax3, 'YGrid', 'on');set(gca,'XTick',[0 f f*2 f*3 f*4 f*5]);set(gca,'XTickLabel',{'-4','-3','-2','-1','Reach ON','1'})
%     hold off;
    ax4=subplot(3,1,1)
    hold on;
    %     ts_max=max(mean_ts)+1
    %     bar(mean_ts);axis([0 48 0 ts_max]);set(gca,'XTick',[0 8 16 24 32 40 48]); set(ax4, 'XGrid', 'on');set(gca,'XTickLabel',{'0','1.3','2.6','3.9','5.2'})
    % ax4 = psth(times2, 50, Fs_SPK, trials_NO, 58594,ax4)
    max_trials=trials_NO
    max_ax2=length(bin_vector)/20;
    f2=1;
    
    plot ([(t(1):0.05:t(end))-t(1)],1*PEH_rate/y_max,'r','LineWidth',3);XLim([0 max_ax2]);YLim([0 1]);set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'})
    hold on;
    plot ([(t(1):0.05:t(end))-t(1)],1*PEH_rate2/y_max2,'k','LineWidth',3);XLim([0 max_ax2]);YLim([0 1]);set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
    hold off;
         titlename=['Block 10 Reach ON SC2 Ch ' num2str(chan_no)];
     title(titlename,'FontSize',16,'FontWeight','BOLD')
    
    % corr_index=23
    % incorr_index=1;
    %for n4=1:trials_NO
    for lcorr=1:length(corr)
        %for lincorr=1:length(incorr)
        %     doorind2(:,:,lcorr)=doorind(:,:,corr(lcorr));
        %     [doordelta,ind]=sort(doorind2,3);
        %rastertics2{n4}=rastertics{ind(n4)};
        
        rastertics7{lcorr}=rastertics2{ind(:,:,lcorr)}
        rastertics3{lcorr}=[rastertics7{lcorr};rastertics7{lcorr}];
        
        subplot(3,1,2)
        plot(rastertics3{lcorr},[0 1]+lcorr,'r','LineWidth',2);plot(doordelta(lcorr),[0 1]+lcorr,'gx');XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
        hold on
    end
    hold on
    for l_incorr=1:length(incorr)
        
        
        %rastertics2{n4}=rastertics{ind(n4)};
        %     rastertics4{l_incorr}=rastertics{incorr(l_incorr)};
        rastertics6{l_incorr}=rastertics4{ind_incorr(:,:,l_incorr)}
        rastertics5{l_incorr}=[rastertics6{l_incorr};rastertics6{l_incorr}];
        subplot(3,1,2)
        plot(rastertics5{l_incorr},[length(corr) length(corr)+1]+l_incorr,'k','LineWidth',2);plot(doordelta_incorr(l_incorr),[length(corr) length(corr)+1]+l_incorr,'cx');XLim([0 max_ax2]);YLim([0 max_trials]);set(gca,'XTick',[0 1 2 3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD'); %set(gca,'YTickLabel','FontSize',14,'FontWeight','BOLD')%axis([0 2.4 (0+n4) (1+n4)]);%hold off;
        hold on
    end
    %xlabel('time (sec)')
    %     subplot(4,1,4)
    % %     %             if ismember(n4,corr)
    % %
    % %
    %     plot(rastertics3{lcorr},[0 1]+lcorr,'r','LineWidth',2);%plot(doordelta(n4),[0 1]+lcorr,'gx');XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    %     hold on
    %     %             else
    %     %                 figure(7)
    %     %                 plot(rastertics3{},[24 25]+lincorr,'k','LineWidth',2);plot(doordelta(n4),[0 1]+lincorr,'gx');XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    %     %                 hold off
    %     plot(rastertics5{l_incorr},[length(corr) length(corr)+1]+l_incorr,'k','LineWidth',2);%plot(doordelta(n4),[0 1]+n4,'gx');XLim([0 max_ax2]);YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
    % % end
    %
    % hold on
    
    
%     %     XLabel('time (sec)')
%     figure(chan_no)
%     subplot(5,4,1)
%     plot((waves_corr),'r-'); hold on; plot(mean(waves_corr,2),'g-.'); XLim([0 30]);YLim([-0.0002 0.0002]); set(gca,'XTick',[0 30]);set(gca,'XTickLabel',{'0','1.2'}); set(gca,'YTick',[-0.0002 0 0.0002]);set(gca,'YTickLabel',{'-200','0','200'}); xlabel('msec'); ylabel('microvolt'); title('Successful')
%     subplot(5,4,2)
%     plot((waves_incorr),'k-'); hold on; plot(mean(waves_incorr,2),'g-.'); XLim([0 30]);YLim([-0.0002 0.0002]); set(gca,'XTick',[0 30]);set(gca,'XTickLabel',{'0','1.2'}); set(gca,'YTick',[-0.0002 0 0.0002]);set(gca,'YTickLabel',{'-200','0','200'}); xlabel('msec'); ylabel('microvolt'); title('Unsuccessful')
% 
%     
    figure(chan_no);
    f7=136
    ax9=subplot(3,1,3)
    [r1 c1]=min(-mean_hold_x_corr);
      [r2 c2]=min(-mean_hold_x_incorr);
      c3=round(c1+c2/2);
%       t=[c3-25:c3+10];
    plot(-mean_hold_x_corr,'r-','LineWidth',3)
    hold on;
    plot(-mean_hold_x_incorr,'k-','LineWidth',3);XLim([(c3-60) (c3+36)]);YLim([(min(-mean_hold_x_corr)-5) (max(-mean_hold_x_corr)+5)]);set(gca,'XTick',[c3-60 c3-30 c3 c3+30]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'}); set(gca,'YTick',[(min(-mean_hold_x_corr)-5) (((min(-mean_hold_x_corr)-5)+(max(-mean_hold_x_corr)+5))/2) (max(-mean_hold_x_corr)+5)]); set(gca,'YTickLabel',{'Initial','','Target'},'FontSize',14,'FontWeight','BOLD');xlabel ('time (sec)','FontSize',16,'FontWeight','BOLD');set(ax9, 'XGrid', 'on');set(ax9, 'YGrid', 'on');

    hold off;
    
        filename=['Mat_files/Result_figs/Block10_SC2_ReachON_SELECTDATAChan' num2str(chan_no) '.tiff'];
    
    saveas(gcf,filename);
      figure;
    for nq=1:trials_NO
        hold on;
        if ismember(nq,corr)==1
            plot(-hold_x(:,:,nq)/10+nq,'r')
        else
            plot(-hold_x(:,:,nq)/10+nq,'k')
        end
        hold on;
    end
    
    
end

