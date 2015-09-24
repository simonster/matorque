# matorque

matorque submits jobs to a Torque cluster via an SSH connection to the head node. It attempts to automatically determine function dependencies so that there is no need to maintain a mirror of local and remote code.

## Examples

Run 3 instances of function `examplefun` with arguments `('hello', 1)` (for the first instance), `('world', 2)` (for the second), `('!', 3)` (for the third):

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
