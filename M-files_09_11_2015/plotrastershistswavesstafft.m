function [Output]=plotrastershistswavesstafft(TimeStamps, chan_no,data,wave,Fs_lfp,Waves,N,sc,bin_size,space)

close all;

length_to_analyze=length(data);
block=1:length_to_analyze;

% averaging LFPs after normalizing
data2=data(:,block);
for k=1:size(data,1)
    lfp_norm(k,:)=(data(k,:)-mean(data(k,:)))/std(data(k,:));
end
lfp_avg2=mean(lfp_norm,1);
lfp_avg=(lfp_avg2-mean(lfp_avg2))/std(lfp_avg2);

%creating pre, during and post intervals
temp3=wave(1,block)>2;
figure;
plot(temp3)
hold on
start1=find(diff(temp3)>0.5);
start2=find(diff(temp3)<-0.5);
[start]=[start1 start2];
figure(100)
% plot(start,[1],'rx');hold off

trange_tot=1/Fs_lfp: length(data)/Fs_lfp;   %round((1:length(data2))/Fs_lfp);
trange_pre=1/Fs_lfp: start1/Fs_lfp;%round((1:start1)/Fs_lfp);
trange_dur=start1/Fs_lfp: start2/Fs_lfp; %round((start1:start2)/Fs_lfp);
trange_post=start2/Fs_lfp: length(data)/Fs_lfp;%round((start2:length(data2))/Fs_lfp);
% GAP_THRESH=2; %threshold value for gap in spike times

for i=chan_no
    clear trials tstamps tstamps_tot tstamps_pre tstamps_dur tstamps_post spont gaps trial_ind bin_rate max_bin_rate Yax_lim
    clear waves binned dNpre tpre dNdur tdur dNpost tpost dNpost2 dNpre2
    % spikes =[1:2:10, 15:1.6:30, 35:0.3:50, 53:0.1:60, 80:1:90];
    if N{chan_no(i),sc}<=50
        disp (chan_no(i))
    else
        figure(i)
        tstamps=TimeStamps{chan_no(i),sc};
        
        tstamps_tot=tstamps(1:space:end);
        tpre1=find(tstamps>trange_pre(1));
        tpre2=find(tstamps>trange_pre(end));
        tstamps_pre=tstamps(tpre1:tpre2-1);
        tdur1=find(tstamps>trange_dur(1));
        tdur2=find(tstamps>trange_dur(end));
        tstamps_dur=tstamps(tdur1:tdur2-1);
        tpost1=find(tstamps>trange_post(1));
        tpost2=find(tstamps>trange_post(end));
        tstamps_post=tstamps(tpost1);
        
        rastertics_tot{i}=[tstamps_tot];
        rastertics_pre{i}=[tstamps_pre];
        rastertics_dur{i}=[tstamps_dur];
        rastertics_post{i}=[tstamps_post];
        
        lfp_tot(i,:)=(data(i,:)-mean(data(i,:)))/std(data(i,:));
        
        bin_vector = [trange_tot(1):bin_size:trange_tot(end)];
        
        waves=Waves{chan_no(i),sc};
        if ~isempty (tstamps)
            if length(tstamps) == 1
                binned = histc(tstamps,bin_vector);
            else
                binned = histc(tstamps,bin_vector)';
            end
        end
        
        bin_rate =[binned];
        max_bin_rate=max(smooth(bin_rate));
        Yax_lim=round(max_bin_rate/2);
        
        [dNpre,tpre]=binspikes(tstamps_tot,0.1,[0 start1/Fs_lfp]);
        [dNdur,tdur]=binspikes(tstamps_tot,0.1,[start1/Fs_lfp start2/Fs_lfp]);
        [dNpost,tpost]=binspikes(tstamps_tot,0.1,[start2/Fs_lfp (length(data)/Fs_lfp)]);
        if length(tpre) < length(tpost)
            dNpost2=dNpost(1:length(tpre));
            [H,P] = ttest(dNpre,dNpost2);
            subplot(4,4,[4 8])
            te=['p value'  num2str(P)]
            scatter(tpre,dNpre); hold on; scatter(tpost,dNpost,'r^'); title(te);
        else
            dNpre2=dNpre(1:length(tpost));
            [H,P] = ttest(dNpre2,dNpost);
            subplot(4,4,[4 8])
            te=['p value'  num2str(P)]
            scatter(tpre,dNpre); hold on; scatter(tpost,dNpost,'r^'); title(te);
        end
        
        subplot(4,4,[2 3]);
        plot((+1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-0.2 1.2]);%title('DC','FontSize',16,'FontWeight','BOLD')
        %         plot((-1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-1.2 0.2]);title('Cathodal tDCS Stimulation','FontSize',16,'FontWeight','BOLD')
        ylabel('current (mA)','FontSize',14,'FontWeight','BOLD');
        set(gca,'XTick',[0 length(temp3)],'XTickLabel',{'',''},'FontSize',14,'FontWeight','BOLD')
        set(gca,'YTick',[0 1],'YTickLabel',{'0','1'},'FontSize',14,'FontWeight','BOLD')
        
        subplot(4,4,[6 7]); plot(trange_tot(1):bin_size:trange_tot(end),smooth(bin_rate),'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max_bin_rate+1.5]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
        set(gca,'FontSize',14,'FontWeight','BOLD');hold on;
        
        subplot(4,4,[6 7]); plot([rastertics_tot{i};rastertics_tot{i}],[0 Yax_lim],'c','Linewidth',1); XLim([0 (length(data)/Fs_lfp)]); hold on %hold on; plot([(temp3)/Fs_lfp],1,'r'); hold off;
        %title('Unit 1 Raster and Firing Rate ','FontSize',16,'FontWeight','BOLD')
        %set(gca,'XTickLabel',{'','','','','','','',''},'FontSize',14,'FontWeight','BOLD')
        xlabel('time (sec)','FontSize',14,'FontWeight','BOLD'); hold off;
        %     subplot(3,4,[9 10 11 12]); plot(trange(1):10:trange(end),smooth(bin_rate),'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max(bin_rate)+2]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
        %     set(gca,'FontSize',14,'FontWeight','BOLD')
        % for i=1:length(chan_no)
        subplot(4,4,[1])
        plot(waves,'y');XLim([0 30]);YLim([-0.00015 0.00015]); set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD'); set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD'); xlabel('t(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD'); %title('Unit 1','FontSize',14,'FontWeight','BOLD')
        subplot(4,4,[5])
        bar(histc(diff(tstamps_tot),[0.005:0.001:0.100]),'y','Linewidth',2);set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');set(gca,'XLim',[0 40.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD');xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD'); ylabel ('Counts per bin','FontSize',14,'FontWeight','BOLD'); title('R37 Spont Block 249 SC1','FontSize',14,'FontWeight','BOLD')
        
        for jpre=2:length(tstamps_pre)-1
            lfp_time_pre1=round(tstamps_pre(jpre)*Fs_lfp);
            lfp_time_pre=lfp_time_pre1-10:lfp_time_pre1+102;
            lfp_pre(jpre,:)=lfp_tot(i,round(lfp_time_pre));
            lfp_avg_pre(jpre,:)=lfp_avg(lfp_time_pre);
        end
        
        for jdur=2:length(tstamps_dur)-1
            lfp_time_dur1=round(tstamps_dur(jdur)*Fs_lfp);
            lfp_time_dur=lfp_time_dur1-10:lfp_time_dur1+102;
            lfp_dur(jdur,:)=lfp_tot(i,lfp_time_dur);
            lfp_avg_dur(jdur,:)=lfp_avg(lfp_time_dur);
        end
        
        for jpost=2:length(tstamps_post)-1
            lfp_time_post1=round(tstamps_post(jpost)*Fs_lfp);
            lfp_time_post=lfp_time_post1-10:lfp_time_post1+102;
            lfp_post(jpost,:)=lfp_tot(i,lfp_time_post);
            lfp_avg_post(jpost,:)=lfp_avg(lfp_time_post);
        end
        subplot(4,4,[9 10 13 14])
        plot(mean(lfp_pre),'b', 'Linewidth',2);hold on;
        plot(mean(lfp_avg_pre),'b', 'Linewidth',4);
        plot(mean(lfp_dur),'r', 'Linewidth',2);
        plot(mean(lfp_avg_dur),'r', 'Linewidth',4);
        plot(mean(lfp_post),'g', 'Linewidth',2);
        plot(mean(lfp_avg_post),'g', 'Linewidth',4);%XLim([round(3*Fs_lfp) round(3*Fs_lfp)+102])
        title('STA','FontSize',14,'FontWeight','BOLD')
        xlabel('time (msec)','FontSize',14,'FontWeight','BOLD')
        ylabel('amp','FontSize',14,'FontWeight','BOLD');
        legend('pre','pre_avg','dur','dur_avg', 'post','post_avg')
        set(gca,'XTick',[0 11 113],'FontSize',12,'FontWeight','BOLD');
        set(gca,'XTickLabel',{'-10','SpikeTime', '100'},'FontSize',12,'FontWeight','BOLD');
        hold off;
          
        
        lfp_pre_full=lfp_tot(i,1:start1);
        lfp_dur_full=lfp_tot(i,start1:start2);
        lfp_post_full=lfp_tot(i,start2:length(data));
        
        NFFTpre = 2^nextpow2(length(lfp_pre_full)); % Next power of 2 from length of y
        Ypre = fft(lfp_pre_full,NFFTpre)/length(lfp_pre_full);
        f_pre = Fs_lfp/2*linspace(0,1,NFFTpre/2+1);
        
        NFFTdur = 2^nextpow2(length(lfp_dur_full)); % Next power of 2 from length of y
        Ydur = fft(lfp_dur_full,NFFTdur)/length(lfp_dur_full);
        f_dur = Fs_lfp/2*linspace(0,1,NFFTdur/2+1);
        
        NFFTpost = 2^nextpow2(length(lfp_post_full)); % Next power of 2 from length of y
        Ypost = fft(lfp_post_full,NFFTpost)/length(lfp_post_full);
        f_post = Fs_lfp/2*linspace(0,1,NFFTpost/2+1);
        
        subplot(4,4,[11 12 15 16])
        plot(f_pre,2*abs(Ypre(1:NFFTpre/2+1)),'b', 'Linewidth',2);hold on;
        plot(f_dur,2*abs(Ydur(1:NFFTdur/2+1)),'r', 'Linewidth',2);
        plot(f_post,2*abs(Ypost(1:NFFTpost/2+1)),'g', 'Linewidth',2);
        title('Single-Sided Amplitude Spectrum of y(t)','FontSize',14,'FontWeight','BOLD')
        xlabel('Frequency (Hz)','FontSize',14,'FontWeight','BOLD')
        ylabel('|Y(f)|','FontSize',14,'FontWeight','BOLD');XLim([0 5])
        legend('pre','dur','post')
        hold off;
        
                filename=['Mat_files/Result_figs/SigStims/R38/R38 STA_FFT Block 17 SC3 Chan' num2str(i) '.tiff'];
                saveas(gcf,filename);
    end
end
Output=rastertics_dur{i};

