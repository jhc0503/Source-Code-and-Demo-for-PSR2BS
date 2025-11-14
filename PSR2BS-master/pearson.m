function cor = pearson(X1, X2)

% N = length(X1);
u1 = mean(X1);
u2 = mean(X2);
delta1 = std(X1,1);
delta2 = std(X2,1);
cor = (mean(X1.*X2) - u1*u2 )/(delta1 * delta2);

end