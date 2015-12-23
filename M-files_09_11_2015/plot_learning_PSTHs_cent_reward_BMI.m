function [Output]=plot_learning_PSTHs_cent_reward_BMI(TimeStamps, chan_no,data,wave,start_trial, start_pulse2, Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(4*Fs_lfp);
after_zero=round(4*Fs_lfp);
time=0:bin_size:8;
total_trials=length(start_trial);
total_strials=length(start_pulse2);
total_PSTHs=round(total_trials/3);


time_for_twopulse=round(18*Fs_lfp);
% clear bin_rate_s binned_s
for i=length(chan_no)
%     figure;

    bin_rate_s=[];%zeros(141,total_trials);
%     for j=1:total_trials
    %     subplot(1,2,i)
    for n=1:total_strials
        
%         clear  rastertics_u rastertics_s rastertics_u1 rastertics_s1 ts_range_u  t2 t3 max_ax2
%         bin_rate_u=[];
%         bin_rate_s=[];
        time_for_plot=round((start_pulse2(n)-before_zero: start_pulse2(n)+after_zero)/Fs_lfp);
%         time_to_check=round(start_trial(j)-before_zero: start_trial(j)+time_for_twopulse);
        
        tstamps1=TimeStamps{chan_no(i),sc};
        tstamps=tstamps1(1:space:end);
        t2=find(tstamps>time_for_plot(1));
        t3=find(tstamps<time_for_plot(end));
%         ts=intersect(t2,t3);
        
        waves=Waves{chan_no,sc};
        
%         ind=find(start_pulse2>start_trial(n),1,'first');
        
%         if ismember(start_pulse2(ind),time_to_check)==1
            if ~isempty(t2) && ~isempty(t3)
                range_s=intersect(t2,t3);%/Fs_lfp;
                ts_range_s=tstamps(range_s);
                ts_norm_s{n}=[ts_range_s-time_for_plot(1)];
                rastertics_s=[ts_norm_s{n}];%; tstamps(range3)];
                %             rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
                bin_vector = [time];%[(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
                max_ax2=length(bin_vector)/20;
                %                 rastertics_s1=[rastertics_s;rastertics_s];
                %                 plot(rastertics_s1,[0 1]+n,'r','LineWidth',2);plot(rewardind(:,n),[0 1]+n,'bx', 'LineWidth',2);XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
                %                 hold on
                
                if ~isempty (ts_norm_s{n})
                    if length(ts_norm_s{n}) == 1
                        binned_s = histc(ts_norm_s{n},bin_vector);
                    else
                        binned_s = histc(ts_norm_s{n},bin_vector)';
                    end
%                     if n == 1
%                         bin_rate_s = binned_s;
%                     else
                        size(bin_rate_s)
                        size(binned_s)
                        n
                        bin_rate_s(:,n)=[ binned_s];
%                     end
                end
                
               
            end
%         else
%             disp('unsuccessful trial')
%             disp(num2str(n))
            %             if ~isempty(t2) && ~isempty(t3)
            %                 range_u=[t2(1):(t3(1)-1)];%/Fs_lfp;
            %                 ts_range_u=tstamps(range_u);
            %                 ts_norm_u=[ts_range_u-time_for_plot(1)];
            %                 rastertics_u=[ts_norm_u];%; tstamps(range3)];
            % %                 rewardind(:,:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
            %                 rastertics_u1=[rastertics_u;rastertics_u];
            %                 bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
            %                 max_ax2=length(bin_vector)/20;
            % %                 plot(rastertics_u1,[0 1]+n,'k','LineWidth',2);XLim([0 max_ax2]);%plot(rewardind(:,n),[0 1]+n,'gx'))%;%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
            % %                 hold on
            %
            %
            %                 if ~isempty (ts_norm_u)
            %                     if length(ts_norm_u) == 1
            %                         binned_u = histc(ts_norm_u,bin_vector);
            %                     else
            %                         binned_u = histc(ts_norm_u,bin_vector)';
            %                     end
            %                 end
            %
            %                  bin_rate_u =[binned_u];
        end
        
        
        
        
        
        
%     end
end
% hold on;




% PEH_rate1=sum(bin_rate_s,2)/(total_trials)/0.05
PEH_rate1=mean(bin_rate_s(:,1:40),2);
PEH_rate2=mean(bin_rate_s(:,[41:80]),2);
PEH_rate3=mean(bin_rate_s(:,81:120),2);
ymax= max(cat(2,PEH_rate1, PEH_rate2, PEH_rate3));
y_max=max(ymax);
figure
plot (bin_vector,smooth(PEH_rate1,'sgolay'),'r','LineWidth',2);
hold on;
plot (bin_vector,smooth(PEH_rate2,'sgolay'),'g','LineWidth',2);
hold on;
plot (bin_vector,smooth(PEH_rate3,'sgolay'),'b','LineWidth',2);
hold on;
%  XLim([0 30]);
 YLim([0 y_max]); 
 set(gca,'XTick',[0 1 2 3 4 5 6 7],'FontSize',14,'FontWeight','BOLD');
 set(gca,'XTickLabel',{'-4','-3','-2','-1','^','1','2','3'},'FontSize',14,'FontWeight','BOLD'); 
%  set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');
     set(gca,'FontSize',14,'FontWeight','BOLD')
%     ylabel('Count','FontSize',14,'FontWeight','BOLD');
    xlabel('Time (sec)','FontSize',14,'FontWeight','BOLD')
    t=['Learning Over Trials Centered to Reward Ch' num2str(chan_no)];
    title(t ,'FontSize',14,'FontWeight','BOLD')
    legend('First 1/3rd trials','Second 1/3rd trials','Last 1/3rd trials','Location','NorthWest')
               filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\T12\6_7_13Late\Task Every Third Trial PSTH_cent_reward Ch' num2str(chan_no) '.tiff'];
               set(gcf, 'Position', get(0,'Screensize')); 
               saveas(gcf,filename);

Output=bin_rate_s;

