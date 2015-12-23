clear all;

%%%%%%%%%%%%%%%%T12D1new
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\TaskBlock1new';
clear all;
load ('Activities.mat','Activities');
load('EnsemblespelletPCA.mat', 'eigenvalues25','lambda_max25');
pre1=Activities(4).pre';
post1=Activities(4).post';
n_eig1 = sort(eigenvalues25/lambda_max25,'descend');

a = length(post1);
b = size(post1,2);
post1=reshape(post1,[a*b 1]);
pre1=reshape(pre1,[a*b 1]);

post1(:,2)=12;
pre1(:,2)=12;

post1(:,3)=1;
pre1(:,3)=0;
count=0;
for i = 1:b
    start=count*a+1;
    endpos = (count+1)*a;    
    post1(start:endpos,4)=n_eig1(i);
    pre1(start:endpos,4)=n_eig1(i);
    count=count+1;
end
Act=[];
Act=[Act; [pre1;post1]];
%%
tmp = Act;
%%%%%%%%%%%%%%%%T28D1
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T28\TaskD1Block1'
clear Activities e* n*
load ('Activities.mat','Activities');
load('EnsemblesgraspPCA.mat', 'eigenvalues25','lambda_max25');
pre1=Activities(4).pre';
post1=Activities(4).post';
n_eig1 = sort(eigenvalues25/lambda_max25,'descend');

a = length(post1);
b = size(post1,2);
post1=reshape(post1,[a*b 1]);
pre1=reshape(pre1,[a*b 1]);

post1(:,2)=28;
pre1(:,2)=28;

pre1(:,3)=0;
post1(:,3)=1;

count=0;
for i = 1:b
    start=count*a+1;
    endpos = (count+1)*a;    
    post1(start:endpos,4)=n_eig1(i);
    pre1(start:endpos,4)=n_eig1(i);
    count=count+1;
end

Act=[Act; [pre1;post1]];

%%

%%
tmp = Act;
%%%%%%%%%%%T34D1
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\TaskD1new'
clear Activities e* n*
load ('Activities.mat','Activities');
load('EnsemblespelletPCA.mat', 'eigenvalues25','lambda_max25');
pre1=Activities(3).pre';
post1=Activities(3).post';
n_eig1 = sort(eigenvalues25/lambda_max25,'descend');

a = length(post1);
b = size(post1,2);
post1=reshape(post1,[a*b 1]);
pre1=reshape(pre1,[a*b 1]);

post1(:,2)=34.1;
pre1(:,2)=34.1;

pre1(:,3)=0;
post1(:,3)=1;

count=0;
for i = 1:b
    start=count*a+1;
    endpos = (count+1)*a;    
    post1(start:endpos,4)=n_eig1(i);
    pre1(start:endpos,4)=n_eig1(i);
    count=count+1;
end

Act=[Act; [pre1;post1]];
%%

tmp = Act;
%%%%%%%%%%%T34D1
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\TaskD2'
clear Activities e* n*
load ('Activities.mat','Activities');
load('EnsemblespelletPCA.mat', 'eigenvalues25','lambda_max25');
pre1=Activities(4).pre';
post1=Activities(4).post';
n_eig1 = sort(eigenvalues25/lambda_max25,'descend');

a = length(post1);
b = size(post1,2);
post1=reshape(post1,[a*b 1]);
pre1=reshape(pre1,[a*b 1]);

post1(:,2)=34.2;
pre1(:,2)=34.2;

pre1(:,3)=0;
post1(:,3)=1;

count=0;
for i = 1:b
    start=count*a+1;
    endpos = (count+1)*a;    
    post1(start:endpos,4)=n_eig1(i);
    pre1(start:endpos,4)=n_eig1(i);
    count=count+1;
end

Act=[Act; [pre1;post1]];

%%
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\TaskD3';


tmp = Act;
%%%%%%%%%%%T34D3
cd 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\TaskD2'
clear Activities e* n*
load ('Activities.mat','Activities');
load('EnsemblespelletPCA.mat', 'eigenvalues25','lambda_max25');
pre1=Activities(4).pre';
post1=Activities(4).post';
n_eig1 = sort(eigenvalues25/lambda_max25,'descend');

a = length(post1);
b = size(post1,2);
post1=reshape(post1,[a*b 1]);
pre1=reshape(pre1,[a*b 1]);

post1(:,2)=34.3;
pre1(:,2)=34.3;

pre1(:,3)=0;
post1(:,3)=1;

count=0;
for i = 1:b
    start=count*a+1;
    endpos = (count+1)*a;    
    post1(start:endpos,4)=n_eig1(i);
    pre1(start:endpos,4)=n_eig1(i);
    count=count+1;
end

Act=[Act; [pre1;post1]];

%%
low = Act(Act(:,4)<1.3,:);
high = Act(Act(:,4)>1.3,:);

[B,DEV,STATS] = GLMFIT(Act(:,3),Act(:,1));
[B2,DEV2,STATS2] = GLMFIT(Act(:,3:4),Act(:,1));

[B_low,DEV_low,STATS_low] = GLMFIT(low(:,3),low(:,1));
[B2_low,DEV2_low,STATS2_low] = GLMFIT(low(:,3:4),low(:,1));

[B_high,DEV_high,STATS_high] = GLMFIT(high(:,3),high(:,1));
[B2_high,DEV2_high,STATS2_high] = GLMFIT(high(:,3:4),high(:,1));

pre = Act(Act(:,3)==0,:);
post= Act(Act(:,3)==1,:);

pre_low = low(low(:,3)==0);
post_low= low(low(:,3)==1);

pre_high = high(high(:,3)==0);
post_high= high(high(:,3)==1);

pre_m = mean(pre);
post_m = mean(post);
pre_std = std(pre)/sqrt(length(pre));
post_std = std(post)/sqrt(length(post));

%%
pre_mlow = mean(pre_low);
post_mlow = mean(post_low);
pre_stdlow = std(pre_low)/sqrt(length(pre_low));
post_stdlow = std(post_low)/sqrt(length(post_low));

pre_mhigh = mean(pre_high);
post_mhigh = mean(post_high);
pre_stdhigh = std(pre_high)/sqrt(length(pre_high));
post_stdhigh = std(post_high)/sqrt(length(post_high));
%%
preh = hist(pre_high(:,1),[-100:10:1000]); ylim([0 100]);
posth = hist(post_high(:,1),[-200:10:1000]); ylim([0 100]);
diff = posth-preh; 
stem(diff);
subplot(211); hist(pre(:,1),[-100:25:800]); ylim([0 200]); title('Pre-learning');
subplot(212); hist(post(:,1),[-100:25:800]);ylim([0 200]);title('Post-learning');

% qqplot(pre_high,post_high);
% qqplot(pre_high,post_high)
% 
% qqplot(pre_low,post_low)
qqplot(pre,post);
xlabel('Pre-Sleep');
ylabel('Post-Sleep');

