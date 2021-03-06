%function [new]=concatenate_neural_events_T70(Block_1,Block_2, Block_3, Block_4,Block_5,Block_6,Block_7)

close all;

clear all;

%Block_1 = 'data_block_DemoTank2_Block-312.mat';
%Block_1='data_block_DemoTank2_Block-313.mat';
Block_1='data_block_DemoTank2_Block-315.mat';
%Block_2='data_block_DemoTank2_Block-316.mat';
Block_2='data_block_DemoTank2_Block-317.mat';
%Block_6='data_block_DemoTank2_Block-318.mat';
%Block_3='data_block_DemoTank2_Block-320.mat';

Blockx=num2str(Block_1);
Blocky=num2str(Block_2);
%Blockz=num2str(Block_3);
%Blockz1=num2str(Block_4);
%Blockz2=num2str(Block_5);
%Blockz3=num2str(Block_6);
%Blockz4=num2str(Block_7);


cd('D:\Users\zeiss\Documents\T70data\ ')
x=load(Blockx);
y=load(Blocky);
%z=load(Blockz);
%z1=load(Blockz1);
%z2=load(Blockz2);
%z3=load(Blockz3);
%z4=load(Blockz4);

% getting data out of two struct arrays
% data_x=x.data;
% N_x=x.N;
% TimeStamps_x=x.TimeStamps;
% Waves_x=x.Waves;
% Fs_lfp_x=x.Fs_lfp;
% wave_x=x.wave;
% 
% data_y=y.data;
% N_y=y.N;
% TimeStamps_y=y.TimeStamps;
% Waves_y=y.Waves;
% Fs_lfp_y=y.Fs_lfp;
% wave_y=y.wave;

Fs_lfp_x=x.Fs_lfp;
new.Fs_lfp=x.Fs_lfp;
[r c]=size(x.N);
time_add=length(x.data)/Fs_lfp_x;
%time_add2=(length(y.data)/Fs_lfp_x)+time_add;
%time_add3=(length(z.data)/Fs_lfp_x)+time_add2;
%time_add4=(length(z1.data)/Fs_lfp_x)+time_add3;
%time_add5=(length(z2.data)/Fs_lfp_x)+time_add4;
%time_add6=(length(z3.data)/Fs_lfp_x)+time_add5;

for j=2
    for i=1:r
        if (~isempty(x(1).TimeStamps{i,j}))% && ~isempty (z3(1).TimeStamps{i,j})) %%&& isempty (z(1).TimeStamps{i,j})==1 && isempty (z1(1).TimeStamps{i,j})==1 %&& isempty (z2(1).TimeStamps{i,j})==1
            new(1).TimeStamps{i,j}=[x.TimeStamps{i,j} y.TimeStamps{i,j}+time_add];% z.TimeStamps{i,j}+time_add2];% z1.TimeStamps{i,j}+time_add3];
            new(1).N{i,j}=[x.N{i,j}+y.N{i,j}];%+z.N{i,j}];%+z1.N{i,j}];                    
        else
            new(1).TimeStamps{i,j}=[NaN];
            new(1).N{i,j}=[NaN];
        end
    end
end

for j=2
    for i=1:r
%     if sum(sum(isnan(x(1).Waves{i,j})))==1% || sum(sum(isnan(y(1).Waves{i,j})))==1 || sum(sum(isnan(z(1).Waves{i,j})))==1 || sum(sum(isnan(z1(1).Waves{i,j})))==1
%            new(1).Waves{i,j}=[NaN];
%     else
           new(1).Waves{i,j}=[x.Waves{i,j} y.Waves{i,j}];% z.Waves{i,j}];% z1.Waves{i,j}];    
   % end
    
    end
end

new(1).wave(j,:)=[x(1).wave(1,:) y.wave(1,:)];% z.wave(1,:)];% z1.data(1,:)];% z2.wave(j,:)];
     
SpkData=x.SpkData;  
%data=new.data;
Fs_lfp=new.Fs_lfp;
TimeStamps=new.TimeStamps;
Waves = new.Waves;
wave = new.wave;


fname =('data_block_T70_Cat_D1_15_17_20TS2B');
cd ('D:\Users\zeiss\Documents\T70data\')
save (fname, 'Fs_lfp', 'Waves','TimeStamps', 'wave', 'SpkData','-v7.3')

%cd ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\S34')
%save (['Tanuj/Mat_files/raw_data/New (Acute_Neuromod_I)/data_block_R36_NewCat'], 'data', 'Fs_lfp', 'wave', 'TimeStamps','N')



