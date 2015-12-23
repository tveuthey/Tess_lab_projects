function [Output]=plot_spontaneous_BMI_neurons(TimeStamps, chan_no,data,wave,start_trial, start_pulse2, x, Fs_lfp,Waves,N,sc,bin_size,space)
% close all;
length_to_analyze=length(data);
block=1:length_to_analyze;
x;
before_zero=round(600*Fs_lfp);
after_zero=round(600*Fs_lfp);
time= (x(1)-before_zero):(x(2)+after_zero);
% total_trials=length(start_pulse2);
% total_PSTHs=round(total_trials/4);
%
% time_for_twopulse=round(18*Fs_lfp);

for i=length(chan_no)
    figure;
    %     subplot(1,2,i)
    %     for n=1:total_trials
    clear  rastertics_u rastertics_s rastertics_u1 rastertics_s1 ts_range_u ts_norm_u ts_range_s ts_norm_s max_ax2
    %         bin_rate_u=[];
    %         bin_rate_s=[];
    time_for_plot=round(time/Fs_lfp);
%     time_to_check=round(start_pulse2(n)-before_zero: start_pulse2(n)+time_for_twopulse);
    
    tstamps1=TimeStamps{chan_no(i),sc};
    tstamps=tstamps1(1:space:end);
    t2=find(tstamps>time_for_plot(1));
    t3=find(tstamps>time_for_plot(end));
    
    waves=Waves{chan_no,sc};
    
    %         ind=find(start_pulse2>start_trial(n),1,'first');
    
    %         if ismember(start_pulse2(ind),time_to_check)==1
    if ~isempty(t2) && ~isempty(t3)
        range_s=[t2(1):(t3(1)-1)];%/Fs_lfp;
        ts_range_s=tstamps(range_s);
        ts_norm_s=[ts_range_s-time_for_plot(1)];
        rastertics_s=[ts_norm_s];%; tstamps(range3)];
        %             rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
        bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
        max_ax2=length(bin_vector);
        %                 rastertics_s1=[rastertics_s;rastertics_s];
        %                 plot(rastertics_s1,[0 1]+n,'r','LineWidth',2);plot(rewardind(:,n),[0 1]+n,'bx', 'LineWidth',2);XLim([0 max_ax2]);%YLim([0 max_trials]);%set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
        %                 hold on
        
        if ~isempty (ts_norm_s)
            if length(ts_norm_s) == 1
                binned_s = histc(ts_norm_s,bin_vector);
            else
                binned_s = histc(ts_norm_s,bin_vector)';
            end
        end
        
        bin_rate_s =[binned_s];
        PEH_rate(i,:)=(bin_rate_s);
        y_max(i,:) = max(PEH_rate(i,:));
        plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],((1*PEH_rate(i,:))/y_max(i,:)),'k','LineWidth',2);XLim([0 max_ax2]);YLim([0 1]);
    end
end
% hold on;




Output=bin_rate_s;

