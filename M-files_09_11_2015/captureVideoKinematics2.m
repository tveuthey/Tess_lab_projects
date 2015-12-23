%[points flags] = captureVideoKinematics(videoFile,numPoints,points,flags)
%Cycles through the video file and allows user to click on points and
%record them in points.
%
%Left click to mark a point
%Right click to delete a previously placed point
%
%Use the buttons on the bottom to navigate, flag frames, change points 
%Press the exit button to output data, or cycle through all the frames to
%exit.
%
%Input:
%videoFile is a .mat file of images or a filename
%numPoints is the number of points to record.
%
%Output:
%points: is a   numFrames x numPoints x 2(x&y)
%
%flags: flagged trials are set to 1
%
%plotting the x trajectory after running the function should be as easy as:
%[points flags] = captureVideoKinematics(im1,3)
% plot(points(:,:,1),'.');
% hold on;
% stem(flags*300); %will show your flags as big vertical lines

function [points flags] = captureVideoKinematics(videoFile,numPoints,points,flags)

global frameSkip ExitFunction currentPoint selection Frame1 advanceFrame
frameSkip = 10;%how many frames to skip when the 
ExitFunction = 0;
advanceFrame = 0;
Frame1 = 0;


currentFrame = 1;
currentPoint = 1;

if strcmp('char',class(videoFile))
    load(videoFile);
    %Should get the following variables:
    %im1 & maybe im2 if a second image is present
    %t1 : time frame
    %tot_frames : Total number of frames
    vid = im1;
    
    if exist('im2')
        selection = menu('Choose Image file to load','image 1','image 2');
        if selection == 2
            vid=im2;
        end
    end
else
    vid = videoFile;
end

selection = 1;
% if numPoints > 1
%     selection = menu('Capture Method','One point per image (Faster)','All points at once');
% else
%     selection = 1;
% end

fig = figure;
img = image(vid(:,:,:,1));
hold on
ScrSize = get(0,'ScreenSize');
ScrSize(1) = ScrSize(1)+50; ScrSize(2) = ScrSize(2)+50;ScrSize(3) = ScrSize(3)-100;ScrSize(4) = ScrSize(4)-100;
set(gcf,'Units','pixels','Position',ScrSize);

pointPlot = plot(nan(1,numPoints),nan(1,numPoints),'o','linewidth',2,'markerfacecolor','y','markeredgecolor','k','markersize',10);

xlabel('Left Click to Mark Point, Right Click to erase previous point')

buttons(1) = uicontrol('style','edit','string',frameSkip,'Callback',@btn_frameSkip,'position',[560 10 55 20]);
buttons(2) = uicontrol('string','<<','style','pushbutton','position',[535 8 25 25],'Callback',@btn_backFrame);
buttons(3) = uicontrol('string','>>','style','pushbutton','position',[615 8 25 25],'Callback',@btn_forwardFrame);
buttons(4) = uicontrol('string','EXIT','style','pushbutton','position',[20 10 40 20],'Callback',@btn_Exit,'backgroundcolor','r');
buttons(5) = uicontrol('style','checkbox','position',[100 10 20 20]);
uicontrol('style','text','string','Flag','position',[90 30 40 20],'backgroundcolor',[.8 .8 .8]);
buttons(6) = uicontrol('style','edit','string',currentPoint,'Callback',@btn_currentPoint,'position',[645 10 20 20]);
uicontrol('style','text','string','Current Point','position',[641 40 50 40]);
buttons(7) = uicontrol('style','popup','string','One point per image|All points at once','position',[690 10 150 20],'Callback',@btn_selection);
buttons(8) = uicontrol('string','-1','style','pushbutton','position',[535 33 25 25],'Callback',@btn_backOne);
buttons(9) = uicontrol('string','+1','style','pushbutton','position',[615 33 25 25],'Callback',@btn_forwardOne);
buttons(10) = uicontrol('string','Frame 1','style','pushbutton','position',[560 35 55 20],'Callback',@btn_Frame1,'backgroundcolor','g');
buttons(11) = uicontrol('string','^','style','pushbutton','position',[665 20 15 15],'Callback',@btn_upPoint);
buttons(12) = uicontrol('string','v','style','pushbutton','position',[665 5 15 15],'Callback',@btn_downPoint);

if ~exist('points')
    points = nan(size(vid,4),numPoints,2);
end
if ~exist('flags')
    flags = zeros(1,size(vid,4));
end

while ~ExitFunction

    title(['Current Point in Frame ',num2str(currentFrame),' of ',num2str(size(vid,4)),': ', num2str(currentPoint),' with ',num2str(sum(flags)),' flags marked'])
    [x,y,button] = ginput(1); %1 for left, 3 for right button
    
    if y <= size(vid,1) %if below the image, mark points otherwise handle buttons
        
        if button == 1
            points(currentFrame,currentPoint,:) = [x y];
            set(pointPlot,'xData',points(currentFrame,:,1));
            set(pointPlot,'yData',points(currentFrame,:,2));
            
            
            if selection == 2%advance to next point
                if currentPoint < numPoints
                    currentPoint = currentPoint +1;
                    set(buttons(6),'string',num2str(currentPoint));
                    continue;
                else
                    currentPoint = 1;
                    set(buttons(6),'string',num2str(currentPoint));
                end
            end
            
            
        elseif button == 3%remove the previous point
            points(currentFrame,currentPoint,:)=[nan nan];
            
            if currentPoint>1
                currentPoint=currentPoint-1;
                set(buttons(6),'string',num2str(currentPoint));
            end
            points(currentFrame,currentPoint,:)=[nan nan];
            
            set(pointPlot,'xData',points(currentFrame,:,1));
            set(pointPlot,'yData',points(currentFrame,:,2));
            
            continue
            
        end
        %Advancing the frame
        currentFrame=currentFrame+1;
        
    else
        
        pause(.1) %to allow the button actions to catch up

        flags(currentFrame) = get(buttons(5),'value');
        currentFrame = currentFrame + advanceFrame;
        if Frame1
            currentFrame = 1;
        end
        advanceFrame = 0;
        Frame1 = 0;
        
        if currentPoint > numPoints
            currentPoint = numPoints;
        elseif currentPoint < 1
            currentPoint = 1;
        end
        
        set(buttons(6),'string',num2str(currentPoint));
     end
    
    
    if currentFrame == size(vid,4)+1 || currentFrame == size(vid,4)+frameSkip
        if selection == 1
            beep
            currentFrame = 1;
            currentPoint = currentPoint + 1;
            set(buttons(6),'string',num2str(currentPoint));
            if currentPoint > numPoints
                currentPoint = numPoints;
                currentFrame = size(vid,4);
            end
            set(buttons(6),'string',num2str(currentPoint));
            
        else
            currentFrame = size(vid,4);
        end
    elseif currentFrame > size(vid,4)
        currentFrame = size(vid,4);
    elseif currentFrame<1
        currentFrame = 1;
    end
    
    set(img,'cdata',vid(:,:,:,currentFrame));
    set(pointPlot,'xData',points(currentFrame,:,1));
    set(pointPlot,'yData',points(currentFrame,:,2));
    set(buttons(5),'value',flags(currentFrame));
end

close(fig)

end

function [] = btn_Exit(src,evnt)
%Toggles the global Exit variable
global ExitFunction
ExitFunction = 1;
end

function [] = btn_backFrame(src,evnt)
%Toggles the global currentFrame variable
global advanceFrame frameSkip
advanceFrame = -frameSkip;
end

function [] = btn_forwardFrame(src,evnt)
%Toggles the global currentFrame variable
global advanceFrame frameSkip
advanceFrame = frameSkip;
end

function [] = btn_frameSkip(src,evnt)
%Toggles the global currentFrame variable
global frameSkip
frameSkip = str2num(get(src,'string'));
end

function [] = btn_currentPoint(src,evnt)
%Toggles the global currentFrame variable
global currentPoint
currentPoint = str2num(get(src,'string'));
end

function [] = btn_selection(src,evnt)
%Toggles the global currentFrame variable
global selection
selection = get(src,'value');
end

function [] = btn_backOne(src,evnt)
%Toggles the global currentFrame variable
global advanceFrame
advanceFrame = -1;
end

function [] = btn_forwardOne(src,evnt)
%Toggles the global currentFrame variable
global advanceFrame
advanceFrame = 1;
end

function [] = btn_Frame1(src,evnt)
%Toggles the global currentFrame variable
global Frame1
Frame1 = 1;
end

function [] = btn_downPoint(src,evnt)
%Toggles the global currentFrame variable
global currentPoint
currentPoint = currentPoint - (currentPoint > 1);
end

function [] = btn_upPoint(src,evnt)
%Toggles the global currentFrame variable
global currentPoint
currentPoint = currentPoint +1;%there will be a check to make sure it doesn't go out of bounds in the main loop
end




    
    
    
