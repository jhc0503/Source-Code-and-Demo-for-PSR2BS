function [OA, AA, Kappa] = accuracy2(actual, predicted, clsCnt, Samples) 
    C = zeros(clsCnt, clsCnt); % C is the confusion matrix
    for i = 1:length(actual)
        C(predicted(i), actual(i)) = C(predicted(i), actual(i)) + 1;
    end
    N = sum(Samples);
    
    OA = sum(diag(C)) / N;
    
    Acc = zeros(1, clsCnt);
    for t = 1:clsCnt
        Acc(t) = C(t,t)/sum(C(:,t));
    end
    AA = mean(Acc);
    
    AP = zeros(1,clsCnt);
    for t = 1:clsCnt
        AP(t) = sum(C(:,t)) * sum(C(t,:));
    end
    Pe = sum(AP) / (N * N);
    Kappa = (OA - Pe) / (1 - Pe);
end