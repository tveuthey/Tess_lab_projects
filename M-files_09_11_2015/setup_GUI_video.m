function fh = setup_GUI_video(varargin)
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

p='C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\VIDEOS\';

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
%fh.NAME = uicontrol(fh.fig,'Style','edit',...
%   'Position',[140 575 100 45]);
%set(fh.NAME,'String','Rxx');
%set(fh.NAME,'FontSize',20);

%



% FILE SELECTOR
% fh.fname = uicontrol(fh.fig,'Style','listbox',...
%     'Position',[35 530 150 35],...
%     'String',{'FNAME'; 'TRIAL'},...
%     'FontSize',8);
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
    'String','MARK HAND',...
    'Position',[20 190 180 30],...
    'Callback',@mark_callback);
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

% fh.pause = uicontrol(fh.fig,'Style','togglebutton',...
%     'String','NEXT FRAME',...
%     'Position',[480 50 100 50],...
%     'Callback',@pause_callback);
% fh.doorOpen = uicontrol(fh.fig,'Style','pushbutton',...
%     'String','PREV FRAME',...
%     'Position',[610 50 100 50],...
%     'Callback',@doorOpen_callback);



% READOUT of trial ATTEMPTS
% fh.ax_text=subplot('Position',[0.05 0.6 0.4 0.3]);
% axis off
% fh.trial_time=text(0,0.9,'0:00','FontSize',20,'Color','r');
% fh.trial_no=text(0,0.7,'Trials = 0','FontSize',14);
% fh.trial_Ig=text(0,0.58,'Ignored = 0','FontSize',14);
% fh.trial_At=text(0,0.46,'Attempted (nose only) = 0','FontSize',14);
% fh.trial_At2=text(0,0.34,'Attempted (nose + arm) = 0','FontSize',14);
% fh.trial_MSG=text(0,0.15,'','FontSize',14);

% %PLOT FOR SENSOR VALUESW
% samples=100;
% hold_sens_data=zeros(samples,3);
% hold_thresh=zeros(samples,3);
% fh.sens_data1=plot(fh.sens_ax,hold_sens_data(:,1),'b','LineWidth',2);
% hold on;
% fh.sens_data2=plot(fh.sens_ax,hold_sens_data(:,2),'k','LineWidth',2);
% fh.sens_data3=plot(fh.sens_ax,hold_sens_data(:,3),'r','LineWidth',2);
% fh.sens_thresh1=plot(fh.sens_ax,hold_thresh(:,1),'b:','LineWidth',2);
% fh.sens_thresh2=plot(fh.sens_ax,hold_thresh(:,2),'k:','LineWidth',2);
% fh.sens_thresh3=plot(fh.sens_ax,hold_thresh(:,3),'r:','LineWidth',2);
% ylim([0 1000])
% set(fh.sens_ax,'XTickLabel',[])
% axis off

% INITIALIZATION
set(fh.start_frame, 'String','1')
set(fh.end_frame, 'String','120')
set(fh.step, 'String','1')

    function startStop_callback(hObject,eventdata)
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
        
        %p='C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\VIDEOS\';
        evalin('base','load([p fname])')

        statusUpdate('')
        vid_f_lat=1./mean([diff(t_lat)]);
        t_step=1/vid_f_lat;
        statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
        statusUpdate([num2str(vid_f_lat),' Hz'])
        statusUpdate(['Drop time = ',num2str(t_video_drop)])
        statusUpdate(['Drop frame = ',num2str(t_seq)])
        set(fh.start_frame,'String',num2str(t_seq-25));
        set(fh.end_frame,'String',num2str(t_seq+10));
        exist([p fname2],'file')
        if  exist([p fname2],'file')
             evalin('base','load([p fname2])')
             hold_xy=hold_paths(val_trial);
             if ~isempty(hold_xy)
                 statusUpdate('Paths also loaded...')
             else
                 statusUpdate('No path found...')
             end
        end

        LOAD=0;
        plotVID_path
    end

    function restartStop_callback(hObject,eventdata)
        LOAD=0;
        plotVID_path
    end

    function prev_trial_callback(hObject,eventdata)
        val_trial =get(fh.NAME_trials,'Value');
        if val_trial > 1
            val_trial =get(fh.NAME_trials,'Value')-1; %advance
        end
        set(fh.NAME_trials,'Value',val_trial);
        LOAD=1;
        plotVID_path;
    end

    function next_trial_callback(hObject,eventdata)
        val_trial =get(fh.NAME_trials,'Value')+1; %advance 
        set(fh.NAME_trials,'Value',val_trial);
        LOAD=1;
        plotVID_path;
    end

    function name_callback(hObject,eventdata)
        val=(get(fh.NAME_txt,'Value'))
        set(fh.NAME_subsets,'String',unique_dates{val});
        set(fh.NAME_subsets,'Value',1);
        [trial_ls]=find_trials(unique_rats,unique_dates,val,1,p);
        set(fh.NAME_trials,'String',trial_ls);
        statusUpdate('------------------------------');
        statusUpdate(unique_rats{val});
        statusUpdate(unique_dates{val}{1});
        statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
        hold_paths=cell(length(trial_ls),1); %resets the markings
        statusUpdate(['Hold paths reset']);
    end


    function nameSUB_callback (hObject,eventdata)
        val_rat=(get(fh.NAME_txt,'Value'))
        val=(get(fh.NAME_subsets,'Value'))
        %temp_date=unique_dates{val};
        [trial_ls]=find_trials(unique_rats,unique_dates,val_rat,val,p);
        set(fh.NAME_trials,'String',trial_ls);
        statusUpdate('------------------------------');
        statusUpdate(unique_rats{val_rat});
        statusUpdate(unique_dates{val_rat}{val});
        statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
        hold_paths=cell(length(trial_ls),1);  %resets the markings
        statusUpdate(['Hold paths reset']);
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
  
%         hold_paths
%         subplot('Position',[0.32 0.05 0.61 0.12])
%         plot((hold_xy(:,2)-min(hold_xy(:,2)))/max((hold_xy(:,2))),...
%             'k','LineWidth',2);
%         
%         axis off
%         subplot('Position',[0.32 0.17 0.61 0.12])
%         plot((hold_xy(:,1)-min(hold_xy(:,1)))/max((hold_xy(:,1))),...
%             'r','LineWidth',2);
%         axis off
        hold_paths{val_trial}=hold_xy;
        save ([p fname2],'hold_paths')
    end

    function fig_close(hObject,eventdata)
        delete(a)
        delete(fh.fig)
        delete(vid)
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



    function pellet_callback(hObject,eventdata)
        %if a.servoRead(2) < 90
        disp('Dispensing extra pellet...')
        dispense2(3)
        %end
    end

    function pause_callback(hObject,eventData)
        if get(fh.pause,'Value')
            set(fh.pause,'String','RESUME')
            uiwait
        else
            set(fh.pause,'String','PAUSE')
            uiresume
        end
    end


    function calib (hObject,eventData)
        calibrate_sensor;
    end

    function Schedule_shape(hObject,eventData)
        if get(fh.status2,'value') == 2
            set(fh.camera_stat,'Visible','Off');
            set(fh.camera_re,'Visible','Off');
            set(fh.cam_type,'Visible','Off');
            set(fh.camera_save,'Visible','Off');
            set(fh.Iti ,'String','6 0');
            set(fh.doorWaittext, 'Visible', 'Off');
            set(fh.doorWait, 'Visible', 'Off')
            set(fh.trial_Ig,'String','');
            set(fh.trial_At,'String','');
            set(fh.trial_At2,'String','');
            set(fh.trial_MSG,'String','');
        end
        if get(fh.status2,'value') == 1
            set(fh.camera_stat,'Visible','On');
            set(fh.camera_re,'Visible','On');
            set(fh.cam_type,'Visible','On');
            set(fh.camera_save,'Visible','On');
            set(fh.Iti ,'String','10 0');
            set(fh.doorWaittext, 'Visible', 'On')
            set(fh.doorWait, 'Visible', 'On')
            trial=0;
            trial_ig=0;
            trial_at_n=0; %only nose poke; no reach
            trial_at_na=0; %nose + change in pellet sensor
            set(fh.trial_Ig,'String',['Ignored = ',num2str(trial_ig)]);
            set(fh.trial_At,'String',['Attempted (nose) = ',num2str(trial_at_n)]);
            set(fh.trial_At2,'String',['Attempted (nose + arm) = ',num2str(trial_at_na)]);
            set(fh.trial_MSG,'String','');
        end
    end



    function doorOpen_callback(hObject,eventdata)
        doorstate(0)  %OPEN
    end

    function doorClose_callback(hObject,eventdata)
        doorState(1)  %CLOSE
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
            
            %p='C:\Users\Ganguly Lab\Documents\MATLAB\VIDEOS\';
            evalin('base','load([p fname])')
            
            evalin('base','fname2')
            statusUpdate('')
            vid_f_lat=1./mean([diff(t_lat)]);
            t_step=1/vid_f_lat;
            statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
            statusUpdate([num2str(vid_f_lat),' Hz'])
            statusUpdate(['Drop time = ',num2str(t_video_drop)])
            statusUpdate(['Drop frame = ',num2str(t_seq)])
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
        % PLOT function
        %set(fh.sens_ax2_p,'Xdata',1,'Ydata',1)
        %set(fh.sens_ax3_p,'Xdata',1,'Ydata',1)
        index=s_frame;
        val_trial =get(fh.NAME_trials,'Value'); %advance 
        hold_xy=hold_paths{val_trial};
          if ~isempty(hold_xy)
            set(fh.sens_ax2_p,'Xdata',1:length(hold_xy),...
                'Ydata',-hold_xy(:,1))
            set(fh.sens_ax3_p,'Xdata',1:length(hold_xy(:,2)),...
                'Ydata',hold_xy(:,2))           
        else
            set(fh.sens_ax2_p,'Xdata',1,'Ydata',1)
            set(fh.sens_ax3_p,'Xdata',1,'Ydata',1)
        end
        while index <= e_frame && index <= size(im_lat,4)
            subplot(fh.sens_ax)
            %VAL=get(fh.start,'Value');
            imshow(YUY2toRGB(im_lat(:,:,:,index)));
            text(20,30,['F',num2str(index)],'Color',[1 1 0],'FontSize',20)
            if ~isempty(hold_xy)
                hold on;
                plot(hold_xy(1:index-s_frame+1,1),hold_xy(1:index-s_frame+1,2),'g','Linewidth',3)
            end
            index=index+step;
            pause(0.1);
        end
      
        %         if ~isempty(hold_xy)
        %           temp_x=plot(-(hold_xy(:,1)-min(hold_xy(:,1))));
        %           temp_y=plot((hold_xy(:,2)-min(hold_xy(:,2))));
%           set(fh.sens_ax2_p,'Xdata',1:length(temp_x),'Ydata',temp_x)
%           set(fh.sens_ax3_p,'Xdata',1:length(temp_y),'Ydata',temp_y)
%         end
    end

end