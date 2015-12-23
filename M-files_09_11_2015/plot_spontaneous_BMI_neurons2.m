function [Output]=plot_spontaneous_BMI_neurons2(TimeStamps, chan_no,data,sleep_ind, Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(0.5*Fs_lfp);
after_zero=round(0.5*Fs_lfp);



for i=length(chan_no)
    clear PEH_rate y_max
    figure (chan_no(i));
    for n=1:length(sleep_ind)
        clear   ts_range  max_ax2
        
        time_for_plot=round((sleep_ind(n)-before_zero: sleep_ind(n)+after_zero)/Fs_lfp);
        %     time_to_check=round(start_pulse2(n)-before_zero: start_pulse2(n)+time_for_twopulse);
        
        tstamps1=TimeStamps{chan_no(i),sc};
        tstamps=tstamps1(1:space:end);
        t2=find(tstamps>time_for_plot(1));
        t3=find(tstamps>time_for_plot(end));
        
        waves=Waves{chan_no,sc};
        
        if ~isempty(t2) && ~isempty(t3)
            range=[t2(1):(t3(1)-1)];
            ts_range=tstamps(range);
            ts_norm{n}=[ts_range-time_for_plot(1)];
            rastertics{n}=[ts_norm{n}; ts_norm{n}];
            %             rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
            bin_vector = [(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)];
            max_ax2=length(bin_vector)/100;
            
            
            if ~isempty (ts_norm{n})
                if length(ts_norm{n}) == 1
                    binned = histc(ts_norm{n},bin_vector);
                else
                    binned = histc(ts_norm{n},bin_vector)';
                end
             bin_rate(n,:) =[binned];
            end
            
           
        end
        for n=1:length(chan_no)
            
            
            %             if isempty(ts_norm{n})==1
            %                 disp('not plotting this channels raster')
            %             else
            %                 c=colormap;
            %                 figure (chan_no(i));
            %                 subplot(2,1,2);
            %                 plot(rastertics{n},[0 1]+n,'k');%ylim([0 length(sleep_ind)+2])
            %             end
            %             hold on;
        end
    end
    for n=1:length(sleep_ind)
        if isempty(ts_norm{n})==1
            disp('not plotting this channels raster')
        else
            c=colormap;
            figure (chan_no(i));
            subplot(2,1,2);
            plot(rastertics{n},[0 1]+n,'b', 'Linewidth',2);ylim([0 length(sleep_ind)+2])
        end
        hold on;
    end
    PEH_rate(i,:)=mean(bin_rate(:,:));
    y_max(i,:) = max(PEH_rate(i,:));
    figure (chan_no(i));
    subplot(2,1,1)
    plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],((1*PEH_rate(i,:))/y_max(i,:)),'r','LineWidth',2);XLim([0 max_ax2]);YLim([0 1]);
end

Output=PEH_rate;

