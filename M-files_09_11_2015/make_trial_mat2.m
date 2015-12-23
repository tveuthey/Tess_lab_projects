function [datamat] = make_trial_mat2(marker,data,predur,postdur)
    for j = 1:length(marker)
        t = marker(j);
        datamat(j,:,:)=data(:,round(t-predur):round(t+posdur));
    end

%datamat=permute(datamat,[3 2 1]);
    