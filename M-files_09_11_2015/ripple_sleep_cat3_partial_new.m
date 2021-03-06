function [change]=ripple_sleep_cat3_partial_new(units,TimeStamps,TimeStamps2,sleep_ind_pre,sleep_ind_post,data,data2, Fs_lfp, sc, chan_no, dir)
close all
if isempty(chan_no)
    chan_no=[36];
end

for freq = 1:4
    
    for i=1:length(units)
        close all;
        unit=units(i);
        if unit==chan_no
            chan_no = [17];
        end
        
        temp  =(data([chan_no],:));
        tempb =(data2([chan_no],:));
        temp  = temp-mean(temp);
        tempb = tempb-mean(tempb);
        
        srate = Fs_lfp;
        nyq_sample=srate/2;
        len=1016;
        if freq==1
            FILTER_ORDER=2;
            f_lo=4;
            f_hi=1;
            [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
            temp=(FiltFiltM(b2,a2,temp));
            tempb=(FiltFiltM(b2,a2,tempb));
            lim1=200;
            lim2=508;
            lim3=800;
            len=1016;
            freqname='Delta';
        elseif freq==2
            FILTER_ORDER=2;
            f_lo=18;
            f_hi=8;
            [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
            temp=(FiltFiltM(b2,a2,temp));
            tempb=(FiltFiltM(b2,a2,tempb));
            lim1=200;
            lim2=508;
            lim3=800;
            len=1016;
            freqname='Spindle';
        elseif freq==3
            FILTER_ORDER=2;
            f_lo=8;
            f_hi=4;
            [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
            temp=(FiltFiltM(b2,a2,temp));
            tempb=(FiltFiltM(b2,a2,tempb));
            lim1=200;
            lim2=508;
            lim3=800;
            len=1016;
            freqname='Theta';
        elseif freq==4
            temp=temp;
            tempb=tempb;
            lim1=200;
            lim2=508;
            lim3=800;
            len=1016;
            freqname='Unfiltered';
        end
        
        TS10=TimeStamps{unit,sc}*Fs_lfp;
        TS10b = TimeStamps2{unit,sc}*Fs_lfp;
        
        clear TS10_s1 TS10_s2
        TS10_s1=[];
        TS10_s2=[];
        temp1 = temp;
        temp2 = tempb;
        clear temp tempb;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Pre_Sleep_STA Analysis
        
        length_sws = 0;
        for n=1:size(sleep_ind_pre,1)
           % while length_sws<600000
            sws1=[sleep_ind_pre(n,1):sleep_ind_pre(n,2)];
            s_ts=find(TS10>sws1(1));
            e_ts=find(TS10<sws1(end));
            ts=intersect(s_ts,e_ts);
            TS10_s1=[TS10_s1 TS10(ts)];
            length_sws = length_sws+(sleep_ind_pre(n,2) - sleep_ind_pre(n,1));
            %end
        end
        pre_fr = numel(TS10_s1)/(length_sws/Fs_lfp);
        trllngth = 'half';
        Num=length(TS10_s1);
        disp('Num')
        hold_s1d=zeros(Num,len);
        
        for n=1:Num
            ind=round(TS10_s1(n));
            pre_ind=ind-round(len/2)+1;
            post_ind=ind+round(len/2);
            hold_s1d(n,:)=temp1(pre_ind:post_ind);
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
        sta_sd=std(hold_s1d)/sqrt(Num-1); hold on;
        shadedErrorBar([],(sta-mean(sta)),(1 *sta_sd),'g',0)
        xlim([0 1017]);
        hold on;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Post_Sleep_STA Analysis
        length_sws2 = 0;
        for n=1:size(sleep_ind_post,1)
            %while length_sws2<600000
            sws2=[sleep_ind_post(n,1):sleep_ind_post(n,2)];
            s_ts=find(TS10b>sws2(1));
            e_ts=find(TS10b<sws2(end));
            ts=intersect(s_ts,e_ts);
            TS10_s2=[TS10_s2 TS10b(ts)];
            length_sws2 = length_sws2+(sleep_ind_post(n,2) - sleep_ind_post(n,1));
            %end
        end
        post_fr = numel(TS10_s2)/(length_sws2/Fs_lfp);
        Num=length(TS10_s2);
        disp('Num')
        hold_s1d=zeros(Num,len);
        
        for n=1:Num
            ind=round(TS10_s2(n));
            pre_ind=ind-round(len/2)+1;
            post_ind=ind+round(len/2);
            hold_s1d(n,:)=temp2(pre_ind:post_ind);
        end
        hold_s1d_tp=hold_s1d';
        hold_s1d_tpost=hold_s1d;
        ripl_post=reshape(hold_s1d_tp,1,(Num*len));
        sta2=mean(hold_s1d);
        sta2_min2=min(sta2(:,lim1:lim3));
        sta2_max2=max(sta2(:,lim2:lim3));
        sta2_max1=max(sta2(:,lim1:lim2));
        sta2_max3=(sta2_max1+sta2_max2)/2;
        peak2=sta2_max3-sta2_min2;
        sta2_sd=std(hold_s1d)/sqrt(Num-1);
        hold on
        shadedErrorBar([],(sta2-mean(sta2)),(1*sta2_sd),'r',0)
        change1=((peak2-peak1)/peak1)*100;
        change(i,1)= unit;
        change(i,2)= peak1;
        change(i,3)= peak2;
        change(i,4)= change1;
        change(i,5)= pre_fr;
        change(i,6)= post_fr;
        Dur='full';
        if freq==1
            t=['Pre-Post SWA' Dur 'Ch' num2str(unit)];
        elseif freq==2
            t=['Pre-Post Spindle' Dur 'Ch' num2str(unit)];
        elseif freq==3
            t=['Pre-Post Theta' Dur 'Ch' num2str(unit)];
        elseif freq==4
            t=['Unfiltered_LFP' Dur 'Ch' num2str(unit)];
        end
        title(t)
        filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' dir freqname Dur ' SC' int2str(sc) 'Ch' num2str(unit) '.tiff'];
        saveas(gcf,filename);
    end
    close all;
    matfile = strcat('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\',dir, freqname, Dur, 'SC', int2str(sc),'STAdata.mat');
    length_sws=length_sws/Fs_lfp;
    length_sws2=length_sws2/Fs_lfp;
    
    save (matfile, 'change','length_sws','length_sws2');
end
