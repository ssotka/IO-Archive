NAME
====

IO::Archive - Adds libarchive capabilities to IO::Path objects

SYNOPSIS
========

Note: Requires libarchive to be installed and in place raku can find it. 

For MacOS try;
```brew install libarchive```
* You may need to manually copy or link `libarchive.13.dylib` to someplace like `/usr/local/lib`.

```
# Get a list of the files in the archive
my @files = "test-archive.tgz".IO.arch-list;

# Extract a specific file to a destination
"test-archive.tgz".IO.arch-extract( @files[2], $dest );

# extract the contents of a file in the archive to a string
my Str $str-buf = "test-archive.tgz".IO.arch-extract( @files[2] );

# Extract all the files from the archive to a given destination
"test-archive.tgz".IO.arch-extract-all( $dest );

# Create an archive 
"new-archive.tgz".IO.arch-create( @file-paths );

# Add or update a file to an archive
"new-archive.tgz".IO.arch-insert( $file );
```


DESCRIPTION
===========

IO::Archive adds archive methods to the IO::Path class to create and extract from
archive files like tgz, zip, bzip and any other archive that is handled by libarchive.

AUTHOR
======

Scott Sotka <ssotka@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Scott Sotka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
