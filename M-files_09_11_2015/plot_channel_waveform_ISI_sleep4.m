

function plot_channel_waveform_ISI_sleep4(Waves1,Waves2,TimeStamps1,TimeStamps2,units,andir)



for i=1:length(units)
    close;
    ch = units(i).un;
    for j = 1:length(ch);  
        close all
    chan_no=ch(j);
    W1=Waves1{chan_no,i+1};
    W2=Waves2{chan_no,i+1};
    TS1=TimeStamps1{chan_no,i+1};
    TS2=TimeStamps2{chan_no,i+1};
    Wpre = [];
    Wpost=[];
    l1 = 0;
    l2 = 0;
    T1a=[];
    T2a=[];
    
    Wpre=W1(:,:);
    Wpost=W2(:,:);
    waves_pre=mean(Wpre,2);
    sta_waves_pre=std(Wpre,0,2)/sqrt((size(Wpre,2))-1); hold on;

    subplot(2,2,1)
    shadedErrorBar([],waves_pre,(100*sta_waves_pre),'b',0);hold on; %plot(W,'c')
    
    XLim([0 30]);
    YLim([-0.00025 0.00015]);
    set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD');
    xlabel('time(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD');
    t=['Pre'];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    waves_post=mean(Wpost,2);
    sta_waves_post=std(Wpost,0,2)/sqrt((size(Wpost,2))-1); hold on;
    subplot(2,2,2)
    shadedErrorBar([],waves_post,(100*sta_waves_post),'g',0);hold on; %plot(W,'c')
    
    %  plot(waves,'y');
    XLim([0 30]);
    YLim([-0.00025 0.00015]);
    set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD');
    xlabel('time(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD');
    t=['Post'];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    subplot(2,2,3)
    bar(histc(diff(TS1),[0.001:0.001:0.200]),'EdgeColor','k','FaceColor','r');
    set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XLim',[0 80.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD')
    xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD');
    ylabel ('Counts','FontSize',14,'FontWeight','BOLD');
    t=['ISI Histogram Ch' num2str(chan_no)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    subplot(2,2,4)
    
    bar(histc(diff(TS2),[0.001:0.001:0.200]),'EdgeColor','k','FaceColor','g');
    set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XLim',[0 80.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD')
    xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD');
    ylabel ('Counts','FontSize',14,'FontWeight','BOLD');
    t=['ISI Histogram Ch' num2str(chan_no)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    
    set(gcf, 'Position', get(0,'Screensize'));

        filename= [andir 'Waveform_Ch' num2str(chan_no) 'SC_' num2str(i) '.tiff'];
        set(gcf, 'Position', get(0,'Screensize'));
        saveas(gcf,filename);
close all;
    end
end

Output=Change_firing;