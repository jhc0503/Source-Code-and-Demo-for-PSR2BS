function p = rep_select2(M, H, in)
s = size(M,2);
W = zeros(1,s);
H_raw = H(in); % raw information entropy
H = (H - min(H) * ones(1, size(H, 2))) / (max(H) - min(H));
% H_n = H(in); % Normalized information entropy

if s == 1
    p = 1;

elseif s >= 2 && s <= 10
    for i = 1:s
%         W(i) = H_n(i) + sum(M(i,:)) / (s * H_raw(i));
%         W(i) = H_n(i) * sum(M(i,:)) / (s * H_raw(i));
        W(i) = H_raw(i) + sum(M(i,:)) / ((s-1) * H_raw(i));
    end
    [~, p] = max(W);    
    
elseif s > 10
    [~, p] = max(H_raw);
    
end

end