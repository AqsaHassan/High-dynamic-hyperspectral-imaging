% This script loads digital numbers and radiances from the given path. It
% is assumed that every digital number has a corresponding radiance file.
% For setting the number of rows and columns and bands, you can load one of
% the hypercube replicating the code present in this script and see the
% size of the cube. Note that the script loads the cubes in order of their
% file names. So be sure that this order is same as you want the 4D cubes
% to be filled.

% % images details
% number of exposures
n_exps = 2;

% number of rows of image of hyperspectral data
n_rows = 3976;

% number of columns of image of hyperspectral data
n_cols = 1800;

% number of bands of image of hyperspectral data
n_bands = 186;

% path where digital number files are present. These files are the output
% of hyspexRAD software where .hyspex file is converted to 16-bits unsigned
% integers (radiometric calibration option unchecked). Remember to remove
% the .hyspex extension from the output files in order for this chunk of
% code to read it.
path_dn = 'C:\Users\colorlab\OneDrive\Desktop\Aqsa_data2023\digital_numbers\';

% path where radiances files are present. These files are the output
% of hyspexRAD software where .hyspex file is converted to 32-bits floats
% (radiometric calibration option checked).
path_rad = 'C:\Users\colorlab\OneDrive\Desktop\Aqsa_data2023\radiance\';


% The name of .mat file in which the digital number and radiance 4D cubes
% will be stored
mat_file_name = 'data_Aqsa2023';

% path where the .mat file will be saved
path_mat = 'D:\aqsa_ali_internship\cosi-internship\mat_files\';

% 4D matrix to hold digital numbers. Dimensions of this matrix is as
% follows: (exposure number, image row, image column, band number).
digital_numbers = zeros(n_exps, n_rows, n_cols, n_bands, 'uint16');

% same as above but for radiances.
radiances = zeros(n_exps, n_rows, n_cols, n_bands, 'single');

% getting all digital number file names in the mentioned folder.
file_names_dn = dir(fullfile(path_dn, '*.hdr'));

% getting all radiances file names in the mentioned folder.
file_names_rad = dir(fullfile(path_rad, '*.hdr'));

% looping over each file name and loading the digital numbers cube to our
% 4D matrix.
for file_idx = 1 : size(file_names_dn, 1)
    % % for digital numbers
    % loading the hypercube structure of the file
    hcube = hypercube([path_dn file_names_dn(file_idx).name]);

    % extracting hyperspectral cube matrix and storing it in our 4D cube.
    digital_numbers(file_idx, :, :, :) = hcube.DataCube(:,:,:);

    % % for radiances
    % loading the hypercube structure of the file
    hcube = hypercube([path_rad file_names_rad(file_idx).name]);

    % extracting hyperspectral cube matrix and storing it in our 4D cube.
    radiances(file_idx, :, :, :) = hcube.DataCube(:,:,:);
end

% saving digital numbers and radiances to .mat file. The '-v7.3' is passed
% because otherwise was giving an error that files of size greater than 2GB
% can not be saved. Mentioning '-v7.3' was suggested by MATLAB itself.
save(strcat(path_mat, mat_file_name), 'digital_numbers', 'radiances', '-v7.3');