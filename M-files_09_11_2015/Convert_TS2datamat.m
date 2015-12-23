function [Task_bin_all]=Convert_TS2datamat(TimeStamps,trial_marker,Fs_lfp,bin,units,len_bef,len_aft)
predur=len_bef;
postdur = len_aft;
trl_len=round(predur+postdur); % in units of seconds (i.e. 0.5 for 500 mseconds).
count_all=0;
count_end=0;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';
units_cnt = 0;
ts_bin=[];
for j =1:length(trial_marker)
    if ~isnan(trial_marker(j))
        uncnt=0;
        clear dn_pre ts* trl_datatmp
        for a = 1: length(units)
            for i = 1:length(units(a).un)
                uncnt = uncnt+1;  
                unit=units(a).un(i);
%                ts_bin=zeros(length(units(a).un),length(bin2));
                ts1=TimeStamps{unit,a+1};
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
                tstmp = ts1(ts1>t(1) & ts1<t(2));
                bin1 = [t(1):bin/Fs_lfp:t(2)];
                tmpbin = histc(tstmp,bin1);
                ts_bin(uncnt,:)=tmpbin;
           %     imagesc(ts_bin); pause;
            end
        end
        if ~isempty(ts_bin)
            count_all=count_all+1;
            Task_bin_all(count_all).A = ts_bin';
            Task_bin_all(count_all).times = [-predur:bin:postdur];
        end
    end
end


