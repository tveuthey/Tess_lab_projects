function [Output]=multitaper_LFP_FFT(data, sleep_ind_pre, sleep_ind_post_early, sleep_ind_post_late )

data=median(data);

l1=length(sleep_ind_pre(1):sleep_ind_pre(end));
l2=length(sleep_ind_post_early(1):sleep_ind_post_early(end));
l3=length(sleep_ind_post_late(1):sleep_ind_post_late(end));

l=min([l1 l2 l3]);

if l==l1
    
    sleep_ind_pre1=[sleep_ind_pre(1):sleep_ind_pre(end)];
    sleep_ind_post_early1=sleep_ind_post_early(1):sleep_ind_post_early(end);
    sleep_ind_post_early1=sleep_ind_post_early1(1:length(sleep_ind_pre1));
    sleep_ind_post_late1=sleep_ind_post_late(1):sleep_ind_post_late(end);
    sleep_ind_post_late1=sleep_ind_post_late1(1:length(sleep_ind_pre1));
else
    if l==l2       
        
        sleep_ind_post_early1=sleep_ind_post_early(1):sleep_ind_post_early(end);
        sleep_ind_pre1=[sleep_ind_pre(1):sleep_ind_pre(end)];
        sleep_ind_pre1=sleep_ind_pre1(1:length(sleep_ind_post_early1));
        sleep_ind_post_late1=sleep_ind_post_late(1):sleep_ind_post_late(end);
        sleep_ind_post_late1=sleep_ind_post_late1(1:length(sleep_ind_post_early1));
    else
        if l==l3
            
            sleep_ind_post_late1=sleep_ind_post_late(1):sleep_ind_post_late(end);
            sleep_ind_post_early1=sleep_ind_post_early(1):sleep_ind_post_early(end);
            sleep_ind_post_early1=sleep_ind_post_early1(1:length(sleep_ind_post_late1));
            sleep_ind_pre1=[sleep_ind_pre(1):sleep_ind_pre(end)];
            sleep_ind_pre1=sleep_ind_pre1(1:length(sleep_ind_post_early1));
            
            
        end
    end
end

if length(sleep_ind_pre1)~=length(sleep_ind_post_early1)
    disp('Pre and Post Early Not Equal')
else
    if length(sleep_ind_pre1)~=length(sleep_ind_post_late1)
        disp('Pre and Post Late Not Equal')
    else
        if length(sleep_ind_post_early1)~=length(sleep_ind_post_late1)
            disp('Post Early and Post Late Not Equal')
        else
            disp('ALL equal')
        end
    end
end


sws1=round(([sleep_ind_pre1(1):sleep_ind_pre1(end)]))%/Fs_lfp);
disp(length(sws1))
sws2=round(([sleep_ind_post_early1(1):sleep_ind_post_early1(end)]))%/Fs_lfp);
disp(length(sws2))
sws3=round(([sleep_ind_post_late1(1):sleep_ind_post_late1(end)]))%/Fs_lfp);
disp(length(sws3))

data_pre=data(:,sws1);
data_pre=data(:,sws1);
















