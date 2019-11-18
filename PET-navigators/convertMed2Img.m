%------------------------------------------------------------------------%
% This function converts images in medical imaging formats (Nifti or
% Analyze) to commercially usable formats (JPG, PNG)
%
% Author : Lalith Kumar Shiyam Sundar
% Date   : 18 November, 2019
%
% Inputs: 
%       [1]CMIinputs.path2MedImg: file path to the medical image.
%       [2]CMIinputs.uID: string to be attached to the written images.
%       [3]CMIinputs.where2Store: file path to store the generated images.
%       [4]CMIinputs.fileFormat: 'jpg' or 'png'.
%
% Outputs: Folder containing the converted images. 
%
% Usage: convertMed2Img(CMIinputs);
%       
%------------------------------------------------------------------------%
%                           Program start
%------------------------------------------------------------------------%

function [] = convertMed2Img(CMIinputs)
path2MedImg=CMIinputs.path2MedImg;
uID=CMIinputs.uID;
where2Store=CMIinputs.where2Store;
fileFormat=CMIinputs.fileFormat;

% Create the folder to store the converted images.
splitFiles=regexp(path2MedImg,filesep,'split')
convertedFolder=[splitFiles{end},'-',fileFormat];
where2Store=[where2Store,filesep,convertedFolder];


% Find out the format of the medical images: Dicom, nifti or analyze.
medFormat=checkFileFormat(path2MedImg);
cd(path2MedImg)
switch medFormat
    case 'Analyze'
        medFiles=dir('*hdr')
        for lp=1:length(medFiles)
            medImg{lp}=analyze75read(medFiles(lp).name);
        end
    case 'Nifti'
        medFiles=dir('*nii')
        for lp=1:length(medFiles)
            medImg{lp}=niftiread(medFiles(lp).name);
        end
end

medImg=im2double(medImg);

for lp=1:size(medImg,3)
    pngImg=mat2gray(medImg(:,:,lp)); 
    pngFileName=[uID,'-',num2str(lp),'.',fileFormat];
    imwrite(pngImg,pngFileName)
    disp(['Writing slice number ',num2str(lp),'...']);
    movefile(pngFileName,where2Store)
    disp(['Moving ',pngFileName,' to ',where2Store])
end