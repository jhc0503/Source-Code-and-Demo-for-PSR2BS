function W = MinMaxNor(W)
maxW = max(W(:));
minW = min(W(:));

W = (W-minW)/(maxW-minW);

end