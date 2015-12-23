function [PC V] = get_PCs (data_sub)
% data
% range in trial
% MAX --> maximum # of trials common
% WIN --> size of moving window

if ~exist('PLOT')
    PLOT=1;
end

%PCA_file=1;
%creates PC compoments from 1 data set
%data_sub=all_bins{PCA_file};
[M,N2] = size(data_sub);
mn = mean(data_sub,2);
data_sub = data_sub - repmat(mn,1,N2);% subtract off the mean for each dimension
covariance = 1 / (N2-1) * data_sub * data_sub'; % calculate the covariance matrix
size(covariance);
[PC, V] = eig(covariance);% find the eigenvectors and eigenvalues
V = diag(V); % extract diagonal of matrix as vector
[junk, rindices] = sort(-1*V); % sort the variances in decreasing order
V = V(rindices);
PC = PC(:,rindices);

figure;
ppca_dim=2;
[var, U, lambda] = ppca(covariance,ppca_dim)
figure;
for index=1:ppca_dim
    subplot(ppca_dim,1,index);
    plot(PC(:,index),'k','LineWidth',5);
    hold on;
    plot(U(:,index),'r','LineWidth',2);
end
    


