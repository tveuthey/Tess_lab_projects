aviobj = avifile('pre_learning.avi','compression','None');

for frame = 1:size(M, 4)
    aviobj = addframe(aviobj, M(:,:,:,frame); %// This is assuming your image is a vector of RGB images. If it's a vector of indexed images then drop one : and make the loop go to size(M,3)
end

aviobj = close(aviobj);

aviobj = avifile('post_learning.avi','compression','None');

for frame = 1:size(M, 4)
    aviobj = addframe(aviobj, M(:,:,:,frame); %// This is assuming your image is a vector of RGB images. If it's a vector of indexed images then drop one : and make the loop go to size(M,3)
end

aviobj = close(aviobj);