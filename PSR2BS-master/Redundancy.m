function Out = Redundancy(W,C)
[L,~] = size(C);
Out = 0;
for i = 1:L
    for j = 1:L
        Out = Out + norm(W(i,:),2)*norm(W(j,:),2)*C(i,j);
    end
end
end