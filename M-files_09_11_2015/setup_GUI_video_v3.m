function fh = setup_GUI_video_v3(varargin)
global fh
global im_lat
global t_lat
global t_seq
global t_step
global p
global t_video_drop
global fname
global fname2
global hold_xy
global trial_no
global hold_paths
global unique_rats
global temp
global rat_id
global unique_dates
global trial_ls
global LOAD
global disp_fig
global file_vals
global hold_starts

%-----------------CREATE GUI-----------------------
%Main figure window
if isempty(varargin) %if just checking GUI layout
    fh.fig = figure('Position',[ 15    84   769   655],...
        'MenuBar','none','NumberTitle','off',...
        'Name','Sharing Data with UserData');
    
else %elseif during a rat test
    fh.fig = figure('Position',[ 15    84   769   655],...
        'MenuBar','none','NumberTitle','off',...
        'CloseRequestFcn',@fig_close,...
        'Name','Sharing Data with UserData');
end

p='C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_Video\';

% VIDEO FRAME
fh.sens_ax=subplot('Position',[0.3 0.3 0.65 0.5]);
axis off
fh.sens_ax2=subplot('Position',[0.32 0.17 0.61 0.12]);
fh.sens_ax2_p=line(1,1,'Color','r','LineWidth',2);
axis off;
fh.sens_ax3=subplot('Position',[0.32 0.05 0.61 0.12]);
fh.sens_ax3_p=line(1,1,'Color','k','LineWidth',2);
axis off;

%rat name
fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[35 575 150 40],...
    'String','Rat XX',...
    'Callback',@name_callback);
set(fh.NAME_txt,'FontSize',20);
set(fh.NAME_txt,'BackgroundColor',[1 0.1 0 ]);
[unique_rats temp rat_id unique_dates] = find_rats (p);
set(fh.NAME_txt,'String',unique_rats);
% set(fh.NAME_txt,'String','T12');
% unique_rats = 'T12';
% unique_dates = {'2013_6_21'};
% fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[35 575 150 40],...
%     'String','Rat XX');
 %     
fh.NAME_subsets = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[210 575 250 40],...
    'String','Rat XX',...
    'Callback',@nameSUB_callback);
set(fh.NAME_subsets,'FontSize',12);
set(fh.NAME_subsets,'String',unique_dates{1});

fh.NAME_trials = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[490 575 60 40],...
    'String','1');
set(fh.NAME_trials,'FontSize',16);
set(fh.NAME_trials,'BackgroundColor',[0 1 0 ]);
[trial_ls]=find_trials(unique_rats,unique_dates,1,1,p);
set(fh.NAME_trials,'String',trial_ls);
hold_paths=cell(length(trial_ls),1); %resets the markings
hold_starts=cell(length(trial_ls),1);  %resets the markings

%fh.NAME = uicontrol(fh.fig,'Style','edit',...
%   'Position',[140 575 100 45]);
%set(fh.NAME,'String','Rxx');
%set(fh.NAME,'FontSize',20);

fh.keep = uicontrol(fh.fig,'Style','radiobutton',...
    'Position',[575 575 100 40],...
    'String','Keep settings',...
    'Value',1);

% FILE SELECTOR
fh.fname = uicontrol(fh.fig,'Style','listbox',...
    'Position',[35 530 150 35],...
    'String',{'FNAME'; 'TRIAL'},...
    'FontSize',8);
fh.next_trial = uicontrol(fh.fig,'Style','pushbutton',...
    'String','NEXT',...
    'Position',[120 485 80 40],...
    'Callback',@next_trial_callback);
fh.prev_trial = uicontrol(fh.fig,'Style','pushbutton',...
    'String','PREV',...
    'Position',[35 485 80 40],...
    'Callback',@prev_trial_callback);

fh.status = uicontrol(fh.fig,'Style','listbox',...
    'Position',[35 270 180 200],...
    'String',{'Video values...'},...
    'FontSize',8);



% ANIMATE PARAMETERS
fh.start = uicontrol(fh.fig,'Style','pushbutton',...
    'String','ANIMATE',...
    'Position',[35 530 165 40],...
    'Callback',@startStop_callback);

fh.restart = uicontrol(fh.fig,'Style','pushbutton',...
    'String','RE-ANIMATE',...
    'Position',[20 225 180 30],...
    'Callback',@restartStop_callback);
fh.mark = uicontrol(fh.fig,'Style','pushbutton',...
    'String','MARK KINEMATICS',...
    'Position',[20 190 180 30],...
    'Callback',@mark_callback);

fh.mark_start = uicontrol(fh.fig,'Style','pushbutton',...
    'String','MARK START',...
    'Position',[20 155 180 30],...
    'Callback',@mark2_callback);

uicontrol(fh.fig,'Style','text',...
    'Position',[20 30 100 30],...
    'String','Step',...
    'FontSize',12);
fh.step = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 30 70 30]);
uicontrol(fh.fig,'Style','text',...
    'Position',[20 70 100 30],...
    'String','End Frame',...
    'FontSize',12);
fh.end_frame = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 70 70 30]);
uicontrol(fh.fig,'Style','text',...
    'Position',[20 110 100 30],...
    'String','Start Frame',...
    'FontSize',12);
fh.start_frame = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 110 70 30]);


% INITIALIZATION
set(fh.start_frame, 'String','1')
set(fh.end_frame, 'String','120')
set(fh.step, 'String','1')

%if ~isempty(file_vals)
get(fh.NAME_txt,'Value')
    name_callback
    disp('setup...')
%end

    function startStop_callback(hObject,eventdata)
        close(disp_fig);
        val_rat=(get(fh.NAME_txt,'Value'));
        val_date=(get(fh.NAME_subsets,'Value'));
        val_trial =get(fh.NAME_trials,'Value');
        val_trial=trial_ls(val_trial);
        base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date});
        fname=strcat(base_name,'-',num2str(val_trial),'.mat');
        fname2=strcat(base_name,'-','PATH','.mat');
        fname=fname{1};
        fname2=fname2{1};
        dash=find(fname=='-');
        
        p='C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_Video\';
        evalin('base','load([p fname])')
        
%         statusUpdate('')
        vid_f_lat=1./mean([diff(t_lat)]);
        t_step=1/vid_f_lat;
%         statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
%         statusUpdate([num2str(vid_f_lat),' Hz'])
%         statusUpdate(['Drop time = ',num2str(t_video_drop)])
%         statusUpdate(['Drop frame = ',num2str(t_seq)])
        set(fh.start_frame,'String',num2str(t_seq-25));
        set(fh.end_frame,'String',num2str(t_seq+10));
        exist([p fname2],'file')
        if  exist([p fname2],'file')
            evalin('base','load([p fname2])')
            hold_xy=hold_paths(val_trial);
            if ~isempty(hold_xy)
%                 statusUpdate('Paths also loaded...')
            else
%                 statusUpdate('No path found...')
            end
        end
        
        LOAD=0;
        plotVID_path
    end

    function restartStop_callback(hObject,eventdata)
        LOAD=0;
        close (disp_fig);
        plotVID_path
    end

    function prev_trial_callback(hObject,eventdata)
        val_trial =get(fh.NAME_trials,'Value');
        if val_trial > 1
            val_trial =get(fh.NAME_trials,'Value')-1; %advance
        end
        set(fh.NAME_trials,'Value',val_trial);
        LOAD=1;
        close (disp_fig);
        plotVID_path;
    end

    function next_trial_callback(hObject,eventdata)
        val_trial =get(fh.NAME_trials,'Value')+1; %advance
        set(fh.NAME_trials,'Value',val_trial);
        LOAD=1;
        close (disp_fig);
        plotVID_path;
    end

    function name_callback(hObject,eventdata)
        val=(get(fh.NAME_txt,'Value'))
        set(fh.NAME_subsets,'String',unique_dates{val});
        set(fh.NAME_subsets,'Value',1);
        [trial_ls]=find_trials(unique_rats,unique_dates,val,1,p);
        set(fh.NAME_trials,'String',trial_ls);
%         statusUpdate('------------------------------');
%         statusUpdate(unique_rats{val});
%         statusUpdate(unique_dates{val}{1});
%         statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
         hold_paths=cell(length(trial_ls),1); %resets the markings
        hold_starts=cell(length(trial_ls),1);  %resets the markings
%         statusUpdate(['Hold paths reset']);
    end


    function nameSUB_callback (hObject,eventdata)
        val_rat=(get(fh.NAME_txt,'Value'))
        val=(get(fh.NAME_subsets,'Value'))
        %temp_date=unique_dates{val};
        [trial_ls]=find_trials(unique_rats,unique_dates,val_rat,val,p);
        set(fh.NAME_trials,'String',trial_ls);
%         statusUpdate('------------------------------');
%         statusUpdate(unique_rats{val_rat});
%         statusUpdate(unique_dates{val_rat}{val});
%         statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
        hold_paths=cell(length(trial_ls),1);  %resets the markings
        hold_starts=cell(length(trial_ls),1);  %resets the markings

%         statusUpdate(['Hold paths reset']);
    end

    function mark_callback(hObject,eventdata)
        hold_xy=[];
        val_trial =get(fh.NAME_trials,'Value');
        subplot(fh.sens_ax)
        s_frame=get(fh.start_frame,'String');
        s_frame=str2num(s_frame)
        e_frame=get(fh.end_frame,'String');
        e_frame=str2num(e_frame)
        step=get(fh.step,'String');
        step=str2num(step)
        index=s_frame;
        while index <= e_frame
            imshow(YUY2toRGB(im_lat(:,:,:,index)));
            text(20,30,['F',num2str(index)],'Color',[1 1 0],...
                'FontSize',20)
            [x,y]=ginput(1);
            hold_xy=[hold_xy; x y]
            rectangle('Position',[x y 10 10],'curvature',[0 0],...
                'EdgeColor','r','LineWidth',1);
            index=index+step;disp(index);
        end
        disp(index)
        disp(size(hold_xy))
        hold on
        plot(hold_xy(:,1),hold_xy(:,2),'r','Linewidth',3)
        
        set(fh.sens_ax2_p,'Xdata',1:length(hold_xy),...
            'Ydata',-hold_xy(:,1))
        set(fh.sens_ax3_p,'Xdata',1:length(hold_xy(:,2)),...
            'Ydata',hold_xy(:,2))
        
        hold_paths{val_trial}=hold_xy;
        save ([p fname2],'hold_paths', 'hold_starts')
    end

    function mark2_callback(hObject,eventdata)
        hold_s=[];
        val_trial =get(fh.NAME_trials,'Value');
        subplot(fh.sens_ax)
        s_frame=get(fh.start_frame,'String');
        s_frame=str2num(s_frame)
        e_frame=get(fh.end_frame,'String');
        e_frame=str2num(e_frame)
        step=get(fh.step,'String');
        step=str2num(step)
        index=s_frame;
        temp_f=figure;
        set(temp_f,'Position',[  215    89   500   582]);
        nxt = uicontrol(temp_f,'Style','pushbutton',...
            'String','NEXT',...
            'Position',[200 20 180 30],...
            'Callback',@advance);
         prev = uicontrol(temp_f,'Style','pushbutton',...
            'String','PREVIOUS',...
            'Position',[20 20 180 30],...
            'Callback',@goback);
         stop = uicontrol(temp_f,'Style','pushbutton',...
            'String','MARK',...
            'Position',[20 60 180 30],...
            'Value',1);
        while get(stop,'Value')
            imshow(YUY2toRGB(im_lat(:,:,:,index)));
            text(20,30,['F',num2str(index)],'Color',[1 1 0],...
                'FontSize',20);
            pause(0.1)
        end

        hold_s=index-s_frame;
        hold_starts{val_trial}=hold_s;
        close(temp_f)
        save ([p fname2],'hold_paths', 'hold_starts')
        
        function advance (hObject,eventdata)
            index=index+1          
        end
        function goback (hObject,eventdata)          
              index=index-1

        end
        
        
    end



    function fig_close(hObject,eventdata)
        beep
        val_rat=(get(fh.NAME_txt,'Value'))
        val_date=(get(fh.NAME_subsets,'Value'))
        val_trial =get(fh.NAME_trials,'Value')
        KEEP=get(fh.keep,'Value')
        save ('settings.mat', 'val_rat', 'val_date' ,'val_trial','KEEP')
        delete(fh.fig)
        %delete(vid)
        %elete(vid3)
    end

    function pelLoc_callback(hObject,eventdata)
        if strcmp(get(fh.pelLoc,'String'),'BOTH')
            set(fh.pelLoc,'BackgroundColor',[0.2 1 0.2],'String','LEFT')
        elseif strcmp(get(fh.pelLoc,'String'),'LEFT')
            set(fh.pelLoc,'BackgroundColor',[1 0.2 0.2],'String','RIGHT')
        else
            set(fh.pelLoc,'BackgroundColor',[0.2 0.2 1],'String','BOTH')
        end
    end

    function plotVID_path (hObject,eventdata)
        if LOAD == 1
            val_rat=(get(fh.NAME_txt,'Value'));
            val_date=(get(fh.NAME_subsets,'Value'));
            val_trial =get(fh.NAME_trials,'Value');
            val_trial=trial_ls(val_trial);
            base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date});
            fname=strcat(base_name,'-',num2str(val_trial),'.mat');
            fname2=strcat(base_name,'-','PATH','.mat');
            fname=fname{1};
            fname2=fname2{1};
            dash=find(fname=='-');
            
          p='C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_Video\';
           evalin('base','load([p fname])')
            
            evalin('base','fname2')
%             statusUpdate('')
            vid_f_lat=1./mean([diff(t_lat)]);
            t_step=1/vid_f_lat;
%             statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
%             statusUpdate([num2str(vid_f_lat),' Hz'])
%             statusUpdate(['Drop time = ',num2str(t_video_drop)])
%             statusUpdate(['Drop frame = ',num2str(t_seq)])
            set(fh.start_frame,'String',num2str(t_seq-25));
            set(fh.end_frame,'String',num2str(t_seq+10));
            exist([p fname2],'file')
            if  exist([p fname2],'file')
                evalin('base','load([p fname2])')
                statusUpdate('Paths also loaded...')
            end
        end
        step=get(fh.step,'String');
        step=str2num(step)
        s_frame=get(fh.start_frame,'String');
        s_frame=str2num(s_frame)
        e_frame=get(fh.end_frame,'String');
        e_frame=str2num(e_frame)
        
        drop_frame=t_seq-s_frame;
        
        disp_fig=figure(100);
        set(disp_fig,'Position',[822    90   500   582]);
        index=s_frame;
        val_trial =get(fh.NAME_trials,'Value'); %advance
        hold_xy=hold_paths(val_trial);
        hold_xy=hold_xy{1};
        %pause
        %         figure
        %         plot(-hold_xy(drop_frame-10:drop_frame,1));
        %         hold on;plot([reach_on reach_on],[1 200]);
        %         reach_on=drop_frame-reach_on;
        if ~isempty(hold_xy)
            
            hold_xy=hold_paths{val_trial};
            hold_xy(:,1)=smooth(hold_xy(:,1),6,  'loess'   );
            hold_xy(:,2)=smooth(hold_xy(:,2),6 , 'loess'   );
            
            %find start of reach (min)
            win_prior=15;
            [m_x reach_on]=min (-hold_xy(drop_frame-win_prior:drop_frame,1))
            disp(-hold_xy(drop_frame-win_prior:drop_frame))
            
            disp(m_x)
            reach_on=drop_frame-(win_prior-reach_on)-1;
            disp(-hold_xy(reach_on))
            subplot(6,1,5);
            title(drop_frame)
            plot(-hold_xy(:,1),'r','LineWidth',2)
            ylim([min(-hold_xy(:,1)) max(-hold_xy(:,1))]);
            axis off;hold on
            a=axis;line([drop_frame drop_frame],a(3:4),'LineStyle',':');
            
            line([reach_on reach_on],a(3:4),'LineStyle',':','Color','c','LineWidth',3);
            line([0 36],[m_x m_x])
            
            subplot(6,1,6);
            plot(hold_xy(:,2),'k','LineWidth',2)
            a=axis;line([drop_frame drop_frame],a(3:4),'LineStyle',':');
            
            hold on; axis off;
            % a=axis;line([25 25],a(3:4));
            %             set(fh.sens_ax2_p,'Xdata',1:length(hold_xy),...
            %                 'Ydata',-hold_xy(:,1))
            %             set(fh.sens_ax3_p,'Xdata',1:length(hold_xy(:,2)),...
            %                 'Ydata',hold_xy(:,2))
            %         else
            %             set(fh.sens_ax2_p,'Xdata',1,'Ydata',1)
            %             set(fh.sens_ax3_p,'Xdata',1,'Ydata',1)
        end
        subplot('Position',[0.05 0.4 0.9 0.6])
        while index <= e_frame && index <  size(im_lat,4)
            %subplot(fh.sens_ax)
            %VAL=get(fh.start,'Value');
            imshow(YUY2toRGB(im_lat(:,:,:,index)));
            text(20,30,['F',num2str(index)],'Color',[1 1 0],'FontSize',20)
            if ~isempty(hold_xy)
                hold on;
                plot(hold_xy(1:index-s_frame+1,1),hold_xy(1:index-s_frame+1,2),'g','Linewidth',3)                
                if (index-s_frame) >= reach_on
                    plot(hold_xy(reach_on,1),hold_xy(reach_on,2),'co','Linewidth',6)
                end           
                if (index-s_frame) >= drop_frame
                    plot(hold_xy(drop_frame-1,1),hold_xy(drop_frame-1,2),'bo','Linewidth',6)
                end
            end
            index=index+step;
            pause(0.1);
        end
    end

end