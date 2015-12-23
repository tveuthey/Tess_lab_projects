function [Output]=plot_BMI_PETH(TimeStamps, chan_no,data,wave,sleep_ind, Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(0.4*Fs_lfp);
after_zero=round(0.4*Fs_lfp);
% time= (sleep_ind(1)-before_zero):(x(2)+after_zero);
% total_trials=length(start_pulse2);
% total_PSTHs=round(total_trials/4);
%
% time_for_twopulse=round(18*Fs_lfp);
c= colormap;
for i=length(chan_no)
    figure;
    %     subplot(1,2,i)
    %     for n=1:total_trials
    clear  rastertics  ts_range ts_norm  max_ax2
    %         bin_rate_u=[];
    %         bin_rate_s=[];
    for n= 1:length(sleep_ind)
        clear tstamps tstamps1 t2 t3 ts_range
        time_for_plot= round(((sleep_ind(n)-before_zero):(sleep_ind(n)+after_zero))/Fs_lfp);
        %     time_to_check=round(start_pulse2(n)-before_zero: start_pulse2(n)+time_for_twopulse);
        
        tstamps1=TimeStamps{chan_no(i),sc};
        tstamps=tstamps1(1:space:end);
        t2=find(tstamps>time_for_plot(1));
        t3=find(tstamps>time_for_plot(end));
        
        waves=Waves{chan_no,sc};
        
        %         ind=find(start_pulse2>start_trial(n),1,'first');
        
        %         if ismember(start_pulse2(ind),time_to_check)==1
        if ~isempty(t2) && ~isempty(t3)
            range=[t2(1):(t3(1)-1)];%/Fs_lfp;
            ts_range=tstamps(range);
            ts_norm{n}=[ts_range-time_for_plot(1)];
            rastertics{n}=[ts_norm{n}; ts_norm{n}];%; tstamps(range3)];
            %             rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
            bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
            max_ax2=length(bin_vector)/40;
            %                 rastertics_s1=[rastertics_s;rastertics_s];
            %                 plot(rastertics_s1,[0 1]+n,'r','LineWidth',2);plot(rewardind(:,n),[0 1]+n,'bx', 'LineWidth',2);XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
            %                 hold on
            
            if ~isempty (ts_norm{n})
                if length(ts_norm{n}) == 1
                    binned = histc(ts_norm{n},bin_vector);
                else
                    binned = histc(ts_norm{n},bin_vector)';
                end
            end
            
            bin_rate(n,:) =[binned];
        end
    end
    PEH_rate(i,:)=mean(bin_rate);
    y_max(i,:) = max(PEH_rate(i,:));
    subplot(2,1,1)
    plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],((1*PEH_rate(i,:))/y_max(i,:)),'Color',c(i+(2*(i-1)),:),'LineWidth',2);XLim([0 max_ax2]);%YLim([0 1]);
    %     hold on;
    for n=1:length(sleep_ind)
        
        subplot(2,1,2);
        if isempty(ts_norm{n})==1
            disp('not plotting this channels raster')
        else
            c=colormap;
            plot(rastertics{n},[0 1]+n,'Color',c(10,:))
        end
        hold on;
    end
    
    
end
Output=PEH_rate;






