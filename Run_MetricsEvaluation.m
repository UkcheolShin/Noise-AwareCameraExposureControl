% Type your dataset path
Path_to_datset = './DataSet_AE';

addpath('./Utils_metric');

% Run Metric Evaluator 
Eval_Metric(strcat(Path_to_datset,'\indoor_class_room1_340Lux\left'));
Eval_Metric(strcat(Path_to_datset,'\indoor_class_room2_401Lux\left'));     
Eval_Metric(strcat(Path_to_datset,'\indoor_class_room3_320Lux\left'));
Eval_Metric(strcat(Path_to_datset,'\indoor_class_room4_263Lux\left'));     
Eval_Metric(strcat(Path_to_datset,'\indoor_common_room1_177Lux\left'));    
Eval_Metric(strcat(Path_to_datset,'\indoor_common_room2_95Lux\left'));     
Eval_Metric(strcat(Path_to_datset,'\indoor_lounage1_200Lux\left'));        
Eval_Metric(strcat(Path_to_datset,'\indoor_meeting_room1_198Lux\left'));
Eval_Metric(strcat(Path_to_datset,'\indoor_meeting_room3_213Lux\left'));   
Eval_Metric(strcat(Path_to_datset,'\indoor_meeting_room2_191Lux\left'));   
Eval_Metric(strcat(Path_to_datset,'\outdoor_bench1_6420Lux\left'));        
Eval_Metric(strcat(Path_to_datset,'\outdoor_bench2_5530Lux\left'));        
Eval_Metric(strcat(Path_to_datset,'\outdoor_bicycle1_14230Lux\left'));     
Eval_Metric(strcat(Path_to_datset,'\outdoor_bicycle2_2680Lux\left'));      
Eval_Metric(strcat(Path_to_datset,'\outdoor_car1_15310Lux\left'));         
Eval_Metric(strcat(Path_to_datset,'\outdoor_car2_5530Lux\left'));          
Eval_Metric(strcat(Path_to_datset,'\outdoor_car3_4080Lux\left'));          
Eval_Metric(strcat(Path_to_datset,'\outdoor_car4_5520Lux\left'));          
Eval_Metric(strcat(Path_to_datset,'\outdoor_car5_5290Lux\left'));          
Eval_Metric(strcat(Path_to_datset,'\outdoor_car6_4539Lux\left'));          
Eval_Metric(strcat(Path_to_datset,'\outdoor_car7_8490Lux\left')); 
Eval_Metric(strcat(Path_to_datset,'\outdoor_scene1_7380Lux\left'));        
Eval_Metric(strcat(Path_to_datset,'\outdoor_scene2_7710Lux\left'));        
Eval_Metric(strcat(Path_to_datset,'\outdoor_weed1_3350Lux\left'));         
Eval_Metric(strcat(Path_to_datset,'\outdoor_weed2_3010Lux\left'));

% Run hyper paramter tester
% Test_HyperParam(strcat(Path_to_datset,'\indoor_class_room1_340Lux\left'));
% Test_HyperParam(strcat(Path_to_datset,'\indoor_class_room2_401Lux\left'));     
% Test_HyperParam(strcat(Path_to_datset,'\indoor_class_room3_320Lux\left'));
% Test_HyperParam(strcat(Path_to_datset,'\indoor_class_room4_263Lux\left'));     
% Test_HyperParam(strcat(Path_to_datset,'\indoor_common_room1_177Lux\left'));    
% Test_HyperParam(strcat(Path_to_datset,'\indoor_common_room2_95Lux\left'));     
% Test_HyperParam(strcat(Path_to_datset,'\indoor_lounage1_200Lux\left'));        
% Test_HyperParam(strcat(Path_to_datset,'\indoor_meeting_room1_198Lux\left'));
% Test_HyperParam(strcat(Path_to_datset,'\indoor_meeting_room3_213Lux\left'));   
% Test_HyperParam(strcat(Path_to_datset,'\indoor_meeting_room2_191Lux\left'));   
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_bench1_6420Lux\left'));        
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_bench2_5530Lux\left'));        
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_bicycle1_14230Lux\left'));     
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_bicycle2_2680Lux\left'));      
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car1_15310Lux\left'));         
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car2_5530Lux\left'));          
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car3_4080Lux\left'));          
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car4_5520Lux\left'));          
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car5_5290Lux\left'));          
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car6_4539Lux\left'));          
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_car7_8490Lux\left')); 
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_scene1_7380Lux\left'));        
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_scene2_7710Lux\left'));        
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_weed1_3350Lux\left'));         
% Test_HyperParam(strcat(Path_to_datset,'\outdoor_weed2_3010Lux\left'));

% Extract result img
Extract_Result(strcat(Path_to_datset,'\indoor_class_room1_340Lux\left'));
Extract_Result(strcat(Path_to_datset,'\indoor_class_room2_401Lux\left'));     
Extract_Result(strcat(Path_to_datset,'\indoor_class_room3_320Lux\left'));
Extract_Result(strcat(Path_to_datset,'\indoor_class_room4_263Lux\left'));     
Extract_Result(strcat(Path_to_datset,'\indoor_common_room1_177Lux\left'));    
Extract_Result(strcat(Path_to_datset,'\indoor_common_room2_95Lux\left'));     
Extract_Result(strcat(Path_to_datset,'\indoor_lounage1_200Lux\left'));        
Extract_Result(strcat(Path_to_datset,'\indoor_meeting_room1_198Lux\left'));
Extract_Result(strcat(Path_to_datset,'\indoor_meeting_room3_213Lux\left'));   
Extract_Result(strcat(Path_to_datset,'\indoor_meeting_room2_191Lux\left'));   
Extract_Result(strcat(Path_to_datset,'\outdoor_bench1_6420Lux\left'));        
Extract_Result(strcat(Path_to_datset,'\outdoor_bench2_5530Lux\left'));        
Extract_Result(strcat(Path_to_datset,'\outdoor_bicycle1_14230Lux\left'));     
Extract_Result(strcat(Path_to_datset,'\outdoor_bicycle2_2680Lux\left'));      
Extract_Result(strcat(Path_to_datset,'\outdoor_car1_15310Lux\left'));         
Extract_Result(strcat(Path_to_datset,'\outdoor_car2_5530Lux\left'));          
Extract_Result(strcat(Path_to_datset,'\outdoor_car3_4080Lux\left'));          
Extract_Result(strcat(Path_to_datset,'\outdoor_car4_5520Lux\left'));          
Extract_Result(strcat(Path_to_datset,'\outdoor_car5_5290Lux\left'));          
Extract_Result(strcat(Path_to_datset,'\outdoor_car6_4539Lux\left'));          
Extract_Result(strcat(Path_to_datset,'\outdoor_car7_8490Lux\left')); 
Extract_Result(strcat(Path_to_datset,'\outdoor_scene1_7380Lux\left'));        
Extract_Result(strcat(Path_to_datset,'\outdoor_scene2_7710Lux\left'));        
Extract_Result(strcat(Path_to_datset,'\outdoor_weed1_3350Lux\left'));         
Extract_Result(strcat(Path_to_datset,'\outdoor_weed2_3010Lux\left'));
