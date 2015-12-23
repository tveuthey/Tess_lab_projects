function [all_bins Trial_binned] = get_ensemble_trials(fname,BMIorMAN,N,bin,SMOOTH);
% fname  --> name of raw data_file
% gets the ensemble activity per trials
% BMIoRMAN == 1 --> BMI
%
if ~exist('SMOOTH')
    SMOOTH=1
elseif SMOOTH < 0
    SMOOTH=1;
end
    
disp('BMI/hand always binned at 100ms');
if BMIorMAN == 1
    f=[fname,'_BMIensemble.mat'];
    if ~exist(f,'file')
        Time_before_START =2; %data taken before START_EVENT; in s
        Data_length= Time_before_START+5; %if =2 then 2sec of data at Fs (sample rate)
        [Trial_data] = get_BMI_trials(fname,Time_before_START,Data_length);
        %reassign the ouput data from above
        Trial_data_X_pos=Trial_data{1};
        Trial_data_Y_pos=Trial_data{2};
        Trial_spikebins=Trial_data{3};
        Trial_spike_times=Trial_data{4};
        BMI_x=Trial_data{5};
        BMI_y=Trial_data{6};
        N_index=Trial_data{7};
        S=Trial_data{8};
        Trial_data_events=Trial_data{9};
        Trial_data_event_times=Trial_data{10};
        Trials_complete=Trial_data{11};
        Fs=Trial_data{12};
        Fs_BMI=Trial_data{13};
        Time_before_START=Trial_data{14};
        Data_length=Trial_data{15};
        neuron_firing_std=Trial_data{16};
        save(f)
        disp(['File ',f,' SAVED']);
        clear Trial_data
    else
        hold_N=N;
        hold_bin=bin;
        load(f);
        disp(['File ',f,' LOADED']);
        N=hold_N;
        bin=hold_bin;
    end
else
    f=[fname,'_MANensemble.mat'];
    if ~exist(f,'file')
        Time_before_START =2; %data taken before START_EVENT; in s
        Data_length= Time_before_START+5; %if =2 then 2sec of data at Fs (sample rate)
        [Trial_data] = get_MANUAL_trials(fname,Time_before_START,Data_length);
        %reassign the ouput data from above
        Trial_data_X_pos=Trial_data{1};
        Trial_data_Y_pos=Trial_data{2};
        Trial_spikebins=Trial_data{3};
        Trial_spike_times=Trial_data{4};
        BMI_x=Trial_data{5};
        BMI_y=Trial_data{6};
        N_index=Trial_data{7};
        S=Trial_data{8};
        Trial_data_events=Trial_data{9};
        Trial_data_event_times=Trial_data{10};
        Trials_complete=Trial_data{11};
        Fs=Trial_data{12};
        Fs_BMI=Trial_data{13};
        Time_before_START=Trial_data{14};
        Data_length=Trial_data{15};
        neuron_firing_std=Trial_data{16};
        save(f)
        disp(['File ',f,' SAVED']);
        clear Trial_data
    else
        hold_N=N;
        hold_bin=bin;
        load(f);
        disp(['File ',f,' LOADED']);
        N=hold_N;
        bin=hold_bin;
    end

end

Trial_type =[9]; %based on code, eg 9 = Rewarded trial

if BMIorMAN == 1
    target_events =73:80; %target codes for Strobed events
else
    target_events =[64,65,66,67,68,69,70,71];
end

Trial_NUM=length(Trials_complete);
nsig=length(N_index);
neuron_subset=1:1:nsig;

subplot_transform =[6 3 2 1 4 7 8 9];
angle_for_trial = [0 45 90 135 180 225 270 315];
plot_color = ['k','b','r','c','g','y','m','k'];
plot_c_2   = ['k','b','r','c','g','y','m','g'];
max_trials = 0;
%sorts trials in per TARGET groups; plots the trajectories
Trials_per_target = cell (length(target_events),1);
figure;
plot_to=(2+Time_before_START)*1/0.1;
for k = 1:1:length(target_events)
    [r,c] = find (Trial_data_events == target_events(k));
    [r2,c2] =find (Trial_data_events == 9); %rewarded trials
    trials_to_plot = intersect (r,r2); % PLOTS ONLY REWARDED, SUBSET
    if max_trials < length(trials_to_plot)  %for plotting purposes
        max_trials = length(trials_to_plot);
    end
    plot (mean(Trial_data_X_pos (trials_to_plot,1:plot_to))',mean(Trial_data_Y_pos (trials_to_plot,1:plot_to))',plot_c_2(k),'LineWidth',4);
    hold on; axis off;
    Trials_per_target {k}= trials_to_plot;
end

%finds min trial #
min_trialsNO=1000000;
for index=1:8
    m_temp=size(Trials_per_target{index},1);
    if m_temp<min_trialsNO
        min_trialsNO=m_temp;
    end
end
disp(['LCM of trials = ',num2str(min_trialsNO)]);

% look at all neurons/target
figure
N=intersect(N,N_index);
BMI_N_tot=length(N); %for 2/10 only use BMI neurons --> i.e.  N
subplot_transform =[6 3 2 1 4 7 8 9];
bin_vector = -Time_before_START:bin:((Data_length-Time_before_START));
      
% groups spike BINs into arrays PER trial and ALL_BIN array
k_list=1:1:length(target_events);   
Trial_binned=cell(length(k_list),min_trialsNO);
for k = 1:length(k_list) 
    [r,c] = find (Trial_data_events == target_events(k_list(k)));
    [r2,c2] =find (Trial_data_events == 9); %rewarded trials
    trials_to_plot = intersect (r,r2); %   PLOTS ONLY REWARDED, SUBSET
    all_bins=[];
    for trial_n=1:min_trialsNO
        binned_trial=zeros(BMI_N_tot,length(bin_vector));
        for neuron_n=1:BMI_N_tot  
            neuron_index=find(N_index==N(neuron_n));
            spikes = Trial_spike_times {trials_to_plot(trial_n),neuron_index}; %CHANGE OFFSET!!!
            spikes=spikes'; 
            binned = histc(spikes,bin_vector);
            if ~isempty (spikes)
                binned_trial(neuron_n,:)=smooth(binned,SMOOTH);
            end
        end
        Trial_binned{k,trial_n}=binned_trial;
        all_bins=[all_bins binned_trial];
    end
    temp_trials=Trial_binned{k,:};
    plot(mean(temp_trials),plot_c_2(k)); hold on;
end
