function h = myconv(img,w)
    [w_row, w_col] = size(w);
    w_c_x = floor(w_row/2);
    w_c_y = floor(w_col/2);

    g = padarray(img,[w_c_x,w_c_y],'replicate','both');
    [g_row, g_col] = size(g);
    
    h = zeros(g_row,g_col);

    for i = 1+w_c_x:g_row-w_c_x
        for j = 1+w_c_y:g_col-w_c_y
            temp = (g((i-w_c_x):(i+w_c_x),(j-w_c_y):(j+w_c_y)).*w);
            h(i,j) = sum(temp(:));
        end
    end
    h = h(w_c_x+1:end-w_c_x, w_c_y+1:end-w_c_y);
end