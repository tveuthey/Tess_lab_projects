function [data_lfpn,data_spkn]=create_lfpspkcoh_trials(data_lfp,data_spk,time_range,Fs_lfp)
data_lfpn=data_lfp(1:time_range);
% data_lfpn=reshape(data_lfp1,4000,10);%/Fs_lfp;
% for i=0:9
%     tstamps=data_spk*Fs_lfp;
%      tstamps_tot=tstamps(1:end);
%         tpre1=find(tstamps>((4000*i)+1));
%         tpre2=find(tstamps>((4000*i)+4000));
%         data_spkn(i+1).times=tstamps(tpre1(1):tpre2(1)-1);
% end

    tstamps=data_spk*Fs_lfp;
%    tstamps2=tstamps(1:time_range);
        tpre1=find(tstamps>1);
        tpre2=find(tstamps>time_range(end));
        data_spkn(1).times=tstamps(tpre1(1):tpre2(1)-1);