function histograms = get_colour_histograms(image_paths, quantisation_level, colour_space)
    images_count = size(image_paths, 1);
    histograms = zeros(images_count, quantisation_level^3);

    % For each image, in parallel.
    parfor i = 1 : images_count
        img = imread(char(image_paths(i)));

        % If the color space isn't rgb, convert the image.
        switch lower(colour_space)
            case 'hsv'
                img = rgb2hsv(img);
            case 'opponent'
                img_r = img(:,:,1);
                img_g = img(:,:,2);
                img_b = img(:,:,3);

                rg = img_r - img_g;
                by = 2* img_b - img_r - img_g;
                wb = img_r + img_g + img_b;

                img(:,:,1) = rg;
                img(:,:,2) = by;
                img(:,:,3) = wb;
        end

        % Quantize
        img = double(img);
        img = img/255;
        img = round(img*(quantisation_level-1)) + 1;

        % Intiialize the empty histogram.
        histogram = zeros(quantisation_level, quantisation_level, quantisation_level);

        % Increment each histogram index by 1 for each colour in image
        for j = 1 : size(img, 1)
            for k = 1 : size(img, 2)
                histogram(img(j,k,1), img(j,k,2), img(j,k,3)) = histogram(img(j,k,1), img(j,k,2), img(j,k,3)) + 1;
            end
        end

        % Flatten the histogram
        histogram = histogram(:);

        histograms(i, :) = histogram;
    end
end