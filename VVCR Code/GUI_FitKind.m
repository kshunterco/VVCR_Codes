function varargout = GUI_FitKind (varargin)
% GUI_FitKind MATLAB code for GUI_FitKind.fig
%      GUI_FitKind, by itself, creates a new GUI_FitKind or raises the
%      existing singleton*.
%
%      H = GUI_FitKind returns the handle to a new GUI_FitKind or the
%      handle to the existing singleton*.
%
%      GUI_FitKind('CALLBACK',hObject,eventData,handles,...) calls the
%      local function named CALLBACK in GUI_FitKind.M with the given input
%      input arguments.
%
%      GUI_FitKind('Property','Value',...) creates a new GUI_FitKind
%      or raises the existing singleton*.  Starting from the left,
%      property value pairs are applied to the GUI before GUI_FitKind-
%      _OpeningFcn gets called.  An unrecognized property name or invalid 
%      value makes property application stop.  All inputs are passed to 
%      GUI_FitKind_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only
%      one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FitKind

% Last Modified by GUIDE v2.5 22-Sep-2017 20:29:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FitKind_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FitKind_OutputFcn, ...
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
end

% --- Executes just before GUI_FitKind is made visible.
function GUI_FitKind_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FitKind (see VARARGIN)

% Choose default command line output for GUI_FitKind
handles.output = hObject;

% set the input variable in the global handles environment
% passed as PeakStruct from VVCR_* script
handles.InVar = cell2mat(varargin(1));
GUIDat = cell2mat(varargin(2));
handles.InVar.Data  = GUIDat.Data;
handles.InVar.ivIdx = GUIDat.ivIdx;
handles.InVar.ivVal = GUIDat.ivVal;
handles.InVar.ivSeg = GUIDat.ivSeg;

handles.InVar.MeanTP = handles.InVar.FitK.MeanTP;

handles.Cycle = 1;
handles.CycMx = length(GUIDat.ivIdx.Ps1);
set(handles.CycleMinus, 'Enable', 'off');

% Extract Data, Indices/Values, and Fit Segments from passed structures.
Data = handles.InVar.Data;
Plot = handles.InVar.Plot;
ivIdx = handles.InVar.ivIdx;
ivVal = handles.InVar.ivVal;
ivSeg = handles.InVar.ivSeg;
FitK = handles.InVar.FitK;

% store first fit output into output structure.
handles.OutVar.FitK = FitK;
handles.OutVar.Exit = 'good';

% Initialize UNDO structure.
handles.UNDO.Res = [];

% plot pressure, sinusoid fits
[handles] = gui_kind_plot (Data, ivIdx, ivSeg, FitK, Plot, handles);

% Update handles.
guidata(hObject, handles);

% UIWAIT makes GUI_FitKind wait for user response (see UIRESUME)
uiwait(handles.figure1);
end

% function that executes when user clicks on graph
function GraphCallBack(hObject, eventdata, handles)

% get the current point
cp(1,:) = [eventdata.IntersectionPoint(1), eventdata.IntersectionPoint(2)];
disp('GUI_FitKind>GraphCallBack:');
disp(['    Time:     ',num2str(cp(1))]);
disp(['    Pressure: ',num2str(cp(2))]);

end

% --- Outputs from this function are returned to the command line.
function varargout = GUI_FitKind_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.OutVar;

% Destroy the GUI
delete(hObject);

end

% --- Executes on button press in CyclePlus.
function CyclePlus_Callback(hObject, eventdata, handles)
% hObject    handle to CyclePlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Cycle = handles.Cycle + 1;
if handles.Cycle > 1
    set(handles.CycleMinus, 'Enable', 'on');
end
if handles.Cycle == handles.CycMx
    set(handles.CyclePlus, 'Enable', 'off');
end
set(handles.CycleInd, 'String', ['Cycle #' num2str(handles.Cycle,'%02i')]);

% Extract Data, Indices/Values, and Fit Segments from passed structures.
Data = handles.InVar.Data;
Plot = handles.InVar.Plot;
ivIdx = handles.InVar.ivIdx;
ivSeg = handles.InVar.ivSeg;
FitK = handles.InVar.FitK;

% plot pressure, sinusoid fits, update indicator
[handles] = gui_kind_plot (Data, ivIdx, ivSeg, FitK, Plot, handles);
set(handles.CycleInd, 'String', ['Cycle #' num2str(handles.Cycle,'%02i')]);

% Update handles.
guidata(hObject, handles);

end


% --- Executes on button press in CycleMinus.
function CycleMinus_Callback(hObject, eventdata, handles)
% hObject    handle to CycleMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Cycle = handles.Cycle - 1;
if handles.Cycle == 1
    set(handles.CycleMinus, 'Enable', 'off');
end
if handles.Cycle < handles.CycMx
    set(handles.CyclePlus, 'Enable', 'on');
end

% Extract Data, Indices/Values, and Fit Segments from passed structures.
Data = handles.InVar.Data;
Plot = handles.InVar.Plot;
ivIdx = handles.InVar.ivIdx;
ivSeg = handles.InVar.ivSeg;
FitK = handles.InVar.FitK;

% plot pressure, sinusoid fits, update indicator
[handles] = gui_kind_plot (Data, ivIdx, ivSeg, FitK, Plot, handles);
set(handles.CycleInd, 'String', ['Cycle #' num2str(handles.Cycle,'%02i')]);

% Update handles.
guidata(hObject, handles);

end

% --- Executes on button press in Remove.
function Remove_Callback(hObject, eventdata, handles)
% hObject    handle to Remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Make the cusor a spinning wheel so user is aware program is busy
set(handles.figure1, 'pointer', 'watch');
drawnow;

% obtain variables from InVar Struct for a clear workflow
ivIdx = handles.InVar.ivIdx;
ivVal = handles.InVar.ivVal;
ivSeg = handles.InVar.ivSeg;
Plot  = handles.InVar.Plot;

FitK = handles.OutVar.FitK;

% store the current structures in UNDO structure for the undo button.
handles.UNDO.Res  = handles.OutVar;
handles.UNDO.Plot  = Plot;
handles.UNDO.ivIdx = ivIdx;
handles.UNDO.ivVal = ivVal;
handles.UNDO.ivSeg = ivSeg;

WaveRm = handles.Cycle;
disp(['GUI_FitKind>Remove: wave ' num2str(WaveRm, '%02i') ...
    ' is being removed']);

% Erase wave from (2 - Kind) ivIdx, ivVal structures. 
ivIdx.Ps2(WaveRm)   = [];
ivIdx.Pe2(WaveRm)   = [];
ivIdx.Ns2(WaveRm)   = [];
ivIdx.Ne2(WaveRm)   = [];
ivIdx.Ps2_D(WaveRm) = [];
ivIdx.Pe2_D(WaveRm) = [];
ivIdx.Ns2_D(WaveRm) = [];
ivIdx.Ne2_D(WaveRm) = [];
ivVal.Ps2(WaveRm)   = [];
ivVal.Pe2(WaveRm)   = [];
ivVal.Ns2(WaveRm)   = [];
ivVal.Ne2(WaveRm)   = [];

ivIdx.dPmax2(WaveRm)   = [];
ivIdx.dPmin2(WaveRm)   = [];
ivIdx.dPmin2_D(WaveRm) = [];
ivVal.dPmax2(WaveRm)   = [];
ivVal.dPmin2(WaveRm)   = [];

ivSeg.iv2Time(WaveRm) = [];
ivSeg.iv2Pres(WaveRm) = [];

FitK.Rsq(WaveRm)      = [];
FitK.RCoef(WaveRm,:)  = [];
FitK.BadCyc(WaveRm)   = [];
FitK.CycICs(WaveRm,:) = [];

Plot.iv2TShift(WaveRm) = [];

% Store changes
handles.InVar.ivIdx = ivIdx;
handles.InVar.ivVal = ivVal;
handles.InVar.ivSeg = ivSeg;

handles.OutVar.FitK = FitK;

handles.CycMx = handles.CycMx - 1;
if handles.Cycle > handles.CycMx
    handles.Cycle = handles.CycMx;
    set(handles.CycleInd, 'String', ['Cycle #' num2str(handles.Cycle,'%02i')]);
end
        
% Plot the results
Data = handles.InVar.Data;
Plot = handles.InVar.Plot;
[handles] = gui_kind_plot (Data, ivIdx, ivSeg, FitK, Plot, handles);

% update global handles & set cursor back to normal
guidata(hObject,handles);
set(handles.figure1, 'pointer', 'arrow');

end


% --- Executes on button press in Done.
function Done_Callback(~, ~, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% call on uiresume so output function executes
uiresume(handles.figure1);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
 
    % If you close the figure, we understand that as stopping the analysis.
    handles.OutVar = false;
    guidata(hObject, handles);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

end

% --- Executes on button press in Exit.
function Exit_Callback(hObject, ~, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keep in mind when the exit button is pressed, the current
% patient, i, will not be evaluated
                
% set output to false
handles.OutVar.Exit = false;

% update handles globally
guidata(hObject, handles);

% call on uiresume so output function executes
uiresume(handles.figure1);
end

% --- Executes on button press in Discard.
function Discard_Callback(hObject, ~, handles)
% hObject    handle to Discard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set outputs to true, indicating Discard button
handles.OutVar.Exit = true;

% update handles globally
guidata(hObject, handles)

% call on uiresume so output function executes
uiresume(handles.figure1);
end

% --- Executes on button press in Undo.
function Undo_Callback(hObject, ~, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Make the cusor a spinning wheel so user is aware program is busy
set(handles.figure1, 'pointer', 'watch');
drawnow;

% if the handles.Old variables have been created (user has clicked on the
% plot and removed pressure waveform(s).
if ~isempty(handles.UNDO.Res)
    disp('GUI_FitKind>Undo_Callback: Restoring Previous Fit & Plot');
    handles.OutVar = handles.UNDO.Res;

    handles.InVar.Plot  = handles.UNDO.Plot;
    handles.InVar.ivIdx = handles.UNDO.ivIdx;
    handles.InVar.ivVal = handles.UNDO.ivVal;
    handles.InVar.ivSeg = handles.UNDO.ivSeg; 

    % Reset Res indicator (undo only goes one deep)
    handles.UNDO.Res = [];

    if handles.Cycle == handles.CycMx
        set(handles.CyclePlus, 'Enable', 'on');
    end
    handles.CycMx = handles.CycMx + 1;
        
    % Extract Data, Values, Fit Segments, Plots, & Segments from handles.
    FitK = handles.OutVar.FitK;
    Data = handles.InVar.Data;
    Plot = handles.InVar.Plot;
    ivIdx = handles.InVar.ivIdx;
    ivSeg = handles.InVar.ivSeg;

    [handles] = gui_kind_plot (Data, ivIdx, ivSeg, FitK, Plot, handles);

    % update global handles
    guidata(hObject,handles);

else

    disp('GUI_FitKind>Undo_Callback: Nothing to Undo!');

end

% Set cursor back to normal
set(handles.figure1, 'pointer', 'arrow');

end

% --- Function that updates the main plot
function [handles] = gui_kind_plot (Data, ivIdx, ivSeg, Fit, Plot, handles);

cycid = handles.Cycle;

axes(handles.pressure_axes);

h = plot(Data.Time_D,Data.Pres_D,'b', ...
         Plot.iv2PlotTime,Plot.iv2PlotPres,'ro');
set(h, 'HitTest', 'off');

set(handles.pressure_axes,'ButtonDownFcn', ...
    @(hObject, eventdata)GraphCallBack(hObject, eventdata, handles));
set(handles.pressure_axes,'fontsize',12);

title('Kind Sinusoidal Fitting','FontSize',16);
xlabel('Time [s]','FontSize',14);
ylabel('Data.Pres_Dsue [mmHg]','FontSize',14);

hold on;

mystp = Data.time_step/2;

% obtain the range of time of each peak, then normalize to zero
FitSineTime = Data.Time_D(ivSeg.iv2Time(cycid).PosIso(1,1)):mystp: ...
    Data.Time_D(ivSeg.iv2Time(cycid).NegIso(end,1))+Plot.iv2TShift(cycid);

% plug into Kind equation
dPtimes = [Data.Time(ivIdx.dPmax2(cycid)) Data.Time(ivIdx.dPmin2(cycid)) ...
    Data.time_per];
FitSinePres = data_kind (Fit.RCoef(cycid,:), FitSineTime, dPtimes);

% find time point corresponding to Pmax
[~, Idx] = min(abs(FitSinePres-Fit.RCoef(cycid,1)));
PmaxT = FitSineTime(Idx);

plot(FitSineTime, FitSinePres, 'k--', PmaxT, Fit.RCoef(cycid,1), 'go');
hold on;

% Set reasonable plot limits.
xmn = FitSineTime(1)-0.1;
xmx = FitSineTime(end)+0.1;
ymx = max(Fit.RCoef(:,1))+5;

xlim([xmn xmx]);
if ymx > 300
    ylim([0, 300]);
else
    ylim([0, ymx]);
end

legend('Pressure', 'Isovolumic Points', 'Sinusoid Fit', 'Pmax', ...
    'Location','southoutside', 'Orientation', 'horizontal');

box on;
grid on;
hold off;

end
