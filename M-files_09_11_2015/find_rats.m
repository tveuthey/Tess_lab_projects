function [unique_rats temp rat_id unique_dates] = find_rats (p)

% if isempty ('p')
%     p='E:\Videos\';
% end

temp=ls(p);
temp_stop=1; offset=0;
while temp_stop
    temp2=temp(offset+1,:);
    dash=find(temp2=='.');
    temp_stop=~strcmp('mat',temp2(dash+1:dash+3));
    offset=offset+1;
end

animal_name=cell(length(temp),1);
animal_dates=cell(length(temp),1);
u_index=1;
for n= offset:length(temp)
    temp2=temp(n,:);
    dash=find(temp2=='-');
    animal_name{n}=temp2(1:dash(1)-1);
    if n == offset
        unique_rats{u_index}=animal_name{n};
    else
        hold_comp=zeros(u_index,1);
        for n2=1:u_index
            %disp([unique_rats{n2},animal_name{n}])
            %disp(strcmp(unique_rats{n2},animal_name{n}))
            hold_comp(n2)=strcmp(unique_rats{n2},animal_name{n});
        end
        %disp(hold_comp);
        if sum(hold_comp) == 0
            unique_rats{u_index+1}=animal_name{n};
            u_index=u_index+1;
        end
    end
end

rat_id=zeros(length(temp),1)
for n= offset:length(temp)    
    for n2=1:u_index
        temp2=temp(n,:);
        dash=find(temp2=='-');
        temp3=temp2(1:dash(1)-1)
        temp_id=strcmp(temp3,unique_rats);
        rat_id(n)=find(temp_id==1);
    end
end


date_id=zeros(length(temp),1)
unique_dates=cell(u_index,1)
for n2=1:u_index
    ind=(find(rat_id==n2));
    temp2=temp(ind(1),:);
    dash=find(temp2=='-');
    temp_date=temp2(dash(1)+1:dash(3)-1);
        
    hold_u_dates=[];
    u_date_index=1;
    hold_u_dates{u_date_index}=temp_date;
    for n3=2:length(ind)
        temp2=temp(ind(n3),:);
        dash=find(temp2=='-');
        temp_date=temp2(dash(1)+1:dash(3)-1);
        hold_comp=zeros(length(u_date_index),1);
        for n4=1:u_date_index
            %disp([hold_u_dates{n4},temp_date])
            %disp(strcmp(hold_u_dates{n4},temp_date))
            hold_comp(n4)=strcmp(hold_u_dates{n4},temp_date);
        end
        if sum(hold_comp) == 0
            u_date_index=u_date_index+1;       
            hold_u_dates{u_date_index}=temp_date;
        end
        %u_date_index
    end
    unique_dates{n2}=hold_u_dates;
end

for n2=1:u_index
    disp(unique_rats{n2})
    temp4=unique_dates{n2};
    for n3=1:length(temp4)
        disp(temp4(n3))
    end
end