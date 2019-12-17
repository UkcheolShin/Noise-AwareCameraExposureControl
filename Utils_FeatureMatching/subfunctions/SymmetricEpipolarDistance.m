%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name   : SymmetricEpipolarDistance
% Input  : E            - Essential matrix
%          x1           - normalized image points from the 1st camera [3 x N]
%          x2           - normalized image points from the 2nd camera [3 x N]
%          th           - distance threshold for inliers
% Output : D            - sum of distances
%          flag_inliers - flags of inliners
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D, flag_inliers] = SymmetricEpipolarDistance(F, x1, x2, th)

% Epipolar lines
l1 = F'*x2;
l2 = F*x1;

l1 = l1./repmat(sqrt(sum(l1(1:2,:).^2, 1)), [3, 1]);
l2 = l2./repmat(sqrt(sum(l2(1:2,:).^2, 1)), [3, 1]);

% Distance
d1 = sqrt(sum(l1.*x1, 1).^2);
d2 = sqrt(sum(l2.*x2, 1).^2);

d = (d1 + d2);

flag_inliers = d < th;

D = sum(d(:));

return