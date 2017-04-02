function [boundary, landmark, smiling,dir,race] = getInterestPointsFPP(ignore, api,img_path, max_pos)
addpath('./FaceFppLibrary/');
rst = detect_file(api, img_path, 'race,pose,smiling');
img_width = rst{1}.img_width;
img_height = rst{1}.img_height;
faces = rst{1}.face;

%Finding the center of the image
image_center = img_width/2;
fprintf('Totally %d faces detected!\n', length(faces));
% max_pos = 0; max_area = 0;
landmark = zeros([83,2]);
boundary = zeros([1,4]);
if (isempty(faces))
    return;
end
% for i = 1 : length(faces)
%     face = faces{i};
%     area = face.position.height * face.position.height;
%     if(area>max_area)
%         max_area = area;
%         max_pos = i;
%     end
% end
largest_face = faces{max_pos};
if largest_face.attribute.smiling.value>2
    smiling = 1;
else
    smiling = 0;
end
if largest_face.attribute.pose.yaw_angle.value < -4
    dir = 0;
elseif largest_face.attribute.pose.yaw_angle.value <= 4
    dir = 1;
else
    dir = 2;
end
race = largest_face.attribute.race.value;
center = largest_face.position.center;

if(~ignore && image_center > 0.01*img_width*center.x)
    display('Left face detected');
    return;
end

w = largest_face.position.width / 100 * img_width;
h = largest_face.position.height / 100 * img_height;
boundary = [center.x * img_width / 100 - w/2, center.y * img_height / 100 - h/2, center.x * img_width / 100 + w/2, center.y * img_height / 100 + h/2];
boundary = round(boundary);

rst2 = api.landmark(largest_face.face_id, '83p');
landmark_points = rst2{1}.result{1}.landmark;
landmark_names = fieldnames(landmark_points);

for j = 1 : length(landmark_names)
    pt = landmark_points.(landmark_names{j});
    landmark(j,:) = [pt.x * img_width / 100, pt.y * img_height / 100];
end
