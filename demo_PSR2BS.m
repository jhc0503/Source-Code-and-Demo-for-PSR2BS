clc
clear all
close all
addpath Superpixel
addpath Datasets
addpath Evaluate
addpath(genpath(cd));
warning off

%% load data and preprocess
load Botswana;
img_src = Botswana;
[W, h, L] = size(img_src);
clear Botswana;

load Botswana_gt; 
img_gt = Botswana_gt(:);
img_gt0 = reshape(img_gt, W, h);
clear Botswana_gt;


x = 5:5:50; % the number of selected bands.
repeats = 5; % The times experiments are repeated.



%%
u = find(img_gt ~= 0);

img_src0 = img_src;
img_src = double(img_src);
img_src_orig3D = img_src;

img_src = reshape(img_src, W * h, L);

img_src(img_src<0) = 0;

maxgray = max(max(img_src));
mingray = min(min(img_src));
for i = 1 : L
    img_src(:, i) = (img_src(:,i) - mingray) / (maxgray-mingray); % for SVM classifier
end

alpha = 5e-4;
gama = 5e-5; % the optimal parameters for Botswana dataset in paper
index_Rep = aPSR2BS_main(img_src_orig3D,img_gt,alpha, gama);

OA_KNN = zeros(size(x,2), repeats);
AA_KNN = zeros(size(x,2), repeats);
K_KNN  = zeros(size(x,2), repeats);
OA_SVM = zeros(size(x,2), repeats);
AA_SVM = zeros(size(x,2), repeats);
K_SVM  = zeros(size(x,2), repeats);

for m1 = 1:size(x,2)
    
k = x(m1);
Y = index_Rep(1:k);
sort_Y = sort(Y);  
% All bands
Y_all = 1:L;
disp('！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！')
fprintf('The selected bands is %d. \n', k);
%% Classification Evaluation
for m2 = 1:repeats

    clsCnt = length(unique(img_gt))-1; 
    per = 0.10; % the number of the training samples 
    [tstNum,num,part,trnData,trnLab,trnPos,tstData,tstLab,tstPos] = ...
        dataClss_percentage_pos(clsCnt,Y_all,img_src',img_gt, per);
    
        trnDatai = trnData(Y,:);
        tstDatai = tstData(Y,:);
        for classifier = 1:2
            switch classifier
                case 1
                k2 = 3;  
                preLab1 = KNN(trnDatai,trnLab,tstDatai,tstLab,k2);
                [OA_KNN(m1,m2),AA_KNN(m1,m2),K_KNN(m1,m2)] = accuracy2( tstLab,preLab1,clsCnt,tstNum );
                case 2
                model = svmtrain(trnLab',trnDatai','-c 10000.000000 -g 0.500000 -m 500 -t 2 -q');
                SVMtest = svmpredict(tstLab',tstDatai',model);
                [OA_SVM(m1,m2),AA_SVM(m1,m2),K_SVM(m1,m2)] = accuracy2( tstLab,SVMtest',clsCnt,tstNum );
            end
        end
end

end

mean_OA_KNN = mean(OA_KNN, 2);
mean_AA_KNN = mean(AA_KNN, 2);
mean_K_KNN  = mean(K_KNN, 2);

fprintf('\nThe overall accuracy of PSR2BS by KNN with different number of selected bands is \n') % The average accuracy/ kappa coefficient
disp(mean_OA_KNN')

mean_OA_SVM = mean(OA_SVM, 2);
mean_AA_SVM = mean(AA_SVM, 2);
mean_K_SVM = mean(K_SVM, 2);
fprintf('\nThe overall accuracy of PSR2BS by SVM with different number of selected bands is \n')
disp(mean_OA_SVM')




