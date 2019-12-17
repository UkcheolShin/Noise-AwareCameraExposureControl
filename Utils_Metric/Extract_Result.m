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
%  Name   : Extract_Result
%             : Extract result image of each image assessment metric and upsampled workspace.
%
%  Modified:
%
%    17 December 2019
%
%  Author:
%
%    Ukcheol Shin
%
%  Input    : path_name     -  Path of each dataset
%  output  : None            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Extract_Result(path_name)
close all;
clc; 

% Check number of inputs.
if nargin >2
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 1 optional inputs');
end

% Load workspace matlab file
path_result = strcat(path_name(1:regexp(path_name,'DataSet_AE')-2),'\Results');
workspace_file = strcat(path_result,'\Result_graph', path_name(regexp(path_name,'DataSet_AE')+10:length(path_name)-5), '\workspace_result.mat');
load(workspace_file);

Left_folder = path_name;
Right_folder = strcat(path_name(1:length(path_name)-5),'\right');

% Make output directory
Output_folder =strcat(path_result,'\Result_Exp', path_name(regexp(path_name,'DataSet_AE')+10:length(path_name)-5));
Result_left_folder    = strcat(Output_folder,'\left');
Result_right_folder  = strcat(Output_folder,'\right');

mkdir(Result_left_folder);
mkdir(Result_right_folder);

% Copy each algorithms result img
for i = 1 : length(Files)

    % parse ISO/Exposure time
    FileNames = Files(i).name;
    index = regexp(FileNames,'ISO-'); 
    index2 = regexp(FileNames,'-ExpT-');
    index3 = regexp(FileNames,'.jpg');
    ISO_ = str2double(FileNames(index+4 : index2 -1));
    Exp_time_ = str2double(FileNames(index2+6 : index3 -1));
    
    ImgLeftFile = strcat(Left_folder,'\',Files(i).name);
    ImgRightFile = strcat(Right_folder,'\',Files(i).name);
    
    % If the maximum points of each method are matches, copy the image.
    [~, idx] = max(Results_Our(:,3));
    MAX_value = Results_Our(idx,:);
    if(ISO_ == MAX_value(1))
        if(Exp_time_ ==  MAX_value(2))
            saveLeftFile = strcat(Result_left_folder,'\Ours_ISO-',num2str(ISO_),'-ExpT-',num2str(Exp_time_),'.jpg');
            saveRightFile = strcat(Result_right_folder,'\Ours_ISO-',num2str(ISO_),'-ExpT-',num2str(Exp_time_),'.jpg');
            copyfile(ImgLeftFile, saveLeftFile);
            copyfile(ImgRightFile, saveRightFile);
        end
    end
    
    % Add other alogorithms result
    
end

% Copy camera built-in AutoExposuer result img
path_AE =  strcat(path_name(1:length(path_name)-5),'\AE');
Files_AE = dir(strcat(path_AE,'\','*.jpg'));

for i = 1 : length(Files_AE)

    % parse ISO/Exposure time
    FileNames = Files_AE(i).name;
    index = regexp(FileNames,'ExpT-');
    index2 = regexp(FileNames,'-ISO-'); 
    index3 = regexp(FileNames,'.jpg');
    Exp_time_ = str2double(FileNames(index+5 : index2 -1));
    ISO_ = str2double(FileNames(index2+5 : index3 -1));

    if(strcmp(FileNames(1:6), 'Param1'))
        ImgRightFile = strcat(path_AE,'\',Files_AE(i).name);
        saveRightFile = strcat(Result_right_folder,'\AE_ISO-',num2str(ISO_),'-ExpT-',num2str(Exp_time_),'.jpg');
        copyfile(ImgRightFile, saveRightFile);
    elseif(strcmp(FileNames(1:6), 'Param2'))            
        ImgLeftFile = strcat(path_AE,'\',Files_AE(i).name);
        saveLeftFile = strcat(Result_left_folder,'\AE_ISO-',num2str(ISO_),'-ExpT-',num2str(Exp_time_),'.jpg');
        copyfile(ImgLeftFile, saveLeftFile);
    end

end

% Copy workspace file & upsampled results
saveWorkSpaceFile = strcat(Output_folder,'\workspace_result.mat');
copyfile(workspace_file, saveWorkSpaceFile);

interval_dB = 0.1;
interval_ExpT = 10;
min_dB = min(x);
max_dB = max(x);
min_ExpT = min(y);
max_ExpT = max(y);

[Xq, Yq] = meshgrid( min_dB : interval_dB : max_dB, min_ExpT : interval_ExpT : max_ExpT);
Zq= interp2(X,Y,Z,Xq,Yq,'cubic');

% Display interpolated surface
%surfc(Xq,Yq,Zq); grid on; hold on;
%set(gca,'FontName', 'Times New Roman','FontSize',17);
%xlabel('Gain','fontsize',20, 'fontweight','bold');  ylabel('ExpT','fontsize',20, 'fontweight','bold'); zlabel('Metric value','fontsize',20, 'fontweight','bold');
%view(-40,45)

if(max_dB == 20) dataset_flag = 0; % outdoor
elseif(max_dB == 24) dataset_flag = 1; %indoor

saveWorkSpaceFile = strcat(Output_folder,'\','workspace_upsampled_result');
save(saveWorkSpaceFile,'Xq','Yq','Zq','path_name', 'dataset_flag', 'Results_Our','interval_dB', 'interval_ExpT');

disp('Done.')
end


   
