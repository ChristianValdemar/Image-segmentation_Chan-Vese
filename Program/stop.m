function F = stop(string)
% Christian Valdemar Hansen, SDU 2012.

% Messagebox:
M = msgbox(string,'Stop iterating');
pos1 = [50, 50,150,80];
set(M,'OuterPosition',pos1) 

% The parts below are parts from:
% http://www.mathworks.com/matlabcentral/fileexchange/20455-stoploop-v1-0-j
% un-2008 
% by Jos van der Geest
% create the two anonymous functions
F.Stop = @() stopfun(M) ; % false if message box still exists
F.Clear = @() clearfun(M) ; % delete message box

function r = stopfun(M)
drawnow ;          % ensure that button presses are recorded
r = ~ishandle(M) ; % false if message box still exists

function clearfun(M)
% clear the message box if it still exists
if ishandle(M),
    delete(M) ;
end