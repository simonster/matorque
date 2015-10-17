# matorque

matorque submits jobs to a Torque cluster via an SSH connection to the head node. It attempts to automatically determine function dependencies so that there is no need to maintain a mirror of local and remote code. It requires MATLAB 2014a or later.

## Examples

To run:

```
examplefun('hello', 1)
examplefun('world', 2)
examplefun('!', 3)
```

in parallel on the cluster, use:

```
>> job = TorqueJob('examplefun', {{'hello', 1}, {'world', 2}, {'!', 3}})
Connecting to server...
Copying dependencies to server...
Submitting tasks...

job = 

  TorqueJob with properties:

       dir: 'jobs/1418863386'
     tasks: {[1x1 TorqueTask]  [1x1 TorqueTask]  [1x1 TorqueTask]}
    status: 'queued'
```

You can also specify PBS directives as the third argument. Please do this! You might want something like:

```
>> job = TorqueJob('examplefun', {{'hello', 1}, {'world', 2}, {'!', 3}}, ...
                   'walltime=2:00:00,mem=8GB')
```

to specify that the job will take two hours (if it takes longer, it will be killed) and that it will consume 8 GB of memory.

Get printed output (diary) from task 1:

```
>> job.tasks{1}.diary

ans =

                            < M A T L A B (R) >
                  Copyright 1984-2013 The MathWorks, Inc.
                    R2013b (8.2.0.701) 64-bit (glnxa64)
                              August 13, 2013

 
To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
 
arg1 = hello; arg2 = 1
```

Get the return value from task 1:

```
>> job.tasks{1}.output

ans =

hello
```

Check whether tasks are complete (also available for individual tasks):

```
>> job.status

ans =

done
```

Kill tasks (also available for individual tasks):

```
>> job.kill()
```

## Dependency resolution

By default, `TorqueJob` uses the MATLAB built-in `matlab.codetools.requiredFilesAndProducts` to copy the dependencies of the specified function from the local machine to the server. This may be slow or fail if there are a large number of dependencies. To disable this behavior, pass `false` as the fourth argument to `TorqueJob`:

```
>> job = TorqueJob('examplefun', {{'hello', 1}, {'world', 2}, {'!', 3}}, 'walltime=10:00', false);
```

If you disable dependency resolution, you must manually add paths to any dependent functions at the start of your function, e.g.:

```matlab
function myfun()
addpath('deps');          % Add the directory "deps", located in your home
                          % directory, to the MATLAB path
addpath(genpath('deps')); % Add the directory "deps" to the MATLAB path along
                          % with all subfolders
```
