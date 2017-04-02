function img = morph_tps_wrapper(im1,im2,im1_pts,im2_pts,warp_frac,dissolve_frac)
%MORPH_TPS_WRAPPER Summary of this function goes here
[nr1, nc1, ~] = size(im1);
[nr2, nc2, ~] = size(im2);

nr = max(nr1, nr2); 
nc = max(nc1, nc2);
im1 = padarray(im1, [nr-nr1, nc-nc1], 'replicate', 'post');
%im2 = padarray(im2, [nr-nr2, nc-nc2], 'replicate', 'post');



int_pts = im1_pts*(1-warp_frac) + im2_pts*warp_frac;

[ a1_x, ax_x, ay_x, w_x ] =  est_tps( int_pts, im1_pts(:,1) );
[ a1_y, ax_y, ay_y, w_y ] =  est_tps( int_pts, im1_pts(:,2));
sz = size(im1);
morphed_im1 = morph_tps( im1, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, int_pts, sz(:,1:2));

% [ a1_x, ax_x, ay_x, w_x ] =  est_tps( int_pts, im2_pts(:,1));
% [ a1_y, ax_y, ay_y, w_y ] =  est_tps( int_pts, im2_pts(:,2));
% sz = size(im2);
%morphed_im2 = morph_tps( im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, int_pts, sz(:, 1:2));

img = morphed_im1*(1-dissolve_frac);
%+ morphed_im2*dissolve_frac;

end

