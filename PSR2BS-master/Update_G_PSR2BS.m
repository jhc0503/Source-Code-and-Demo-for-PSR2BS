function [G, t] = Update_G_PSR2BS(X, W, Lp, F, beta, miu, tao)
[~, ns] = size(Lp);
[~, c] = size(W);
A = beta*Lp + (1+0.5*miu)*eye(ns);
[~, D_A] = eig(double(A+1e-6));
maxEig = max(diag(D_A)) + 1;
A = maxEig * eye(ns) - A;
B = X*W + 0.5*miu*F;
G = zeros(ns, c);
for i = 1:c
    G(i,i) = 1;
end

diff = norm(G, 'fro');
t = 0;
Tmax = 50;
% obj = zeros(Tmax,1);
while diff >= tao
    G0 = G;
    M = 2*A*G + 2*B;
    [U,~,V] = svd(M);
    U = U(:,1:c);
    G = U * V';
    diff = norm(G-G0, 'fro');
    t = t + 1;
    if t > 50
        break
    end
%     obj(t) = norm(X*W-G, 'fro')^2 + beta*trace(G'*Lp*G) + 0.5*miu*norm(G-F, 'fro')^2;
end
% figure
% iter = 1:Tmax;
% plot(iter,obj(1:Tmax),'-r')
end