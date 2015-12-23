function [dir1,indir1,unrel1,FR]=classify_groups(mega)


dir=[0 0];
indir=[0 0];
unrel=[0 0];

for i=1:size(mega,1)
    if mega(i,1)==1
        dir=[dir; mega(i,2:3) ]
%         dir(i,:)=mega(i,2:3);
    else
        if mega(i,1)==2
        indir=[indir; mega(i,2:3) ]
        else
            if mega(i,1)==3
        unrel=[unrel; mega(i,2:3) ]
            end
        end
    end
end
ndir=length(dir)-1;
nindir=length(indir)-1;
nunrel=length(unrel)-1;
FR=mega(:,4);

for i=2:size(dir,1)
    if isnan(dir(i,1))==1
        dir1(i,1)=70;
    else 
        if isnan(dir(i,2))==1
            dir1(i,1)=70;
        else
            if dir(i,1)>dir(i,2)
                dir1(i,1)=dir(i,1);
            else
                dir1(i,1)=dir(i,2);
            end
        end
    end
end

for i=2:size(indir,1)
    if isnan(indir(i,1))==1
        indir1(i,1)=70;
    else 
        if isnan(indir(i,2))==1
            indir1(i,1)=70;
        else
            if indir(i,1)>indir(i,2)
                indir1(i,1)=indir(i,1);
            else
                indir1(i,1)=indir(i,2);
            end
        end
    end
end

for i=2:size(unrel,1)
    if isnan(unrel(i,1))==1
        unrel1(i,1)=0;
    else 
        if isnan(unrel(i,2))==1
            unrel1(i,1)=0;
        else
            if unrel(i,1)>unrel(i,2)
                unrel1(i,1)=unrel(i,2);
            else
                unrel1(i,1)=unrel(i,1);
            end
        end
    end
end


