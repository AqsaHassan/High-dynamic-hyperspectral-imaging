function imgOut = ChangeLuminance_hyperspectral(img, Lold, Lnew) 
    imgOut = zeros(size(img));
    col = size(img, 3);
    for i=1:col
        imgOut(:,:,i) = (img(:,:,i) .* Lnew) ./ Lold;
    end 
    imgOut = RemoveSpecials(imgOut);

end