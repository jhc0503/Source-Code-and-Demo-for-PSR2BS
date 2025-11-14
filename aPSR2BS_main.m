function index_Rep_out = aPSR2BS_main(img_src, img_gt, alpha, gama) % Output scores for each band.
beta = 10;
miu = 100; ns = 100; % the number of superpixels, default is 100
c = 15; nn = 5; % c - the number of rows of W; nn - the number of neighbors in constructing Lp
[W, h, L] = size(img_src);
img_src = img_src./max(img_src(:));
data2D = reshape(img_src, W*h, L);
clsCnt = length(unique(img_gt))-1; 
clsNum = zeros(1, clsCnt);
for i = 1:clsCnt
    index0 = find(img_gt==i);
    clsNum(i) = length(index0);
end


Tmax = 17;



%% super-pixels segmentation

labels = cubseg(img_src,ns);


%% Spectral-Spatial UBS
tic
Labels = labels(:);
img_s = zeros(ns, L);
img_pos = zeros(ns, 2);
for i = 1:ns
    [index1,index2] = find(labels==i-1);
    index = find(Labels==i-1);
    img_superpixels = data2D(index, :);
    img_s(i,:) = mean(img_superpixels, 1);
    img_pos(i,1) = mean(index1);
    img_pos(i,2) = mean(index2);
end

G = zeros(ns, c);
for i = 1:c
    G(i,i) = 1;
end

distance_spec = pdist(img_s, 'euclidean');
distance_spec = MinMaxNor(distance_spec);
distance_spat = pdist(img_pos, 'euclidean');
distance_spat = MinMaxNor(distance_spat);
distance = distance_spec .* distance_spat;
Weight_Matrix = squareform(distance);
[~, index] = sort(Weight_Matrix);
Weight_Matrix = - (Weight_Matrix);
for i = 1:ns
    in_p = index(nn+2:ns,i);
    Weight_Matrix(in_p,i) = 0;
    Weight_Matrix(i,i)=0;
end
[~,~,W_var] = find(Weight_Matrix);
bw = var(W_var, 1);
W_Matrix = exp( -(Weight_Matrix.^2)/bw );
W_Matrix(W_Matrix==1)=0;
W_Matrix = (W_Matrix+W_Matrix')/2;
Degree_Matrix = sum(W_Matrix);
Lp = diag(Degree_Matrix) - W_Matrix;



cc = zeros(L,L);
for i = 1:L
    for j = 1:L
        cc(i,j) = pearson(img_s(:,i),img_s(:,j));
        cc(i,i) = 1;
    end
end
cc = cc.^2;
C = cc;

tic
W  = zeros(L, c);
F  = zeros(ns, c);
T = 1; 
res_W = zeros(1, Tmax); res_G = zeros(1, Tmax); res_F = zeros(1, Tmax); 
res_W(1) = 10;
res_G(1) = norm(G,'fro');
res_F(1) = 10;

tao  = 1e-5;
Tao  = 1e-4;
% miu = 1e2;
obj = zeros(Tmax,1) ;
index_Rep = zeros(Tmax,L);

while res_W(T)>=Tao || res_G(T)>=Tao || res_F(T)>=Tao
    W0 = W; G0 = G; F0 = F;
    [W, ~] = Update_W_PSR2BS(img_s, G, alpha, C, gama, tao);
    [G, ~] = Update_G_PSR2BS(img_s, W, Lp, F, beta, miu, tao);
    F  = max(G, zeros(ns, c));
    
    Rep1 = zeros(1, L);
    for i = 1:L
        Rep1(i) = norm(W(i,:),2);
    end
    [~, index_Rep(T,:)] = sort(Rep1, 'descend');
    T = T+1;
    res_W(T)  = norm(W-W0, 'fro'); 
    res_G(T)  = norm(G-G0, 'fro'); 
    res_F(T)  = norm(F-F0, 'fro'); 
    if T >= Tmax
        break 
    end
end
toc
T_cut = 15;


% fprintf('The number of iterations is %d. \n', T_cut);
index_Rep_out = index_Rep(T_cut,:);
