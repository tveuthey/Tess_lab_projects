function [Output]=plot_BMI_rasters_stacked(TimeStamps, chan_no,data,time_range,wave,Fs_lfp,Waves,N,sc,bin_size,space)
% close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

times=10*Fs_lfp;

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

time_to_eval=time_range(1):time_range(2);
clear time_points
time_points=[];
for n=1:300
    time_points=round([time_points time_range(1)+(10*n)*Fs_lfp]);
end

% time_points2
for i=2:length(time_points)
    %         close all;
    
    if (time_points(i)-time_points(i-1))<=1
        disp('not plotting same LFP range')
    else
        if (time_points(i)-time_points(i-1))>1
            %             final_ind=[final_ind SWSpoint(i)];
            time=(0:1:(10*1017))/Fs_lfp;
            range=round(time_points(i):(time_points(i)+times));
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
                    plot(rastertics{n},[0 1]+(5*i),'b');%'Color',c(n+(3*(n-1)),:));
                end
                hold on;
            end
            
        end
        
        
    end
    
end


time_to_eval=time_range(1):time_range(2);
clear time_pointsp
time_pointsp=[];
for n=1:300
    time_pointsp=round([time_pointsp time_range(2)+(10*n)*Fs_lfp]);
end
for i=2:length(time_pointsp)
    %         close all;
    
    if (time_pointsp(i)-time_pointsp(i-1))<=1
        disp('not plotting same LFP range')
    else
        if (time_pointsp(i)-time_pointsp(i-1))>1
            %             final_ind=[final_ind SWSpoint(i)];
            time=(0:1:(10*1017))/Fs_lfp;
            rangep=round(time_pointsp(i):(time_pointsp(i)+times));
            range_np=round(rangep/Fs_lfp);
%             for n=chan_no
%                 subplot(1,2,1);
%                 plot(time,(data(n,range)/max(data(n,range)))+(5*i)); hold on;
%                 %                 subplot(3,1,2);
%                 %                 plot(data_lfpfilt(n,range);xlim([0 1*times]); hold on;
%             end
            for n=1:length(chan_no)
                tstamps1p=TimeStamps{chan_no(n),sc};
                t2p=find(tstamps1p>range_np(1));
                t3p=find(tstamps1p>range_np(end));
                if ~isempty(t2p) && ~isempty(t3p)
                    range2p=[t2p(1):(t3p(1)-1)];%/Fs_lfp;
                    ts_range2p=tstamps1p(range2p);
                    tstampsp{n}=ts_range2p;
                    ts_normp{n}=[tstampsp{n}-range_np(1)];
                    rasterticsp{n}=[ts_normp{n}; ts_normp{n}];
                end
            end
            
            for n=1:length(chan_no)
                
                subplot(1,2,2)
                if isempty(tstampsp{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    plot(rasterticsp{n},[0 1]+(5*i),'r');%'Color',c(n+(3*(n-1)),:));
                end
                hold on;
            end
            
        end
        
        
    end
    
end


Output=rastertics;

