%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%
%%         RMSMovAvg.m Implements  2*P-point moving average, donsamples by
%%                      Q.  Use an even number (for now).
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function movavg=RMSMovAvg(data1,P,Q)
wvec=floor([1:P/2 P/2:-1:1]);
data=[];
for(k=1:size(data1,3))
    data=cat(1,data,data1(:,:,k));
end
l=1;
for(r=1:(length(data)-(P+1) ))
    windata=data(:,r:(r+ (P-1) ));
    if(mod(r,Q)==0)
        
        movavg(:,l)=sqrt(mean((windata.^2)*diag((wvec/sum(wvec.^2))),2));
        l=l+1;
    end
end