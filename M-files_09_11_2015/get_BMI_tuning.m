function [neuron_tuning,fit_tuning,fit_para,neuron_var]= get_BMI_tuning (fname, N, tuning_per_end, show_rasters)
% fname  --> name of raw data_file
% N --> list of BMI neurons; in range of 1:512
% tuning_per_end --> post GO, how long to integrate, ?  1s
% show_rasters --> shows the indiv neurons


f=[fname,'_BMI.mat'];

if ~exist(f,'file')
    Time_before_START =1.5; %data taken before START_EVENT; in s
    Data_length= Time_before_START+tuning_per_end+0.5; %if =2 then 2sec of data at Fs (sample rate)
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
   hold_show_r=show_rasters;  % TO MAKE SURE LOADING DOES NOT OVERWRITE
   hold_tuning_per_end=tuning_per_end;
   hold_N=N;
   load(f);
   disp(['File ',f,' LOADED']);
   show_rasters=hold_show_r;
   tuning_per_end=hold_tuning_per_end;
   N=hold_N;
end


Trial_NUM=length(Trials_complete);
nsig=length(N_index);

neuron_subset=1:1:nsig;
bin = 0.1;
Trial_type =[9]; %based on code, eg 9 = Rewarded trial
target_events =73:80; %target codes for Strobed events
subplot_transform =[6 3 2 1 4 7 8 9];
angle_for_trial = [0 45 90 135 180 225 270 315];
plot_color = ['k','b','r','c','g','y','m','k'];
plot_c_2   = ['r','r','k','k','k','k','k','r'];
max_trials = 0;


%if show_rasters ==1
%    temp_fig=figure; hold on;
%end

%sorts trials in per TARGET groups; plots the trajectories
Trials_per_target = cell (length(target_events),1);
for k = 1:1:length(target_events)
    [r,c] = find (Trial_data_events == target_events(k));
    [r2,c2] =find (Trial_data_events == 9); %rewarded trials
    trials_to_plot = intersect (r,r2); % PLOTS ONLY REWARDED, SUBSET
    %trials_to_plot = r;% PLOTS ALL TRIALS

    if max_trials < length(trials_to_plot)  %for plotting purposes
        max_trials = length(trials_to_plot);
    end

    %if show_rasters ==1
    %    figure(temp_fig);
    %    plot (mean(Trial_data_X_pos (trials_to_plot,:))',mean(Trial_data_Y_pos (trials_to_plot,:))',plot_c_2(k),'LineWidth',4);
    %    axis ([-0.075 0.085 0.08 0.2]);
    %end
    Trials_per_target {k}= trials_to_plot;
end

Trials_per_target

%figure; f_two=gcf;
BMI_N_tot=length(N); %for 2/10 only use BMI neurons --> i.e.  N
neuron_PD=zeros(BMI_N_tot,2);
bin_vector = -Time_before_START:bin:(Data_length-Time_before_START);


neuron_tuning=zeros(BMI_N_tot, length(target_events));
tuning_per_start=(find(bin_vector==0));
tuning_per_end=tuning_per_end/bin;
tuning_range=[tuning_per_start+1:tuning_per_start+1+tuning_per_end];


for index = 1:1:BMI_N_tot % index is the unit being looked at
    neuron_i=find(N_index==N(index));
    bin_rate = zeros (length(target_events),length (bin_vector));
    for k = 1:1:length(target_events)
        trials_to_plot = Trials_per_target {k};
        %spikes_hold=0;
        for k2 = 1:1:length (trials_to_plot)
            spikes = Trial_spikebins (trials_to_plot (k2),neuron_i,:);
            spikes=reshape(spikes,1,Data_length*Fs_BMI+1);
            %spikes_hold=spikes_hold+spikes;
            bin_rate(k,:)=bin_rate(k,:)+spikes;

            %plots the reward time
            %delt_r = Trial_data_event_times(trials_to_plot(k2),8)-Trial_data_event_times(trials_to_plot(k2),4);
            %delt_r=delt_r/Fs;

        end
        if length(trials_to_plot) > 0
            bin_rate(k,:) = 10*bin_rate(k,:)/length(trials_to_plot); %goes from bin to rate (0.1 -->10x)
        end
        %plot (bin_vector,bin_rate(k,:)+length(trials_to_plot),'b','LineWidth',2);
    end

    y_max =  max (max (bin_rate)); %scales the plot to the maximum firing rate
    y_max = y_max *1.25;
    raster_limits = [-Time_before_START (Data_length-Time_before_START) 0 y_max+length(trials_to_plot)];
    for k = 1:1:length(target_events)
        norm_bin_rate=bin_rate(k,:)/neuron_firing_std(neuron_i);
        neuron_tuning(index,k)=mean(norm_bin_rate(tuning_range));
        neuron_var(index,k)=var(norm_bin_rate(tuning_range));
        %norm_bin_rate=bin_rate(k,:)/10;
        %norm_bin_rate=(norm_bin_rate-mean(norm_bin_rate))/std(norm_bin_rate);
        %neuron_tuning(index,k)=mean(norm_bin_rate(tuning_range));
    end
    %neuron_tuning(index,:)=smooth (neuron_tuning(index,:),'sgolay');
    neuron_tuning(index,:)=neuron_tuning(index,:)-mean(neuron_tuning(index,:));
end

disp('check tuning variance vs std, CHECK ** get_BMI_tuning_unNORM')

%normalizes the tuning curves
neuron_tuning=neuron_tuning/max(max(neuron_tuning));


%calculates the cosine tuning
theta=[0:45:360-45];
X=[ones(1,8); sind(theta); cosd(theta)];
for index = 1:1:BMI_N_tot % index is the unit being looked at
    single_tuning=neuron_tuning(index,:);
    val_fit=single_tuning/X;
    fit_tuning(index,:)=val_fit(2)*sind(theta)+ val_fit(3)*cosd(theta);
    fit_para(index,:)=val_fit;
end


fit_tuning=[fit_tuning fit_tuning(:,1)]; %WRAPS for cosine tuning);

%plots the tuning cuves
figure
n_curves=size(neuron_tuning,1);
n_points=size(neuron_tuning,2);
px1=0.1; pdx=0.8;
py1=0.1; py2=0.9;

pdy=(py2-py1)/n_curves;
py=[0.1:pdy:0.9];

% for index=1:n_curves
%     temp=neuron_tuning(index,:);
%     subplot('Position',[px1 py(index) pdx 0.8*pdy]);
%     surface([temp; temp])
%     shading interp
%     xlim([1 n_points]);
%     set(gca,'XTick',[],'Ytick',[]);
%     if index==n_curves
%         title(fname);
%     end
% end
% 
% figure
for index=1:n_curves
    temp=fit_tuning(index,:);
    subplot('Position',[px1 py(index) pdx 0.8*pdy]);
    surface([temp; temp])
    shading interp
    xlim([1 n_points+1]);
    set(gca,'XTick',[],'Ytick',[]);
    if index==n_curves
        title(fname);
    end
end


if show_rasters == 1
    %to look at rasters
    %need to pass this data
    % uses N -> the list of BMI neurons
    START_EVENT=5;
    PLOT_STUFF=1; %0=auto; 1=look at each neuron

    pass_data=cell (7,1);
    pass_data{1} = Time_before_START*Fs; %*****
    pass_data{2} = Data_length*Fs;  %*****
    pass_data{3} = Fs;
    pass_data{4} = Trial_data_events;
    pass_data{5} = Trial_data_event_times;
    pass_data{6} = START_EVENT;
    pass_data{7} = Trial_spike_times;
    pass_data{8} = bin_vector;
    pass_data{9} = bin;
    pass_data{10}= target_events;
    pass_data{11}= PLOT_STUFF;

    neuron_label=get_chan_labels(N_index);

    for index = 1:1:length(N)%length(neuron_subset) % n is the unit being looked at
        %for index = 1:1:length(N_index)%length(neuron_subset) % n is the unit being looked at

        neuron_no=N(index);
        %neuron_no=N_index(index);
        neuron_index=find(N_index==neuron_no);

        disp (['Looking at neuron number...',num2str(neuron_no)]);
        y_max_hold = 0;
        spike_no = neuron_subset (neuron_index);  % Trial_spikes_times (# of trials..Trial_NUM, # of neurons...nsig)
        bin_rate = zeros (length(target_events),length (bin_vector));
        
        %plot_ABA_BMI;
        PEH_rate_neurons (index,:,:) = plot_ABA_BMI_BMI_raster (spike_no,Trials_per_target,max_trials,pass_data);
        %PEH_rate_neurons (index,:,:) = plot_ABA_BMI_clean (spike_no,Trials_per_target,max_trials,pass_data);
        %PEH_rate_neurons (index,:,:) = plot_ABA_BMI (spike_no,Trials_per_target,max_trials,pass_data);
    
        %text(0,-20, ([fname,', NEURON#',char(neuron_label(neuron_index))]));
        %pause;
    end
end