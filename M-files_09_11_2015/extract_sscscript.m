%%
%clear all;
PChange_sws(Change_sws==0)=NaN;
load('SSC.mat');
Change_spindle(Change_spindle==0)=NaN;
for i = 1:7
    for j = i:8
        Change_spindle(j,i)=Change_spindle(i, j);
    end
end

SSC_spin = nanmean(Change_spindle)';
SSC_sws = nanmean(PChange_sws)';