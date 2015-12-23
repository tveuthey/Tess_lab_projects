clear all
lim=10;
reach_trials=[];
per_suc=[];
blocklen=100;
p = 'E:\T31\Day1\';
[unique_rats temp rat_id unique_dates] = find_rats (p);
%[unique_rats temp rat_id unique_dates] = find_rats (p);
%[trial_ls]=find_trials(unique_rats,unique_dates,1,1,p);
temp2 = cellstr(temp);
temp2 = sort_nat(temp2);
n=1;
%PELLET_DROP=1;
trcnt=[];
    for i = 1:length(temp2)-2
        if rem(i,blocklen)==0
            block(i/blocklen)=length(reach_trials);
        end
            tmp = strcat(p,temp2{i+2});
            load(tmp);
            %pause;
            if PELLET_DROP==1 && t_video_drop>.78
               t_video_drop
               reach_trial = view_video (im_lat,1,t_video_drop,t_lat,0)
%             pause;
            reach_trials=[reach_trials reach_trial];
            len_rtr=length(reach_trials);
            trcnt(i)=1;
            %pause;
            if(length(reach_trials))>lim
                tmpper_suc = sum(reach_trials(len_rtr-lim:len_rtr-1))/lim;
            else
                 tmpper_suc = sum(reach_trials)/length(reach_trials);
            end
            
            per_suc = [per_suc, tmpper_suc];
        else
            reach_trial=NaN;
            trcnt(i)=0;
        end
    end
trcnt=trcnt';
%%
block=[];
block(1) = sum(trcnt(1:150));
block(2) = sum(trcnt(151:300))+block(1);
% block(3) = sum(trcnt(201:300))+block(2);
% block(4) = sum(trcnt(301:400))+block(3);

cnt = [10,20,30];
avg=[];
for i = 1:length(cnt)
k=1;
    for j = 1:length(block)
        if j==1
        avg(i,k) = sum(reach_trials(1:cnt(i)))/cnt(i);
        else
        avg(i,k) = sum(reach_trials(block(j-1)+1:block(j-1)+cnt(i)+1))/cnt(i);
        end
    k=k+1;
    avg(i,k) = sum(reach_trials(block(j)-2*cnt(i):block(j)-cnt(i)))/cnt(i);
    k=k+1;
    avg(i,k) = sum(reach_trials(block(j)-cnt(i):block(j)))/cnt(i);
    k=k+1;
    end
end
k=1;
avg2=[];
for j = 1:length(block)
    if j==1
        avg2(k) = sum(reach_trials(1:round(block(j)/2)))/length(reach_trials(1:round(block(j)/2)));
        k=k+1;
        avg2(k) = sum(reach_trials(round(block(j)/2):block(j)))/length(reach_trials(round(block(j)/2):block(j)));
        k=k+1;
    else
        bin = round((block(j)-block(j-1))/2);
        avg2(k) = sum(reach_trials(block(j-1):(block(j-1)+bin)))/length(reach_trials(block(j-1):(block(j-1)+bin)));
        k=k+1;
        avg2(k) = sum(reach_trials(block(j-1)+bin:block(j)))/length(reach_trials(block(j-1)+bin:block(j)));
        k=k+1;
    end
end