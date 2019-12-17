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
% Name   : Test_HyperParam
%            : Test hyper parameter of proposed metric
% Input    : path_name     -  Path of each dataset
% output  : None            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Test_HyperParam(path_name)
close all;
clc; 

% Check number of inputs.
if nargin >2
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 1 optional inputs');
end

% load workspace matlab file
path_result = strcat(path_name(1:regexp(path_name,'DataSet_AE')-2),'\Results');
workspace_file = strcat(path_result,'\Result_graph', path_name(regexp(path_name,'DataSet_AE')+10:length(path_name)-5), '\workspace_result.mat');
load(workspace_file);

Left_folder = path_name;
Right_folder = strcat(path_name(1:length(path_name)-5),'\right');

% make output directory
Output_folder =strcat(path_result,'\Result_HypeParam', path_name(regexp(path_name,'DataSet_AE')+10:length(path_name)-5));
Result_left_folder   = strcat(Output_folder,'\left');
Result_right_folder = strcat(Output_folder,'\right');

mkdir(Output_folder);
mkdir(Result_left_folder);
mkdir(Result_right_folder);

file_name = strcat(Output_folder,'\','max_value.txt');
fileID = fopen(file_name,'a');

Test_Our = Results_Our;
Kg = 2;

% Test hyper parameter
for Alpha = 0 : 0.2 : 1.0
    for Beta = 0 : 0.1 : 1    
        fprintf('alpha : %d , beta : %d \n',Alpha,Beta);
         Test_Our(:,3) = Alpha*Kg*Results_Gradient(:,3) + (1-Alpha)*Results_Entropy(:,3) - Beta*Results_Noise(:,3);

        % Write a result
        [~, idx] = max(Test_Our(:,3));
        MAX_value = Test_Our(idx,:);
        str = strcat('Alpha : ', num2str(Alpha), ' Beta : ', num2str(Beta) , ' ISO : ', num2str(MAX_value(1)),' E_T : ', num2str(MAX_value(2)), ' Value : ', num2str(MAX_value(3)), '\r\n');
        fprintf(fileID,str);
        
        % Copy left/right images according to the each maximum point
        ImgLeftFile = strcat(Left_folder,'\',Files(idx).name);
        ImgRightFile = strcat(Right_folder,'\',Files(idx).name);
        
        saveLeftFile = strcat(Result_left_folder,'\alpha_',num2str(Alpha*10),'_beta_',num2str(Beta*10), '_ISO-',num2str(MAX_value(1)),'-ExpT-',num2str(MAX_value(2)),'.jpg');
        saveRightFile = strcat(Result_right_folder,'\alpha_',num2str(Alpha*10),'_beta_',num2str(Beta*10), '_ISO-',num2str(MAX_value(1)),'-ExpT-',num2str(MAX_value(2)),'.jpg');
        copyfile(ImgLeftFile, saveLeftFile);
        copyfile(ImgRightFile, saveRightFile);
    
        % plot values
        figure(1);
        x = unique(Test_Our(:,1));
        y = unique(Test_Our(:,2));
        [X,Y] = meshgrid(x,y);
        Z = zeros(size(y,1),size(x,1));
        for k = 1: size(Test_Our,1)
            x_index = find( x == Test_Our(k,1));
            y_index = find( y == Test_Our(k,2));
            Z(y_index,x_index) = Test_Our(k,3);
            %fprintf('x: %d, y : %d, z: %d \n',list(k,1), list(k,2), list(k,3))
        end

        surfc(X,Y,Z); grid on;
        xlabel('Gain(ISO)');  ylabel('Exposure Time(us)'); zlabel('Measure value');
        title('Ours');
        output = strcat(Output_folder,'\','Ours_Alpha_', num2str(Alpha*10), '_Beta_', num2str(Beta*10));
        %saveas(gcf,output,'fig');
        %saveas(gcf,output,'pdf');
        saveas(gcf,output,'jpeg');
    end
end

fclose(fileID);
end


   
