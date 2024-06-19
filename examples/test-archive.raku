#!/usr/bin/env raku
# want to add methods to the IO::Path class

use IO::Archive;

my @files = "../resources/test-archive.tgz".IO.arch-list;
say @files.join("\n");


my Str $strbuf = "../resources/test-archive.tgz".IO.arch-extract("test-archive/second-level/file3.txt");
say $strbuf;

#say "\n\n=== now trying a zip file ===\n\n";
#my @zfiles = "../resources/monitor-bot.zip".IO.arch-list.join("\n").say;
#'../resources/monitor-bot.zip'.IO.arch-extract('monitor-bot/docker-compose.yml').say;

my @cfiles = qw< test-path/f1 test-path/f2 test-path/d1/d1f1 >;
"new-archive.tgz".IO.arch-create( @cfiles ).say;

"new-archive.zip".IO.arch-create( @cfiles ).say;

# shell out and create a new file as test-path/d1/d1f2
shell "echo 'this is a test' > test-path/d1/d1f2";
# add the new file to the archive
"new-archive.tgz".IO.arch-insert( "test-path/d1/d1f2" ).say;
"new-archive.zip".IO.arch-insert( "test-path/d1/d1f2" ).say;

my @new-list = "new-archive.tgz".IO.arch-list;
say @new-list.join("\n");

# remove the file from the directory
shell "rm test-path/d1/d1f2";

