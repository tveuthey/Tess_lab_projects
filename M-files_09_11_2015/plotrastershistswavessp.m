function [Output]=plotrastershistswavessp(TimeStamps, chan_no,data,wave,Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;
data2=data(:,block);
temp3=wave(1,block)>2;
figure;
plot(temp3)
hold on
start=diff(temp3)>0.5;
[start]=find(start==1);
figure(100)
% plot(start,[1],'rx');hold off
trange=0:((length(data2))/Fs_lfp);
% GAP_THRESH=2; %threshold value for gap in spike times
for i=1:length(chan_no)
    clear trials tstamps spont gaps trial_ind bin_rate max_bin_rate Yax_lim
    % spikes =[1:2:10, 15:1.6:30, 35:0.3:50, 53:0.1:60, 80:1:90];
    if N{chan_no(i),sc}<=500
        disp (chan_no(i))
    else
        figure(i)
        tstamps2=TimeStamps{chan_no(i),sc};
        tstamps=tstamps2(1:space:end);
        rastertics{i}=[tstamps];
        bin_vector = [trange(1):bin_size:trange(end)];
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
        Yax_lim=round(max_bin_rate/3);
        
        subplot(3,1,2);
        plot((+1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-0.2 1.2]);title('Spontaneous','FontSize',16,'FontWeight','BOLD')
%         plot((-1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-1.2 0.2]);title('Cathodal tDCS Stimulation','FontSize',16,'FontWeight','BOLD')
        ylabel('current (mA)','FontSize',14,'FontWeight','BOLD');
        set(gca,'XTick',[0 length(temp3)],'XTickLabel',{'',''},'FontSize',14,'FontWeight','BOLD')
        set(gca,'YTick',[0 1],'YTickLabel',{'0','1'},'FontSize',14,'FontWeight','BOLD')
        subplot(3,4,[9 10 11 12]); plot(trange(1):bin_size:trange(end),smooth(bin_rate),'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max(bin_rate)+2]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
        set(gca,'FontSize',14,'FontWeight','BOLD');hold on;
        subplot(3,4,[9 10 11 12]); plot([rastertics{i};rastertics{i}],[0 Yax_lim],'y','Linewidth',1); XLim([0 (length(data)/Fs_lfp)]); hold on %hold on; plot([(temp3)/Fs_lfp],1,'r'); hold off;
        %title('Unit 1 Raster and Firing Rate ','FontSize',16,'FontWeight','BOLD')
        %set(gca,'XTickLabel',{'','','','','','','',''},'FontSize',14,'FontWeight','BOLD')
        xlabel('time (sec)','FontSize',14,'FontWeight','BOLD'); hold off;
        %     subplot(3,4,[9 10 11 12]); plot(trange(1):10:trange(end),smooth(bin_rate),'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max(bin_rate)+2]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
        %     set(gca,'FontSize',14,'FontWeight','BOLD')
        % for i=1:length(chan_no)
        subplot(3,4,1)
        plot(waves,'y');XLim([0 30]);YLim([-0.00015 0.00015]); set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD'); set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD'); xlabel('t(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD'); %title('Unit 1','FontSize',14,'FontWeight','BOLD')
        subplot(3,4,[2 3 4])
        bar(histc(diff(tstamps2),[0.005:0.001:0.100]),'y','Linewidth',3);set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');set(gca,'XLim',[0 40.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD');xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD'); ylabel ('Counts per bin','FontSize',14,'FontWeight','BOLD'); title('R37 Spont Block 256 SC1','FontSize',14,'FontWeight','BOLD')
        filename=['Mat_files/Result_figs/New/R37 Spont Block 256 SC1 Chan' num2str(i) '.tiff'];
        saveas(gcf,filename);
    end
end

Output=rastertics{i};