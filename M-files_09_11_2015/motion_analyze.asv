function  [move]=motion_analyze (fname, view)
% view = 1 show; o/w no


%f_path='C:\Users\Karunesh\Desktop\autobox\VID\';
f_path='E:\T32\';
fname=[f_path fname];
av12=mmreader(fname);
temp=get(av12);
s_frame=1;
e_frame=temp.NumberOfFrames;
 
a=read(av12,[s_frame e_frame]);
data=a;

if ~exist ('view')
    view=0;
end

if view == 1
    f=figure;
    for n=1:25:(e_frame-s_frame)
        imshow(a(:,:,:,n))
        title(n)
        pause(0.01)
    end
    close(f);
end

if view==1
    figure
end

filt_box1=[20 20];
filt_box2=[50 50];
threshold=0.1; %for converting to a BW image

max_area_thresh=5; %to determine if a movement occurred or not
move=[];
for N=2:size(data,4)
    
    %diff_im = data(:,:,:,1) - background;
    %diff_im = imabsdiff(rgb2gray(data(:,:,:,1)),rgb2gray(data(:,:,:,2)));
    %diff_im = imabsdiff((data(:,:,:,N)),(data(:,:,:,N-1)));

    d2=imadjust(rgb2gray(data(:,:,:,N-1)));
    d1=imadjust(rgb2gray(data(:,:,:,N)));
    diff_im=imabsdiff(d1,d2);
    diff=diff_im;
    
    %BW = imextendedmax(diff_im,50);
    
    if view==1
        subplot(2,2,1);
        imshow(diff);
              %imshow(BW);
    end
    
    %threshold2 = graythresh(diff);
    %disp(threshold2)
    %title(threshold)
    
    diff_bw = im2bw(diff,threshold);
    %diff_bw = bwareaopen(diff_bw, 20);
    
    diff_bw = medfilt2(diff_bw,filt_box1);
    %chan2=medfilt2(diff_bw,filt_box2);
    
    bw2 = imfill(diff_bw,'holes');
    %bw_chan2 = imfill(chan2,'holes');
    %imshow(diff_bw)
    
    if view==1
        subplot(2,2,2);
        imshow(bw2);
        %imshow(bw_chan2);
    end
    
    s  = regionprops(bw2, 'centroid','BoundingBox','Area','image','ConvexImage');
    
    if view==1
        subplot(2,2,3)
    end
    
   if view==1
         [B,L] = bwboundaries(bw2,'noholes');
        imshow(label2rgb(L, @jet, [.5 .5 .5]))
        
        hold on
        for k = 1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
        end
        
        subplot(2,2,4)
        imshow(data(:,:,:,N));
        hold(imgca,'on');
    end
    
    if size(s,1) > 0
        area=cat(1,s.Area);
        [val i]=sort(area,'descend');
        centroids = cat(1, s.Centroid);
        centroids=centroids(i,:);
        if length(i) > 4
            mean_mass=mean(centroids(1:2,:))
        else
            mean_mass=(centroids(1,:));
        end
        
        keep_i=1;
        i=i(keep_i);
        area=area(i);
        max_area=area(1);
        %centroids=centroids(i,:);
        
        BB=cat(1,s.BoundingBox);
        BB=BB(i,:);
        
        if view==1           
            plot(mean_mass(1),mean_mass(2),'c*','MarkerSize',20);
        end

        if max_area>max_area_thresh
            disp([N max_area 1])
            if view==1               
                text(15,30,'**','FontSize',40,'Color','g');
            end
            
            move=[move 1];
        else
            if view==1               
                text(15,30,'**','FontSize',40,'Color','k');
            end
            disp([N max_area 0])
            move=[move 0];
            
        end
    else
        if view==1            
            text(15,30,'**','FontSize',40,'Color','k');
        end
        disp([N 0 0])
        move=[move 0];
        
    end
    if view==1
        %rectangle('Position',[cd 60 33],'LineWidth',2,'EdgeColor','b');
        hold(imgca,'off');
    end
    if view == 1
        pause(0.01)
    end
end

figure;
plot(move);
ylim([0 2]);
end
