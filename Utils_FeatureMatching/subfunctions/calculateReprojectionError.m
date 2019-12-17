% CALCULATEREPROJECTIONERROR Calculate reprojection error
%
% Inputs
%   params    - Input rotation and translation vectors [R(3), T(3)]
%   pts_left  - Left keypoints [3 x N]
%   pts_right - Right keypoints [3 x N]
%
% Outputs
%   err       - Calculated reprojection error
function err = calculateReprojectionError(params, T, pts_left, pts_right)
    R = rotationVectorToMatrix(params(1:3))';
%     T = params(4:6)';
    
    T_mat = [    0, -T(3),  T(2);
              T(3),     0, -T(1);
             -T(2),  T(1),     0];
         
    E = R*T_mat;
    
    num = size(pts_left, 2);
    if(size(pts_right, 2) ~= num)
        error('Number of size must be the same');
    end
    
    pts_left = [pts_left; ones(1, num)];
    pts_right = [pts_right; ones(1, num)];
    
    l1 = E'*pts_right;
    l2 = E*pts_left;
    
    l1_norm = sqrt(sum(l1.^2, 1));
    l2_norm = sqrt(sum(l2.^2, 1));
    
    l1 = l1./repmat(l1_norm, [3, 1]);
    l2 = l2./repmat(l2_norm, [3, 1]);
    
    d1 = abs(sum(l1.*pts_left, 1));
    d2 = abs(sum(l2.*pts_right, 1));
    
    err = (d1(:) + d2(:))/2;
%     err = logLoss(err);
end

% function err_out = logLoss(err_in)
%     err_out = log(err_in + 1);
% end