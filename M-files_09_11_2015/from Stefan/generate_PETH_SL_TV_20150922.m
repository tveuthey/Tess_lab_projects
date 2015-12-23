function generate_PETH_SL(path_to_data, save_path, reach_block, wave_samp_freq, PETH_size, PETH_bin)
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
%  - all_units which presents time-sorted PETHs of all units as heat plot
% 
% SL - 9/16/15

% load reach block
cd (path_to_data)
load(reach_block)

% generate matrices with wave and spike time data
Reach_mat_wave = eval(sprintf('%s_wave', strtok(reach_block,'.')));
Reach_mat = eval(strtok(reach_block,'.'));

% generate empty matrix to hold all PETHs
PETH_mat = cell(size(Reach_mat));

% get pelletdrop_markers in ms
[~, pelletdrop_markers, ~]=find_pulses_reach_M1M2_TV_20150922(Reach_mat_wave);
pelletdrop_markers = pelletdrop_markers/wave_samp_freq*1000;

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
        if ~isempty(Reach_mat{num_channels,num_units})
            
            % update number of units
            num_real_units = num_real_units + 1;
            
            % generate empty matrix that is the size of PETH data
            temp_unit_binned = zeros(size(PETH_size(1):PETH_bin:(PETH_size(2)-PETH_bin)));
            
            % loop through all trials and add binned spike counts to  vector
            for trial_num = 1:length(pelletdrop_markers)              
                temp_unit = Reach_mat{num_channels,num_units};
                temp_unit = temp_unit(temp_unit > (pelletdrop_markers(trial_num)+PETH_size(1)) & temp_unit < (pelletdrop_markers(trial_num)+PETH_size(2)));
                temp_unit_binned = temp_unit_binned + histcounts(temp_unit, [(pelletdrop_markers(trial_num)+PETH_size(1)):PETH_bin:(pelletdrop_markers(trial_num)+PETH_size(2))]);
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
            title(sprintf('Chan %d Unit %d Bin %d PETH',num_channels,num_units, PETH_bin));
            saveas(fig,sprintf('Chan %d Unit %d Bin %d PETH',num_channels,num_units, PETH_bin),'tiff') 
            
            % move back to general save path
            cd(save_path)
       
        end
    end
end

% index into event time
index = (abs(PETH_size(1)) / PETH_bin);

% save the PETH matrix and the time of event within each PETH
save(sprintf('PETH_mat_bin=%d.mat',PETH_bin), 'PETH_mat', 'index')

% generate matrix of z scored unit x trial time x binned spiking
heat_plot = zeros(num_real_units,floor(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)));
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

% sort by time of peak firing
max_position = zeros(1,num_real_units);
for n = 1:length(max_position)
    temp = find(heat_plot(n,:) == max(heat_plot(n,:)));
    max_position(n) = temp(1);
end
[~,I] = sort(max_position);
ordered_heat_plot = heat_plot(I,:);

% save z-scored and sorted data
save(sprintf('PETH_mat_bin=%d_sort.mat',PETH_bin), 'ordered_heat_plot', 'index')

% plot all units
fig = figure;
imagesc(ordered_heat_plot)           
colorbar;
colormap jet;
hold on;
line([(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*2/3),(((abs(PETH_size(1)) + abs(PETH_size(2))) / PETH_bin)*2/3)],[1,119],'Color','r','LineWidth',2,'linestyle',':')
hold off
saveas(fig,sprintf('all_unit_PETH_bin=%d',PETH_bin),'tiff')       


close all; clear all; clc;
end


