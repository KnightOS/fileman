# fileman

The KnightOS file manager.

## Compiling

First, install the [KnightOS SDK](http://www.knightos.org/sdk).

    $ knightos init
    $ make
    $ make run # to test
    $ make package # to produce an installable package

## Installing

Use `make package` to get a package that you can install. It include a default configuration
in `/etc/fileman.conf`, which looks like this:

    # If yes, show file sizes
    showsize=yes
    # If yes, show files that begin with '.'
    showhidden=no
    # If yes, allow the user to browse outside of startdir
    browseroot=no
    # Which directory to start up in
    startdir=/home/
    # If yes, show the UI for manipulating symlinks
    editsymlinks=no

You can edit these settings through the KnightOS settings app.

## Help, Bugs, Feedback

If you need help with KnightOS, want to keep up with progress, chat with
developers, or ask any other questions about KnightOS, you can hang out in the
IRC channel: [#knightos on irc.freenode.net](http://webchat.freenode.net/?channels=knightos).
 
To report bugs, please create [a GitHub issue](https://github.com/KnightOS/KnightOS/issues/new) or contact us on IRC.
 
If you'd like to contribute to the project, please see the [contribution guidelines](http://www.knightos.org/contributing).
