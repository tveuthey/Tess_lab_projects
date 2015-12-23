function [datamat] = make_trial_mat2(marker,data,predur,postdur)
%data = zscore(data');
%data=data';
if pos >1
    pre = 0;
    post = dur;
else
    pre = -1*dur;
    post = 0;
end
    for j = 1:length(marker)
        t = marker(j);
        datamat(j,:,:)=data(:,round(t+pre):round(t+post));
    end

datamat=permute(datamat,[3 2 1]);
    