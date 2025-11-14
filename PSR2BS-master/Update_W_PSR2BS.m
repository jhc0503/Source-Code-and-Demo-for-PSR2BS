function [W, t] = Update_W_PSR2BS(X, G, alpha, C, gama, tao)
[~, d] = size(X);
D = eye(d); 
D2= D;
W = (X'*X+alpha*D+gama*D2) \ X' * G;

diff = norm(W, 'fro');
t = 0;
Tmax = 50;
% obj = zeros(Tmax,1);
while diff >= tao
    p1 = zeros(1,d);
    p2 = zeros(1,d);
    norm_Wrows = zeros(d,1);
    for i = 1:d
        norm_Wrows(i) = norm(W(i,:),2);
    end
    for i = 1:d
        p1(i) = 1/( 2*norm_Wrows(i) + eps );
        p2(i) = p1(i)*(norm_Wrows'*C(i,:)');
    end
    D = diag(p1);
    D2= diag(p2);
    W0= W;
    W = (X'*X+alpha*D+gama*D2) \ X' * G;
    diff = norm(W-W0, 'fro');
    t = t+1;
    if t > Tmax
        break 
    end
%     obj(t) = norm(X*W-G, 'fro')^2 + alpha*l21norm(W) + gama*Redundancy(W,C);
end
% figure
% iter = 1:Tmax;
% plot(iter,obj(1:Tmax),'-r')
end