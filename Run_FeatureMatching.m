% Type your dataset path
Path_to_result = './Results\Result_img';

addpath('./Utils_FeatureMatching');

% Run feature extraction & matching 
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_class_room1_340Lux'));
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_class_room2_401Lux'));     
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_class_room3_320Lux'));
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_class_room4_263Lux'));     
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_common_room1_177Lux'));    
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_common_room2_95Lux'));     
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_lounage1_200Lux'));        
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_meeting_room1_198Lux'));
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_meeting_room3_213Lux'));   
main_feature_matching_analysis(strcat(Path_to_result,'\indoor_meeting_room2_191Lux'));   
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_bench1_6420Lux'));        
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_bench2_5530Lux'));        
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_bicycle1_14230Lux'));     
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_bicycle2_2680Lux'));      
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car1_15310Lux'));         
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car2_5530Lux'));          
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car3_4080Lux'));          
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car4_5520Lux'));          
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car5_5290Lux'));          
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car6_4539Lux'));          
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_car7_8490Lux')); 
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_scene1_7380Lux'));        
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_scene2_7710Lux'));        
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_weed1_3350Lux'));         
main_feature_matching_analysis(strcat(Path_to_result,'\outdoor_weed2_3010Lux'));