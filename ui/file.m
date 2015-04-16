function varargout = file(varargin)
% FILE Application M-file for file.fig
%    FIG = FILE launch file GUI.
%    FILE('callback_name', ...) invoke the named callback.
%   Aurhor: Efsun Sarioglu

% Last Modified by GUIDE v2.0 06-Jun-2005 22:16:24

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% -------------------------------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton1.
[filename, pathname] = uigetfile( {'*.dat', 'All Data Files (*.dat)'; '*.mat','All MAT Files(*.mat)'; '*.*','All Files (*.*)'},'Select Input data file');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
return
% Otherwise construct the fullfilename and Check and load the file
else
File = fullfile(pathname,filename);
handles.File = File;
set(handles.editFile,'String',File);
guidata(h,handles);
end

% -------------------------------------------------------------------------------------------
function varargout = pushbuttonUpload_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbuttonUpload.
% if (isfield(handles,'Delimeter')==0)
%    handles.Delimeter = ' ';
%    guidata(h,handles);
% end
f = dlmread(handles.File,handles.Delimeter);
plot(f);
% --------------------------------------------------------------------
function varargout = popupDelimeter_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupDelimeter.

val = get(h,'Value');
str = get(h, 'String');
switch str{val};
case 'Comma' % comma separated values
handles.Delimeter = ',';
case 'Space' % space separated values
handles.Delimeter = ' ';
case 'Tab' % tab separated values
handles.Delimeter = '\t';
otherwise
handles.Delimeter = ' ';
end
guidata(h,handles);
% val = get(hObject,'Value');
% str = get(hObject, 'String');
% switch str{val};
% case 'peaks' % User selects peaks
% handles.current_data = handles.peaks;
% case 'membrane' % User selects membrane
% handles.current_data = handles.membrane;
% case 'sinc' % User selects sinc
% handles.current_data = handles.sinc;
% end
% guidata(hObject,handles)
% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edit2.
disp('edit2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton3.
disp('pushbutton3 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupDelimeter_CreateFcn(h, eventdata, handles, varargin)
% Stub for CreateFcn of the uicontrol handles.popupDelimeter.
disp('popupDelimeter CreateFcn not implemented yet.')
