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
%  Name   : Eval_Metric
%
%  Modified:
%
%    17 December 2019
%
%  Author:
%
%    Ukcheol Shin
%
%  Input    : path_name   -  path of dataset
%  output  : None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ]= Eval_Metric(path_name)
close all;
clc; 

% Check number of inputs.
if nargin >2
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 1 optional inputs');
end

% Flag for saving results 
Save_flag        = 1;

% Read dataset list
output_folder =strcat(path_name(1:regexp(path_name,'DataSet_AE')-2),'\Results\Result_graph',path_name(regexp(path_name,'DataSet_AE')+10:length(path_name)-5));

mkdir(output_folder);
Files = dir(strcat(path_name,'\','*.jpg'));

Results_Our         = zeros(length(Files),3); 
Results_Gradient   = zeros(length(Files),3);
Results_Entropy    = zeros(length(Files),3);
Results_Noise       = zeros(length(Files),3);

for k=1:length(Files)
    fprintf('Path : %s, Processing %dth / %dth image .... \n',path_name,k,length(Files));

    % Read files one-by-one
    FileNames = Files(k).name;
    FilePaths = strcat(path_name,'\',FileNames);

    % Parsing gain & Exposure time
    index_iso = regexp(FileNames,'ISO-');
    index_exp = regexp(FileNames,'-ExpT-');
    index_jpg = regexp(FileNames,'.jpg');

    ISO_ = FileNames(index_iso+4 : index_exp -1);
    Exp_time_ = FileNames(index_exp+6 : index_jpg -1);
    
    % Evalutate images with a Image assessment metrics
    [V_Ours, V_Gradient, V_Entropy, V_Noise] = Metric_Our(FilePaths);
    
    % Save each methods value
    Results_Our(k,:)        =  [str2double(ISO_), str2double(Exp_time_), V_Ours ];
    Results_Entropy(k,:)   =  [str2double(ISO_), str2double(Exp_time_), V_Entropy ];
    Results_Gradient(k,:)  =  [str2double(ISO_), str2double(Exp_time_), V_Gradient ];
    Results_Noise(k,:)      =  [str2double(ISO_), str2double(Exp_time_), -V_Noise ];
end

% Write max value
if Save_flag == 1 
    file_name = strcat(output_folder,'\','Selected_image_info.txt');
    fileID = fopen(file_name,'a');
    
    % Save maximum point with Our metric 
    [~, idx] = max(Results_Our(:,3));
    MAX_value = Results_Our(idx,:);
    str = strcat('Ours  : ', ' ISO : ', num2str(MAX_value(1)),' E_T : ', num2str(MAX_value(2)), ' Value : ', num2str(MAX_value(3)), '\r\n');
    fprintf(fileID,str);

    % Save maximum point with Noise metric 
    [~, idx] = max(Results_Noise(:,3));
    MAX_value = Results_Noise(idx,:);
    str = strcat('Noise : ', ' ISO : ', num2str(MAX_value(1)),' E_T : ', num2str(MAX_value(2)), ' Value : ', num2str(MAX_value(3)), '\r\n');
    fprintf(fileID,str);

    % Save maximum point with Entropy metric 
    [~, idx] = max(Results_Entropy(:,3));
    MAX_value = Results_Entropy(idx,:);
    str = strcat('Entropy : ', ' ISO : ', num2str(MAX_value(1)),' E_T : ', num2str(MAX_value(2)), ' Value : ', num2str(MAX_value(3)), '\r\n');
    fprintf(fileID,str);

    % Save maximum point with Gradient metric 
    [~, idx] = max(Results_Gradient(:,3));
    MAX_value = Results_Gradient(idx,:);
    str = strcat('Gradient : ', ' ISO : ', num2str(MAX_value(1)),' E_T : ', num2str(MAX_value(2)), ' Value : ', num2str(MAX_value(3)), '\r\n');
    fprintf(fileID,str);

    fclose(fileID);
end

% plot values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Gradient-based Metric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = unique(Results_Gradient(:,1));
y = unique(Results_Gradient(:,2));
[X,Y] = meshgrid(x,y);
Z = zeros(size(y,1),size(x,1));

for k = 1: size(Results_Gradient,1)
    x_index = find( x == Results_Gradient(k,1));
    y_index = find( y == Results_Gradient(k,2));
    Z(y_index,x_index) = Results_Gradient(k,3);
end

figure(1);
surfc(X,Y,Z); grid on;
xlabel('Gain(ISO)'); ylabel('Exposure Time(us)'); zlabel('Measure value'); title('Spatial Gradient Value Graph');

% save the result
if Save_flag == 1 
    output = strcat(output_folder,'\','SpatialGradient');
%    saveas(gcf,output,'fig');
%    saveas(gcf,output,'pdf');
    saveas(gcf,output,'jpeg');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Entropy-based Metric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = unique(Results_Entropy(:,1));
y = unique(Results_Entropy(:,2));
[X,Y] = meshgrid(x,y);
Z = zeros(size(y,1),size(x,1));

for k = 1: size(Results_Entropy,1)
    x_index = find( x == Results_Entropy(k,1));
    y_index = find( y == Results_Entropy(k,2));
    Z(y_index,x_index) = Results_Entropy(k,3);
end

figure(2);
surfc(X,Y,Z); grid on;
xlabel('Gain(ISO)'); ylabel('Exposure Time(us)'); zlabel('Measure value'); title('Entropy Value Graph');

% save the result
if Save_flag == 1 
    output = strcat(output_folder,'\','Entropy');
%    saveas(gcf,output,'fig');
%    saveas(gcf,output,'pdf');
    saveas(gcf,output,'jpeg');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Noise-based Metric
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = unique(Results_Noise(:,1));
y = unique(Results_Noise(:,2));
[X,Y] = meshgrid(x,y);
Z = zeros(size(y,1),size(x,1));

for k = 1: size(Results_Noise,1)
    x_index = find( x == Results_Noise(k,1));
    y_index = find( y == Results_Noise(k,2));
    Z(y_index,x_index) = Results_Noise(k,3);
end

figure(3);
surfc(X,Y,Z); grid on;
xlabel('Gain(ISO)'); ylabel('Exposure Time(us)'); zlabel('Measure value'); title('Noise Value Graph');

% save the result
if Save_flag == 1 
    output = strcat(output_folder,'\','Noise');
%    saveas(gcf,output,'fig');
%    saveas(gcf,output,'pdf');
    saveas(gcf,output,'jpeg');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Ours: Grad + Noise + Entropy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = unique(Results_Our(:,1));
y = unique(Results_Our(:,2));
[X,Y] = meshgrid(x,y);
Z = zeros(size(y,1),size(x,1));
for k = 1: size(Results_Our,1)
    x_index = find( x == Results_Our(k,1));
    y_index = find( y == Results_Our(k,2));
    Z(y_index,x_index) = Results_Our(k,3);
    %fprintf('x: %d, y : %d, z: %d \n',list(k,1), list(k,2), list(k,3))
end

figure(4);
surfc(X,Y,Z); grid on;
xlabel('Gain(ISO)');  ylabel('Exposure Time(us)'); zlabel('Measure value'); title('Ours');

% save the result
if Save_flag == 1 
    output = strcat(output_folder,'\','Ours');
%    saveas(gcf,output,'fig');
%    saveas(gcf,output,'pdf');
    saveas(gcf,output,'jpeg');
end

if Save_flag == 1 
    output = strcat(output_folder,'\','workspace_result');
    save(output);
end
end

   
