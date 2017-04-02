
function  stabilize(video_file)

filename = video_file;
hVideoSrc = vision.VideoFileReader(filename);
reset(hVideoSrc);

% hVPlayer = vision.VideoPlayer; % Create video viewer

out_filename = strcat('smoothed_', video_file);
writeObj = VideoWriter(out_filename);
writeObj.FrameRate = 24;
open(writeObj);

% Process all frames in the video
movMean = step(hVideoSrc);
imgB = movMean;
imgBp = imgB;
correctedMean = imgBp;
ii = 2;
Hcumulative = eye(3);
while ~isDone(hVideoSrc)
    % Read in new frame
    imgA = imgB; % z^-1
    imgAp = imgBp; % z^-1
    imgB = step(hVideoSrc);
    movMean = movMean + imgB;

    % Estimate transform from frame A to frame B, and fit as an s-R-t
    H = cvexEstStabilizationTform(imgA(:,:,1),imgB(:,:,1));
    HsRt = cvexTformToSRT(H);
    Hcumulative = HsRt * Hcumulative;
    imgBp(:,:,1) = imwarp(imgB(:,:,1),affine2d(Hcumulative),'OutputView',imref2d(size(imgB(:,:,1))));
    imgBp(:,:,2) = imwarp(imgB(:,:,2),affine2d(Hcumulative),'OutputView',imref2d(size(imgB(:,:,1))));
    imgBp(:,:,3) = imwarp(imgB(:,:,3),affine2d(Hcumulative),'OutputView',imref2d(size(imgB(:,:,1))));

    % Display as color composite with last corrected frame
%     step(hVPlayer, imfuse(imgAp,imgBp,'ColorChannels','red-cyan'));
    composite_image = imfuse(imgAp,imgBp, 'blend');
    composite_image = im2double(composite_image);
    writeVideo(writeObj,  composite_image);
    correctedMean = correctedMean + imgBp;

    ii = ii+1;
end
correctedMean = correctedMean/(ii-2);
movMean = movMean/(ii-2);

% Here you call the release method on the objects to close any open files
% and release memory.
release(hVideoSrc);
close(writeObj);
end
