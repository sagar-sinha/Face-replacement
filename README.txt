How to run the face replacement program
-----------------------------------------------
1. To replace a face in a video, run the following command:
    replaceFaceWithFacePP(video_file, output_name, pose_detection_off)
	Here video_file is the path of the video file in which face has to be replaced,
	output_name(string) is the output file name excluding the extension as the file will always have .avi extension
	pose_detection_off(boolean) - This sets pose detection to off, so to set the pose detection off pass it as true otherwise false.
	
	
2. To run motion compensation on a generated video, run the following command:
     stablize(video_file) - Here video_file is the video file path to be smoothed
	 This will generate a video file with 'smoothed' prefixed to the video file name.
	 
	
External Libraries Used(Credits)
-------------------------------------
1. For Poisson Editing we used an external library "gradient-blend-master" as it was faster than our code for gradient blending in Project 4A
2. We used Face++ Library for detecting the face and facial features. Its code is in "FaceFppLibrary"
3. For motion compensation we followed the tutorial from MATLAB on Video Stabilization  here "https://www.mathworks.com/help/vision/examples/video-stabilization-using-point-feature-matching.html"