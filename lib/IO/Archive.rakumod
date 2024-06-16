unit package IO::Archive;

use Archive::Libarchive;
use Archive::Libarchive::Constants;
use MONKEY-TYPING;

augment class IO::Path {

    multi method arch-list ( --> Array) {
        my @files;
        my Archive::Libarchive $a .= new: operation => LibarchiveRead, file => self.path;
        my Archive::Libarchive::Entry $e .= new;
        while $a.next-header($e) {
            push @files, $e.pathname;
            $a.data-skip;
        }
        $a.close;
        return @files;
    }
    
    multi method arch-extract ( Str $file, Str $dest --> Bool) {
        my Bool $success = True;
        say "Extracting $file to $dest";
        my Archive::Libarchive $a .= new:
            operation => LibarchiveExtract,
            file => self.path,
            flags => ARCHIVE_EXTRACT_TIME +| ARCHIVE_EXTRACT_PERM +| ARCHIVE_EXTRACT_ACL +| ARCHIVE_EXTRACT_FFLAGS;
        try {
            $a.extract: sub (Archive::Libarchive::Entry $e --> Bool) { $e.pathname eq $file }, $dest;
            CATCH {
                say "Can't extract files: $_";
                $success = False;
            }
        }
        $a.close;
        return $success;
    }

    # extract file to a string buffer and return it
    multi method arch-extract ( Str $file --> Str) {
        my Buf $content;
        my Archive::Libarchive $a .= new:
            operation => LibarchiveExtract,
            file => self.path,
            flags => ARCHIVE_EXTRACT_TIME +| ARCHIVE_EXTRACT_PERM +| ARCHIVE_EXTRACT_ACL +| ARCHIVE_EXTRACT_FFLAGS;
        try {
            my $operation = LibarchiveExtract;
            my Archive::Libarchive::Entry $e .= new;
            while $a.next-header($e) {
                if $e.pathname eq $file {
                    $content = $a.read-file-content($e);
                    last;
                }
                $a.data-skip;
            }
            CATCH {
                say "Can't extract files: $_";
            }
        }
        $a.close;
        return $content.decode;
    }

    multi method arch-extract-all ( Str $dest --> Bool) {
        my Bool $success = True;
        my Archive::Libarchive $a .= new:
            operation => LibarchiveExtract,
            file => self.path,
            flags => ARCHIVE_EXTRACT_TIME +| ARCHIVE_EXTRACT_PERM +| ARCHIVE_EXTRACT_ACL +| ARCHIVE_EXTRACT_FFLAGS;
        try {
            $a.extract: sub (Archive::Libarchive::Entry $e --> Bool) { }, $dest;
            CATCH {
                say "Can't extract files: $_";
                $success = False;
            }
        }
        $a.close;
        return $success;
    }

    multi method arch-create ( @files --> Bool) {
        my Bool $success = True;
        my Archive::Libarchive $a .= new: operation => LibarchiveWrite, file => self.path;
        for @files -> $file {
            try {
                $a.write-header($file,
                                uname => 'user1',
                                gname => 'group1',
                                filetype => ($file.IO.l ?? AE_IFLNK !! AE_IFREG)
                                );
                $a.write-data($file);
                CATCH {
                    default { .Str.say }
                    $success = False;
                }
            }
        }
        $a.close;
        return $success;
    }

}


