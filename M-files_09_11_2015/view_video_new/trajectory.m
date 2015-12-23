function fh = trajectory(varargin)
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
global hold_paths
global hold_trial_vals
global hold_STARTS

global trial_no
global unique_rats
global temp
global rat_id
global unique_dates
global trial_ls
global LOAD
global disp_fig
global file_vals
global trial_step
global STOP

%-----------------CREATE GUI-----------------------
%Main figure window
if isempty(varargin) %if just checking GUI layout
    fh.fig = figure('Position',[1316          14         532         880],...
        'MenuBar','none','NumberTitle','off',...
        'Name','Sharing Data with UserData');
    
else %elseif during a rat test
    fh.fig = figure('Position',[1316          14         532         880],...
        'MenuBar','none','NumberTitle','off',...
        'CloseRequestFcn',@fig_close,...
        'Name','Sharing Data with UserData');
end

%p='C:\Users\Karunesh\Desktop\VIDEOS\';
p='E:\T28\Day1\'

Y1=800; %height of the first row
Y2=750;
%
% % VIDEO FRAME
% fh.sens_ax=subplot('Position',[0.3 0.3 0.65 0.5]);
% axis off
% fh.sens_ax2=subplot('Position',[0.32 0.17 0.61 0.12]);
% fh.sens_ax2_p=line(1,1,'Color','r','LineWidth',2);
% axis off;
% fh.sens_ax3=subplot('Position',[0.32 0.05 0.61 0.12]);
% fh.sens_ax3_p=line(1,1,'Color','k','LineWidth',2);
% axis off;

%rat name
fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[250 Y1-60 150 50],...
    'String','Rat XX',...
    'Callback',@name_callback);
set(fh.NAME_txt,'FontSize',20);
set(fh.NAME_txt,'BackgroundColor',[1 0.1 0 ]);
[unique_rats temp rat_id unique_dates] = find_rats (p);
set(fh.NAME_txt,'String',unique_rats);

% fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[35 575 150 40],...
%     'String','Rat XX');

fh.NAME_subsets = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[250 Y1-125 250 40],...
    'String','Rat XX',...
    'Callback',@nameSUB_callback);
set(fh.NAME_subsets,'FontSize',12);
set(fh.NAME_subsets,'String',unique_dates{1});

fh.NAME_trials = uicontrol(fh.fig,'Style','popupmenu',...
    'Position',[250 Y1-175 60 40],...
    'String','1',...
    'Callback',@triallist_callback);
set(fh.NAME_trials,'FontSize',16);
set(fh.NAME_trials,'BackgroundColor',[0 1 0 ]);
[trial_ls]=find_trials(unique_rats,unique_dates,1,1,p);
set(fh.NAME_trials,'String',trial_ls);
%fh.NAME = uicontrol(fh.fig,'Style','edit',...
%   'Position',[140 575 100 45]);
%set(fh.NAME,'String','Rxx');
%set(fh.NAME,'FontSize',20);

fh.keep = uicontrol(fh.fig,'Style','radiobutton',...
    'Position',[35 Y1+4 100 40],...
    'String','SAVE settings',...
    'Value',1);

fh.FILT = uicontrol(fh.fig,'Style','radiobutton',...
    'Position',[135 Y1+4 100 40],...
    'String','USE FILTERS',...
    'Value',1);

% FILE SELECTOR
% fh.fname = uicontrol(fh.fig,'Style','listbox',...
%     'Position',[35 530 150 35],...
%     'String',{'FNAME'; 'TRIAL'},...
%     'FontSize',8);
fh.next_trial = uicontrol(fh.fig,'Style','pushbutton',...
    'String','NEXT',...
    'Position',[120 Y2 80 45],...
    'Callback',@next_trial_callback);
fh.prev_trial = uicontrol(fh.fig,'Style','pushbutton',...
    'String','PREV',...
    'Position',[35 Y2 80 45],...
    'Callback',@prev_trial_callback);

fh.status = uicontrol(fh.fig,'Style','listbox',...
    'Position',[35 270 180 400],...
    'String',{'Video values...'},...
    'FontSize',8);



% ANIMATE PARAMETERS
fh.start = uicontrol(fh.fig,'Style','pushbutton',...
    'String','ANIMATE',...
    'Position',[35 Y2-70 165 60],...
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


% TRIAL CHARACTERISTICS
fh.KEEP_TRIAL = uicontrol(fh.fig,'Style','togglebutton',...
    'String','Trial OK','Value',0,...
    'Position',[250 Y1-230 100 50],'FontSize',10,...
    'BackgroundColor','g','ForegroundColor',[0 0 0],...
    'Callback',@keep_trial_callback);
fh.CORRECT = uicontrol(fh.fig,'Style','togglebutton',...
    'String','INCORRECT','Value',0,...
    'Position',[250 Y1-310 100 50],'FontSize',10,...
    'BackgroundColor','k','ForegroundColor',[1 1 1],...
    'Callback',@correct_callback);
fh.ATTEMPTS = uicontrol(fh.fig,'Style','edit',...
    'Position',[360 Y1-310 60 50],'String','0','FontSize',15);
fh.SAVE_CHAR = uicontrol(fh.fig,'Style','pushbutton',...
    'String','SAVE','Value',0,...
    'Position',[250 Y1-400 150 80],'FontSize',13,...
    'BackgroundColor',[0.5 0.5 0],'ForegroundColor',[0 0 0],...
    'Callback',@save_char_callback);


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
        % 'ANIMATE' button
        trial_step=0;
        LOAD=1;
        plotVID_path
    end

    function restartStop_callback(hObject,eventdata)
        % 'REANIMATE' button
        LOAD=0;
        plotVID_path
    end

    function prev_trial_callback(hObject,eventdata)
        % PREVIOUS button
        trial_step=-1;
        LOAD=1;
        plotVID_path;
    end

    function next_trial_callback(hObject,eventdata)
        %NEXT button
        trial_step=1;
        LOAD=1;
        plotVID_path;
    end

    function name_callback(hObject,eventdata)
        % FUNCTION for RAT NAME (e.g. S15)
        val=(get(fh.NAME_txt,'Value'))
        set(fh.NAME_subsets,'String',unique_dates{val});
        set(fh.NAME_subsets,'Value',1);
        [trial_ls]=find_trials(unique_rats,unique_dates,val,1,p);
        set(fh.NAME_trials,'String',trial_ls);
%         statusUpdate('------------------------------');
%         statusUpdate(unique_rats{val});
%         statusUpdate(unique_dates{val}{1});
%         statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
%         %hold_paths=cell(length(trial_ls),1); %resets the markings
        %hold_starts=cell(length(trial_ls),1);  %resets the markings
%         statusUpdate(['Hold paths reset']);
        trial_step=-10;LOAD=1; % flags to open new file
    end


    function nameSUB_callback (hObject,eventdata)
        % FUNCTION for DAY of FILES
        val_rat=(get(fh.NAME_txt,'Value'));
        disp('Change session...')
        val=(get(fh.NAME_subsets,'Value'));
        set(fh.NAME_trials,'Value',1) %TRIAL reset to 1
        %temp_date=unique_dates{val};
        [trial_ls]=find_trials(unique_rats,unique_dates,val_rat,val,p);
        set(fh.NAME_trials,'String',trial_ls);
%         statusUpdate('------------------------------');
%         statusUpdate(unique_rats{val_rat});
%         statusUpdate(unique_dates{val_rat}{val});
%         statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
%         %hold_paths=cell(length(trial_ls),1);  %resets the markings
%         %hold_starts=cell(length(trial_ls),1);  %resets the markings
%         
%         statusUpdate(['Hold paths reset']);
        trial_step=-10;LOAD=1; % flags to open new file
    end


% function for MARK KINEMATICS
    function mark_callback(hObject,eventdata)
        %hold_xy=[];
        val_trial =get(fh.NAME_trials,'Value');
        temp_f=figure;
        
        %subplot(fh.sens_ax)
        s_frame=get(fh.start_frame,'String');
        s_frame=str2num(s_frame)
        e_frame=get(fh.end_frame,'String');
        e_frame=str2num(e_frame)
        step=get(fh.step,'String');
        step=str2num(step)
        index=s_frame;
        subplot('position',[0 0 1 1])
        im_fig=imshow(YUY2toRGB(im_lat(:,:,:,index)));
        t_fig=text(20,30,['F',num2str(index)],'Color',[1 1 0],...
            'FontSize',20)
        set(temp_f,'Position',[23           9        1288         993]);
        hold_xy=[];
        while index <= e_frame
            %imshow(YUY2toRGB(im_lat(:,:,:,index)));
            set(im_fig,'CData',YUY2toRGB(im_lat(:,:,:,index)));
            set(t_fig,'String',num2str(index))
            %text(20,30,['F',num2str(index)],'Color',[1 1 0],...
            %    'FontSize',20)
            [x,y]=ginput(1);
            hold_xy=[hold_xy; x y]
            rectangle('Position',[x y 10 10],'curvature',[0 0],...
                'EdgeColor','r','LineWidth',1);
            index=index+step;disp(index);
        end
        disp(index)
        disp(size(hold_xy))
        hold on;
        plot(hold_xy(:,1),hold_xy(:,2),'g','Linewidth',2)
        
        
        %         subplot(fh.sens_ax2); hold off
        %         plot(-hold_xy(:,1),'r','LineWidth',2)
        %         axis off
        %         subplot(fh.sens_ax3); hold off
        %         plot(hold_xy(:,2),'k','LineWidth',2)
        %         axis off;
        
        hold_paths{val_trial}=hold_xy;
        %save ([p fname2],'hold_paths', 'hold_starts')
        save ([p fname2],'hold_paths', 'hold_trial_vals', 'hold_STARTS');
        
        disp('Path saved')
        close(temp_f);
        LOAD=0;
        plotVID_path
        
    end


% function for MARK START BUTTON
    function mark2_callback(hObject,eventdata)
        disp('MARK START')
        hold_s=[];
        val_trial =get(fh.NAME_trials,'Value');
        %subplot(fh.sens_ax)
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
        
        %         CORRECT = uicontrol(temp_f,'Style','togglebutton',...
        %             'String','INCORRECT','Value',0,...
        %             'Position',[390 20 100 70],'FontSize',10,...
        %             'BackgroundColor','k','ForegroundColor',[1 1 1],...
        %             'Callback',@correct);
        %         ATTEMPTS = uicontrol(temp_f,'Style','edit',...
        %             'Position',[220 60 140 30],'String','0','FontSize',15);
        %im_fig=imshow(YUY2toRGB(im_lat(:,:,:,1)));
        %while index <= e_frame && index <  size(im_lat,4) && STOP==0
        %subplot(fh.sens_ax)
        %set(im_fig,'CData',im_lat(:,:,:,index))
        while get(stop,'Value')
            imshow(YUY2toRGB(im_lat(:,:,:,index)));
            text(20,30,['F',num2str(index)],'Color',[1 1 0],...
                'FontSize',20);
            pause(0.1)
        end
        
        %         hold_correct{val_trial}=get(CORRECT,'Value')
        %
        %         a_string=get(ATTEMPTS,'String');
        %         hold_attempts{val_trial}=str2num(a_string)
        
        %hold_s=index-s_frame;
        hold_s=index;
        
        hold_STARTS(val_trial)=hold_s
        close(temp_f)
        save ([p fname2],'hold_paths', 'hold_trial_vals', 'hold_STARTS');
        
        function advance (hObject,eventdata)
            index=index+1
        end
        function goback (hObject,eventdata)
            index=index-1
            
        end
        function correct(hObject,eventdata)
            v=get(CORRECT,'Value');
            if v == 1
                set(CORRECT,'BackgroundColor',[0 1 0.1],'String','CORRECT')
            else
                set(CORRECT,'BackgroundColor','k','String','INCORRECT')
            end
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

% associated with CORRECT BUTTON
    function correct_callback(hObject,eventdata)
        v=get(fh.CORRECT,'Value');
        if v == 1
            set(fh.CORRECT,'BackgroundColor',[0 1 0.1],'String','CORRECT')
        else
            set(fh.CORRECT,'BackgroundColor','k','String','INCORRECT')
        end
    end

    function keep_trial_callback(hObject,eventdata)
        v=get(fh.KEEP_TRIAL,'Value');
        if v == 0
            set(fh.KEEP_TRIAL,'BackgroundColor',[0 1 0.1],'String','TRIAL OK')
        else
            set(fh.KEEP_TRIAL,'BackgroundColor',[0.7 0.7 0.7],'String','Discard trial.')
        end
    end

% SAVE THE TRIAL DATA PER TRIAL
    function save_char_callback(hObject,eventdata)
        disp('saving...')
        val_trial =get(fh.NAME_trials,'Value');
        %hold_trial_vals=zeros(5,n_trials); %1=keep,2=correct,3=attempts,4=s_frame,5=e_frame;
        hold_trial_vals(1,val_trial)=~get(fh.KEEP_TRIAL,'Value');
        hold_trial_vals(2,val_trial)=get(fh.CORRECT,'Value');
        hold_trial_vals(3,val_trial)=str2num(get(fh.ATTEMPTS,'String'));
        hold_trial_vals(4,val_trial)=str2num(get(fh.start_frame,'String'));
        hold_trial_vals(5,val_trial)=str2num(get(fh.end_frame,'String'));
        disp([val_trial hold_trial_vals(:,val_trial)']);
        save ([p fname2],'hold_paths', 'hold_trial_vals', 'hold_STARTS');
        
    end




    function plotVID_path (hObject,eventdata)
        if LOAD == 1
            val_rat=(get(fh.NAME_txt,'Value'))
            val_date=(get(fh.NAME_subsets,'Value'))
            val_trial =get(fh.NAME_trials,'Value')
            
            if trial_step==-10 %NEW FILE load
                %val_trial = 1;
                set(fh.NAME_trials,'Value',1) %reset to 1
                trial_step=0;
            end
            
            if trial_step==1 %NEXT TRIAL
                val_trial = val_trial+trial_step;
                trial_step=0;
                if val_trial > length(trial_ls) %wraps around
                    val_trial = 1;
                end
                set(fh.NAME_trials,'Value',val_trial) %reset to 1
            end
            
            if trial_step==-1 %PREV TRIAL
                val_trial = val_trial+trial_step;
                trial_step=0;
                if val_trial < 1 %wraps around
                    val_trial = length(trial_ls);
                end
                set(fh.NAME_trials,'Value',val_trial) %reset to 1
            end
            val_trial
            base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date})
            fname=strcat(base_name,'-',num2str(trial_ls(val_trial)),'.mat')
            fname2=strcat(base_name,'-','PATH','.mat')
            fname=fname{1};
            fname2=fname2{1};
            dash=find(fname=='-');
            
%            p='C:\Users\Public\Documents\VIDEO\';

            %p='C:\Users\Karunesh\Desktop\VIDEOS\'
            evalin('base','load([p fname])')
            evalin('base','fname2')
            
            %statusUpdate('')
            vid_f_lat=1./mean([diff(t_lat)]);
            t_step=1/vid_f_lat;
%             statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
%             statusUpdate([num2str(vid_f_lat),' Hz'])
%             statusUpdate(['Drop time = ',num2str(t_video_drop)])
%             statusUpdate(['Drop frame = ',num2str(t_seq)])
            set(fh.start_frame,'String',num2str(t_seq-20));
            set(fh.end_frame,'String',num2str(t_seq+15));
            exist([p fname2],'file')
            if  exist([p fname2],'file')
                evalin('base','load([p fname2])')
%                 statusUpdate('Paths also loaded...')
            else
                n_trials=length(trial_ls)
                hold_paths=cell(1,n_trials);
                hold_trial_vals=zeros(5,n_trials); %1=keep,2=correct,3=attempts,4=s_frame,5=e_frame;
                hold_trial_vals(1:2,:)=1;
                hold_STARTS=zeros(1,n_trials);
                save ([p fname2],'hold_paths', 'hold_trial_vals', 'hold_STARTS');
            end

        end
        step=get(fh.step,'String');
        step=str2num(step)
        s_frame=get(fh.start_frame,'String');
        s_frame=str2num(s_frame)
        e_frame=get(fh.end_frame,'String');
        e_frame=str2num(e_frame)
        
        drop_frame=t_seq-s_frame;
        
        KEEP_trials=ones(size(trial_ls));
        
        %disp_fig=figure(100);
        %set(disp_fig,'Position',[ 562    39   500   582]);
        index=s_frame;
        val_trial =get(fh.NAME_trials,'Value'); %advance
        hold_xy=hold_paths{val_trial};
        
        % if path there then does moves to show trajectory
        is_path_there=isempty(hold_paths{1});
        if ~is_path_there
            LOAD=0;
        end
        
        
        if LOAD == 0
            disp_fig=figure;
            set(disp_fig,'DeleteFcn',@dcall)
            
            %temp_f=figure;
            im_fig=imshow(YUY2toRGB(im_lat(:,:,:,index)));
            t_fig=text(20,30,['F',num2str(index)],'Color',[1 1 0],...
                'FontSize',20)
            set(disp_fig,'Position',[23           9        1288         993]);
            if ~isempty(hold_xy)
                hold_xy=hold_paths{val_trial};
                hold_xy(:,1)=smooth(hold_xy(:,1),8,  'loess'   );
                hold_xy(:,2)=smooth(hold_xy(:,2),8 , 'loess'   );
            end
            index
            e_frame
            %im_fig=imshow(YUY2toRGB(im_lat(:,:,:,1)));
            while index <= e_frame && index <  size(im_lat,4)
                %subplot(fh.sens_ax)
                %set(im_fig,'CData',im_lat(:,:,:,index))
                if LOAD == 0
                    set(im_fig,'CData',YUY2toRGB(im_lat(:,:,:,index)));
                    hold on;
                    set(t_fig,'String',['[T',num2str(trial_ls(val_trial)),' F',num2str(index)])
                     %end
                if ~isempty(hold_xy)
                    %while (index-s_frame) < length(hold_xy)
                        %disp(index-s_frame)
                        if (index-s_frame) < length(hold_xy)
                            hold on;
                            plot(hold_xy(1:index-s_frame+1,1),hold_xy(1:index-s_frame+1,2),'g','Linewidth',3)
                            %                 if (index-s_frame) >= reach_on
                            %                     plot(hold_xy(reach_on,1),hold_xy(reach_on,2),'co','Linewidth',6)
                            %                end
                            %                 if (index-s_frame) >= drop_frame
                            %                     plot(hold_xy(drop_frame-1,1),hold_xy(drop_frame-1,2),'bo','Linewidth',6)
                            %                 end
                        end
                    end
                end
                index=index+1;
                pause(0.05);
            end
            pause(0.5)
                        close(disp_fig)

        else  %ANIMATE
            disp_fig=figure;          
            im_fig=imshow(YUY2toRGB(im_lat(:,:,:,index)));
            t_fig=text(20,30,['F',num2str(index)],'Color',[1 1 0],...
                'FontSize',20)
            set(disp_fig,'Position',[23           9        1288         993]);
            for index=1:e_frame+5 %&& STOP==0
                %subplot(fh.sens_ax)
                %set(im_fig,'CData',im_lat(:,:,:,index))
                %if LOAD == 0
                set(im_fig,'CData',YUY2toRGB(im_lat(:,:,:,index)));
                hold on;
                set(t_fig,'String',['[T',num2str(trial_ls(val_trial)),' F',num2str(index)])
                %else
                %    imshow(YUY2toRGB(im_lat(:,:,:,index)));
                %    text(20,30,['[T',num2str(trial_ls(val_trial)),' F',num2str(index),']'],'Color',[1 1 0],'FontSize',20)
                %end
                %index=index+5;
                pause(0.05);
                if index == s_frame || index == e_frame
                    pause(0.75)
                end
            end
            disp('disp done')
            close(disp_fig)
            
        end
        
        
        % plots the path IF it is known
        
        
        %plots the, KEEP, correct and attempt if it is knonw
        %         hold_keep=hold_trial_vals(1,val_trial);
        %         if hold_keep == 1
        %             set(fh.KEEP_TRIAL,'Value',0);
        %             set(fh.KEEP_TRIAL,'BackgroundColor',[0 1 0.1],'String','TRIAL OK')
        %         else
        %             set(fh.KEEP_TRIAL,'Value',1);
        %             set(fh.KEEP_TRIAL,'BackgroundColor',[0.7 0.7 0.7],'String','Discard trial.')
        %         end
        %
        %         hold_correct=hold_trial_vals(2,val_trial);
        %         hold_attempts=hold_trial_vals(3,val_trial);
        %         if ~isempty(hold_correct)
        %             set(fh.ATTEMPTS,'Visible','On');
        %             set(fh.CORRECT,'Visible','On');
        %             set(fh.ATTEMPTS,'String',hold_attempts);
        %             if ~isempty(hold_correct)
        %                 if hold_correct
        %                     set(fh.CORRECT,'Value',1);
        %                     set(fh.CORRECT,'BackgroundColor',[0 1 0.1],'String','CORRECT')
        %                 else
        %                     set(fh.CORRECT,'Value',0);
        %                     set(fh.CORRECT,'BackgroundColor','k','String','INCORRECT')
        %                 end
        %             end
        %         else
        %             set(fh.ATTEMPTS,'Visible','Off');
        %             set(fh.CORRECT,'Visible','Off');
        %         end
        %         %else
        %    set(fh.ATTEMPTS,'Visible','Off');
        %    set(fh.CORRECT,'Visible','Off');
        %end
        %         if s_frame > 0
        %             index=s_frame;
        %         else
        %             index=1;
        %         end
        %
        %
        %         STOP=0;
        %
        %         e_frame=210;
        %         %im_fig=imshow(YUY2toRGB(im_lat(:,:,:,1)));
        %         while index <= e_frame && index <  size(im_lat,4) && STOP==0
        %             %subplot(fh.sens_ax)
        %             %set(im_fig,'CData',im_lat(:,:,:,index))
        %             if LOAD == 0
        %                 set(im_fig,'CData',YUY2toRGB(im_lat(:,:,:,index)));
        %                 hold on;
        %                 set(t_fig,'String',['[T',num2str(trial_ls(val_trial)),' F',num2str(index)])
        %             else
        %                 imshow(YUY2toRGB(im_lat(:,:,:,index)));
        %                 text(20,30,['[T',num2str(trial_ls(val_trial)),' F',num2str(index),']'],'Color',[1 1 0],'FontSize',20)
        %             end
        %             if ~isempty(hold_xy)
        %                 while (index-s_frame) < length(hold_xy)
        %                     disp(index-s_frame)
        %                     if (index-s_frame) < length(hold_xy)
        %                         hold on;
        %                         plot(hold_xy(1:index-s_frame+1,1),hold_xy(1:index-s_frame+1,2),'g','Linewidth',3)
        %                         %                 if (index-s_frame) >= reach_on
        %                         %                     plot(hold_xy(reach_on,1),hold_xy(reach_on,2),'co','Linewidth',6)
        %                         %                end
        %                         %                 if (index-s_frame) >= drop_frame
        %                         %                     plot(hold_xy(drop_frame-1,1),hold_xy(drop_frame-1,2),'bo','Linewidth',6)
        %                         %                 end
        %                     end
        %                 end
        %             end
        %             index=index+5;
        %             pause(0.05);
        %         end
        disp('disp done')
    end

    function dcall(hObject,eventdata)
        STOP=1;
    end

    function triallist_callback(hObject,eventdata)
        %LOADS FILE IF LIST CHANGED
         %if LOAD == 1
%             val_rat=(get(fh.NAME_txt,'Value'))
%             val_date=(get(fh.NAME_subsets,'Value'))
%             val_trial =get(fh.NAME_trials,'Value')
%             
%             if trial_step==-10 %NEW FILE load
%                 %val_trial = 1;
%                 set(fh.NAME_trials,'Value',1) %reset to 1
%                 trial_step=0;
%             end
%             
%             if trial_step==1 %NEXT TRIAL
%                 val_trial = val_trial+trial_step;
%                 trial_step=0;
%                 if val_trial > length(trial_ls) %wraps around
%                     val_trial = 1;
%                 end
%                 set(fh.NAME_trials,'Value',val_trial) %reset to 1
%             end
%             
%             if trial_step==-1 %PREV TRIAL
%                 val_trial = val_trial+trial_step;
%                 trial_step=0;
%                 if val_trial < 1 %wraps around
%                     val_trial = length(trial_ls);
%                 end
%                 set(fh.NAME_trials,'Value',val_trial) %reset to 1
%             end
%             val_trial
%             base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date})
%             fname=strcat(base_name,'-',num2str(trial_ls(val_trial)),'.mat')
%             fname2=strcat(base_name,'-','PATH','.mat')
%             fname=fname{1};
%             fname2=fname2{1};
%             dash=find(fname=='-');
%             
%             %p='C:\Users\Karunesh\Desktop\VIDEOS\'
%             p='C:\Users\Public\Documents\VIDEO\'
% 
%             evalin('base','load([p fname])')
%             evalin('base','fname2')
%             
%             statusUpdate('')
%             vid_f_lat=1./mean([diff(t_lat)]);
%             t_step=1/vid_f_lat;
%             statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
%             statusUpdate([num2str(vid_f_lat),' Hz'])
%             statusUpdate(['Drop time = ',num2str(t_video_drop)])
%             statusUpdate(['Drop frame = ',num2str(t_seq)])
%             set(fh.start_frame,'String',num2str(t_seq-20));
%             set(fh.end_frame,'String',num2str(t_seq+15));
%             exist([p fname2],'file')
%             if  exist([p fname2],'file')
%                 evalin('base','load([p fname2])')
%                 statusUpdate('Paths also loaded...')
%             else
%                 n_trials=length(trial_ls)
%                 hold_paths=cell(1,n_trials);
%                 hold_trial_vals=zeros(5,n_trials); %1=keep,2=correct,3=attempts,4=s_frame,5=e_frame;
%                 hold_trial_vals(1:2,:)=1;
%                 hold_STARTS=zeros(1,n_trials);
%                 save ([p fname2],'hold_paths', 'hold_trial_vals', 'hold_STARTS');
%             end
% 
%         %end
%         step=get(fh.step,'String');
%         step=str2num(step)
%         s_frame=get(fh.start_frame,'String');
%         s_frame=str2num(s_frame)
%         e_frame=get(fh.end_frame,'String');
%         e_frame=str2num(e_frame)
         trial_step=0;
        LOAD=1;
        plotVID_path
    end




end