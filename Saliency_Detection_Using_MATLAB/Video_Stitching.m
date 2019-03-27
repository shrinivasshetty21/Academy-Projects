clear all;
close all;
clc;
% Importing the Video and Reading it.
obj = VideoReader('Rhinos.avi');
get(obj);
Frames = obj.NumberOfFrames;
pickind='jpg';
for frame = 1 : Frames
  	% Extract the frame from the movie structure.
  	thisFrame = read(obj, frame);
    [m,n,k]=size(thisFrame);
    I = thisFrame;
    Lab=RGB2Lab(I);
    % Taking avg of image at each plane of LAB colour space
    L1=Lab(:,:,1);
    a1=Lab(:,:,2);
    b1=Lab(:,:,3);
    % Taking Average of L,a,b planes for present frame.
    avgl=mean(mean(L1));
    avga=mean(mean(a1));
    avgb=mean(mean(b1));
    % Gaussian Kernal
    k=[1/16 1/4 6/16 1/4 1/16];
    % Blurring of L1 plane
    % Blurring in X direction
    l1=imfilter(L1,k);
    % Blurring in Y direction
    l2=imfilter(l1,k');
    % Blurring of a1 plane
    % Blurring in X direction
    A1=imfilter(a1,k);
    % Blurring in Y direction
    A2=imfilter(A1,k');
    % Blurring of b1 plane
    % Blurring in X direction
    B1=imfilter(b1,k);
    % Blurring in Y direction
    B2=imfilter(B1,k');
    % Computing Saliency Map for the Frame
    sm = (l2-avgl).^2 + (A2-avga).^2 + (B2-avgb).^2;
    % Finding Range of Pixel Value
    min_sm = min(min(sm));
    max_sm = max(max(sm));
    % Scaling between 0-255
    Range = max_sm - min_sm;
    SalMap = ((255.*(sm-min_sm))/Range);
    Binary_Mask = SalMap;
    % Making Binary Film
    Thresholding = sum(sum(Binary_Mask))*2/(m*n);
    Binary_Mask(find(Binary_Mask > Thresholding))= 255;
    Binary_Mask(find(Binary_Mask <= Thresholding))= 0;
    Binary_Mask_O=im2double(Binary_Mask);
    Salient_Frame(:,:,frame) = SalMap;
    Binary_Frame(:,:,frame) = Binary_Mask_O;
end
implay(uint8(Salient_Frame))

% Now I have modified the approach by using median values in a frame to enhance output.
for frame = 1 : Frames
  	% Extract the frame from the movie structure.
  	thisFrame = read(obj, frame);
    [m,n,k]=size(thisFrame);
    I = thisFrame;
    [m,n,k]=size(I);
    % Convert RGB to LAB
    Lab=RGB2Lab(I);
    L1=Lab(:,:,1);
    a1=Lab(:,:,2);
    b1=Lab(:,:,3);
    % Applying Blur to present frame in L, a, b planes. 
    Lab2 = myblur(Lab);
    L2=Lab2(:,:,1);
    A2=Lab2(:,:,2);
    B2=Lab2(:,:,3);
    %Computing Median values for each plane of the frame
    L11 = reshape(L1,1,m*n);
    MedianL2 = median(L11);
    A11 = reshape(a1,1,m*n);
    MedianA2 = median(A11);
    B11 = reshape(b1,1,m*n);
    MedianB2 = median(B11);
    % Finding index for values greater than Median
    idx1 = (L2>MedianL2);
    idx2 = (A2>MedianA2);
    idx3 = (B2>MedianB2);
    L3 = L2; A3 = A2; B3 = B2;
    L3(idx1) = L3(idx1) - MedianL2;
    A3(idx2) = A3(idx2) - MedianA2;
    B3(idx3) = B3(idx3) - MedianB2;
    sm = (L3).^2 + (A3).^2 + (B3).^2;
    % Making Binary Film
    min_sm = min(min(sm));
    max_sm = max(max(sm));
    range = max_sm - min_sm;
    SalMap = ((255.*(sm-min_sm))/range);
    Binary_Mask_M = SalMap;
    Thresholding_M = sum(sum(Binary_Mask_M))*2/(m*n);
    Binary_Mask_M(find(Binary_Mask_M > Thresholding_M))= 255;
    Binary_Mask_M(find(Binary_Mask_M <= Thresholding_M))= 0;
    BinaryM_Mask_M_O=im2double(Binary_Mask_M);
    Binary_Frame_M(:,:,frame) = BinaryM_Mask_M_O;
    Salient_Frame_M(:,:,frame) = SalMap;
end
implay(uint8(Salient_Frame_M))
