function [PC V ang_dist] = get_PC_compare2 (all_bins,Trial_binned,REF_PC,N,RANGE,MAX,WIN,OFFSET);
% data
% range in trial
% MAX --> maximum # of trials common
% WIN --> size of moving window

if ~exist('OFFSET')
    OFFSET=0; %starts with trial #OFFSET
end

disp('3 DIMENSION computations');
DIM=3;

%ZERO=find(RANGE==20);
targ_selected=[1:8];


MAX_TRIAL_NO=MAX;
moving_trial_window=WIN;
end_trials_range=OFFSET+MAX_TRIAL_NO-moving_trial_window;

fig_one=figure;
c=colormap('colorcube');



%pca based on one space
%[PC V] = get_PCs (all_bins{REF_PC},Trial_binned{REF_PC},N,RANGE,MAX,WIN,0);
[PC V] = get_PCs (all_bins{REF_PC});
disp ('pca based on one REF_pC');      

% % pca based on ALL trials to be projected
% temp_bins=[all_bins{2} all_bins{1}];
% [PC V] = get_PCs (temp_bins,Trial_binned{REF_PC},N,RANGE,MAX,WIN,0);
% disp ('PCA based on one space vs ALL data');         


disp('10 DIMENSION computations');
DIM=10;
if size(PC,1) < DIM
    DIM=size(PC,1);
    disp('DIMENSIONAL analysis parameter had to be changed');
end
    


disp ('??? subtract mean from pca projection');         
l_style=[':','-'];
for targ_selected=[1:8]
    %subplot(2,4,targ_selected)
    Trial_file1=Trial_binned{1};
    Trial_file2=Trial_binned{2};
    for k = targ_selected
        for n1=OFFSET+1:end_trials_range
            temp1=zeros(size(Trial_file1{1,1}));
            temp2=zeros(size(temp1));
            
            % FILE 1
            for n=n1:n1+(moving_trial_window-1)
                temp1=temp1 + Trial_file1{k,n};
            end
            temp1=temp1/moving_trial_window;
            temp1=temp1(:,RANGE);
            m=mean(temp1);
            signals1=PC'*(temp1-ones(size(temp1,1),1)*m);
            %signals1 = PC' * temp1(:,RANGE); % project the original data set
            %vector1=[signals1(1,:); signals1(2,:); signals1(3,:)];
            vector1=[signals1(1:DIM,:)];
                        
            % FILE 2
            for n=n1:n1+(moving_trial_window-1)
                temp2=temp2 + Trial_file2{k,n};
            end
            temp2=temp2/moving_trial_window;
            temp2=temp2(:,RANGE);
            m=mean(temp2);
            signals2=PC'*(temp2-ones(size(temp2,1),1)*m);
            %signals2 = PC' * temp2(:,RANGE); % project the original data set    
            %vector2=[signals2(1,:); signals2(2,:); signals2(3,:)];
            vector2=[signals2(1:DIM,:)];

                        
            ang_series=get_vector_ang(vector1',vector2');
            dist_series=get_vector_dist(vector1',vector2');
            
            subplot(2,1,1)
            plot(ang_series,'Color',c(k,:)); hold on;
            
            subplot(2,1,2)
            plot(dist_series,'Color',c(k,:)); hold on;
            
            hold_dist_series(targ_selected,:)=dist_series;
            hold_ang_series(targ_selected,:)=ang_series;
        end
    end
    %pause
end
subplot(2,1,1)
disp('CHECK sem calculation');
sem=std(hold_ang_series);
plot(mean(hold_ang_series),'k','LineWidth',4); hold on;
%plot(mean(hold_ang_series),'Color',[0.5 0.5 0.5],'LineWidth',10)
plot(mean(hold_ang_series)+sem,'k','LineWidth',2)
plot(mean(hold_ang_series)-sem,'k','LineWidth',2)
y=ylim;
%plot([ZERO ZERO], [y(1) y(2)],'r');
title('angle')
ang_dist{1}=hold_ang_series;
ang_dist{2}=sem;
subplot(2,1,2)
sem=std(hold_dist_series);
plot(mean(hold_dist_series),'k','LineWidth',4);  hold on;
%plot(mean(hold_ang_series),'Color',[0.5 0.5 0.5],'LineWidth',10)
plot(mean(hold_dist_series)+sem,'k','LineWidth',2)
plot(mean(hold_dist_series)-sem,'k','LineWidth',2)
y=ylim;
%plot([ZERO ZERO], [y(1) y(2)],'r');
title('distance')
subplot
ang_dist{3}=hold_dist_series;
ang_dist{4}=sem;

% plots the two neural traj per target --> ONLY 1 target
l_w=[2 1];
c=['b' 'r'];
figure
%set(gcf,'Color',[0 0 0 ])
for index=1:2
    target_selected=1;
        Trial_file=Trial_binned{index};
        for k = targ_selected
            for n1=OFFSET+1:end_trials_range
                temp=zeros(size(Trial_file1{1,1}));
                for n=n1:n1++(moving_trial_window-1)
                    temp=temp + Trial_file{k,n};
                end
                temp=temp/moving_trial_window;
                subtemp=temp(:,RANGE);
                signals = PC' * subtemp; % project the original data set
                plot3(signals(1,1),signals(2,1),signals(3,1),'o','Color',[1 1 1],'MarkerSize',5,'LineWidth',2.5);
                hold on;            
                set(gca,'Color',[0 0 0 ])
                plot3(signals(1,:),signals(2,:),signals(3,:),c(index),'LineWidth',l_w(index));
                hold on;
            end
        end
        axis off;
    end
end


% % plots the two neural traj per target
% l_w=[2 1];
% c=['b' 'g'];
% fig_two=figure;
% set(gcf,'Color',[0 0 0 ])
% for index=1:2
%     for targ_selected=[1:8]
%         subplot(2,4,targ_selected)
%         Trial_file=Trial_binned{index};
%         for k = targ_selected
%             for n1=OFFSET+1:end_trials_range
%                 temp=zeros(size(Trial_file1{1,1}));
%                 for n=n1:n1++(moving_trial_window-1)
%                     temp=temp + Trial_file{k,n};
%                 end
%                 temp=temp/moving_trial_window;
%                 subtemp=temp(:,RANGE);
%                 signals = PC' * subtemp; % project the original data set
%                 plot3(signals(1,1),signals(2,1),signals(3,1),'o','Color',[1 1 1],'MarkerSize',5,'LineWidth',2.5);
%                 hold on;            
%                 set(gca,'Color',[0 0 0 ])
%                 plot3(signals(1,:),signals(2,:),signals(3,:),c(index),'LineWidth',l_w(index));
%                 hold on;
%             end
%         end
%         axis off;
%     end
% end
