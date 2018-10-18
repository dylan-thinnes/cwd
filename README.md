# cwd
A working directory stack for managing directories across multiple terminals.
Pronounced k-wuh-d

## What It Does
Creates a file in your home directory called ~/.cwd-history
You can add directories to this file in a stacking manner, and withdraw them.
This is useful when you have mutiple terminals and would like to send them all to same / similar directories. (e.g. i3 window manager)

Provides a set of commands for:
- Pushing your current directory onto the stack.
- Pushing a directory onto the stack.
- Going to the directory on top of the stack.
- Removing the directory on top of the stack.
- Clearing the stack

## Example Usage
```sh
/home/djt $ cd my-dir
/home/djt/my-dir $ cwdadd                   # Add the current directory to the stack
History file /home/djt/.cwd_history exists.
/home/djt/my-dir added to history
/home/djt/my-dir $ cd ..
/home/djt $ cwdgo                           # Go to last directory added to stack - /home/djt/my-dir
History file /home/djt/.cwd_history exists.
Changed directory to /home/djt/projects.
/home/djt/my-dir $ cwdrem                   # Remove directory on top of stack
History file /home/djt/.cwd_history exists.
/home/djt/projects removed from history file.
```

## Functions
`cwdadd <directory>`  
Adds the directory to the stack.  
If no directory is passed in, defaults to current directory.

`cwdgo`
Goes to the directory on the top of the stack (the last directory added to the stack).
If the stack is empty, does nothing and exits with 1.

`cwdrem <number>`
Remove the specific number of directory from the top of the stack.
Removes one by default.

`cwdpop <number>`
Remove the specific number of directory from the top of the stack, then go to the last directory that was removed.
Removes one by default.

`cwdclear`
Clear the stack completely.
