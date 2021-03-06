function [hold_s1d_tpre, ripl_pre, hold_s1d_tpost, ripl_post, change]=ripple_sleep_cat2(units,lim,TimeStamps,sleep_ind_pre,sleep_ind_post,data, Fs_lfp, chan_no,sc, freq)
close all

for i=1:length(units)
    close;
    unit=units(i);
    
    lim1=lim(1);
    lim2=lim(2);
    lim3=lim(3);
    
    if isempty(chan_no)==1
        if unit==1
            chan_no=[3];
        else
            if unit==2
                chan_no=[4];
            else
                if unit==3
                    chan_no=[6];
                else if unit==4
                        chan_no=[6];
                    else if unit==5
                            chan_no=[7];
                        else if unit==6
                                chan_no=[8];
                            else if unit==7
                                    chan_no=[2];
                                else if unit==8
                                        chan_no=[15];
                                    else if unit==9
                                            chan_no=[11];
                                        else if unit==10
                                                chan_no=[12];
                                            else if unit==11
                                                    chan_no=[13];
                                                else if unit==12
                                                        chan_no=[14];
                                                    else if unit==13
                                                            chan_no=[15];
                                                        else if unit==14
                                                                chan_no=[16];
                                                            else if unit==15
                                                                    chan_no=[31];
                                                                else if unit==16
                                                                        chan_no=[9];
                                                                    else if unit==17
                                                                            chan_no=[19];
                                                                        else if unit==18
                                                                                chan_no=[20];
                                                                            else if unit==19
                                                                                    chan_no=[21];
                                                                                else if unit==20
                                                                                        chan_no=[22];
                                                                                    else if unit==21
                                                                                            chan_no=[23];
                                                                                        else if unit==22
                                                                                                chan_no=[24];
                                                                                            else if unit==23
                                                                                                    chan_no=[21];
                                                                                                else if unit==24
                                                                                                        chan_no=[31];
                                                                                                    else if unit==25
                                                                                                            chan_no=[27];
                                                                                                        else if unit==26
                                                                                                                chan_no=[28];
                                                                                                            else if unit==27
                                                                                                                    chan_no=[29];
                                                                                                                else if unit==28
                                                                                                                        chan_no=[30];
                                                                                                                    else if unit==29
                                                                                                                            chan_no=[31];
                                                                                                                        else if unit==30
                                                                                                                                chan_no=[32];
                                                                                                                            else if unit==31
                                                                                                                                    chan_no=[15];
                                                                                                                                else if unit==32
                                                                                                                                        chan_no=[25];
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        
                                        
                                    end
                                end
                            end
                        end
                    end
                    
                end
                
            end
        end
    else
        disp('using' )
        disp(chan_no)
    end
    
    
    if length(chan_no)==1
        temp1=(data([chan_no],:));
        temp=base_norm(temp1);
    else
        temp1=(mean(data([chan_no],:)));
        temp=base_norm(temp1);
    end
 
    srate = Fs_lfp;
    nyq_sample=srate/2;
    if freq==1
        
        FILTER_ORDER=3;
        f_lo=3;
        f_hi=0.3;
        [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
        temp=(filtfilt(b2,a2,temp));
        
    else
        if freq==2
            
            
            FILTER_ORDER=5;
            f_lo=18;
            f_hi=8;
            [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
            temp=(filtfilt(b2,a2,temp));
        else
            if freq==3
                
                
                FILTER_ORDER=5;
                f_lo=250;
                f_hi=120;
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
    end
    
    
    % hold_rip1=[];
    Num=length(TS10_s1);
    disp('Num')
    hold_s1d=zeros(Num,len);
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
    peak1=sta_max3-sta_min1;
    % plot(sta-mean(sta),'LineWidth',3)
    sta_sd=std(hold_s1d)/sqrt(Num-1); hold on;
    % plot((sta-mean(sta))+(2*sta_sd));
    % plot((sta-mean(sta))-(2*sta_sd));
    shadedErrorBar([],(sta-mean(sta)),(1 *sta_sd),'g',0)
    % plot((sta-mean(sta))+(1*sta_sd));
    % plot((sta-mean(sta))-(1*sta_sd));
    hold on;
    
    for n=1:size(sleep_ind_post,1)
        %     clear TS10_s1
        % sws1=[sleep_ind_pre(n,1):sleep_ind_pre(n,2)];
        sws2=[sleep_ind_post(n,1):sleep_ind_post(n,2)];
        
        
        s_ts=find(TS10>sws2(1));
        e_ts=find(TS10<sws2(end));
        ts=intersect(s_ts,e_ts);
        TS10_s2=[TS10_s2 TS10(ts)];
    end
    
    
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
    shadedErrorBar([],(sta-mean(sta)),(1*sta_sd),'r',0)
    
    change1=((peak2-peak1)/peak1)*100;
    % c=['change' num2str(unit)];
    change{i}=change1;
        Session='S34\4_10_13Late\ ';
    Dur='half'
    if freq==1
        t=['Pre-Post SWA' Dur 'Ch' num2str(unit)];
        
    else
        if freq==2
            t=['Pre-Post Spindle' Dur 'Ch' num2str(unit)];
            
        else
            if freq==3
                t=['Pre-Post Ripple' Dur 'Ch' num2str(unit)];
                
            end
        end
    end
    title(t)
    xlab=['averaged to' num2str([chan_no])];
    xlabel(xlab);
    % plot(sta-mean(sta),'r','LineWidth',3);
    % plot((sta-mean(sta))+sta_sd,'r');
    % plot((sta-mean(sta))-sta_sd,'r');

    if sc==2
        if freq==1
            filename=['C:\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep SWA post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
        else
            if freq==2
                filename=['C:\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep Spindle post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
            else
                if freq==3
                    filename=['C:\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep Ripple post-' Dur 'SC1 Ch' num2str(unit) '.tiff'];
                end
            end
        end
    else
        if sc==3
            if freq==1
                filename=[C:'\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep SWA post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
            else
                if freq==2
                    filename=['C:\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep Spindle post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
                else
                    if freq==3
                        filename=['C:\Users\Ganguly Lab\Desktop\S34_learning\' Session 'Sleep Ripple post-' Dur 'SC2 Ch' num2str(unit) '.tiff'];
                    end
                end
            end
        end
    end
    
    
    saveas(gcf,filename);
    
end



