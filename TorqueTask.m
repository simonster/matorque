classdef TorqueTask < handle
properties(Access=private)
    job;
end

properties(SetAccess=private)
    name;
    arguments;
    outfile;
end

properties(Dependent)
    output;
    status;
end

methods
    function self = TorqueTask(job, name, arguments, outfile)
        self.job = job;
        self.name = name;
        self.arguments = arguments;
        self.outfile = outfile;
    end
    
    function out = get.output(self)
        out = strjoin(self.job.remotefile(self.outfile)', '\n');
    end
    
    function out = get.status(self)
        out = self.job.taskstatus(self.name);
    end
    
    function kill(self)
        self.job.taskkill(self.name);
    end
end
end