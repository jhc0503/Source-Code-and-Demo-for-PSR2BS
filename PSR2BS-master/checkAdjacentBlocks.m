function areAdjacent = checkAdjacentBlocks(image1, image2)
    
    % 提取两个像素块的边界像素
    boundary1 = bwperim(image1);
    boundary2 = bwperim(image2);
    dilatedBoundary1 = imdilate(boundary1, ones(3));
    dilatedBoundary2 = imdilate(boundary2, ones(3));
    
    % 判断是否有相邻的膨胀后的边界像素
    adjacentPixels = dilatedBoundary1 & dilatedBoundary2;    
    
    % 如果有相交的边界像素，则说明两个像素块相邻
    areAdjacent = any(adjacentPixels(:));
end