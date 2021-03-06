function fh = setup_GUI_video_v2(varargin)
global fh
global FileName
global PathName
global F
global HOLD_XY_ALL
global HOLD_xy_type
global MARK
global hold_xy
global f
global index
global IM_P
global im

% global im_lat
% global t_lat
% global t_seq
% global t_step
% global t_video_drop
% global fname
% global fname2
% global hold_xy
% global trial_no
% global hold_paths
% global unique_rats
% global temp
% global rat_id
% global unique_dates
% global trial_ls
% global LOAD
% global disp_fig
% global file_vals
% global hold_starts

%-----------------CREATE GUI-----------------------
%Main figure window
f_pos=[1509         287         350         754];
x_off=35;
f=[];im=[];index=1;

if isempty(varargin) %if just checking GUI layout
    fh.fig = figure('Position',f_pos,...
        'MenuBar','none','NumberTitle','off',...
        'Name','Sharing Data with UserData');
    
else %elseif during a rat test
    fh.fig = figure('Position',f_pos,...
        'MenuBar','none','NumberTitle','off',...
        'CloseRequestFcn',@fig_close,...
        'Name','Sharing Data with UserData');
end


% ---------------------------------------------
% FIND THE RATS IN THE VIDEO FILE
p='E:\Videos\T25\';
%[unique_rats temp_rat_id unique_dates] = find_rats (p);
%[trial_ls]=find_trials(unique_rats,unique_dates,1,1,p);

% ---------------------------------------------



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
% fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[35 575 150 40],...
%     'String','Rat XX',...
%     'Callback',@name_callback);
% set(fh.NAME_txt,'FontSize',20);
% set(fh.NAME_txt,'BackgroundColor',[1 0.1 0 ]);
% set(fh.NAME_txt,'String',unique_rats);

% fh.NAME_txt = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[35 575 150 40],...
%     'String','Rat XX');

% fh.NAME_subsets = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[210 575 250 40],...
%     'String','Rat XX',...
%     'Callback',@nameSUB_callback);
% set(fh.NAME_subsets,'FontSize',12);
% set(fh.NAME_subsets,'String',unique_dates{1});
%
% fh.NAME_trials = uicontrol(fh.fig,'Style','popupmenu',...
%     'Position',[490 575 60 40],...
%     'String','1');
% set(fh.NAME_trials,'FontSize',16);
% set(fh.NAME_trials,'BackgroundColor',[0 1 0 ]);
% set(fh.NAME_trials,'String',trial_ls);


%fh.NAME = uicontrol(fh.fig,'Style','edit',...
%   'Position',[140 575 100 45]);
%set(fh.NAME,'String','Rxx');
%set(fh.NAME,'FontSize',20);

% fh.keep = uicontrol(fh.fig,'Style','radiobutton',...
%     'Position',[575 575 100 40],...
%     'String','Keep settings',...
%     'Value',1);

%LOAD PARAMETERS
fh.start = uicontrol(fh.fig,'Style','pushbutton',...
    'String','LOAD FILE','FontSize',12,...
    'Position',[x_off f_pos(4)*0.88 250 70],...
    'Callback',@startStop_callback);
fh.mark = uicontrol(fh.fig,'Style','pushbutton',...
    'String','MARK KINEMATICS','FontSize',12,...
    'Position',[x_off 588 160 70],...
    'Callback',@mark_callback);

fh.prev_trial = uicontrol(fh.fig,'Style','pushbutton',...
    'String','BACK',...
    'Position',[x_off+170 625 80 33],...
    'Callback',@prev_trial_callback);
fh.next_trial = uicontrol(fh.fig,'Style','togglebutton',...
    'String','NEXT',...
    'Position',[x_off+170 588 80 33],...
    'Callback',@next_trial_callback);
set(fh.prev_trial,'Visible','Off')
set(fh.next_trial,'Visible','Off')

% STATUS UPDATE
fh.status = uicontrol(fh.fig,'Style','listbox',...
    'Position',[x_off 270 280 300],...
    'String',{'Start...'},...
    'FontSize',9);

% fh.next_trial = uicontrol(fh.fig,'Style','pushbutton',...
%     'String','STOP',...
%     'Position',[x_off+170 f_pos(4)*0.78 80 25],...
%     'Callback',@next_trial_callback);

% FILE SELECTOR
% fh.fname = uicontrol(fh.fig,'Style','listbox',...
%     'Position',[x_off 530 150 x_off],...
%     'String',{'FNAME'; 'TRIAL'},...
%     'FontSize',8)

fh.next_frame = uicontrol(fh.fig,'Style','pushbutton',...
    'String','ADVANCE',...
    'Position',[x_off+170 530 80 33],...
    'Callback',@nextframe_callback);

fh.restart = uicontrol(fh.fig,'Style','pushbutton',...
    'String','SHOW ALL KINEMATICS',...
    'Position',[x_off 225 180 30],...
    'Callback',@restartStop_callback);


fh.mark_start = uicontrol(fh.fig,'Style','pushbutton',...
    'String','MARK START',...
    'Position',[x_off 155 180 30],...
    'Callback',@mark2_callback);

uicontrol(fh.fig,'Style','text',...
    'Position',[x_off 30 100 30],...
    'String','Step',...
    'FontSize',12);

fh.step = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 30 70 30]);

uicontrol(fh.fig,'Style','text',...
    'Position',[x_off 70 100 30],...
    'String','End Frame',...
    'FontSize',12);

fh.end_frame = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 70 70 30]);

uicontrol(fh.fig,'Style','text',...
    'Position',[x_off 110 100 30],...
    'String','Start Frame',...
    'FontSize',12);

fh.start_frame = uicontrol(fh.fig,'Style','edit',...
    'Position',[130 110 70 30]);


% INITIALIZATION
set(fh.start_frame, 'String','1')
set(fh.end_frame, 'String','120')
set(fh.step, 'String','1')

if ~isempty(file_vals)
get(fh.NAME_txt,'Value')
    name_callback
    disp('setup...')
end

    function startStop_callback(hObject,eventdata)
        disp(p)
        if p(end) ~= '\'
            p='E:\Videos\T28\';
        end
        [FileName,PathName,FilterIndex]= uigetfile(p);
        p=PathName;
     %   statusUpdate('------------------------------');
        %statusUpdate(FileName)
        %evalin('base','F=load([PathName FileName])')
        F=load([PathName FileName]);
        im=F.im_lat;
        t=F.t_lat;
        
        if ~exist([PathName FileName '_MARK.mat'])
            HOLD_XY_ALL=cell(1);
            HOLD_xy_type=cell(1);
            MARK.move_start=cell(1);
            MARK.lim_start=cell(1);
            MARK.lim_end=cell(1);
            MARK.GOOD_trial=cell(1);
            MARK.COMMENT=cell(1);
            [PathName,FileName,'_MARK.mat']
            save([PathName,FileName(1:end-4),'_MARK.mat'],'HOLD_XY_ALL','HOLD_xy_type','MARK')
        end
        F2=load([PathName,FileName(1:end-4),'_MARK.mat'])
        
        if exist('im')
            disp('animate')
            len=size(im,4);
            %statusUpdate(['Loaded frames from 1 to ',num2str(len)]);
            f=figure;
            temp=imshow((im(:,:,:,1)));
            set(gcf,'Position',[461         179        1027         817]);
            if exist('t')
                vid_f1=1./mean([diff(t)]);
%                statusUpdate(['Rate ',num2str(vid_f1),' Hz']);
            else
                vid_f1=0;
            end
            if ~exist('step_size')
                step_size=1;
            end            
            for x = 1:step_size:len
                %imshow(YUY2toRGB(im1(:,:,:,x)));
                temp_x=((im(:,:,:,x)));
                set(temp,'CData',temp_x)            
                title([num2str(x),' of ',num2str(len)]);
                pause(.01);
            end
            pause(0.5)
            close (f)
        end
        
      
        %
        %         %close(disp_fig);
%                 val_rat=(get(fh.NAME_txt,'Value'));
%                 val_date=(get(fh.NAME_subsets,'Value'));
%                 val_trial =get(fh.NAME_trials,'Value');
%                 val_trial=trial_ls(val_trial);
        %         base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date});
        %         fname=strcat(base_name,'-',num2str(val_trial),'.mat')
        %         fname2=strcat(base_name,'-','PATH','.mat')
        %         fname=fname{1};
        %         fname2=fname2{1};
        %         dash=find(fname=='-');
        %
        %         disp(p)
        %          p='C:\Users\Karunesh\Desktop\VIDEOS\';
        %          %p='C:\Users\Ganguly Lab\Documents\MATLAB\VIDEOS\';
        %         exist([p fname])
        %         evalin('base','F=load([p fname])')
        %         %load([p fname])
        %         F=evalin('base','F');
        %
        %         statusUpdate('')
        %         vid_f_lat=1./mean([diff(F.t_lat)])
        %         t_step=1/vid_f_lat;
        %         statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
        %         statusUpdate([num2str(vid_f_lat),' Hz'])
        %         statusUpdate(['Drop time = ',num2str(F.t_video_drop)])
        %         statusUpdate(['Drop frame = ',num2str(F.t_seq)])
        %         set(fh.start_frame,'String',num2str(F.t_seq-25));
        %         set(fh.end_frame,'String',num2str(F.t_seq+10));
        %         exist([p fname2],'file')
        %         if  exist([p fname2],'file')
        %             evalin('base','load([p fname2])')
        %             hold_xy=hold_paths(val_trial);
        %             if ~isempty(hold_xy)
        %                 statusUpdate('Paths also loaded...')
        %             else
        %                 statusUpdate('No path found...')
        %             end
        %         end
        %
        %         LOAD=0;
        %         plotVID_path
    end

    function restartStop_callback(hObject,eventdata)
        LOAD=0;
        %close (disp_fig); 
        plotVID_path
    end

%     function prev_trial_callback(hObject,eventdata)
%         val_trial =get(fh.NAME_trials,'Value');
%         if val_trial > 1
%             val_trial =get(fh.NAME_trials,'Value')-1; %advance
%         end
%         set(fh.NAME_trials,'Value',val_trial);
%         LOAD=1;
%         close (disp_fig);
%         plotVID_path;
%     end

 

    function name_callback(hObject,eventdata)
        val=(get(fh.NAME_txt,'Value'))
        set(fh.NAME_subsets,'String',unique_dates{val});
        set(fh.NAME_subsets,'Value',1);
        [trial_ls]=find_trials(unique_rats,unique_dates,val,1,p);
        set(fh.NAME_trials,'String',trial_ls);
        %statusUpdate('------------------------------');
        %statusUpdate(unique_rats{val});
        %statusUpdate(unique_dates{val}{1});
        %statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
        hold_paths=cell(length(trial_ls),1); %resets the markings
        hold_starts=cell(length(trial_ls),1);  %resets the markings
        statusUpdate(['Hold paths reset']);
    end


    function nameSUB_callback (hObject,eventdata)
        val_rat=(get(fh.NAME_txt,'Value'))
        val=(get(fh.NAME_subsets,'Value'))
        %temp_date=unique_dates{val};
        [trial_ls]=find_trials(unique_rats,unique_dates,val_rat,val,p);
        set(fh.NAME_trials,'String',trial_ls);
        %statusUpdate('------------------------------');
        %statusUpdate(unique_rats{val_rat});
        %statusUpdate(unique_dates{val_rat}{val});
        %statusUpdate(['Trials# ',num2str(trial_ls(1)),':',num2str(trial_ls(end))]);
        hold_paths=cell(length(trial_ls),1);  %resets the markings
        hold_starts=cell(length(trial_ls),1);  %resets the markings
        
        %statusUpdate(['Hold paths reset']);
    end


    % MARK NEW KINEMATICS FUNCTION
    function mark_callback(hObject,eventdata)
        set(fh.prev_trial,'Visible','On')
        set(fh.next_trial,'Visible','On')
        set(fh.next_frame,'Visible','On')
        im=F.im_lat;
        size(im)
        t=F.t_lat;
        len=size(im,4);
        %statusUpdate('------------------------------');
        %statusUpdate('Mark kinematics...');
        IM_P.f=figure;
        index=1;        
        set(gcf,'Position',[451         181        1027         817]);
        subplot('Position',[0.2 0.15 0.6 0.1]);
        IM_P.p_x=plot(ones(10,1),'k','LineWidth',2); axis off;  ylim([1 340]); %text(0,0,'X Position')
        subplot('Position',[0.2 0.05 0.6 0.1]);
        IM_P.p_y=plot(ones(10,1),'k','LineWidth',2); axis off;  ylim([1 240]);%text(0,0,'Y Position')
        IM_P.p_im=subplot('Position',[0.1 0.3 0.8 0.6]);
        IM_P.p_im_p=imshow((im(:,:,:,1)));
        hold on;
        IM_P.im_trace=plot(ones(10,1),ones(10,1),'go','Color',[0.6 1 0],'Linewidth',5,'Markersize',3);
        IM_P.temp_txt=text(20,30,['F',num2str(index)],'Color',[1 1 0],...
            'FontSize',20)
        if exist('t')
            vid_f1=1./mean([diff(t)]);
%            statusUpdate(['Rate ',num2str(vid_f1),' Hz']);
        else
            vid_f1=0;
        end
    
        hold_xy=[];
        step=1;
        
        while index <= len && get(fh.next_trial,'Value')==0
            disp('===================');
            get(fh.next_trial,'Value')
            disp(index)
            temp_x=((im(:,:,:,index)));
            set(IM_P.p_im_p,'CData',temp_x)
            IM_P.p_im_p=imshow((im(:,:,:,index)));
%            imshow(YUY2toRGB(im(:,:,:,index)));
            set(IM_P.temp_txt,'String',['F',num2str(index)]);
            [x,y]=ginput(1);
            hold_xy=[hold_xy; x y];
            set(IM_P.p_x,'YData',hold_xy(:,1));
            set(IM_P.p_y,'YData',240-hold_xy(:,2));
            %             rectangle('Position',[x y 2 2],'curvature',[1 1],...
            %                 'EdgeColor','g','LineWidth',3);
                           
            if size (hold_xy,1) < 10
                temp_x=zeros(10,1);temp_y=zeros(10,1);
                temp_x(1:index)=hold_xy(:,1);
                temp_y(1:index)=hold_xy(:,2);
                set(IM_P.im_trace,'XData',temp_x);
                set(IM_P.im_trace,'YData',temp_y);
            else
                hold_xy(index-9:index,1)
                set(IM_P.im_trace,'XData',hold_xy(index-9:index,1));
                set(IM_P.im_trace,'YData',hold_xy(index-9:index,2));
            end
            
             index=index+1;
             disp(index);
        end
        
        % plots the entire trace
        %set(IM_P.im_trace,'XData',hold_xy(:,1));
        %set(IM_P.im_trace,'YData',hold_xy(:,2));
        plot(hold_xy(:,1),hold_xy(:,2),'go','Color',[0.6 1 0],'Linewidth',5,'Markersize',3);
        set(fh.next_trial,'Value',0)
        disp([PathName,FileName(1:end-4),'_MARK.mat'])
        f = figure; set(f,'Position',[686   183   400   90]);
        set(f,'Menubar','none'); set(f,'NumberTitle','off');
        set(f,'Name','Type in kinematic type...')
        h = uicontrol('Position',[20 20 350 40],'Style','edit',...
            'Callback','save_vid=0;uiresume(gcbf)');
        set(h,'String','xxx');
        set(h,'FontSize',20);
        uiwait(gcf);
        temp_filename=get(h,'String');
        close(f);
        
        h_len=length(HOLD_XY_ALL);
        HOLD_XY_ALL
        isempty(HOLD_XY_ALL{1})
        if h_len==1 && isempty(HOLD_XY_ALL{1})
            HOLD_XY_ALL{1}=hold_xy
            HOLD_xy_type{1}=temp_filename
        else
            disp('next one')
            HOLD_XY_ALL{h_len+1}=hold_xy
            HOLD_xy_type{h_len+1}=temp_filename
        end
        
        MARK
        save([PathName,FileName(1:end-4),'_MARK.mat'],'HOLD_XY_ALL','HOLD_xy_type','MARK')
        set(fh.prev_trial,'Visible','Off')
        set(fh.next_trial,'Visible','Off')

        end
        
        function nextframe_callback(hObject,eventdata)
            disp('-------');
            index = index+1;
            figure(IM_P.f); subplot(IM_P.p_im);
            set(IM_P.p_im_p,'CData',im(:,:,:,index))
            set(IM_P.temp_txt,'String',['F',num2str(index)]);
            hold_xy(index,1) = 0;
            hold_xy(index,2) = 0;
            
            if size (hold_xy,1) < 10
                temp_x=zeros(10,1);temp_y=zeros(10,1);
                temp_x(1:index)=hold_xy(:,1);
                temp_y(1:index)=hold_xy(:,2);
                set(IM_P.im_trace,'XData',temp_x);
                set(IM_P.im_trace,'YData',temp_y);
            else
                hold_xy(index-9:index,1)
                set(IM_P.im_trace,'XData',hold_xy(index-9:index,1));
                set(IM_P.im_trace,'YData',hold_xy(index-9:index,2));
            end
            
            set(IM_P.p_x,'YData',hold_xy(:,1));
            set(IM_P.p_y,'YData',240-hold_xy(:,2));
            
            if size (hold_xy,1) < 10
                temp_x=zeros(10,1);temp_y=zeros(10,1);
                temp_x(1:index)=hold_xy(:,1);
                temp_y(1:index)=hold_xy(:,2);
                set(IM_P.im_trace,'XData',temp_x);
                set(IM_P.im_trace,'YData',temp_y);
            else
                hold_xy(index-9:index,1)
                set(IM_P.im_trace,'XData',hold_xy(index-9:index,1));
                set(IM_P.im_trace,'YData',hold_xy(index-9:index,2));
            end
            
        end
        
            
   
    function prev_trial_callback(hObject,eventdata)    
        % GO BACK and erase acquired points in HOLD_XY
        disp('-------');
        %disp(IM_P.f)
        figure(IM_P.f); subplot(IM_P.p_im);
        %disp(index)
        %disp(hold_xy)
        if index >= 3
            index=index-1 % takes into account current trial is one more than len hold_xy
            set(IM_P.p_im_p,'CData',im(:,:,:,index))
            set(IM_P.temp_txt,'String',['F',num2str(index)]);
            hold_xy=hold_xy(1:end-1,:);
            if size (hold_xy,1) < 10
                temp_x=zeros(10,1);temp_y=zeros(10,1);
                %1:index-1
                %size(hold_xy(:,1))
                temp_x(1:index-1)=hold_xy(:,1);
                temp_y(1:index-1)=hold_xy(:,2);
                set(IM_P.im_trace,'XData',temp_x);
                set(IM_P.im_trace,'YData',temp_y);
            else
                %hold_xy(index-9-1:index,1)
                set(IM_P.im_trace,'XData',hold_xy((index-9-1):(index-1),1));
                set(IM_P.im_trace,'YData',hold_xy((index-9-1):(index-1),2));
            end
        elseif index == 2
            index=1;
            set(IM_P.p_im_p,'CData',im(:,:,:,1))
            set(IM_P.temp_txt,'String',['F',num2str(1)]);     
            hold_xy=[];
            temp_x=zeros(10,1);temp_y=zeros(10,1);
            set(IM_P.im_trace,'XData',temp_x);
            set(IM_P.im_trace,'YData',temp_y);
        elseif index == 1
            index=1;
            hold_xy=[];
        end
        if ~isempty(hold_xy)
            set(IM_P.p_x,'YData',hold_xy(:,1));
            set(IM_P.p_y,'YData',240-hold_xy(:,2));
        else
            set(IM_P.p_x,'YData',[]);
            set(IM_P.p_y,'YData',[]);
        end
        disp(hold_xy)
    end

    % END THE PATH ACQ EARLY AND SAVE
   function next_trial_callback(hObject,eventdata)
        % simply toggle to off
        get(fh.next_trial,'Value')

    end


    function mark2_callback(hObject,eventdata)
        im=F.im_lat;
        size(im)
        t=F.t_lat;
        len=size(im,4);
        temp_f=figure;
        index=1;      
        step=1;
            
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
       temp=imshow((im(:,:,:,1)));
       set(gcf,'Position',[461         179        1027         817]);    
       
       while index<len %&& get(stop,'Value')
               %imshow(YUY2toRGB(im1(:,:,:,x)));
               temp_x=((im(:,:,:,index)));
               set(temp,'CData',temp_x)
               title([num2str(x),' of ',num2str(len)]);
               index=index+1;
               pause(.1);
       end
           hold on;
        
        hold_s=index-s_frame;
        hold_starts{val_trial}=hold_s;
        close(temp_f)
        save ([p fname2],'hold_paths', 'hold_starts')
        
        function advance (hObject,eventdata)
            index=index+1
            figure(gcf); subplot(IM_P.p_im);
            set(IM_P.p_im_p,'CData',im(:,:,:,index))
            set(IM_P.temp_txt,'String',['F',num2str(index)]);
            hold_xy(index,1) = 0;
            hold_xy(index,2) = 0;
        end
        function goback (hObject,eventdata)
            index=index-1
            index=index+1
            figure(IM_P.f); subplot(IM_P.p_im);
            set(IM_P.p_im_p,'CData',im(:,:,:,index))
            set(IM_P.temp_txt,'String',['F',num2str(index)]);
            hold_xy(index,1) = 0;
            hold_xy(index,2) = 0;
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
%          im=evalin('base','im_lat');
 %       t_lat=evalin('base','t_lat');

        
        if exist('im')
            disp('animate')
            len=size(im,4);
         %   statusUpdate(['Loaded frames from 1 to ',num2str(len)]);
            f=figure;
            temp=imshow((im(:,:,:,1)));
            set(gcf,'Position',[461         179        1027         817]);
            if exist('t_lat')
                vid_f1=1./mean([diff(t_lat)]);
               % statusUpdate(['Rate ',num2str(vid_f1),' Hz']);
            else
                vid_f1=0;
            end
            if ~exist('step_size')
                step_size=1;
            end            
            for x = 1:step_size:len
                %imshow(YUY2toRGB(im1(:,:,:,x)));
                temp_x=((im(:,:,:,x)));
                set(temp,'CData',temp_x)            
                title([num2str(x),' of ',num2str(len)]);
                pause(0.01);
            end
            pause(0.5)
            close (f)
        end
        LOAD
        %         if LOAD == 1
        %             val_rat=(get(fh.NAME_txt,'Value'));
        %             val_date=(get(fh.NAME_subsets,'Value'));
        %             val_trial =get(fh.NAME_trials,'Value');
        %             val_trial=trial_ls(val_trial);
        %             base_name=strcat(unique_rats(val_rat),'-',unique_dates{val_rat}{val_date});
        %             fname=strcat(base_name,'-',num2str(val_trial),'.mat');
        %             fname2=strcat(base_name,'-','PATH','.mat');
        %             fname=fname{1};
        %             fname2=fname2{1};
        %             dash=find(fname=='-');
        %
        %             p='C:\Users\Karunesh\Desktop\VIDEOS\';
        %             evalin('base','load([p fname])')
        %
        %             evalin('base','fname2')
        %             statusUpdate('')
        %             vid_f_lat=1./mean([diff(t_lat)]);
        %             t_step=1/vid_f_lat;
        %             statusUpdate(['Trial# ',num2str(fname(dash(end)+1:end))]);
        %             statusUpdate([num2str(vid_f_lat),' Hz'])
        %             statusUpdate(['Drop time = ',num2str(t_video_drop)])
        %             statusUpdate(['Drop frame = ',num2str(t_seq)])
        %             set(fh.start_frame,'String',num2str(t_seq-25));
        %             set(fh.end_frame,'String',num2str(t_seq+10));
        %             exist([p fname2],'file')
        %             if  exist([p fname2],'file')
        %                 evalin('base','load([p fname2])')
        %                 statusUpdate('Paths also loaded...')
        %             end
        %         end
        
        
        
        F=evalin('base','F');
        im_lat=F.im_lat;
        %size(im_lat)
        %display_video(im_lat);
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