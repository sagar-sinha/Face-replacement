function result_image = wrapper_replace(target_img, source_img, tar_points, sour_points, tar_rectangle, sour_rectangle)  
    %addpath('gradient-domain-fusion-master');
    addpath('gradient-blend-master');
    addpath('warping')
    %get the replacement image morphed into the shape of the target image 
    %but in color of the replacement image. This is achieved with
    %warp_frac=1 and dissolve_frac = 0. I know we know this but just wanted to
    %spell this out.
    morphed_img = morph_tps_wrapper(source_img,target_img,sour_points,tar_points,1,0);
    morphed_img = morphed_img(1:size(target_img,1),1:size(target_img,2),:);
    morphed_img = uint8(morphed_img);
    morphed_img = im2double(morphed_img);
    
    %blend the morphed image into the target image
    %Side note: mask is binary here
    mask = get_mask(size(target_img), tar_points);
    result_image = gradient_blend(morphed_img, mask, target_img);
    
    %smoothen the blended image by using the gaussian of the binary mask 
    %Side note: mask is fractional here
    mask = imgaussfilt(double(mask),4);
    rplcmnt_smooth(:,:,1) = result_image(:,:,1).*mask;
    rplcmnt_smooth(:,:,2) = result_image(:,:,2).*mask;
    rplcmnt_smooth(:,:,3) = result_image(:,:,3).*mask;
    
    mask_inv = 1-mask;    
    target_smooth(:,:,1) = target_img(:,:,1).*mask_inv;
    target_smooth(:,:,2) = target_img(:,:,2).*mask_inv;
    target_smooth(:,:,3) = target_img(:,:,3).*mask_inv;
    
    result_image = rplcmnt_smooth + target_smooth;
    result_image(result_image<0) = 0;
end