function [new]=concatenate_neural_events_4blocs(Block_1,Block_2, Block_3, Block_4,Block_5,Block_6,Block_7)

close all;
Blockx=num2str(Block_1);
Blocky=num2str(Block_2);
Blockz=num2str(Block_3);
Blockz1=num2str(Block_4);
Blockz2=num2str(Block_5);
Blockz3=num2str(Block_6);
Blockz4=num2str(Block_7);


cd('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored')
x=load(Blockx);
y=load(Blocky);
z=load(Blockz);
z1=load(Blockz1);
z2=load(Blockz2);
z3=load(Blockz3);
z4=load(Block4);

% getting data out of two struct arrays
data_x=x.data;
N_x=x.N;
TimeStamps_x=x.TimeStamps;
Waves_x=x.Waves;
Fs_lfp_x=x.Fs_lfp;
wave_x=x.wave;

data_y=y.data;
N_y=y.N;
TimeStamps_y=y.TimeStamps;
Waves_y=y.Waves;
Fs_lfp_y=y.Fs_lfp;
wave_y=y.wave;

new.Fs_lfp=Fs_lfp_x;
[r c]=size(N_x);
time_add=length(x.data)/Fs_lfp_x;
time_add2=(length(y.data)/Fs_lfp_x)+time_add;
time_add3=(length(z.data)/Fs_lfp_x)+time_add2;
time_add4=(length(z1.data)/Fs_lfp_x)+time_add3;
time_add5=(length(z2.data)/Fs_lfp_x)+time_add4;
time_add6=(length(z3.data)/Fs_lfp_x)+time_add5;

for j=1:c
    for i=1:r
        if isempty (x(1).TimeStamps{i,j})==1 && isempty (y(1).TimeStamps{i,j})==1 && isempty (z(1).TimeStamps{i,j})==1 && isempty (z1(1).TimeStamps{i,j})==1 %&& isempty (z2(1).TimeStamps{i,j})==1
            new(1).TimeStamps{i,j}=[NaN];
            new(1).N{i,j}=[NaN];
        else
            new(1).TimeStamps{i,j}=[x.TimeStamps{i,j} y.TimeStamps{i,j}+time_add z.TimeStamps{i,j}+time_add2 z1.TimeStamps{i,j}+time_add3 z2.TimeStamps{i,j}+time_add4 z3.TimeStamps{i,j}+time_add5 z4.TimeStamps{i,j}+time_add6];
            new(1).N{i,j}=[x(1).N{i,j}+y.N{i,j}+z.N{i,j}+z1.N{i,j}];%+z2.N{i,j}];            
        end
    end
end

for j=1:c
    for i=1:r
    if sum(sum(isnan(x(1).Waves{i,j})))==1 || sum(sum(isnan(y(1).Waves{i,j})))==1 || sum(sum(isnan(z(1).Waves{i,j})))==1 || sum(sum(isnan(z1(1).Waves{i,j})))==1
           new(1).Waves{i,j}=[NaN];
    else
           new(1).Waves{i,j}=[x.Waves{i,j} y.Waves{i,j} z.Waves{i,j} z1.Waves{i,j} z2.Waves{i,j} z3.Waves{i,j} z4.Waves{i,j}];    
    end
    
    end
end

for j=1
    for i=1:r
        new(1).data(i,:)=[x(1).data(i,:) y.data(i,:) z.data(i,:) z1.data(i,:) z2.data(i,:) z3.data(i,:) z4.data(i,:)];% z2.data(i,:)];
        new(1).wave(j,:)=[x(1).wave(j,:) y.wave(j,:) z.wave(j,:) z1.data(i,:) z2.data(i,:) z3.data(i,:) z4.data(i,:)];% z2.wave(j,:)];
    end
end
data=new.data;
Fs_lfp=new.Fs_lfp;
TimeStamps=new.TimeStamps;
Waves = new.Waves;


fname = strcat('data_block_T12_Cat_D1_allblocksTSonly',);
cd ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T39')
save (fname, 'Fs_lfp' 'Waves','TimeStamps', 'data','-v7.3')

%cd ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\S34')
%save (['Tanuj/Mat_files/raw_data/New (Acute_Neuromod_I)/data_block_R36_NewCat'], 'data', 'Fs_lfp', 'wave', 'TimeStamps','N')



