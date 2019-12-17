%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name   : ValidCameraPosition
% Input  : E  - essential matrix
%          P1 - normalized camera matrix of the 1st camera [R | T]
%          x1 - normalized points of the 1st camera [2 x N]
%          x2 - normalized points of the 2nd camera [2 x N]
% Output : P2 - normalized camera matrix of the 2nd camera [R | T]
%          R  - rotation matrix
%          T  - translation matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P2, R, T] = ValidCameraPosition(E, P1, x1, x2)
[U, ~, V] = svd(E);

W = [0, -1, 0; 1, 0, 0; 0, 0, 1];
u3 = U(:,3);

% 4 possible positions
P21 = [U*W*V', u3];
P22 = [U*W*V', -u3];
P23 = [U*W'*V', u3];
P24 = [U*W'*V', -u3];

P = {P21, P22, P23, P24};

P_ref = [eye(3,3), zeros(3,1)];

P2 = [];
R = [];
T = [];

N = size(x1, 2);
num_valid = 0;

for k=1:4
    X = zeros(4,N);
    
    for n=1:N
        A = [x1(1)*P_ref(3,:) - P_ref(1,:);
             x1(2)*P_ref(3,:) - P_ref(2,:);
             x2(1)*P{k}(3,:) - P{k}(1,:);
             x2(2)*P{k}(3,:) - P{k}(2,:)];

        [~, ~, V] = svd(A);
        X(:,n) = V(:,end);
    end
    
    % Projected points
    xp1 = P_ref*X;
    xp2 = P{k}*X;
    
    d1 = (sign(det(squeeze(P_ref(:,1:3))))*xp1(3,:))./(X(4,:)*norm(P_ref(3,:)));
    d2 = (sign(det(squeeze(P{k}(:,1:3))))*xp2(3,:))./(X(4,:)*norm(P{k}(3,:)));
    
    num_pos = sum((d1 > 0) & (d2 > 0));
    
    if((num_pos > 0) && (num_pos > num_valid))
        num_valid = num_pos;
        
        P_tmp = P{k}*[P1; [0, 0, 0, 1]];
        
        R = P_tmp(:,1:3);
        T = P_tmp(:,4);
        
        R_det = det(R);
        
        R = R/R_det;
        T = T/R_det;
        
        P2 = [R, T];
    end
end

return;