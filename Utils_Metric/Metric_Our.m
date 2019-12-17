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
% Name   : Metric_Our
% Input    : Img_path        -  Path of a image
% output  : Value_Ours     - Proposed image assessment value of the given image
%            : Value_Grad     - Gradient-based image assessment value of the given image
%            : Value_Entorpy - Entropy-based image assessment value of the given image
%            : Value_Noise    - Noise-based image assessment value of the given image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Value_Ours, Value_Grad, Value_Entropy, Value_Noise] = Metric_Our(Img_path)

% Set hyper parameters
Resize_factor   = 1.0;
Alpha            = 0.4;
Beta              = 0.4;

% hyper parameter for gradient-based metric
Kg = 2;
Lambda = 10^3;
Gamma = 0.06;

% hyper parameter for noise-based metric
Ke = 0.125; % 1/8  
p = 0.10;
T_lower = 15;
T_upper = 235;

% Set flag for display
plot_flag = 0;

%% 1. Noise-based Metric
Img = imread(Img_path);
Img = imresize(Img,Resize_factor);
Value_Noise = zeros(size(Img,3),1);

for Channel = 1 : size(Img,3)
    Image  = uint8(Img(:,:,Channel));
    
    [H,W]   = size(Image);

    % 1. Estimate homogenous region mask based on adaptive edge thresholding
    [Image_Grad, ]  = imgradient(double(Image), 'Sobel').^2;
    Grad_1D          = reshape(Image_Grad, [1,H*W]); % 1D histogram
    Sort_Grad_1D   = sort(Grad_1D);    
    Gth                = Sort_Grad_1D(1,int32(H*W*p)); % p% = 0.10
    HomogenousRegionMask      = double(Image_Grad <= Gth);

    % 2. Estimate Unsaturated mask 
    UnsaturatedMask = zeros(H,W);
    for i = 1 : H
        for j = 1: W
            if(T_lower <= Image(i,j) && Image(i,j) <= T_upper)
                UnsaturatedMask(i,j) = 1;
            else
                UnsaturatedMask(i,j) = 0;
            end
        end
    end

    % 3. Get integrated mask
    UnSaturatedHomogenousMask = UnsaturatedMask .* HomogenousRegionMask;

    % 4. Estimate Noise level of the image
    Ng = [ 1, -2,  1 ;
           -2,  4, -2 ;
            1, -2, 1  ];

    Laplacian_Image  = conv2(double(Image),double(Ng));
    Laplacian_Image  = Laplacian_Image(2:H+1,2:W+1);
    Masked_Laplacian_Image = Laplacian_Image.*UnSaturatedHomogenousMask;

    % In the paper, I was missed the number of "6", plz refer the equation
    % from "Immerkaer, John. "Fast noise variance estimation." Computer vision and image understanding 64.2 (1996): 300-302."
    Ns                              = sum(sum(UnSaturatedHomogenousMask));
    Value_Noise(Channel)      = sqrt(pi/2) * (1/(6*Ns)) * sum(sum(abs(Masked_Laplacian_Image)));

    % If there are no reliable regions, we follows the original noise
    % estimation equation.
    if(sum(sum(UnSaturatedHomogenousMask)) < H*W*0.0001)    
        Value_Noise(Channel) = sqrt(pi/2)*(1/(6*(W-2)*(H-2)))*sum(sum(abs(Laplacian_Image)));
    end

    %% 7. Plot
    if plot_flag == 1
        figure; 
        subplot(2,4,1);
        imagesc(Image);
        title('Input Img');

        subplot(2,4,2);
        imagesc(uint8(255*Image_Grad)); 
        title('Gradient Map');

        subplot(2,4,3);
        imagesc(uint8(255*HomogenousRegionMask));
        title('homogenous Mask Image');

        subplot(2,4,4);
        imshow(UnsaturatedMask);
        title('Unsaturated Mask Image');

        subplot(2,4,5);
        imshow(UnSaturatedHomogenousMask);
        title('UnSaturated Homogenous Mask Image');

        subplot(2,4,6);
        imagesc(uint8(Laplacian_Image)); 
        title('Laplacian image');

        subplot(2,4,7);
        imagesc(uint8(Masked_Laplacian_Image)); 
        title('Masked Laplacian image');
    end
end

% the camera we used has a Bayer pattern, so we multiply 2 on the green channel,
% but empirically 'R+G+B/3'  shows almost similar results.
if (size(Img_path,3) == 3)
    Value_Noise = (Value_Noise(1) + 2*Value_Noise(2) + Value_Noise(3)) / 4;
else
    Value_Noise = mean(Value_Noise);
end


%% 2. Gradient-based Metric
gray_Image = rgb2gray(Img);
[H,W] = size(gray_Image);

% 1.normalize gradient image
[Image_Grad,] = imgradient(gray_Image);
G_norm = Image_Grad./sqrt(16 * 255 * 255 + 16 * 255 * 255); % normalize

% In the paper "Auto-adjusting camera exposure for outdoor robotics using gradient information, IROS2014." 
% The author used lambda = 10^3, Gamma = 0.06 in all experiments, so we follow the setup.
Ng = log(Lambda.*(1-Gamma)+1);
Mapped_Grad = zeros(H,W);
for i=1:H
    for j=1:W
        if G_norm(i,j)>=Gamma
            Mapped_Grad(i,j)= log(Lambda * (G_norm(i,j) - Gamma) + 1)./ Ng;
        else
            Mapped_Grad(i,j) = 0;
        end
    end
end

% Estimate grid-level statistics of gradient metric
num = 10; % num x num grid 
Gridded_Grad = zeros(num,num);

for i = 1:num
    for j = 1:num
        Gridded_Grad(i,j) = mean2(Mapped_Grad(1+H/num * (i-1) : H/num * (i-1) +H/num,  1+W/num * (j-1) :W/num * (j-1) + W/num));
    end
end
Gridded_Grad_1D = reshape(Gridded_Grad, [num*num,1]);
Grad_mean = mean(Gridded_Grad_1D);
Std_num = std(Gridded_Grad_1D);
Value_Grad = Grad_mean / Std_num;

%% 3. Entropy-based Metric
Value_Entropy = Ke*entropy(gray_Image);

%% 4. Proposed Metric
% Kg is scalling factor and empirically decided.
Value_Ours = Alpha*Kg*Value_Grad + (1-Alpha)*Value_Entropy - Beta*Value_Noise;
end