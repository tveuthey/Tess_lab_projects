function generate_PETH_1x32probes_SL_TV_20151012(path_to_data, save_path, reach_block, wave_samp_freq, PETH_size, PETH_bin, event)
% Generates PETH for cell array (channels x units) containing a vector of
% spike times for each unit.
%
% INPUT
% path_to_data - path to folder where reach_block is stored as .mat file
% save_path - path to save output
% reach_block - name of reach_block file (e.g., 'Reach_1.mat')
% wave_samp_freq - ...
% PETH_size - milliseconds before and after event to analyze (e.g., [(-4000 2000])
% PETH_bin - binning size for PETH
%
% OUTPUT
% no direct output but saves:
%  - PETH_mat_bin - cell array (channel x unit) holding PETH data
%  - plots of all PETH
%  - raw_all which presents channel-sorted PETHs of all units as heat plot
%  - z-scored_ordered_all_units which presents peak time-sorted PETHs of all units as heat plot
%
% SL - 9/16/15
% TV - 25/09/2015

% load reach block
cd (path_to_data)
load(reach_block)

% generate matrices with wave and spike time data
% Reach_mat_wave = eval(sprintf('%s_wave', strtok(reach_block,'.')));
% Reach_mat = eval(strtok(reach_block,'.'));
Reach_mat_wave = wave;
Reach_mat = Spike_times;

% generate empty matrix to hold all PETHs
PETH_mat = cell(size(Reach_mat));

% % get pelletdrop_markers in ms

% get event_markers in ms
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(Reach_mat_wave);
event_markers = eval(event)/wave_samp_freq*1000;
% pelletdrop_markers = pelletdrop_markers/wave_samp_freq*1000;

% change/make save directory
if(~exist(save_path))
    mkdir(save_path)
end
cd(save_path)

% create variable to store number of units
num_real_units = 0;

% generate figure to populate and save in loop
fig = figure('color','w','units','normalized', 'position',[0.25,0.25,0.5,0.5]);

% loop to go through each non-empty cell in reach_mat array one by one
for num_channels = 1:size(Reach_mat,1)
    for num_units = 1:size(Reach_mat,2)
        if ~isnan(Reach_mat{num_channels,num_units})
            %                     if ~isempty(Reach_mat{num_channels,num_units})
            
            % update number of units
            num_real_units = num_real_units + 1;
            
            % generate empty matrix that is the size of PETH data
            temp_unit_binned = zeros(size(PETH_size(1):PETH_bin:(PETH_size(2)-PETH_bin)));
            
            % loop through all trials and add binned spike counts to  vector
            for trial_num = 1:length(event_markers)
                temp_unit = Reach_mat{num_channels,num_units}; %get data from that unit for that trial
                temp_unit = temp_unit*wave_samp_freq; %TV included because data was not converted to ms
                temp_unit = temp_unit(temp_unit > (event_markers(trial_num)+PETH_size(1)) & temp_unit < (event_markers(trial_num)+PETH_size(2))); %take chunk around reach (-4 to +2s)
                temp_unit_binned = temp_unit_binned + histcounts(temp_unit, [(event_markers(trial_num)+PETH_size(1)):PETH_bin:(event_markers(trial_num)+PETH_size(2))]);
            end
            PETH_mat{num_channels,num_units} = temp_unit_binned;
            
            % create and move to bin-specific directory for PETHs
            if(~exist(sprintf('%s\\bin_%d',save_path,PETH_bin)))
                mkdir(sprintf('%s\\bin_%d',save_path,PETH_bin))
            end
            cd(sprintf('%s\\bin_%d',save_path,PETH_bin))
            
            % generate figure and save it
            bar([PETH_size(1):PETH_bin:(PETH_size(2)-PETH_bin)],PETH_mat{num_channels,num_units})
            xlim(PETH_size);
            title(sprintf('%s Chan %d Unit %d Bin %d PETH',event,num_channels,num_units, PETH_bin));
            saveas(fig,sprintf('%s Chan %d Unit %d Bin %d PETH',event,num_channels,num_units, PETH_bin),'tiff')
            
            % move back to general save path
            cd(save_path)
            
        end
    end
end

num_real_units1=0;

for num_channels = 1:32;
    for num_units = 1:size(Reach_mat,2)
        if ~isnan(Reach_mat{num_channels,num_units})
            num_real_units1 = num_real_units1 + 1;
        end
    end
end
            
num_real_units2=0;

% % for num_channels = 33:64;
% %     for num_units = 1:size(Reach_mat,2)
% %         if ~isnan(Reach_mat{num_channels,num_units})
% %             num_real_units2 = num_real_units2 + 1;
% %         end
% %     end
% % end

%% group plots
% index into event time
index = (abs(PETH_size(1)) / PETH_bin);

% save the PETH matrix and the time of event within each PETH
save(sprintf('%s_PETH_mat_bin=%d.mat',event,PETH_bin), 'PETH_mat', 'index', 'num_real_units','PETH_bin','event','reach_block')
% load((sprintf('PETH_mat_bin=%d.mat',PETH_bin)), 'PETH_mat', 'index')

% generate matrix of z scored unit(y) x trial time(x) x binned spiking(hue)
heat_plot1 = zeros(num_real_units1,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
% % heat_plot2 = zeros(num_real_units2,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
count = 1;

%% raw data plots for two 32-channel probes
% group data (no z-scoring)
for num_channels = 1:32;
    for num_units = 1:size(PETH_mat,2)
        if ~isempty(PETH_mat{num_channels,num_units})
            tmp = PETH_mat{num_channels,num_units};
%             tmp = zscore(tmp);
            heat_plot1(count,:) = tmp;
            count = count + 1;
        end
    end
end

% % count = 1;
% % 
% % for num_channels = 33:64;
% %     for num_units = 1:size(PETH_mat,2)
% %         if ~isempty(PETH_mat{num_channels,num_units})
% %             tmp = PETH_mat{num_channels,num_units};
% % %             tmp = zscore(tmp);
% %             heat_plot2(count,:) = tmp;
% %             count = count + 1;
% %         end
% %     end
% % end

% plot all units
fig = figure;
subplot(1,1,1)
imagesc(heat_plot1)
colorbar;
colormap jet;
hold on;
line([(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2),(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2)],[1,size(heat_plot1,1)],'Color','r','LineWidth',2,'linestyle',':')
hold off
% saveas(fig,sprintf('%s_raw_all_unit_PETH_bin=%d',event,PETH_bin),'tiff')
% % 
% % % fig = figure;
% % subplot(1,2,2)
% % imagesc(heat_plot2)
% % colorbar;
% % colormap jet;
% % hold on;
% % line([(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2),(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2)],[1,size(heat_plot2,1)],'Color','r','LineWidth',2,'linestyle',':')
% % hold off
saveas(fig,sprintf('raw_all_unit_PETH_bin=%d',PETH_bin),'tiff')

%% z-scored data
clear heat_plot1 heat_plot2

% generate matrix of z scored unit(y) x trial time(x) x binned spiking(hue)
heat_plot = zeros(num_real_units,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
heat_plot1 = zeros(num_real_units1,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
% heat_plot2 = zeros(num_real_units2,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
count = 1;

% z score data
for num_channels = 1:size(PETH_mat,1)
    for num_units = 1:size(PETH_mat,2)
        if ~isempty(PETH_mat{num_channels,num_units})
            tmp = PETH_mat{num_channels,num_units};
            tmp = zscore(tmp);
            heat_plot(count,:) = tmp;
            count = count + 1;
        end
    end
end

heat_plot1=heat_plot(1:num_real_units1,:);
% % heat_plot2=heat_plot((num_real_units1+1):num_real_units,:);

%% sorted by peak firing

%%sort by time of peak firing
%probe 1
max_position = zeros(1,num_real_units1);
for n = 1:length(max_position)
    temp = find(heat_plot1(n,:) == max(heat_plot1(n,:)));
    max_position(n) = temp(1);
end
[~,I] = sort(max_position);
ordered_heat_plot1 = heat_plot1(I,:);

%save z-scored and sorted data
save(sprintf('1-32_PETH_mat_bin=%d_sort.mat',PETH_bin), 'ordered_heat_plot1', 'index','PETH_bin','reach_block','event')

clear max_position temp I

% % %probe2
% % max_position = zeros(1,num_real_units2);
% % for n = 1:length(max_position)
% %     temp = find(heat_plot2(n,:) == max(heat_plot2(n,:)));
% %     max_position(n) = temp(1);
% % end
% % [~,I] = sort(max_position);
% % ordered_heat_plot2 = heat_plot2(I,:);
% % 
% % %save z-scored and sorted data
% % save(sprintf('33-64_PETH_mat_bin=%d_sort.mat',PETH_bin), 'ordered_heat_plot2', 'index','PETH_bin','reach_block','event')

% plot all units (z-scored and ordered)
fig = figure;
subplot(1,2,1)
imagesc(ordered_heat_plot1)
colorbar;
colormap jet;
hold on;
line([(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2),(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2)],[1,119],'Color','r','LineWidth',2,'linestyle',':')
hold off
% % 
% % subplot(1,2,2)
% % imagesc(ordered_heat_plot2)
% % colorbar;
% % colormap jet;
% % hold on;
% % line([(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2),(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*1/2)],[1,119],'Color','r','LineWidth',2,'linestyle',':')
% % hold off

saveas(fig,sprintf('z-scored_ordered_all_unit_PETH_bin=%d',PETH_bin),'tiff')


close all; clear all; clc;
end



