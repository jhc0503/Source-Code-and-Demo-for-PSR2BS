function [tstNum,num,part,trnData,trnLab,trnPos,tstData,tstLab,tstPos] = ...
    dataClss_percentage_pos(clsCnt, selectedBand, img, Label, per)
    selectedBand = sort(selectedBand);
    newData = img(selectedBand,:);
    clsNum = zeros(1, clsCnt);
    for i = 1:clsCnt
        index0 = find(Label==i);
        clsNum(i) = length(index0);
    end
%     trnPer = 0.1; 
%     [num,part,trnData,trnLab,tstData,tstLab] = TrainTest2(newData',Label,trnPer,clsCnt);
%     trnNum = [50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 10, 10, 10, 10];
    trnNum = ceil(per * clsNum); 

    [num,part,trnData,trnLab,trnPos,tstData,tstLab,tstPos] = TrainTest_pos(newData', trnNum, Label, clsCnt);
    tstNum = zeros(1,clsCnt);
    for i = 1:clsCnt
        index = find(tstLab == i);
        tstNum(i) = length(index);
    end
end

