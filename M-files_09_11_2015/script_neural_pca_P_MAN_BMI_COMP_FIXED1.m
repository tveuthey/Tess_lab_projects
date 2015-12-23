%% MANUAL pca trajectories (PACO FIXED1 ABA) 20908abd
% best ddx b/w ab is when (1) pc only in A; non-smoothing
  % in booth; WIN=1;MAX=15

clear

bin=0.1;
N = [281   285   289   290   293   294   301   317   322   323   333   334   342   351   358   359 ...
        369   371   374   377   378   379   381   382   383   386   401   402   403   413   414   450 ...
        454   486   493   505   345   349 389   449   261];
N=sort(N);

%disp('USING NON-BMI NEURONS');
%N2=1:512;
%N=setdiff(N2,N);


%to make summary figure
OFFSET=10; %start trials for here 
MAX=25-OFFSET;
WIN=10;
SMOOTH=3;
TOT_TRIALS=MAX-WIN;

% to make traj figures figure
% MAX=15;
% OFFSET=5; %start trials for here 
% WIN=1;
% SMOOTH=2;
% TOT_TRIALS=MAX-WIN-1;
% 
% OFFSET=0; %start trials for here 
% MAX=25-OFFSET;
% WIN=10;
% SMOOTH=2;
% TOT_TRIALS=MAX-WIN;


% finds the RANGE based on the bin size
%RANGE_start=-1.5;
RANGE_start=-1;
RANGE_s=RANGE_start:2;%in s, 0 is GO cue
Time_before_START =2; Data_length= Time_before_START+5; %if =2 then 2sec of data at Fs (sample rate)
bin_vector = -Time_before_START:bin:(Data_length-Time_before_START);
ZERO_bin=find(bin_vector==0);
start_bin=ZERO_bin+RANGE_s(1)*1/bin;
end_bin=ZERO_bin+RANGE_s(end)*1/bin;
RANGE=start_bin:end_bin;

disp([MAX WIN OFFSET SMOOTH])

index=1;fname{index}='paco020908a'; BMIorMAN=0; %25 trails
[all_bins{index} Trial_binned{index}]=get_ensemble_trials (fname{index},BMIorMAN,N,bin,SMOOTH);
index=2; fname{index}='paco020908b'; BMIorMAN=1; %25 trails
[all_bins{index} Trial_binned{index}]=get_ensemble_trials (fname{index},BMIorMAN,N,bin,SMOOTH);
index=3; fname{index}='paco020908d';BMIorMAN=0; %25 trails
[all_bins{index} Trial_binned{index}]=get_ensemble_trials (fname{index},BMIorMAN,N,bin,SMOOTH);

% index=1;fname{index}='paco020908a'; BMIorMAN=0; %25 trails
% [all_bins{index} Trial_binned{index}]=get_ensemble_trials_RAND (fname{index},BMIorMAN,N,bin,SMOOTH);
% index=2; fname{index}='paco020908b'; BMIorMAN=1; %25 trails
% [all_bins{index} Trial_binned{index}]=get_ensemble_trials_RAND (fname{index},BMIorMAN,N,bin,SMOOTH);
% index=3; fname{index}='paco020908d';BMIorMAN=0; %25 trails
% [all_bins{index} Trial_binned{index}]=get_ensemble_trials_RAND (fname{index},BMIorMAN,N,bin,SMOOTH);

% MOVING average of trials for NEURAL TRAJ
% %function [PC V] = get_PCs (data_sub,Trial_file,N,RANGE,MAX,WIN)
% Trial_file=Trial_binned{1};
% data_sub=all_bins{1};  
% [PC1 V1] = get_PCs (data_sub,Trial_file,N,RANGE,MAX,WIN);
% data_sub=all_bins{2};
% Trial_file=Trial_binned{2}; 
% [PC2 V2] = get_PCs (data_sub,Trial_file,N,RANGE,MAX,WIN);
% data_sub=all_bins{3};
% Trial_file=Trial_binned{3}; 
% [PC3 V3] = get_PCs (data_sub,Trial_file,N,RANGE,MAX,WIN);
% figure
% subplot(3,1,1); plot(PC1(:,1));hold on;
% subplot(3,1,2); plot(PC1(:,2));hold on;
% subplot(3,1,3); plot(PC1(:,3));hold on;
% subplot(3,1,1); plot(PC2(:,1),'r');hold on;
% subplot(3,1,2); plot(PC2(:,2),'r');hold on;
% subplot(3,1,3); plot(PC2(:,3),'r');hold on;
% subplot(3,1,1); plot(PC3(:,1),'k');hold on;
% subplot(3,1,2); plot(PC3(:,2),'k');hold on;
% subplot(3,1,3); plot(PC3(:,3),'k');hold on;

% compare two sets of neural traj  AA
REF_PC=1;
[PC V ang_dist ang_vector1]=get_PC_compare2_v2 (all_bins([1 2 3]),Trial_binned([1 2 3]),REF_PC,N,RANGE,MAX,WIN,OFFSET,RANGE_start,bin);

%[PC V ang_dist ang_vector1]=get_PC_compare2_v2 (all_bins([1 2]),Trial_binned([1 2]),REF_PC,N,RANGE,MAX,WIN,OFFSET,RANGE_start,bin);
%[PC V ang_dist ang_vector2]=get_PC_compare2_v2 (all_bins([1 3]),Trial_binned([1 3]),REF_PC,N,RANGE,MAX,WIN,OFFSET,RANGE_start,bin);
% figure
% plot(ang_vector1','r');hold on;
% plot(mean(ang_vector1),'r','LineWidth',5);
% plot(ang_vector2','k');
% plot(mean(ang_vector2),'k','LineWidth',5);


%%
%compare using randomized cov matrix
REF_PC=1;
temp=all_bins([1 3]);
temp2=Trial_binned([1 3]);
[PC V ang_dist1]=get_PC_compare2_RAND (temp,temp2,REF_PC,N,RANGE,MAX,WIN);

% compare two sets of neural traj AB
REF_PC=2;
temp=all_bins([1 2]);
temp2=Trial_binned([1 2]);
[PC V ang_dist2]=get_PC_compare2 (temp,temp2,REF_PC,N,RANGE,MAX,WIN,OFFSET);

figure;
Time_before_START =2; %data taken before START_EVENT; in s
Data_length= Time_before_START+5; %if =2 then 2sec of data at Fs (sample rate)
bin_vector = -Time_before_START:bin:(Data_length-Time_before_START);    

subplot(1,2,1)
sem_factor=(sqrt(TOT_TRIALS*8));
ang=ang_dist1{1};
a_sem=ang_dist1{2}/sem_factor;
dist=ang_dist1{3};
d_sem=ang_dist1{4}/sem_factor;
plot((RANGE-ZERO_bin)*bin,mean(ang),'b','LineWidth',4); hold on;
plot((RANGE-ZERO_bin)*bin,mean(ang)+a_sem,'b','LineWidth',2)
plot((RANGE-ZERO_bin)*bin,mean(ang)-a_sem,'b','LineWidth',2)
subplot(1,2,2)
plot((RANGE-ZERO_bin)*bin,mean(dist),'b','LineWidth',4); hold on;
plot((RANGE-ZERO_bin)*bin,mean(dist)+d_sem,'b','LineWidth',2)
plot((RANGE-ZERO_bin)*bin,mean(dist)-d_sem,'b','LineWidth',2)
ang=ang_dist2{1};
a_sem=ang_dist2{2}/sem_factor;
dist=ang_dist2{3};
d_sem=ang_dist2{4}/sem_factor;
subplot(1,2,1)
title('ang b/w AA(blue) and AB(red)')
plot((RANGE-ZERO_bin)*bin,mean(ang),'r','LineWidth',4); hold on;
plot((RANGE-ZERO_bin)*bin,mean(ang)+a_sem,'r','LineWidth',2)
plot((RANGE-ZERO_bin)*bin,mean(ang)-a_sem,'r','LineWidth',2)
xlabel ('Time(s)')
%xlim([0 length(RANGE)])
subplot(1,2,2)
plot((RANGE-ZERO_bin)*bin,mean(dist),'r','LineWidth',4); hold on;
plot((RANGE-ZERO_bin)*bin,mean(dist)+d_sem,'r','LineWidth',2)
plot((RANGE-ZERO_bin)*bin,mean(dist)-d_sem,'r','LineWidth',2)
xlabel ('Time(s)')
title('distance b/w AA(blue) and AB(red)')
%xlim([0 length(RANGE)])


