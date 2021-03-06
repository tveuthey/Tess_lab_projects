function [Output]=plot_trials_succession_nearLFP(TimeStamps, chan_no,data,wave,Fs_lfp,Waves,N,sc,bin_size,space)
close all;
length_to_analyze=length(data);
block=1:length_to_analyze;

times=1*Fs_lfp;

FILTER_ORDER=4;
END_SMOOTHING=100;
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=1;
f_hi=100;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
clear final_ind SWSpoint
final_ind=[];
SWSpoint=[];
for n=1
    data_lfp(n,:)=(data(n,:)-mean(data(n,:)))/(2*std(data(n,:)));
    data_lfpfilt(n,:)=filter(b,a,data_lfp(n,:));
end
ind1=find(data_lfpfilt<(-3.5*(std(data_lfpfilt))));
ind2=find(data_lfpfilt<(-4.5*(std(data_lfpfilt))));
for n=1:length(ind1)
    if ismember(ind1,ind2)==1
        disp('- - -')
    else
        SWSpoint=[SWSpoint ind1];
    end
end

for i=2:length(SWSpoint)
        close all;
    
    if (SWSpoint(i)-SWSpoint(i-1))<=1
        disp('not plotting same LFP range')
    else
        if (SWSpoint(i)-SWSpoint(i-1))>1
            final_ind=[final_ind SWSpoint(i)];
            figure; hold on;
            range=round((SWSpoint(i)-times):(SWSpoint(i)+times));
            range_n=round(range/Fs_lfp);
            for n=1
                subplot(3,1,1);
                plot(data(n+(2*(n-1)),range));xlim([0 2*times]); hold on;
                subplot(3,1,2);
                plot(data_lfpfilt(n+(2*(n-1)),range));xlim([0 2*times]); hold on;
            end
            for n=1:length(chan_no)
                tstamps1=TimeStamps{chan_no(n),sc};
                t2=find(tstamps1>range_n(1));
                t3=find(tstamps1>range_n(end));
                if ~isempty(t2) && ~isempty(t3)
                    range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
                    ts_range2=tstamps1(range2);
                    tstamps{n}=ts_range2;
                    rastertics{n}=[tstamps{n}; tstamps{n}];
                end
            end
            
            for n=1:length(chan_no)
                
                subplot(3,1,3);
                if isempty(tstamps{n})==1
                    disp('not plotting this channels raster')
                else
                    c=colormap;
                    plot(rastertics{n},[0 1]+n,'Color',c(n+(3*(n-1)),:));ylim([0 17])
                end
                hold on;
            end
            pause
        end
        
        
    end
   
end

Output=SWSpoint;

