%%

close all; clear all; clc;
 %{'Block-15','Block-16','Block-17','Block-25','Block-26','Block-27','Block-28','Block-31','Block-32'...
Blocks = [767];
 %Block_Names = {'Block-767','Block-768'}
% ','Block-6','Block-7','Block-8'}
 %Block_Names = {'Block-15','Block-16','Block-17','Block-25','Block-26','Block-27','Block-28','Block-31','Block-32'};

 for i = 1:length(Blocks)

    clearvars -except i Blocks;
    close all;
    clc;
    
len_chs = 32;
TankName='DemoTank2';
Block_Name=strcat('Block-',num2str(Blocks(i)));
SortID='TankSort';
filename='data_spikes_lfps_wav_';

cd 'C:\TDT\OpenEx\Tanks\DemoTank2';
data = TDT2mat(TankName, Block_Name,'SORTNAME','TankSort');
end