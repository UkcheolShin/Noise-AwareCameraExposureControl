%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Camera Exposure Control for Robust Robot Vision 
% with Noise-Aware Image Assessment Metric
%
% Ukcheol Shin, Jinsun Park, Gyumin Shim, Francois Rameau, and In So Kweon
%
% IROS 2019
%
% Please feel free to contact if you have any problems.
% 
% E-mail : Ukcheol Shin (shinwc159@gmail.com / shinwc159@kaist.ac.kr)
%          Robotics and Computer Vision Lab., EE,
%          KAIST, Republic of Korea
%
% Project Page : https://sites.google.com/view/noise-aware-exposure-control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Name   : feature_matching_analysis
%             : conduct feature extraction & matching expeeriments.
%
%  Modified:
%
%    17 December 2019
%
%  Author:
%
%    Ukcheol Shin
%
%  Input    : path_name   -  path of each metric's result
%  output  : None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = main_feature_matching_analysis(path_name)
close all;
clc;

addpath(genpath('subfunctions'));
result_folder = strcat(path_name,'/result_matching');
mkdir(result_folder);

% GT Intrinsic / Extrinsic Parameters
% plz refer the "GT_CameraParameter.txt" of dataset.
K1 = [814.889003,  -0.384418, 764.659138;
        0.000000, 814.206990, 576.541219;
        0.000000,   0.000000,   1.000000];
K2 = [816.254045,  -0.516877, 767.769055;
        0.000000, 815.958860, 580.307083;
        0.000000,   0.000000,   1.000000];
    
D1 = [-0.055030, 0.122773, 0.001917, -0.001426, -0.065038];
D2 = [-0.052789, 0.123278, 0.000337, -0.001296, -0.067356];

R = [0.999887, -0.004519, -0.014343;
     0.004515,  0.999990, -0.000323;
     0.014345,  0.000259,  0.999897];
T = [-0.201597, -0.001746, 0.000769]';

width = 1600;
height = 1200;

%% Initialize rectification map
stereo_rect = cv.stereoRectify(K1, D1, K2, D2, [width, height], R, T, 'Alpha', 0);

R1 = stereo_rect.R1;
R2 = stereo_rect.R2;
P1 = stereo_rect.P1;
P2 = stereo_rect.P2;

[map1_1, map1_2] = cv.initUndistortRectifyMap(K1, D1, [width, height], 'R', R1, 'NewCameraMatrix', P1);
[map2_1, map2_2] = cv.initUndistortRectifyMap(K2, D2, [width, height], 'R', R2, 'NewCameraMatrix', P2);

% Intrinsics and rotation are changed after rectification
K1 = P1(1:3, 1:3);
K2 = P2(1:3, 1:3);
R = eye(3);
T = K2\P2;
T = T(:, 4);
baseline = norm(T);

%% Parameters for experiment
num_features_max = 100000;
num_features = 1000;

th_dist = 0.02; % Inlier epipolar distance threshold
th_reproject = 0.1;
th_fast = 10;

LeftFiles=dir(strcat(path_name,'/left/','*.jpg'));
RightFiles = dir(strcat(path_name,'/right/','*.jpg'));

if(length(LeftFiles) ~= length(RightFiles))
   error('incorrect folder !!!');
   return;
end

%% Do feature extractiong & matching 
file_name = strcat(result_folder,'/','FeatureMactching_Result.txt');
fileID = fopen(file_name,'a');

for k=1 : length(LeftFiles)
    % Check image name consistency
    LeftFileNames = LeftFiles(k).name;
    RightFileNames = RightFiles(k).name;

    path_image_left = strcat(path_name,'/left/',LeftFileNames);
    path_image_right = strcat(path_name,'/right/',RightFileNames);

    index = regexp(LeftFileNames,'_ISO-'); 
    My_name_left = LeftFileNames(1:index);
    index = regexp(RightFileNames,'_ISO-'); 
    My_name_right = RightFileNames(1:index);

    if(~strcmp(My_name_left,My_name_right))
       error('incorrect file matching!!!');
       break;
    end

    % Load images
    image_left_orig = imread(path_image_left);
    image_right_orig = imread(path_image_right);

    image_left = cv.remap(image_left_orig, map1_1, map1_2);
    image_right = cv.remap(image_right_orig, map2_1, map2_2);

    result = struct();

    %% Comparison 1. Number of FAST extracted
    detector_fast = cv.ORB('MaxFeatures', num_features_max, 'ScoreType', 'FAST');
    detector_fast.FastThreshold = th_fast;

    % FAST extraction without limitation
    fast_left_max_num = detector_fast.detect(image_left);
    fast_right_max_num = detector_fast.detect(image_right);

    result.NumFASTLeftUnlimited = numel(fast_left_max_num);
    result.NumFASTRightUnlimited = numel(fast_right_max_num);

    % FAST extraction with limitation
    detector = cv.ORB('MaxFeatures', num_features, 'ScoreType', 'FAST');
    detector.FastThreshold = th_fast;

    fast_left_init = detector.detect(image_left);
    fast_right_init = detector.detect(image_right);

    num_left_init = numel(fast_left_init);
    num_right_init = numel(fast_right_init);

    result.NumFASTLeftInit = num_left_init;
    result.NumFASTRightInit = num_right_init;

    % Feature extraction
    [desc_left, kp_left] = detector.compute(image_left, fast_left_init);
    [desc_right, kp_right] = detector.compute(image_right, fast_right_init);

    result.NumberOfKeyPointsLeft = numel(kp_left);
    result.NumberOfKeyPointsRight = numel(kp_right);

    % matcher = cv.DescriptorMatcher('BFMatcher', 'CrossCheck', true);
    matcher = cv.DescriptorMatcher('BFMatcher', 'NormType', 'Hamming', 'CrossCheck', true);

    % Initial feature matching
    matches = matcher.match(desc_left, desc_right);
    num_initial_matches = numel(matches);

    result.NumMatchesInitial = num_initial_matches;

    image_matches_init = cv.drawMatches(image_left, kp_left, image_right, kp_right, matches);

    % Matched left / right indices
    pts_left = zeros(3, num_initial_matches);
    pts_right = zeros(3, num_initial_matches);

    pts_right_gt = zeros(2, num_initial_matches);

    for k=1:num_initial_matches
        % MexOpenCV (Zero-based) -> MATLAB (One-based)
        % To normalized coordinates
        pts_left(:, k) = K1\[kp_left(matches(k).queryIdx+1).pt'; 1];
        pts_right(:, k) = K2\[kp_right(matches(k).trainIdx+1).pt'; 1];

        pts_right_gt_tmp = [R, T]*[pts_left(:, k); 1];

        pts_right_gt(:, k) = [pts_right_gt_tmp(1)/pts_right_gt_tmp(3); ...
                              pts_right_gt_tmp(2)/pts_right_gt_tmp(3)];

    end

    pts_left = pts_left(1:2, :)./repmat(pts_left(3, :), [2, 1]);
    pts_right = pts_right(1:2, :)./repmat(pts_right(3, :), [2, 1]);

    dist_err = sqrt(sum((pts_right_gt - pts_right).^2, 1));
    flag_match_correct = dist_err < th_reproject;
    matches_correct = matches(flag_match_correct);

    num_correct_matches = sum(flag_match_correct);

    result.NumMatchesInitialCorrect = num_correct_matches;

    image_matches_correct = cv.drawMatches(image_left, kp_left, image_right, kp_right, matches_correct);

    %% Step 2. Pose Estimation
    E = cv.findEssentialMat(pts_left', pts_right', 'Method', 'LMedS');
    % E = cv.findEssentialMat(pts_left', pts_right', 'Method', 'Ransac', 'Threshold', 0.1);

    [R_init, T_init, num_matches_ransac, flag_good] = cv.recoverPose(E, pts_left', pts_right');
    flag_good = flag_good > 0;

    matches_ransac = matches(flag_good);
    pts_left_ransac = pts_left(:, flag_good);
    pts_right_ransac = pts_right(:, flag_good);

    result.NumMatchesRANSAC = num_matches_ransac;

    image_matches_ransac = cv.drawMatches(image_left, kp_left, ...
                            image_right, kp_right, matches_ransac);

    figure(5);
    imagesc([image_matches_init; image_matches_ransac; image_matches_correct]);
    title(sprintf('Number of initial / LMedS / correct matches : %d -> %d -> %d', ...
        result.NumMatchesInitial, result.NumMatchesRANSAC, result.NumMatchesInitialCorrect));
    drawnow;
    output = strcat(result_folder,'/',My_name_left);
    saveas(gcf,output,'fig');
    saveas(gcf,output,'jpg');
    
    % Translation is up-to-scale
    T_init = T_init*baseline/norm(T_init);

    R_err_init = real(acosd(0.5*trace(R'*R_init) - 0.5));
    T_err_init = norm(T - T_init);

    result.R_err_init = R_err_init;
    result.T_err_init = T_err_init;

    result.R = R;
    result.T = T;
    result.R_init = R_init;
    result.T_init = T_init;


    %% Result
    fprintf(fileID, '==========================================\n');
    fprintf(fileID, '\nMatching and Pose Estimation results\n');
    fprintf(fileID, 'Dataset Path : %s                              \n', path_name);
    fprintf(fileID, 'Result of %s                                    \n', My_name_left);
    fprintf(fileID, 'Number of FAST from the left       : %d\n', result.NumFASTLeftUnlimited);
    fprintf(fileID, 'Number of FAST from the right      : %d\n', result.NumFASTRightUnlimited);
    fprintf(fileID, 'Number of keypoints from the left  : %d\n', result.NumberOfKeyPointsLeft);
    fprintf(fileID, 'Number of keypoints from the right : %d\n', result.NumberOfKeyPointsRight);
    fprintf(fileID, 'Number of initial matches          : %d\n', result.NumMatchesInitial);
    fprintf(fileID, 'Number of correct matches          : %d\n', result.NumMatchesInitialCorrect);
    fprintf(fileID, 'Number of RANSAC matches           : %d\n', result.NumMatchesRANSAC);
    fprintf(fileID, 'Initial rotation error             : %f (deg)\n', result.R_err_init);
    fprintf(fileID, 'Initial translation error          : %f (m)\n', result.T_err_init);
    fprintf(fileID, '==========================================\n');
end

fclose(fileID);
end