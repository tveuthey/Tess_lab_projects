function [PEH_rate] = plot_ABA_BMI_clean (spike_no, Trials_per_target, max_trials, pass_data);
% max_trials is a way of collecting the maximum instances of Trials_per_target

x1=0.0333;
x_w=0.45;
x2=2*x1+x_w;
x_c=(1-x_w)/2;
y_w=0.15;

plot_position{3}=[x_c  0.8101   x_w   y_w];
plot_position{4}=[x1   0.6374    x_w   y_w];
plot_position{2}=[x2    0.6374    x_w y_w];
plot_position{5}=[x1   0.4647    x_w   y_w];
plot_position{1}=[x2   0.4647    x_w  y_w];
plot_position{6}=[x1    0.2921    x_w    y_w];
plot_position{8}=[x2    0.2921   x_w   y_w];
plot_position{7}=[x_c     0.1194    x_w   y_w];


%data is passed as a cell call PASS_DATA
Time_before_START = pass_data{1};
Data_length = pass_data{2};
Fs = pass_data{3};
Trial_data_events = pass_data{4};
Trial_data_event_times = pass_data{5};
START_EVENT = pass_data{6};
Trial_spike_times = pass_data{7};
bin_vector = pass_data{8};
bin = pass_data{9};
target_events = pass_data{10};
PLOT_STUFF = pass_data{11};

angle_for_trial  = [0 45 90 135 180 225 270 315];
subplot_transform =[6 3  2  1    4    7   8   9 ]; %to remap to 3,3 subplot for four directions
no_targets = length(target_events);
PEH_rate = zeros (no_targets,length (bin_vector));

y_max = 0;
if PLOT_STUFF == 1
    figure; %(12); %set (gcf, 'Position', [421 103 765 646]);
end

for k = 1:1:no_targets %for each of the eight targets
    trials_to_plot = Trials_per_target {k};
    if PLOT_STUFF==1
        subplot('Position', plot_position{k});
    end
    trial_num = length(trials_to_plot);
    bin_rate = zeros (length (bin_vector),trial_num);

    for k2 = 1:1:length (trials_to_plot)  %for each of the trials per target
        trial_no = trials_to_plot (k2);
        spikes = Trial_spike_times {trial_no,spike_no};
        % plots the spike train
        if ~isempty (spikes)
            if length(spikes) == 1
                binned = histc(spikes,bin_vector);
            else
                binned = histc(spikes,bin_vector)';
            end
            if PLOT_STUFF==1
                spikes=spikes';
                plot ([spikes; spikes],[k2-0.4 k2+0.4],'k','LineWidth',1.5);              
                hold on;
            end
            bin_rate (:,k2) = binned; %keeps track of the binning per target
        end
    end
    PEH_rate (k,:) = sum(bin_rate,2)/trial_num/bin; % average firing rate for the the rate
    if y_max < max(PEH_rate (k,:))  % finds the maximum rate for all targets
        y_max = max(PEH_rate (k,:));
    end
end

if PLOT_STUFF==1  %PLOTS the rate above
    %raster_limits = [-Time_before_START/Fs (Data_length-Time_before_START)/Fs 0 max_trials*2.5];
    for k = 1:1:no_targets %for each of the eight targets
        subplot('Position', plot_position{k});
        xlim([0 1.5]);
        ylim([0 max_trials]);
        %plots normalized firing rate for all the trials
        %plot ([-Time_before_START/Fs:bin:(Data_length-Time_before_START)/Fs],15*PEH_rate(k,:)/y_max+max_trials,'k','LineWidth',2);
        %axis (raster_limits);
        %line([0 0],[0 max_trials*2],'Color','r','LineWidth',2);  %line at time zero    
        set(gca,'XTick',[],'YTick',[]);
        hold off;       
    end
end
subplot('Position', plot_position{3}); %to make sure title is over correct plot
return