function play_vid(im_lat)

for i = 1:size(im_lat,4)
    image(im_lat(:,:,:,i));
    pause(1/30);
end