% %img = double(rgb2gray(imread('butterfly.jpg')));
% img = [ 1 2 4 5 ;
%         5 3 5 1 ;
%         0 3 5 2 ;
%         2 1 7 7 ];
% %g = mymaxfilt(img, ones(3,3));
% w = ones(3,3);
% mx = ordfilt2(img,9,ones(3,3));

function h = mymax(img, w)
    s_w=size(w);
    w_row = s_w(1);
    w_col = s_w(2);
    w_c_x = floor(w_row/2);
    w_c_y = floor(w_col/2);
    
    g = padarray(img,[w_c_x,w_c_y],'symmetric','both');
    s_g = size(g);
    g_row = s_g(1);
    g_col = s_g(2);
    
    h = zeros(g_row,g_col);

    for i = 1+w_c_x:g_row-w_c_x
        for j = 1+w_c_y:g_col-w_c_y
            temp = (g((i-w_c_x):(i+w_c_x),(j-w_c_y):(j+w_c_y)).*w);
            h(i,j) = max(temp(:));
%             disp(temp(:));
%             disp(h(i,j));
        end
    end
    h = h(w_c_x+1:end-w_c_x, w_c_y+1:end-w_c_y);
end