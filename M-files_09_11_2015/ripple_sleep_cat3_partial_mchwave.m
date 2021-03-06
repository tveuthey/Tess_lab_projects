function [hold_s1d_tpre, ripl_pre, hold_s1d_tpost, ripl_post, change]=ripple_sleep_cat3_partial(units,lim,TimeStamps,sleep_ind_pre,sleep_ind_post,data, Fs_lfp, chan_no,sc, freq)
close all

% if isempty(chan_no)==1
%         nch = 1;
% else nch=0;
% end
    
for i=1:length(units)
    Mov=zeros(4,8,Fs_lfp);
    Peaks_diff = zeros(4,8);
    X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3];
    Y_loc = [8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5,8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5];
    meagrid = [8,15,31,24,6,13,29,22,15,13,11,9,16,14,12,10,31,29,27,25,32,30,28,26,24,22,20,18,23,21,19,17];
    close;
    unit=units(i);
    
    lim1=lim(1);
    lim2=lim(2);
    lim3=lim(3);
   
    for ch = 1:32
        chan_no = [ch];
        if chan_no==1
            loc=[8];
        elseif chan_no==2
            loc=[4];
        elseif chan_no==3
            loc=[7];
        elseif chan_no==4
            loc=[3];
        elseif chan_no==5
            loc=[6];
        elseif chan_no==6
            loc=[2];
        elseif chan_no==7
            loc=[5];
        elseif chan_no==8
            loc=[1];
        elseif chan_no==9
            loc=[12];
        elseif chan_no==10
            loc=[16];
        elseif chan_no==11
            loc=[11];
        elseif chan_no==12
            loc=[15];
        elseif chan_no==13
            loc=[10];
        elseif chan_no==14
            loc=[14];
        elseif chan_no==15
            loc=[9];
        elseif chan_no==16
            loc=[13];
        elseif chan_no==17
            loc=[32];
        elseif chan_no==18
            loc=[28];
        elseif chan_no==19
            loc=[31];
        elseif chan_no==20
            loc=[27];
        elseif chan_no==21
            loc=[30];
        elseif chan_no==22
            loc=[26];
        elseif chan_no==23
            loc=[29];
        elseif chan_no==24
            loc=[25];
        elseif chan_no==25
            loc=[20];
        elseif chan_no==26
            loc=[24];
        elseif chan_no==27
            loc=[19];
        elseif chan_no==28
            loc=[23];
        elseif chan_no==29
            loc=[18];
        elseif chan_no==30
            loc=[22];
        elseif chan_no==31
            loc=[17];
        elseif chan_no==32
            loc=[21];
        end
        
   temp1=(data([chan_no],:));
   temp=base_norm(temp1);
%     if length(chan_no)==1
%         temp1=(data([chan_no],:));
%         temp=base_norm(temp1);
%     else
%         temp1=(median(data([chan_no],:)));
%         temp=base_norm(temp1);
%     end
%     
    
%     if isempty(TimeStamps{chan_no,sc})==1
%         disp('no need to interpolate around spikes')
%     else
%      if isnan(TimeStamps{chan_no,sc})==1
%           disp('no need to interpolate around spikes')
%      else 
%          TS_tr=round(TimeStamps{chan_no,sc}*Fs_lfp);
%          tic
%          for i=1:100%:length(TS_tr)
%              
%              temp2=interp1(1:length(temp),temp,((TS_tr(i)-2):(TS_tr(i)+8)));
%              temp= [temp(1,1:(TS_tr(i)-3)),temp2,temp(1,(TS_tr(i)+9):end)];
% %              temp=cat(2,[temp(:,1:(TS_tr(i)-3))],temp2,[temp(:,(TS_tr(i)+9):end)]);
%              
% %             disp('i')
%          end
%          toc
%      end
%     end

    
    
    srate = Fs_lfp;
    nyq_sample=srate/2;
    if freq==1
        
        FILTER_ORDER=3;
        f_lo=3;
        f_hi=0.3;
        [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
%         [b2,a2]=cheby2(FILTER_ORDER,20,[f_hi f_lo]/nyq_sample);
        temp=(filtfilt(b2,a2,temp));
        
    else
        if freq==2
           
            FILTER_ORDER=5;
            f_lo=18;
            f_hi=8;
            [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
%            [b2,a2]=cheby1(FILTER_ORDER,20,[f_hi f_lo]/nyq_sample);
            temp=(filtfilt(b2,a2,temp));
        else
            if freq==3
%                 
%                 
                FILTER_ORDER=4;
                f_lo=8;
                f_hi=4;
                [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
                temp=(filtfilt(b2,a2,temp));

            end
        end
    end
    temp1=(temp-mean(temp))/(std(temp));
    TS10=TimeStamps{unit,sc}*Fs_lfp;
    len=1016;
    clear TS10_s1 TS10_s2
    TS10_s1=[];
    TS10_s2=[];
    length_sws = 0;
    for n=1:size(sleep_ind_pre,1)        
        %     clear TS10_s1
        sws1=[sleep_ind_pre(n,1):sleep_ind_pre(n,2)];
        % sws2=[sleep_ind_post(1):sleep_ind_post(end)];
        %     figure
        s_ts=find(TS10>sws1(1));
        e_ts=find(TS10<sws1(end));
        ts=intersect(s_ts,e_ts);
        % TS10_s1=TS10(ts);
        TS10_s1=[TS10_s1 TS10(ts)];
        size(TS10_s1);
        length_sws = length_sws+(sleep_ind_pre(n,2) - sleep_ind_pre(n,1));
        if length_sws>600000
            break;
        end
        
    end
    
%   trllngth = 'full';
    trllngth = 'half';    
    
    % hold_rip1=[];
        Num=length(TS10_s1);
    
%     if trllngth == 'half'
%      Num=length(TS10_s1);
%     %%% First Half_trial
%     Num2=round(length(TS10_s1)/2);
%     
%     %%% Second Half_trial
%     end   
    disp('Num')
    hold_s1d=zeros(Num,len);
%    
    for n=1:Num
        ind=round(TS10_s1(n));
        pre_ind=ind-round(len/2)+1;
        post_ind=ind+round(len/2);
        hold_s1d(n,:)=temp1(pre_ind:post_ind);
        %     hold_rip1=[hold_rip1, hold_s1d(n,:)];
    end
    
    hold_s1d_tp=hold_s1d';
    hold_s1d_tpre=hold_s1d;
    ripl_pre=reshape(hold_s1d_tp,1,(Num*len));
    sta=mean(hold_s1d);
    sta_min1=min(sta(:,lim1:lim3));
    sta_max1=max(sta(:,lim1:lim2));
    sta_max2=max(sta(:,lim2:lim3));
    sta_max3=(sta_max1+sta_max2)/2;
    subplot(4,8,loc); 
    Mov_pre(X_loc,y_loc,:)=sta;    
    if chan_no==unit
        spcol = 'Yellow'
    else spcol = 'White';
    end
    
    set(subplot(4,8,loc),'Color',spcol)
    peak1=sta_max3-sta_min1;
%     plot(sta-mean(sta),'LineWidth',3)
    sta_sd=std(hold_s1d)/sqrt(Num-1); hold on;
%     plot((sta-mean(sta))+(2*sta_sd));
%     plot((sta-mean(sta))-(2*sta_sd));
%     
    shadedErrorBar([],(sta-mean(sta)),(1 *sta_sd),'g',0)
    xlim([0 1017]);
   
%     plot((sta-mean(sta))+(1*sta_sd));
%     plot((sta-mean(sta))-(1*sta_sd));
    hold on;
    length_sws = 0;
    
    for n=1:size(sleep_ind_post,1)
        %     clear TS10_s1
        % sws1=[sleep_ind_pre(n,1):sleep_ind_pre(n,2)];
        sws2=[sleep_ind_post(n,1):sleep_ind_post(n,2)];
        s_ts=find(TS10>sws2(1));
        e_ts=find(TS10<sws2(end));
        ts=intersect(s_ts,e_ts);
        TS10_s2=[TS10_s2 TS10(ts)];
        length_sws = length_sws+(sleep_ind_post(n,2) - sleep_ind_post(n,1));
        if length_sws>600000
            break;
        end
    end
    
%     if trllngth == 'half'
%     
%     %%%% First Half_trial
% %     Num=round(length(TS10_s2)/2);
%     
%     %%%% Second Half_trial
%     else
    
    Num=length(TS10_s2);
    disp('Num')
    hold_s1d=zeros(Num,len);
    
    for n=1:Num
        ind=round(TS10_s2(n));
        pre_ind=ind-round(len/2)+1;
        post_ind=ind+round(len/2);
        hold_s1d(n,:)=temp1(pre_ind:post_ind);
    end
    
    hold_s1d_tp=hold_s1d';
    hold_s1d_tpost=hold_s1d;
    ripl_post=reshape(hold_s1d_tp,1,(Num*len));
    sta=mean(hold_s1d);
    sta_min2=min(sta(:,lim1:lim3));
    sta_max2=max(sta(:,lim2:lim3));
    sta_max1=max(sta(:,lim1:lim2));
    sta_max3=(sta_max1+sta_max2)/2;
    peak2=sta_max3-sta_min2;
    sta_sd=std(hold_s1d)/sqrt(Num-1);
    hold on
%     Mov_pre(X_loc,y_loc,:)=sta;
    shadedErrorBar([],(sta-mean(sta)),(1*sta_sd),'r',0)
%      pause;
    Mov_post(X_loc,y_loc,:)=sta;
    Mov_diff = Mov_post - Mov_pre;
    change1=((peak2-peak1)/peak1)*100;
    c=['change' num2str(unit)];
    change{i}=change1;
    Session='T12_allblocks\censored\Session1_allch\';
    Dur='10mins'
    if chan_no == unit
        if freq==1
            t=['Pre-Post SWA' Dur 'Ch' num2str(unit)];
        elseif freq==2
            t=['Pre-Post Spindle' Dur 'Ch' num2str(unit)];
        else
            t=['Pre-Post Theta' Dur 'Ch' num2str(unit)];
        end
      title(t)
    end
      
    xlab=['averaged to' num2str([chan_no])];
    xlabel(xlab);
   Peaks_diff(chan_no,1)=change1;
%    Peaks_diff(ch,2)=stdev();
   
    end
    
    % plot(sta-mean(sta),'r','LineWidth',3);
    % plot((sta-mean(sta))+sta_sd,'r');
    % plot((sta-mean(sta))-sta_sd,'r');
    
    if sc==2
        if freq==1
            filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep SWA post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
        else
            if freq==2
                filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep Spindle post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
            else
                if freq==3
                    filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep Theta post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
                end
            end
        end
    else
        if sc==3
            if freq==1
                filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep SWA post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
            else
                if freq==2
                    filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep Spindle post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
                else
                    if freq==3
                        filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'Sleep Theta post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
                    end
                end
            end
        end
    end
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    set(gcf,'color','w');
    f = getframe(gcf); imwrite(f.cdata,filename,'Resolution',[2000 2000])
    pause;
    
    figure;
    Peaks_diff = reshape(Peaks_diff,4,8);
%      filename = strcat('bar',filename);
    bar3(Peaks_diff)
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    set(gcf,'color','w');
    f = getframe(gcf); imwrite(f.cdata,filename,'Resolution',[1000 1000])
  pause;
end






