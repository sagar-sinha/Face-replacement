
function [ Faces, ControlPoints ] = replacementFaceDict(api)
%REPLACEMENTFACEDICT Summary of this function goes here
%   Detailed explanation goes here
    Faces = cell(1, 6);
    ControlPoints = cell(1,6);
    Faces{1,1} = imread('poses_face/left_white.jpg');
    Faces{1,2} = imread('poses_face/front_white.png');
    Faces{1,3} = imread('poses_face/right_white.jpg');
    

    Faces{1,5} = imread('poses_face/front_white_teeth.png');
    Faces{1,4} = imread('poses_face/left_white_teeth.jpg');
    Faces{1,6} = imread('poses_face/right_white_teeth.jpg');
    
    [~, ControlPoints{1,1}, ~, ~, ~] = getInterestPointsFPP(true, api,'poses_face/left_white.jpg',1);
    [~, ControlPoints{1,2}, ~, ~, ~] = getInterestPointsFPP(true, api,'poses_face/front_white.png',1);
    [~, ControlPoints{1,3}, ~, ~, ~] = getInterestPointsFPP(true, api,'poses_face/right_white.jpg',1);

    ControlPoints{1,5} = ControlPoints{1,2};
    ControlPoints{1,4}=  ControlPoints{1,1};
    ControlPoints{1,6}=  ControlPoints{1,3};
    

end

