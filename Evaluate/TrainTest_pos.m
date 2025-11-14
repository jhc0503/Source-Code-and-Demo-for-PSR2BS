function [num, part, trnData, trnLab, trnPos, tstData, tstLab, tstPos] = ...
    TrainTest_pos(data, trnNum, label, clsCnt)

clsNum = zeros(1, clsCnt);          %the total number of data for each class
tstNum = zeros(1, clsCnt);          %the number of test data selected for each class

for i = 1 : clsCnt
   index = find(label == i);                 
   clsNum(i) = size(index,1);                   
   tstNum(i) = clsNum(i) - trnNum(i);           
end
num=[trnNum;tstNum];
 
trnData = [];               
trnLab = [];       
trnPos = []; 

tstData = [];                        
tstLab = [];
tstPos = [];

part=[];
for i = 1 : clsCnt
   index = find(label == i);                  
   random_index = index(randperm(length(index)));
   part{1,i}=random_index;
   
   index1 = random_index(1:trnNum(i));           
   trnData = [trnData data(index1,:)'];         
   trnLab = [trnLab ones(1,length(index1))*i];    
   trnPos = [trnPos; index1];
   
   index2 = random_index(trnNum(i)+1:end);        
   tstData = [tstData data(index2,:)'];         
   tstLab = [tstLab ones(1,length(index2))*i];
   tstPos = [tstPos; index2];
end
end