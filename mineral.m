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

% Last Modified by GUIDE v2.5 20-Jun-2021 09:37:48

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

% CLEAR COMMAND LINE
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

%% TAMPILKAN DATASET
    %% MENGGUNAKAN READTABLE
        set(handles.uitable1,'data',read_dataset('Minerals_Database.csv','B:J'));

    %% MENGGUNAKAN READ MATRIX
%         range = detectImportOptions('Minerals_Database.csv');
%         range.SelectedVariableNames = (2:10);
%         data = readtable('Minerals_Database.csv',range);
%         data1 = table2array(data);
%         set(handles.uitable1,'data',data1);

% --- Executes on button press in bShowTable.
function bShowTable_Callback(hObject, eventdata, handles)
% hObject    handle to bShowTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% menampilkan tabel
handles.uitable1.Visible = 'on';

% menampilkan data tabel
set(handles.uitable1,'data',read_dataset('Minerals_Database.csv','B:J'));


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

%%  INPUT USER SIMPAN DI VARIABEL
    rd = handles.rd;
    mh = str2double(get (handles.editMH, 'string'));
    dy = handles.dy;
    sg = str2double(get (handles.editSG, 'string'));
    o = handles.o;
    ri = str2double(get (handles.editRI, 'string'));
    dp = str2double(get (handles.editDP, 'string'));
    h = str2double(get (handles.editH, 'string'));

    sample = [rd mh dy sg o ri dp h];

%% READ MATRIX (fixed)
    k = 1;
    % ambil data yang diperlukan yaitu kolom 3-10
    range = detectImportOptions('Minerals_Database.csv');
    range.SelectedVariableNames = (3:10);
    training = readtable('Minerals_Database.csv',range);

    % ambil data untuk jenis mineral yaitu kolom kedua
    range = detectImportOptions('Minerals_Database.csv');
    range.SelectedVariableNames = (2);
    group = readtable('Minerals_Database.csv',range);
    class = fitcknn(training, group, 'NumNeighbors', k,... 
                'Distance','cityblock'); 
    classify = predict(class, sample);
    
%% READTABLE (not fix)
%     k = 1;
%     % ambil data yang diperlukan yaitu kolom 3-6
%     training = read_dataset('Minerals_Database.csv','C:J');
%     training = cell2mat(training);
%     % ambil data untuk jenis mineral yaitu kolom kedua
%     group = read_dataset('Minerals_Database.csv','B2:B3112');
%     group = cell2mat(group);
%     class = fitcknn(training, group, 'NumNeighbors', k);
%     classify = predict(class, sample);

%% TAMPILKAN HASIL
    set(handles.textResult,'string', classify);
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% RESET KOLOM INPUT
    set(handles.editMH,'string','');
    set(handles.editSG,'string','');
    set(handles.editRI,'string','');
    set(handles.editDP,'string','');
    set(handles.editH,'string','');


function editMH_Callback(hObject, eventdata, handles)
% hObject    handle to editMH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMH as text
%        str2double(get(hObject,'String')) returns contents of editMH as a double


% --- Executes during object creation, after setting all properties.
function editMH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDY_Callback(hObject, eventdata, handles)
% hObject    handle to editDY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDY as text
%        str2double(get(hObject,'String')) returns contents of editDY as a double


% --- Executes during object creation, after setting all properties.
function editDY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editSG_Callback(hObject, eventdata, handles)
% hObject    handle to editSG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSG as text
%        str2double(get(hObject,'String')) returns contents of editSG as a double


% --- Executes during object creation, after setting all properties.
function editSG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editO_Callback(hObject, eventdata, handles)
% hObject    handle to editO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editO as text
%        str2double(get(hObject,'String')) returns contents of editO as a double


% --- Executes during object creation, after setting all properties.
function editO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editRI_Callback(hObject, eventdata, handles)
% hObject    handle to editRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRI as text
%        str2double(get(hObject,'String')) returns contents of editRI as a double


% --- Executes during object creation, after setting all properties.
function editRI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRI (see GCBO)
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
set(handles.radiobutton2,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 1;
handles.rd = rd;
guidata(hObject,handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 2;
handles.rd = rd;
guidata(hObject,handles);


function editDP_Callback(hObject, eventdata, handles)
% hObject    handle to editDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDP as text
%        str2double(get(hObject,'String')) returns contents of editDP as a double


% --- Executes during object creation, after setting all properties.
function editDP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editH_Callback(hObject, eventdata, handles)
% hObject    handle to editH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editH as text
%        str2double(get(hObject,'String')) returns contents of editH as a double


% --- Executes during object creation, after setting all properties.
function editH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton2,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 3;
handles.rd = rd;
guidata(hObject,handles);

% --- Executes on button press in radiobutton3.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton2,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 4;
handles.rd = rd;
guidata(hObject,handles);

% --- Executes on button press in radiobutton6.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton2,'Value',0);

rd = 5;
handles.rd = rd;
guidata(hObject,handles);

% --- Executes on button press in radiobutton5.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
set(handles.radiobutton1,'Value',0);set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 6;
handles.rd = rd;
guidata(hObject,handles);

% --- Executes on button press in radiobutton6.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton2,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 7;
handles.rd = rd;
guidata(hObject,handles);

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
set(handles.radiobutton1,'Value',0);set(handles.radiobutton6,'Value',0);
set(handles.radiobutton3,'Value',0);set(handles.radiobutton7,'Value',0);
set(handles.radiobutton4,'Value',0);set(handles.radiobutton2,'Value',0);
set(handles.radiobutton5,'Value',0);

rd = 8;
handles.rd = rd;
guidata(hObject,handles);


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
set(handles.radiobutton10,'Value',0);set(handles.radiobutton11,'Value',0);

dy = 1;
handles.dy = dy;
guidata(hObject,handles);


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
set(handles.radiobutton9,'Value',0);set(handles.radiobutton11,'Value',0);

dy = 2;
handles.dy = dy;
guidata(hObject,handles);


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11
set(handles.radiobutton10,'Value',0);set(handles.radiobutton9,'Value',0);

dy = 3;
handles.dy = dy;
guidata(hObject,handles);


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
set(handles.radiobutton14,'Value',0);set(handles.radiobutton15,'Value',0);
set(handles.radiobutton16,'Value',0);
o = 1;
handles.o = o;
guidata(hObject,handles);


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
set(handles.radiobutton13,'Value',0);set(handles.radiobutton15,'Value',0);
set(handles.radiobutton16,'Value',0);

o = 2;
handles.o = o;
guidata(hObject,handles);


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
set(handles.radiobutton13,'Value',0);set(handles.radiobutton14,'Value',0);
set(handles.radiobutton16,'Value',0);

o = 3;
handles.o = o;
guidata(hObject,handles);


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16
set(handles.radiobutton13,'Value',0);set(handles.radiobutton14,'Value',0);
set(handles.radiobutton15,'Value',0);

o = 4;
handles.o = o;
guidata(hObject,handles);
