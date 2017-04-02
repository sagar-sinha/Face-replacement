function morphed_im  = morph_tps( im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz )
%This function finds the morphed image using tps parameters
[nr, nc, ~]= size(im_source);
[X, Y] = meshgrid(1:nc, 1:nr);
Ux = zeros(nr, nc);
Uy = zeros(nr, nc);
for i = 1:size(ctr_pts,1)
    diff_x = X - ctr_pts(i,1);
    diff_y = Y - ctr_pts(i,2);
    norm = diff_x.^2 + diff_y.^2;
    U_func_value = -norm.*log(norm);
    U_func_value(isnan(U_func_value)) = 0;
    Ux = Ux + w_x(i).*U_func_value;
    
    Uy = Uy + w_y(i).*U_func_value;
end
Cal_x = a1_x + ax_x*X + ay_x*Y + Ux;
Cal_y = a1_y + ax_y*X + ay_y*Y + Uy;
Cal_x(Cal_x<1)=1;
Cal_x(Cal_x>nc)=nc;
Cal_y(Cal_y<1)=1;
Cal_y(Cal_y>nr)=nr;
Cal_x = round(Cal_x);
Cal_y = round(Cal_y);

fin_lin_ind = sub2ind([nr nc], Cal_y, Cal_x);
fin_lin_ind = fin_lin_ind(:);

indices = 1:(nr*nc);
sz = [sz, 3];
morphed_im = zeros(sz);
morphed_im(indices) = im_source(fin_lin_ind);
morphed_im(sz(1)*sz(2) + indices) = im_source(nr*nc + fin_lin_ind);
morphed_im(2*sz(1)*sz(2) + indices) = im_source(2*nr*nc + fin_lin_ind);
morphed_im = uint8(morphed_im);
end

