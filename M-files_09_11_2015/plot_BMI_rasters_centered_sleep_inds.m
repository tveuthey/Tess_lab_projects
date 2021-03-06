function [Output]=plot_BMI_rasters_centered_sleep_inds(TimeStamps, chan_no,data,time_range, time_range2,wave,Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

times=1*Fs_lfp;

% FILTER_ORDER=4;
% END_SMOOTHING=100;
% srate = Fs_lfp;
% nyq_sample=srate/2;
% f_lo=1;
% f_hi=100;
% [b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
% clear final_ind
% final_ind=[];
for n=chan_no
    data_lfp(n,:)=(data(n,:)-mean(data(n,:)))/(2*std(data(n,:)));
    %     data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
end
% ind=find(data_lfpfilt>(-4.5*(std(data_lfpfilt))));

time_to_eval=time_range(1):time_range(end);
% clear time_points
% % time_points=[];
% % for n=1:300
% %     time_points=round([time_points time_range(1)+(10*n)*Fs_lfp]);
% % end

% time_points2
for i=2:length(time_range)
    %         close all;
    
    if (time_range(i)-time_range(i-1))<=1
        disp('not plotting same LFP range')
    else
        if (time_range(i)-time_range(i-1))>1
            %             final_ind=[final_ind SWSpoint(i)];
            figure(i);
            time=(0:1:(2*1017))/Fs_lfp;
            range=round(time_range(i)-times:(time_range(i)+times));
            range_n=round(range/Fs_lfp);
%             for n=chan_no
%                 subplot(1,2,1);
%                 plot(time,(data(n,range)/max(data(n,range)))+(5*i)); hold on;
%                 %                 subplot(3,1,2);
%                 %                 plot(data_lfpfilt(n,range);xlim([0 1*times]); hold on;
%             end
            for n=1:length(chan_no)
                tstamps1=TimeStamps{chan_no(n),sc};
                t2=find(tstamps1>range_n(1));
                t3=find(tstamps1>range_n(end));
                if ~isempty(t2) && ~isempty(t3)
                    range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
                    ts_range2=tstamps1(range2);
                    tstamps{n}=ts_range2;
                    ts_norm{n}=[tstamps{n}-range_n(1)];
                    rastertics{n}=[ts_norm{n}; ts_norm{n}];
                end
            end
            
            for n=1:length(chan_no)
                
                subplot(1,2,1);
                if isempty(tstamps{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    plot(rastertics{n},[0 1]+n,'b');%'Color',c(n+(3*(n-1)),:));
                end
                hold on;
            end
            
        end
        
        
    end
    
end
time_range2=time_range2(1:length(time_range));

for i=2:length(time_range2)
    %         close all;
    
    if (time_range2(i)-time_range2(i-1))<=1
        disp('not plotting same LFP range')
    else
        if (time_range2(i)-time_range2(i-1))>1
            %             final_ind=[final_ind SWSpoint(i)];
            figure(i);
            time=(0:1:(2*1017))/Fs_lfp;
            range2=round(time_range2(i)-times:(time_range2(i)+times));
            range_n2=round(range2/Fs_lfp);
%             for n=chan_no
%                 subplot(1,2,1);
%                 plot(time,(data(n,range)/max(data(n,range)))+(5*i)); hold on;
%                 %                 subplot(3,1,2);
%                 %                 plot(data_lfpfilt(n,range);xlim([0 1*times]); hold on;
%             end
            for n=1:length(chan_no)
                tstamps12=TimeStamps{chan_no(n),sc};
                t22=find(tstamps12>range_n2(1));
                t32=find(tstamps12>range_n2(end));
                if ~isempty(t22) && ~isempty(t32)
                    range22=[t22(1):(t32(1)-1)];%/Fs_lfp;
                    ts_range22=tstamps12(range22);
                    tstamps2{n}=ts_range22;
                    ts_norm2{n}=[tstamps2{n}-range_n2(1)];
                    rastertics2{n}=[ts_norm2{n}; ts_norm2{n}];
                end
            end
            
            for n=1:length(chan_no)
                
                subplot(1,2,1);
                if isempty(tstamps2{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    plot(rastertics2{n},[0 1]+n,'r');%'Color',c(n+(3*(n-1)),:));
                end
                hold on;
            end
           filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S23\2_26_13\TrialSample' num2str(i) '.tiff'];
                    saveas(gcf,filename);
        end
        
        
    end
    
end


Output=rastertics;

