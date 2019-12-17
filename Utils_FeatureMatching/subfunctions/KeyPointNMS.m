% KEYPOINTNMS Do non-maximum suppression on keypoints inside a grid
%
% Inputs
%   grid_range - Grid range [x1, y1, x2, y2]
%   pt         - Keypoints
%   num        - Number of keypoints to preserve
% Outputs
%   idx        - Indices of the survived keypoint
function idx = KeyPointNMS(grid_range, kp, num)
    x1 = grid_range(1);
    y1 = grid_range(2);
    x2 = grid_range(3);
    y2 = grid_range(4);
    
    num_kp = numel(kp);
    
    x = zeros(num_kp, 1);
    y = zeros(num_kp, 1);
    s = zeros(num_kp, 1);
    
    for k=1:num_kp
        x(k) = kp(k).pt(1);
        y(k) = kp(k).pt(2);
        s(k) = kp(k).response;
    end
    
    idx_inside = find((x >= x1) & (x < x2) & (y >= y1) & (y < y2));
    
    if(numel(idx_inside) <= num)
        idx = idx_inside;
        return;
    end
    
    score_inside = s(idx_inside);
    
    [~, idx_sorted] = sort(score_inside, 'descend');
    
    idx = idx_inside(idx_sorted(1:num));

end