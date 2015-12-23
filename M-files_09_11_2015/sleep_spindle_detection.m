function [ind_sp_pre, ind_sp_post]=sleep_spindle_detection(data,Fs_lfp, sleep_ind_pre, sleep_ind_post)

sws1=[sleep_ind_pre(1):sleep_ind_pre(end)];
sws2=[sleep_ind_post(1):sleep_ind_post(end)];
clear ind_sp_pre ind_sp_post
for i=1:32
    data_pre1(i,:)=data(i,sws1);
    data_post1(i,:)=data(i,sws2);
    data_pre(i,:)=resample(data_pre1(i,:),500,1017);
    data_post(i,:)=resample(data_post1(i,:),500,1017);
    data_pre(i,:)=(data_pre(i,:)-mean(data_pre(i,:)))/std(data_pre(i,:));
    data_post(i,:)=(data_post(i,:)-mean(data_post(i,:)))/std(data_post(i,:));
end


filter_order=4;
low_pass=16;
hi_pass=11;
srate = 500;
nyq_sample=srate/2;
[b,a]=butter(filter_order,[hi_pass low_pass]/nyq_sample);
hil_hi=16;
hil_lo=11;

for n = 1:32
    data_pre_filt(n,:)=abs(filtfilt(b,a,data_pre(n,:)));
    data_pre_filt(n,:)=(data_pre_filt(n,:)-mean(data_pre_filt(n,:)))/std(data_pre_filt(n,:));
    data_pre_hil (n,:)=abs(hilbert2(data_pre_filt(n,:),500,hil_lo,hil_hi,1));
    data_pre_hil(n,:)=data_pre_hil(n,:).^2;
    data_pre_hil(n,:)=(data_pre_hil(n,:)-mean(data_pre_hil(n,:)))/std(data_pre_hil(n,:));
    
    data_post_filt(n,:)=abs(filtfilt(b,a,data_post(n,:)));
    data_post_filt(n,:)=(data_post_filt(n,:)-mean(data_post_filt(n,:)))/std(data_post_filt(n,:));
    data_post_hil (n,:)=abs(hilbert2(data_post_filt(n,:),500,hil_lo,hil_hi,1));
    data_post_hil(n,:)=data_post_hil(n,:).^2;
    data_post_hil(n,:)=(data_post_hil(n,:)-mean(data_post_hil(n,:)))/std(data_post_hil(n,:));
    
end;

TDT_map=[1 10 26 17;3 12 28 19;5 14 30 21; 7 16 32 23; 2 9 25 18; 4 11 27 20; 6 13 29 22; 8 15 31 24];

avg_hil=(mean(cat(2,data_pre_hil,data_post_hil),2));
% avg_post_hil=mean(mean(data_post_hil));

for i=1:32
    ind_sp_pk_5pre{i}=find(data_pre_hil(i,:)>5*avg_hil(i,:));
    ind_sp_pk_2pre{i}=find(data_pre_hil(i,:)>2*avg_hil(i,:));
    
    ind_sp_pk_5post{i}=find(data_post_hil(i,:)>5*avg_hil(i,:));
    ind_sp_pk_2post{i}=find(data_post_hil(i,:)>2*avg_hil(i,:));
end
ind_sp_pre=[];
for i=1:32
    ind_sp_pk_5=ind_sp_pk_5pre{i};
    ind_sp_pk_2=ind_sp_pk_2pre{i};
    for n=1:length(ind_sp_pk_5pre)
        pre1=find(ind_sp_pk_2<ind_sp_pk_5);
        if isempty(pre1)==1
            disp('no beginning found')
        else
            pre1=pre1(end);
        end
        pre2=find(ind_sp_pk_2>ind_sp_pk_5,2,'first');
        if isempty(pre2)==1
            disp('no end found')
        else
            pre2=pre2;
        end
        if isempty(pre1)==1
            disp('no beginning found')
        else
            if isempty(pre2)==1
                disp('no end found')
            else
                if pre2-pre1<0.33*500
                    disp('too short')
                else
                    if pre2-pre1>3*500
                        disp('too long')
                    else
                        ind_sp_pre=[ind_sp_pre ind_sp_pk_5];
                    end
                end
            end
        end
    end
    ind_sp_pre{i}=(ind_sp_pre);
end

ind_sp_post=[];
for i=1:32
    ind_sp_pk_5=ind_sp_pk_5post{i};
    ind_sp_pk_2=ind_sp_pk_2post{i};
    for n=1:length(ind_sp_pk_5)
        post1=find(ind_sp_pk_2<ind_sp_pk_5);
        if isempty(post1)==1
            disp('no beginning found')
        else
            post1=post1(end);
        end
        post2=find(ind_sp_pk_2>ind_sp_pk_5,2,'first');
        if isempty(post2)==1
            disp('no end found')
        else
            post2=post2;
        end
        if isempty(pre1)==1
            disp('no beginning found')
        else
            if isempty(post2)==1
                disp('no end found')
            else
                if post2-post1<0.33*500
                    disp('too short')
                else
                    if post2-post1>3*500
                        disp('too long')
                    else
                        ind_sp_post=[ind_sp_post ind_sp_pk_5];
                    end
                end
            end
        end
    end
%     ind_sp_post1=find(diff(ind_sp_post)<0.125*500);
    ind_sp_post{i}=(ind_sp_post);
end

end












