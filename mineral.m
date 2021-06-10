function varargout = mineral(varargin)
% MINERAL MATLAB code for mineral.fig
%      MINERAL, by itself, creates a new MINERAL or raises the existing
%      singleton*.
%
%      H = MINERAL returns the handle to a new MINERAL or the handle to
%      the existing singleton*.
%
%      MINERAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINERAL.M with the given input arguments.
%
%      MINERAL('Property','Value',...) creates a new MINERAL or raises the
%      existing singleton*.      Starting from the left, property value pairs are
%      applied to the GUI before mineral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mineral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mineral

% Last Modified by GUIDE v2.5 01-Jun-2021 04:58:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mineral_OpeningFcn, ...
                   'gui_OutputFcn',  @mineral_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before mineral is made visible.
function mineral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mineral (see VARARGIN)

clc

% Choose default command line output for mineral
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mineral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mineral_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% tampilkan dataset
set(handles.uitable1,'data',read_dataset('Minerals_Database.csv','C:J'));

% 4	5.7500	1	3.8800	3	2.5250	0.2130	0 -> Anatase
sample = [4	5.7500 1 3.8800	3 2.5250 0.2130	0];
k = 3;

% ambil data yang diperlukan yaitu kolom 3-6
range = detectImportOptions('Minerals_Database.csv');
range.SelectedVariableNames = (3:10);
training = readmatrix('Minerals_Database.csv',range);

% ambil data untuk spesies mineral yaitu kolom pertama
range = detectImportOptions('Minerals_Database.csv');
range.SelectedVariableNames = (2);
group = readmatrix('Minerals_Database.csv',range);

% ----------------------METODE KNN---------------------
% metode euclidean
    disp("EUCLIDEAN METHOD (default method)");
    tic 
    class = fitcknn(training, group, 'NumNeighbors', k); 
    toc
    classify = predict(class, sample);
    disp(classify)

% metode minskowski
    disp("MINSKOWSKI METHOD");
    tic 
    class = fitcknn(training, group, 'NumNeighbors', k,... 
            'NSMethod','exhaustive','Distance','minkowski',...
            'Standardize',1); 
    toc
    classify = predict(class, sample);
    disp(classify)

% metode chebychev
    disp("CHEBYCHEV METHOD");
    tic 
    class = fitcknn(training, group, 'NumNeighbors', k,... 
            'Distance','chebychev'); 
    toc
    classify = predict(class, sample);
    disp(classify)

% metode correlation
    disp("CORRELATION METHOD");
    tic 
    class = fitcknn(training, group, 'NumNeighbors', k,... 
            'Distance','correlation'); 
    toc
    classify = predict(class, sample);
    disp(classify)
    
% metode cosine
    disp("COSINE METHOD");
    tic 
    class = fitcknn(training, group, 'NumNeighbors', k,... 
            'Distance','cosine'); 
    toc
    classify = predict(class, sample);
    disp(classify)
    
classify = predict(class, sample);

% Tampilkan Hasil
set(handles.textResult, 'string', classify);




% --- Executes on button press in bShowTable.
function bShowTable_Callback(hObject, eventdata, handles)
% hObject    handle to bShowTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% menampilkan tabel
handles.uitable1.Visible = 'on';

% menampilkan data tabel
set(handles.uitable1,'data',read_dataset('Minerals_Database.csv','C:J'));


% --- Executes on button press in bHideTable.
function bHideTable_Callback(hObject, eventdata, handles)
% hObject    handle to bHideTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% sembunyikan tabel
handles.uitable1.Visible = 'off';


% --- Executes on button press in bClassify.
function bClassify_Callback(hObject, eventdata, handles)
% hObject    handle to bClassify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  input user simpan di variabel
cl = str2double(get (handles.editCL, 'string'));
cd = str2double(get (handles.editCD, 'string'));
fl = str2double(get (handles.editFL, 'string'));
bm = str2double(get (handles.editBM, 'string'));
k = str2double(get (handles.editK, 'string'));

sample = [cl cd fl bm];

% ambil data yang diperlukan yaitu kolom 3-6
range = detectImportOptions('Minerals_Database.csv');
range.SelectedVariableNames = (3:10);
training = readmatrix('Minerals_Database.csv',range);

% ambil data untuk spesies mineral yaitu kolom pertama
range = detectImportOptions('Minerals_Database.csv');
range.SelectedVariableNames = (1);
group = readmatrix('Minerals_Database.csv',range);

class = fitcknn(training, group, 'NumNeighbors', k);
classify = predict(class, sample);

set(handles.textResult, 'string', classify);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset kolom input
set(handles.editCL,'string','');
set(handles.editCD,'string','');
set(handles.editFL,'string','');
set(handles.editBM,'string','');
set(handles.editK,'string','');


function editCL_Callback(hObject, eventdata, handles)
% hObject    handle to editCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCL as text
%        str2double(get(hObject,'String')) returns contents of editCL as a double


% --- Executes during object creation, after setting all properties.
function editCL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editCD_Callback(hObject, eventdata, handles)
% hObject    handle to editCD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCD as text
%        str2double(get(hObject,'String')) returns contents of editCD as a double


% --- Executes during object creation, after setting all properties.
function editCD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editFL_Callback(hObject, eventdata, handles)
% hObject    handle to editFL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFL as text
%        str2double(get(hObject,'String')) returns contents of editFL as a double


% --- Executes during object creation, after setting all properties.
function editFL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editBM_Callback(hObject, eventdata, handles)
% hObject    handle to editBM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBM as text
%        str2double(get(hObject,'String')) returns contents of editBM as a double


% --- Executes during object creation, after setting all properties.
function editBM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editK_Callback(hObject, eventdata, handles)
% hObject    handle to editK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editK as text
%        str2double(get(hObject,'String')) returns contents of editK as a double


% --- Executes during object creation, after setting all properties.
function editK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bClearTable.
function bClearTable_Callback(hObject, eventdata, handles)
% hObject    handle to bClearTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = [];
set(handles.uitable1,'data',data);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
