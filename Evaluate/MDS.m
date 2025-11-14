function Z = MDS(D, d)
[~, L] = size(D);
square_D = D.^2;
B = zeros(L, L);

for i = 1:L
    for j = 1:L
        B(i,j) = ( (sum(square_D(i,:)))/L + (sum(square_D(:,j)))/L...
            - (sum(sum(square_D)))/(L^2) - square_D(i,j) )/2;
    end
end

[V,D1] = eig(B);
t = (L-d+1):L;
Z = sqrt(D1(t,t)) * V(:,t)';

end