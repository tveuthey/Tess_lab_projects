function [sleep] = extract_sleep(move)
inds = find(move==1);
dmov = diff(inds);
dmov2=dmov;
dmov2(dmov2<80)=[];
sleep = sum(dmov2)/2;
end    
    