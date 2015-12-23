function [Output]=plot_ripple_individual(unit,TimeStamps, sws1, sws2,Fs_lfp,hold_s1d_tpre,hold_s1d_tpost)
close all





TS10=TimeStamps{unit,2}*Fs_lfp;

len=3000;

figure
s_ts=find(TS10>sws1(1));
e_ts=find(TS10<sws1(end));
ts=intersect(s_ts,e_ts);
TS10_s1=TS10(ts);
size(TS10_s1)

% hold_rip1=[];
Num=size(hold_s1d_tpre,1);
% hold_s1d=zeros(Num,len);
% for n=1:10:Num
%     close all;
    figure(n);
    %     ind=round(TS10_s1(n));
    %     pre_ind=ind-round(len/2)+1;
    %     post_ind=ind+round(len/2);
    for i=1:10
%         figure(i)
        subplot(1,2,1)
        plot(hold_s1d_tpre(i,:)+1*i);
        subplot(1,2,2)
        plot(hold_s1d_tpost(i,:)+1*i); hold on;
        %     hold_rip1=[hold_rip1, hold_s1d(n,:)];
    end
    pause
% end
Output=mean(sws1)
    % hold_s1d_tp=hold_s1d';
    % ripl_pre=reshape(hold_s1d_tp,1,(Num*len));
    %
    % sta=mean(hold_s1d);
    % % plot(sta-mean(sta),'LineWidth',3)
    % sta_sd=std(hold_s1d)/sqrt(Num-1); hold on;
    % % plot((sta-mean(sta))+(2*sta_sd));
    % % plot((sta-mean(sta))-(2*sta_sd));
    % shadedErrorBar([],(sta-mean(sta)),(1*sta_sd),'g',0)
    % % plot((sta-mean(sta))+(1*sta_sd));
    % % plot((sta-mean(sta))-(1*sta_sd));
    % hold on;
    % s_ts=find(TS10>sws2(1));
    % e_ts=find(TS10<sws2(end));
    % ts=intersect(s_ts,e_ts);
    % TS10_s2=TS10(ts);
    %
    % Num=length(TS10_s2);
    % hold_s1d=zeros(Num,len);
    % for n=1:Num
    %     ind=round(TS10_s2(n));
    %     pre_ind=ind-round(len/2)+1;
    %     post_ind=ind+round(len/2);
    %     hold_s1d(n,:)=temp1(pre_ind:post_ind);
    % end
    %
    % hold_s1d_tp=hold_s1d';
    % ripl_post=reshape(hold_s1d_tp,1,(Num*len));
    
  
    % plot(sta-mean(sta),'r','LineWidth',3);
    % plot((sta-mean(sta))+sta_sd,'r');
    % plot((sta-mean(sta))-sta_sd,'r');