classdef TorqueTask < handle
properties(Access=private)
    job;
    isdone;
    saveddiary;
    savedoutput;
end

properties(SetAccess=private)
    name;
    arguments;
    diaryfile;
    outfile;
end


properties(Dependent)
    diary;
    output;
    status;
end

methods
    function self = TorqueTask(job, name, arguments, diaryfile, outfile)
        self.job = job;
        self.name = name;
        self.arguments = arguments;
        self.diaryfile = diaryfile;
        self.outfile = outfile;
        self.isdone = false;
    end
    
    function out = get.diary(self)
        if ~isempty(self.saveddiary)
            out = self.saveddiary;
        else
            out = strjoin(self.job.readtxt(self.diaryfile)', '\n');
            if strcmp(self.status, 'done')
                self.saveddiary = out;
            end
        end
    end
    
    function out = get.output(self)
        if isempty(self.outfile)
            error('Task had no output.');
        elseif ~isempty(self.savedoutput)
            out = self.savedoutput;
        else
            lstatus = self.status;
            if ~strcmp(lstatus, 'done')
                error(['Task is not yet done (status ' lstatus '). ' ...
                       'Output can be read when the task is complete.']);
            else
                try
                    out = self.job.readmat(self.outfile);
                catch err
                    error(['An error occurred retrieving the task output. ' ...
                           'The task may have errored. Check task.diary for '...
                           'error messages.']);
                end
            end
        end
    end
    
    function out = get.status(self)
        if self.isdone
            out = 'done';
        else
            out = self.job.taskstatus(self.name);
            if strcmp(out, 'done')
                self.isdone = true;
            end
        end
    end
    
    function kill(self)
        self.job.taskkill(self.name);
    end
end
end