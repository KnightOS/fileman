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

## Contributing

This project follows the same standards for contribution as the rest of the KnightOS userspace.
These standards are documented [at KnightOS/KnightOS on GitHub](https://github.com/KnightOS/KnightOS/blob/master/CONTRIBUTING).
