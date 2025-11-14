function [tstNum,num,part,trnData,trnLab,trnPos,tstData,tstLab,tstPos] = ...
    dataClss_Numbersamples_pos(clsCnt, selectedBand, img, Label, NumSamples)
    selectedBand = sort(selectedBand);
    newData = img(selectedBand,:);
    clsNum = zeros(1, clsCnt);
    for i = 1:clsCnt
        index0 = find(Label==i);
        clsNum(i) = length(index0);
    end
    trnNum = NumSamples * ones(1, clsCnt);
    [num,part,trnData,trnLab,trnPos,tstData,tstLab,tstPos] = TrainTest_pos(newData', trnNum, Label, clsCnt);
    tstNum = zeros(1,clsCnt);
    for i = 1:clsCnt
        index = find(tstLab == i);
        tstNum(i) = length(index);
    end
end

