function Evec = calibrated_fivepoint( Q1,Q2)
% Function Evec = calibrated_fivepoint( Q1,Q2)
% Henrik Stewenius 20040722
%
%
%  ARTICLE{stewenius-engels-nister-isprsj-2006,
%  AUTHOR = {H. Stew\'enius and C. Engels and D. Nist\'er},
%  TITLE = {Recent Developments on Direct Relative Orientation},
%  JOURNAL = {ISPRS Journal of Photogrammetry and Remote Sensing},
%  URL = {http://dx.doi.org/10.1016/j.isprsjprs.2006.03.005},
%  VOLUME = {60},
%  ISSUE = {4},
%  PAGES = {284--294},
%  MONTH = JUN,
%  CODE = {http://vis.uky.edu/~stewe/FIVEPOINT},
%  PDF = {http://www.vis.uky.edu/~stewe/publications/stewenius_engels_nister_5pt_isprs.pdf},
%  YEAR = 2006
%}
%
%
% For more information please see: 
% Grobner Basis Methods for Minimal Problems in Computer Vision
% Henrik Stewenius, 
% PhD Thesis, Lund University, 2005
% http://www.maths.lth.se/matematiklth/personal/stewe/THESIS/ 
%
% 
% If this implementation is too slow for your needs please see: 
% An Efficient Solution to the Five-Point Relative Pose
%
%@Article{         nister-itpam-04,
%  author        = {Nist\'er, D.},
%  journal       = pami,
%  month         = {June},
%  number        = {6},
%  title         = {Problem},
%  pages         = {756-770},
%  volume        = {26},
%  year          = {2004}
%}
%
% 
%
%
% Code to veryfy that it works: 
% Q1 = rand(3,5);
% Q2 = rand(3,5);
% Evec   = calibrated_fivepoint( Q1,Q2);
% for i=1:size(Evec,2)
%   E = reshape(Evec(:,i),3,3);
%   % Check determinant constraint! 
%   det( E)
%   % Check trace constraint
%   2 *E*transpose(E)*E -trace( E*transpose(E))*E
%   % Check reprojection errors
%   diag( Q1'*E*Q2)
% end
%
% PS: Please note that due to varying standards of which is Q1 and Q2
% it is very possible that you get essential matrices which are 
% the transpose of what your expected. 


%1 Pose linear equations for the essential matrix. 
Q1 = Q1';
Q2 = Q2';

Q = [Q1(:,1).*Q2(:,1) , ...
     Q1(:,2).*Q2(:,1) , ...
     Q1(:,3).*Q2(:,1) , ... 
     Q1(:,1).*Q2(:,2) , ...
     Q1(:,2).*Q2(:,2) , ...
     Q1(:,3).*Q2(:,2) , ...
     Q1(:,1).*Q2(:,3) , ...
     Q1(:,2).*Q2(:,3) , ...
     Q1(:,3).*Q2(:,3) ] ; 


[U,S,V] = svd(Q,0);
EE = V(:,6:9);
   
A = calibrated_fivepoint_helper( EE ) ;
warning('off', 'MATLAB:nearlySingularMatrix');
A = A(:,1:10)\A(:,11:20);
warning('on', 'MATLAB:nearlySingularMatrix');
M = -A([1 2 3 5 6 8], :);
   
M(7,1) = 1;
M(8,2) = 1;
M(9,4) = 1;
M(10,7) = 1;

[V,D] = eig(M );
SOLS =   V(7:9,:)./(ones(3,1)*V(10,:));

Evec = EE*[SOLS ; ones(1,10 ) ]; 
Evec = Evec./ ( ones(9,1)*sqrt(sum( Evec.^2)));

I = find(not(imag( Evec(1,:) )));
Evec = Evec(:,I);
