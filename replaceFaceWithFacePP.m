function  replaceFaceWithFacePP(video_file, output_name, pose_detection_off)
%video file is the input video file
%output_name is the name by which video will be generated
%Pose Detection switch off - True or False
addpath('./FaceFppLibrary/');
API_KEY = '6894a9492a127f5bc36e05763041a641';
API_SECRET = 'itKp-UPlCBwd3T4zhkllnkpin4GfJfqp';
api = facepp(API_KEY, API_SECRET);

% Dictionary for all replacement faces and control pointss 
[ Faces, ControlPoints ] = replacementFaceDict(api);

videoFileReader = vision.VideoFileReader(video_file);
writeObj = VideoWriter(output_name);
writeObj.FrameRate = 24;
open(writeObj);
target_points = zeros([83,2]);
% tracking points for the first video frame. If no face was detected keep
% trying
while sum(sum(target_points)) == 0
    videoFrame = step(videoFileReader);
    imwrite(videoFrame, fullfile('./', 'videoFrame.jpg'));
    [target_rectangle, target_points, smiling, dir, race] = getInterestPointsFPP(true, api,'videoFrame.jpg',1);
end

% visulaize the tracking points FacePP returned 
fpp = 1;
name = strcat(num2str(fpp),'fpp.JPG');
videomarker = insertMarker(videoFrame, target_points, '+','Color', 'white');
imwrite(videomarker, fullfile('./pictures', name));
fpp = fpp + 1;


[replacementFrame, replacement_points] = pose_detection(pose_detection_off,  smiling, dir, race, Faces, ControlPoints );        
% morph the first frame
morphed_image = wrapper_replace(videoFrame,replacementFrame, target_points, replacement_points, target_rectangle, [2,3]);
morphed_image = im2double(morphed_image);
morphed_image(morphed_image<0) = 0;
morphed_image(morphed_image>0.9999) = 0.9999;
writeVideo(writeObj, morphed_image);

%initialize a tracker with the target points
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
initialize(pointTracker, target_points, videoFrame);

count = 1;

while ~isDone(videoFileReader)
    videoFrame = step(videoFileReader);
    
    %get the new target tracking points from FacePP & reinitialize the
    %tracking points for the replacement face
    if(mod(count,15)==0 || sum(sum(target_points)) == 0)
        imwrite(videoFrame, fullfile('./', 'videoFrame.jpg'));
        [target_rectangle, target_points, smiling, dir, race] = getInterestPointsFPP(true, api,'videoFrame.jpg',1);
        
        % if no face was detected, use the old tracking points but don't
        % increment the count yet since we want to check if in the next 
        %frame if faces can be detected
        if sum(sum(target_points)) == 0
            [target_points, isFound] = step(pointTracker, videoFrame);
            
            %skip this frame 
            if sum(isFound) == 0
                display('Control Points from point tracker is 0');
                continue;
            end
            target_points = target_points(isFound, :);
            replacement_points = replacement_points(isFound, :);
            morphed_image = wrapper_replace(videoFrame,replacementFrame, target_points, replacement_points, target_rectangle, [2,3]);
            morphed_image(morphed_image<0) = 0;
            morphed_image(morphed_image>0.9999) = 0.9999;
            writeVideo(writeObj, morphed_image);
            setPoints(pointTracker, target_points);
            continue;
        end        
        %visulaize the tracking points FacePP returned
        name = strcat(num2str(fpp),'fpp.JPG');
        videomarker = insertMarker(videoFrame, target_points, '+','Color', 'white');
        imwrite(videomarker, fullfile('./pictures', name));
        fpp = fpp + 1;
        % tracking points for the replacement face
        [replacementFrame, replacement_points] = pose_detection(pose_detection_off, smiling, dir, race, Faces, ControlPoints );
        setPoints(pointTracker, target_points);
    else
        [target_points, isFound] = step(pointTracker, videoFrame);
        target_points = target_points(isFound, :);
        replacement_points = replacement_points(isFound, :);
    end
    % Important - Don't call wrapper_replace with checking for tracking
    % points, it'll cause convex hull errors
    if sum(sum(target_points)) == 0
        count = count + 1
        continue;
    end
    morphed_image = wrapper_replace(videoFrame,replacementFrame, target_points, replacement_points, target_rectangle, [2,3]);
    morphed_image(morphed_image<0) = 0;
    morphed_image(morphed_image>0.9999) = 1;
    writeVideo(writeObj, morphed_image);
    setPoints(pointTracker, target_points);
    count = count + 1
end

% Clean up
release(videoFileReader);
release(pointTracker);
end
