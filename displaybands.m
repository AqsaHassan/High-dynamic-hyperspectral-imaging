mx = max(radiances_mean(:));
mx=0.8;
for i = 1:100
    
    imshow(imadjust(radiances_mean(:, :,i),[],[],0.2), [0, mx]);
    pause(0.1)
i
end
