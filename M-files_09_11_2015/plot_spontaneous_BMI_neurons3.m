function [Output]=plot_spontaneous_BMI_neurons3(TimeStamps, chan_no,data,sleep_ind1,sleep_ind2, Fs_lfp,Waves,N,sc,bin_size,space, factor)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

before_zero=round(0.5*Fs_lfp);
after_zero=round(0.5*Fs_lfp);



for i=1:length(chan_no)
    if N{chan_no(i),sc}<=10
        disp(i)
        disp('channel is empty')
    else
        if N{chan_no(i),sc}<=100 && N{chan_no(i),sc}>=10
            disp(i)
            disp('Less spikes - not analyzed')
        else
            figure(i)
            clear PEH_rate y_max PEH_ratep y_maxp
            
            for n=1:length(sleep_ind1)
                clear   ts_range  max_ax2
                
                time_for_plot=round((sleep_ind1(n)-before_zero: sleep_ind1(n)+after_zero)/Fs_lfp);
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
                    max_ax2=length(bin_vector)/factor;
                    
                    
                    if ~isempty (ts_norm{n})
                        if length(ts_norm{n}) == 1
                            binned = histc(ts_norm{n},bin_vector);
                        else
                            binned = histc(ts_norm{n},bin_vector)';
                        end
                        bin_rate(n,:) =[binned];
                    end
                end
            end
            for n=1:length(sleep_ind1)
                if isempty(ts_norm{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    %                     figure (chan_no(i));
                    subplot(2,2,3);
                    plot(rastertics{n},[0 1]+n,'b', 'Linewidth',2);ylim([0 length(sleep_ind1)+2])
                end
                hold on;
            end
            PEH_rate(i,:)=mean(bin_rate(:,:));
            var_rate(i,:)=std(bin_rate(:,:));
            y_max(i,:) = max(PEH_rate(i,:));
            %             figure (chan_no(i));
            subplot(2,2,1)
            plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],PEH_rate(i,:),'r','LineWidth',2);XLim([0 max_ax2]);%YLim([0 1]);
            hold on; plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],[PEH_rate(i,:)+(var_rate(i,:))],'r','LineWidth',1);XLim([0 max_ax2]);
            hold on; plot ([(time_for_plot(1):bin_size:time_for_plot(end))-time_for_plot(1)],[PEH_rate(i,:)-(var_rate(i,:))],'r','LineWidth',1);XLim([0 max_ax2]);
            titlename=['S34 Pre Bin 0.01 Ch' num2str(chan_no(i))];
            title(titlename)
            
            
            
            for n=1:length(sleep_ind2)
                clear   ts_rangep  max_ax2p
                
                time_for_plotp=round((sleep_ind2(n)-before_zero: sleep_ind2(n)+after_zero)/Fs_lfp);
                %     time_to_check=round(start_pulse2(n)-before_zero: start_pulse2(n)+time_for_twopulse);
                
                tstamps1p=TimeStamps{chan_no(i),sc};
                tstampsp=tstamps1p(1:space:end);
                t2p=find(tstampsp>time_for_plotp(1));
                t3p=find(tstampsp>time_for_plotp(end));
                
                wavesp=Waves{chan_no,sc};
                
                if ~isempty(t2p) && ~isempty(t3p)
                    rangep=[t2p(1):(t3p(1)-1)];
                    ts_rangep=tstampsp(rangep);
                    ts_normp{n}=[ts_rangep-time_for_plotp(1)];
                    rasterticsp{n}=[ts_normp{n}; ts_normp{n}];
                    %             rewardind(:,n)=start_pulse2(ind)/Fs_lfp- time_for_plot(1);
                    bin_vectorp = [(time_for_plotp(1):bin_size:time_for_plotp(end))-time_for_plotp(1)];
                    max_ax2p=length(bin_vectorp)/factor;
                    
                    
                    if ~isempty (ts_normp{n})
                        if length(ts_normp{n}) == 1
                            binnedp = histc(ts_normp{n},bin_vectorp);
                        else
                            binnedp = histc(ts_normp{n},bin_vectorp)';
                        end
                        bin_ratep(n,:) =[binnedp];
                    end
                end
            end
            for n=1:length(sleep_ind2)
                if isempty(ts_normp{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    %                     figure (chan_no(i));
                    subplot(2,2,4);
                    plot(rasterticsp{n},[0 1]+n,'b', 'Linewidth',2);ylim([0 length(sleep_ind2)+2])
                end
                hold on;
            end
            PEH_ratep(i,:)=mean(bin_ratep(:,:));
            var_ratep(i,:)=sqrt(var(bin_ratep(:,:)));
            y_maxp(i,:) = max(PEH_ratep(i,:));
            %             figure (chan_no(i));
            subplot(2,2,2)
            plot ([(time_for_plotp(1):bin_size:time_for_plotp(end))-time_for_plotp(1)],PEH_ratep(i,:),'r','LineWidth',2);XLim([0 max_ax2p]);%YLim([0 1]);
            hold on; plot ([(time_for_plotp(1):bin_size:time_for_plotp(end))-time_for_plotp(1)],[PEH_ratep(i,:)+var_ratep(i,:)],'r','LineWidth',1);XLim([0 max_ax2p]);
            hold on; plot ([(time_for_plotp(1):bin_size:time_for_plotp(end))-time_for_plotp(1)],[PEH_ratep(i,:)-var_ratep(i,:)],'r','LineWidth',1);XLim([0 max_ax2p]);
            titlename=['S34 Post Bin 0.01 Ch' num2str(chan_no(i))];
            title(titlename)
            
        end
        filename=['C:\Users\Ganguly VA1\Documents\MATLAB\Tanuj\BMI\S34\S34 Pre Bin 0.01 Ch' num2str(chan_no(i)) '.tiff'];
        %             saveas(gcf,filename);
        %             close;
    end
end

Output=PEH_rate;

