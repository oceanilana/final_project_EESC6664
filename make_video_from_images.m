% load the images
images    = cell(12,1);
images{1} = imread('correlation_jan.png');
images{2} = imread('correlation_feb.png');
images{3} = imread('correlation_march.png');
images{4} = imread('correlation_april.png');
images{5} = imread('correlation_may.png');
images{6} = imread('correlation_june.png');
images{7} = imread('correlation_july.png');
images{8} = imread('correlation_aug.png');
images{9} = imread('correlation_sep.png');
images{10} = imread('correlation_oct.png');
images{11} = imread('correlation_nov.png');
images{12} = imread('correlation_dec.png');

% 0.75 seconds per frame = 24fps with 18 frames each
writerObj = VideoWriter('correlation_slowed.mp4', 'MPEG-4');
writerObj.FrameRate = 24;
open(writerObj);

for u = 1:length(images)
    frame = im2frame(images{u});
    for v = 1:24  % 18 frames at 24fps = 0.75 seconds
        writeVideo(writerObj, frame);
    end
end

close(writerObj);