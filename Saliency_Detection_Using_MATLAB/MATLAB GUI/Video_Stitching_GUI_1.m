function varargout = Video_Stitching_GUI_1(varargin)
%VIDEO_STITCHING_GUI_1 M-file for Video_Stitching_GUI_1.fig
%      VIDEO_STITCHING_GUI_1, by itself, creates a new VIDEO_STITCHING_GUI_1 or raises the existing
%      singleton*.
%
%      H = VIDEO_STITCHING_GUI_1 returns the handle to a new VIDEO_STITCHING_GUI_1 or the handle to
%      the existing singleton*.
%
%      VIDEO_STITCHING_GUI_1('Property','Value',...) creates a new VIDEO_STITCHING_GUI_1 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Video_Stitching_GUI_1_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VIDEO_STITCHING_GUI_1('CALLBACK') and VIDEO_STITCHING_GUI_1('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VIDEO_STITCHING_GUI_1.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Video_Stitching_GUI_1

% Last Modified by GUIDE v2.5 08-May-2017 12:19:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Video_Stitching_GUI_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Video_Stitching_GUI_1_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Video_Stitching_GUI_1 is made visible.
function Video_Stitching_GUI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Video_Stitching_GUI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Video_Stitching_GUI_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Video_Stitching_GUI_1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

F = handles.F1;
obj = VideoReader(F);
guidata(gcbo,handles)
thisFrame = read(obj, 1);
[m,n,k]=size(thisFrame);
I = thisFrame;
x=F;
implay(x);
axes(handles.axes1)
imshow(I);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

F = handles.F1;
obj = VideoReader(F);
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
axes(handles.axes2)
imshow(uint8(Salient_Frame(:,:,1)));

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = handles.F1;
obj = VideoReader(F);
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
implay(uint8(Binary_Frame))
axes(handles.axes3)
imshow(uint8(Binary_Frame(:,:,1)))

% If you want to implement the above code please put the path of the file
% where you wish to select the videos from down below to the variable F.


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = uigetfile('*.jpg;*','C:\Users\shrin\Desktop\IVP Project')
handles.F1=F
guidata(gcbo,handles)
