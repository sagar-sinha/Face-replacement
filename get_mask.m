function binary_mask = get_mask(im_size, key_points)
K = convhull(key_points(:,1),key_points(:,2));
binary_mask = poly2mask(key_points(K,1), key_points(K,2), im_size(1), im_size(2));
end

