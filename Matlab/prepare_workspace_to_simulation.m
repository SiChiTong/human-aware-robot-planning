
function [ kinect_data, THumanSingleTask ]  = prepare_workspace_to_simulation( path, HumanTaskRepetitions  )

addpath(path)

%%% Extract the kinect frames of the human movement
kinect_data        = struct();
kinect_data.frames = opennitracker(); % autogenerated function

%%% Extract the occupancy grid
og     = load('points.mat', '-ascii');

rmpath(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% KINECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kinect_data.frames_names =  { '/skel/SpineBase' ...
                            , '/skel/SpineMid'  ...
                            , '/skel/Neck' ...
                            , '/skel/Head' ...
                            , '/skel/ShoulderLeft' ...
                            , '/skel/ElbowLeft' ...
                            , '/skel/WristLeft' ...
                            , '/skel/HandLeft' ...
                            , '/skel/ShoulderRight' ...
                            , '/skel/ElbowRight' ...
                            , '/skel/WristRight' ...
                            , '/skel/HandRight' ...
                            , '/skel/HipLeft' ...
                            , '/skel/KneeLeft' ...
                            , '/skel/AnkleLeft' ...
                            , '/skel/FootLeft' ...
                            , '/skel/HipRight' ...
                            , '/skel/KneeRight' ...
                            , '/skel/AnkleRight' ...
                            , '/skel/FootRight' ...
                            , '/skel/SpineShoulder' ...
                            , '/skel/HandTipLeft' ...
                            , '/skel/ThumbLeft' ...
                            , '/skel/HandTipRight' ...
                            , '/skel/ThumbRight' };

dt = 0.01;
[ tss, TExperimentStart, TExperimentEnd, THumanSingleTask ] = toTimeseries( kinect_data.frames, HumanTaskRepetitions );
n_frame                                                     = round( length(kinect_data.frames) / HumanTaskRepetitions );


time_values = [TExperimentStart:dt:TExperimentEnd]';
kinect_data.xvalues = struct();
kinect_data.yvalues = struct();
kinect_data.zvalues = struct();

kinect_data.xvalues.time = time_values;
kinect_data.yvalues.time = time_values;
kinect_data.zvalues.time = time_values;

kinect_data.xvalues.signals = struct();
kinect_data.yvalues.signals = struct();
kinect_data.zvalues.signals = struct();

kinect_data.xvalues.signals.dimensions = length( kinect_data.frames_names );
kinect_data.yvalues.signals.dimensions = length( kinect_data.frames_names );
kinect_data.zvalues.signals.dimensions = length( kinect_data.frames_names );

% kinect_data.xvalues.signals.nsamples = length(time_values);
% kinect_data.yvalues.signals.nsamples = length(time_values);
% kinect_data.zvalues.signals.nsamples = length(time_values);

kinect_data.xvalues.signals.values = zeros( length(time_values), length( kinect_data.frames_names ) );
kinect_data.yvalues.signals.values = zeros( length(time_values), length( kinect_data.frames_names ) );
kinect_data.zvalues.signals.values = zeros( length(time_values), length( kinect_data.frames_names ) );

for iT=1:length( time_values )
    for iFrame=1:length( kinect_data.frames_names )
        kinect_data.xvalues.signals.values( iT , iFrame) = fnval( time_values(iT), tss{iFrame,1} );
        kinect_data.yvalues.signals.values( iT , iFrame) = fnval( time_values(iT), tss{iFrame,2} );
        kinect_data.zvalues.signals.values( iT , iFrame) = fnval( time_values(iT), tss{iFrame,3} );
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


kinect_data.og_points = zeros( size(og,1), 3 );
% kinect_data.og_points(:,1) = -og(:,3);
% kinect_data.og_points(:,2) =  og(:,2);
% kinect_data.og_points(:,3) =  og(:,4);
kinect_data.og_occurences  = ceil( og(:,5) / HumanTaskRepetitions ) / n_frame;
kinect_data.og_points(:,1) = og(:,2);
kinect_data.og_points(:,2) = og(:,3);
kinect_data.og_points(:,3) = og(:,4);