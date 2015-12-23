function [Output]=plottwoBMIneurons(TimeStamps, chan_no,data,wave,start_trial, start_pulse2, Fs_lfp,Waves,N,sc,bin_size,space)

% close all;

length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(1*Fs_lfp);
after_zero=round(20*Fs_lfp);

total_trials=length(start_trial);

time_for_twopulse=round(18*Fs_lfp);

for i=length(chan_no)
    figure;
%     subplot(1,2,i)
    for n=1:total_trials
        clear bin_rate_u bin_rate_s rastertics_u rastertics_s rastertics_u1 rastertics_s1 ts_range_u ts_norm_u ts_range_s ts_norm_s
        bin_rate_u=[];
        bin_rate_s=[];
        time_for_plot=round((start_trial(n)-before_zero: start_trial(n)+after_zero)/Fs_lfp);
        time_to_check=round(start_trial(n)-before_zero: start_trial(n)+time_for_twopulse);
        
        tstamps1=TimeStamps{chan_no(i),sc};
        tstamps=tstamps1(1:space:end);
        t2=find(tstamps>time_for_plot(1));
        t3=find(tstamps>time_for_plot(end));
        
        waves=Waves{chan_no,sc};
        
        ind=find(start_pulse2>start_trial(n),1,'first');
        
        if ismember(start_pulse2(ind),time_to_check)==1
            if ~isempty(t2) && ~isempty(t3)
                range_s=[t2(1):(t3(1)-1)];%/Fs_lfp;
                ts_range_s=tstamps(range_s);
                ts_norm_s=[ts_range_s-time_for_plot(1)];
                rastertics_s=[ts_norm_s];%; tstamps(range3)];
                rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
                bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
                max_ax2=length(bin_vector)/20;
                rastertics_s1=[rastertics_s;rastertics_s];
                plot(rastertics_s1,[0 1]+n,'r','LineWidth',2);plot(rewardind(:,n),[0 1]+n,'bx', 'LineWidth',2);XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
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
                range_u=[t2(1):(t3(1)-1)];%/Fs_lfp;
                ts_range_u=tstamps(range_u);
                ts_norm_u=[ts_range_u-time_for_plot(1)];
                rastertics_u=[ts_norm_u];%; tstamps(range3)];
%                 rewardind(:,:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
                rastertics_u1=[rastertics_u;rastertics_u];                
                bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
                max_ax2=length(bin_vector)/20;
                plot(rastertics_u1,[0 1]+n,'k','LineWidth',2);XLim([0 max_ax2]);%plot(rewardind(:,n),[0 1]+n,'gx'))%;%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
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
end

Output=length(chan_no);
                
