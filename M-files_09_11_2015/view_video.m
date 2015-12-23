function [succ] = view_video (im_file,step,t_drop,t_lat,DISP)

%  if ~exist('DISP','var')
%      DISP=1;
%  end

if t_drop == 0
    drop=0;
    succ='NaN'
    return
end


THRESH_DETECT=20;
thresh_range=1:60;
base_range=1:10;


f_rate=1/mean(diff(t_lat));
d_frame=round(f_rate*t_drop)

len=size(im_file,4)
close all;

if DISP == 1
    figure
    %     set(gcf,'Position',[92   866   625   497]);
    set(gcf,'Position',[92   166   625   497]);
    subplot('Position',[0 0 1 1])
    x=imshow(im_file(:,:,:,1));
    
    figure
    set(gcf,'Position',[ 63   193   125   497]);
    subplot('Position',[0 0 1 1])
    x2=imshow(im_file(:,:,:,1));
end

% defines ROI
%x1=[51.7032  102.6972  110.2304   25.0473];
%y1=[100.6046 97.9970 144.3551  142.3270];
%%OLD TRAINING/ELECTROPHYS BOX
%x1= [126.708 126.708 102.644 103.668 64.244 1.78 1.268 107.252];
%y1=[211.636 153.78 152.756 72.884 29.876 31.412 239.284 236.724];    
%%%NEW AUTOBOX
x1=[111.4 109 100 100 58 58 58 36 1 1.8];
y1=[143.1962 99 89 90 98 98 48 4.1 3.8 141.5];

% creates a filter for the ROI
m=poly2mask(x1,y1,144,176);

base_im=im_file(:,:,:,1);
m_im3=[];
tmpsz = size(im_file);
for n=(d_frame-30):step:(d_frame+30)
    if (n-1>0 && n<tmpsz(4))
        im=im_file(:,:,:,n);
        im2=(im_file(:,:,:,n));
        im2(m)=256; %create mask
        base_im=(im_file(:,:,:,n-1));
        im3=imsubtract(im,base_im);  %image differential
        im3=rgb2gray(im3);
        im3=medfilt2(im3,[3 3]); % cleans image with diff filter
        m_im3=[m_im3 max((im3(m)))];
        
        if DISP == 1
            set(x,'CData',im2)
                     set(x2,'CData',im3)
            pause(0.1)
        end
    end
end


% figure;
% plot(m_im3)
% ylim([0 150]);

%base_vals=mean(m_im3(base_range))
%e_vals = max(m_im3(thresh_range));
e_vals = max(m_im3);
succ = e_vals < THRESH_DETECT;



