function y = l21norm(W)
[d,~] = size(W);
y = 0;
for i = 1:d
    y = y + norm(W(i,:),2);
end
end