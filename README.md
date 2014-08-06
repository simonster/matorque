# matorque

matorque submits jobs to a Torque cluster via an SSH connection to the head node. It attempts to automatically determine function dependencies so that there is no need to maintain a mirror of local and remote code. It is not yet stable and may be randomly broken, but I will try to fix bugs as they are reported.

## Examples

Run 3 instances of function `myfun` with arguments `('hello', 1)`, `('world', 2)`, `('!', 3)`:

```matlab
>> job = TorqueJob('myfun', {{'hello', 1}, {'world', 2}, {'!', 3}})
Connecting to server...
Copying dependencies to server...
Submitting tasks...

job = 

  TorqueJob with properties:

       dir: 'jobs/1418863386'
     tasks: {[1x1 TorqueTask]  [1x1 TorqueTask]  [1x1 TorqueTask]}
    status: 'queued'
```

Get output from task 1:

```matlab
>> job.tasks{1}.output

ans =

                            < M A T L A B (R) >
                  Copyright 1984-2013 The MathWorks, Inc.
                    R2013b (8.2.0.701) 64-bit (glnxa64)
                              August 13, 2013

 
To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
 
arg1 = hello; arg2 = 1
```

Check whether tasks are complete (also available for individual tasks):

```matlab
>> job.status

ans =

done
```

Kill tasks (also available for individual tasks):

```matlab
>> job.kill()
```
