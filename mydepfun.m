function [filelist, callers] = mydepfun(fn,recursive)
%MYDEPFUN - Variation on depfun which skips toolbox files
%
% [filelist,callers] = mydepfun(fn,recursive=false)
%
% Returns a list of files which are required by the specified
% function, omitting any which are inside $matlabroot/toolbox. 
%
% "fn" is a string specifying a filename in any form that can be
%   identified by the built-in function "which".
% "recursive" is a logical scalar; if false, only the files called
%   directly by the specified function are returned.  If true, *all*
%   those files are scanned to, and any required by those, and so on.
%
% "filelist" is a cell array of fully qualified file name strings,
%   including the specified file.
%
% e.g.
%     filelist = mydepfun('myfunction')
%     filelist = mydepfun('C:\files\myfunction.m',true) 

% Copyright 2006-2010 The MathWorks, Inc.

if ~ischar(fn)
    error('First argument must be a string');
end

foundfile = which(fn);
if isempty(foundfile)
    error('File not found: %s',fn);
end

% Scan this file
[filelist,callers] = i_scan(foundfile);

% If "recursive" is supplied and true, scan files on which this one depends.
if nargin>1 && recursive
    % Create a list of files which we have still to scan.
    toscan = filelist;
    toscan = toscan(2:end); % first entry is always the same file again
    % Now scan files until we have none left to scan
    while numel(toscan)>0
        % Scan the first file on the list
        [newlist, newcallers] = i_scan(toscan{1});
        newlist = newlist(2:end); % first entry is always the same file again
        newcallers = newcallers(2:end);
        toscan(1) = []; % remove the file we've just scanned
        % Find out which files are not already on the list.  Take advantage of
        % the fact that "which" and "depfun" return the correct capitalisation
        % of file names, even on Windows, making it safe to use "ismember"
        % (which is case-sensitive).
        [notnew,oldindex] = ismember(newlist,filelist);
        reallynew = ~notnew;
        if oldindex
            for jj = find(notnew)
                tmp  = [ callers{oldindex(jj)} newcallers{jj}];
                callers(oldindex(jj)) = {unique(tmp)};
            end;
        end;
        newlist = newlist(reallynew);
        % If they're not already in the file list, we'll need to scan them too.
        % (Conversely, if they ARE in the file list, we've either scanned them
        %  already, or they're currently on the toscan list)
        toscan = unique( [ toscan ; newlist ] );
        newfilelist = unique( [ filelist ; newlist ] );
        if numel(newfilelist) ~= (numel(filelist) + numel(newlist))
            error('duplicates should be eliminated already!');
        end;
        newcallers = newcallers(reallynew);
        callers = [ callers ; newcallers ];
        filelist = [ filelist ; newlist ];
    end
end

%%%%%%%%%%%%%%%%%%%%%
% Returns the non-toolbox files which the specified one calls.
% The specified file is always first in the returned list.
function [list,callers] = i_scan(f)

func = i_function_name(f);

[list,~,~,~,~,~,callers,~] = depfun(func,'-toponly','-quiet');

toolboxroot = fullfile(matlabroot,'toolbox');

intoolbox = strncmpi(list,toolboxroot,numel(toolboxroot));

list = list(~intoolbox);
callers = callers(~intoolbox);
for jj = 1:numel(list)
    c = callers{jj};
    cs = cell(numel(c),1);
    for kk = 1:numel(c)
        cs{kk} = list{c(kk)};
    end;
    callers{jj} = cs;
end;

%%%%%%%%%%%%%%%%%%%%%%%%
function func = i_function_name(f)
% Identifies the function name for the specified file,
% including the class name where appropriate.  Does not
% work for UDD classes, e.g. @rtw/@rtw

[dirname,funcname] = fileparts(f);
[ignore,dirname] = fileparts(dirname);

if ~isempty(dirname) && (dirname(1)=='@' || dirname(1)=='+')
    func = [ dirname '/' funcname ];
else
    func = funcname;
end
