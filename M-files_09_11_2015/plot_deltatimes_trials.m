function [Output]=plot_deltatimes_trials(TimeStamps, chan_no,data,wave,start_trial, start_pulse2, Fs_lfp,Waves,N,sc,bin_size,space)

close all;

length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(3*Fs_lfp);
after_zero=round(8.5*Fs_lfp);

total_trials=length(start_trial);

time_for_twopulse=round(18*Fs_lfp);

for i=length(chan_no)
    figure;
    %     subplot(1,2,i)
    for n=[1:total_trials]
        clear t2 t3 bin_rate_u bin_rate_s rastertics_u rastertics_s rastertics_u1 rastertics_s1 ts_range_u ts_range_u1 ts_norm_u ts_range_s ts_range_s1 ts_norm_s success_counts
        success_counts=[];
        bin_rate_u=[];
        bin_rate_s=[];
        time_for_plot=((start_trial(n)-before_zero: start_trial(n)+after_zero)/Fs_lfp);
        time_to_check=(start_trial(n)-before_zero: start_trial(n)+time_for_twopulse);
        
        tstamps1=TimeStamps{chan_no(i),sc};
        tstamps=tstamps1(1:space:end);
        t2=find(tstamps>time_for_plot(1));
        t3=find(tstamps<time_for_plot(end));
        
        waves=Waves{chan_no,sc};
        
        ind=find(start_pulse2>start_trial(n),1,'first');
        
        if ismember(start_pulse2(ind),time_to_check)==1
            if ~isempty(t2) && ~isempty(t3)
                %                 range_s=[t2(1):(t3(1)-1)];%/Fs_lfp;
                %                 ts_range_s=tstamps(range_s);
                ts_range_s1=intersect(t2,t3);
                ts_range_s=tstamps(ts_range_s1);
                ts_norm_s=[ts_range_s-time_for_plot(1)];
                rastertics_s=[ts_norm_s];%; tstamps(range3)];
                rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
                %                 h=figure;
                %                 plot(n,rewardind(:,n),'r*')
                bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
                max_ax2=round(length(bin_vector)/18.48);
                rastertics_s1=[rastertics_s;rastertics_s];
                success_counts=[success_counts n];
                %                 s=figure;
                % subplot(1,2,i);
                if isempty(ts_norm_s)==1
                    disp('not plotting this channels raster')
                else
                    plot(rastertics_s1,[0 1]+n,'r','LineWidth',2);plot(rewardind(:,n),[0.5]+n,'bo', 'LineWidth',2);XLim([0 max_ax2]);YLim([1 total_trials+1]);set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12]);set(gca,'XTickLabel',{'-3','-2','-1','^','1','2','3','4','5','6','7','8'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
                end
                hold on
                
                if ~isempty (ts_norm_s)
                    if length(ts_norm_s) == 1
                        binned = histc(ts_norm_s,bin_vector);
                    else
                        binned = histc(ts_norm_s,bin_vector)';
                    end
                end
                
                bin_rate_s =[bin_rate_s binned];
            end
        else
            if ~isempty(t2) && ~isempty(t3)
                %                 range_u=[t2(1):(t3(1)-1)];%/Fs_lfp;
                %                 ts_range_u=tstamps(range_u);
                ts_range_u1=intersect(t2,t3);
                ts_range_u=tstamps(ts_range_u1);
                
                ts_norm_u=[ts_range_u-time_for_plot(1)];
                rastertics_u=[ts_norm_u];%; tstamps(range3)];
                rewardind(:,n)=(-1);
                rastertics_u1=[rastertics_u;rastertics_u];
                bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
                max_ax2=round(length(bin_vector)/18.48);
                if isempty(ts_norm_u)==1
                    disp('not plotting this channels raster')
                else
                    %                 subplot(1,2,i);
                    plot(rastertics_u1,[0 1]+n,'k','LineWidth',2);XLim([0 max_ax2]);XLim([0 max_ax2]);YLim([1 total_trials+1]);set(gca,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12]);set(gca,'XTickLabel',{'-3','-2','-1','^','1','2','3','4','5','6','7','8'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
                end
                hold on
                
                
                if ~isempty (ts_norm_u)
                    if length(ts_norm_u) == 1
                        binned = histc(ts_norm_u,bin_vector);
                    else
                        binned = histc(ts_norm_u,bin_vector)';
                    end
                end
                
                bin_rate_u =[bin_rate_u binned];
            end
            
            
            
            
            
            
        end
    end
    hold on;
    set(gca,'FontSize',14,'FontWeight','BOLD')
    ylabel('Trials','FontSize',14,'FontWeight','BOLD');
    xlabel('Time (sec)','FontSize',14,'FontWeight','BOLD'); %XLim([0 max_ax2])
    t=['Learning Over Trials Ch' num2str(chan_no)];
    title(t ,'FontSize',14,'FontWeight','BOLD')
    if sc==2
    filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\T12\6_7_13Late\T12_Learning_3to8 Ch' num2str(chan_no) '.tiff'];
    else if sc==3
            filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\T12\6_7_13Late\T12_Learning_3to8 SC_2 Ch' num2str(chan_no) '.tiff'];
        end
    end
    
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    saveas(gcf,filename);
end
hold on;
figure;
for i=1:length(start_trial)
    
    if isempty(rewardind(:,i))==1
        disp('unsuccessful_trial')
    else
        
        plot(i,rewardind(:,i),'h','MarkerEdgeColor','b', 'MarkerFaceColor','c'); hold on;
    end
    XLim([0 total_trials+1])
    set(gca,'FontSize',14,'FontWeight','BOLD')
    xlabel('Trials','FontSize',14,'FontWeight','BOLD');
    ylabel('Time (sec)','FontSize',14,'FontWeight','BOLD')
    title('Time to Reward','FontSize',14,'FontWeight','BOLD')
end

Output=length(chan_no);