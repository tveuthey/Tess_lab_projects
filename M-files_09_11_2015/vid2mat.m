function [im1,t1,tot_frames] = vid2mat(videoFile)
%Converts a video file into a mat image structure with
% im1: frames file
% t1: time of frame according to framerate
% tot_frames: total number of frames

vid = VideoReader(videoFile);
parseSize = 2000;%max number of frames to include in a mat file before separating to avoid slowdown.
t = 0: (1/vid.FrameRate):((vid.NumberOfFrames - 1)/vid.FrameRate); %Master Time frame for the video

for i=1:vid.NumberOfFrames
    
    im1(:,:,:,rem(i-1,parseSize)+1)=read(vid,i);
    
    if rem(i,parseSize) == 0
        tempFile = [videoFile(1:(strfind(videoFile,'.')-1)),'_Frames_',num2str(i-parseSize+1),'-',num2str(i),'.mat'];
        t1 = t(1:parseSize);
        t=t((parseSize+1):end);
        tot_frames = parseSize;
        save(tempFile,'im1','t1','tot_frames')
        
        clear im1 t1 tot_frames tempFile;
    end
end

tempFile = [videoFile(1:(strfind(videoFile,'.')-1)),'_Frames_',num2str(floor(i/parseSize)*parseSize+1),'-',num2str(i),'.mat'];

t1 = t(1:end);
tot_frames = length(t);
save(tempFile,'im1','t1','tot_frames')

clear im1 t1 tot_frames tempFile;

end