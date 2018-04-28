eval 'exec perl -S $0 ${1+"$@"}'
                 if 0;

#
# Pre-process a set of files, handling ONLY the `include directives
# to yield a flat file. All other pre-processor directives are ignored.
#

sub usage
{
    print STDERR <<'USAGE';

Usage: $0 {-I dirname} [-l] [fname]

Pre-process the specified file, expanding ONLY the `include directives
found within it, yielding a flat file. The resulting file is produced
on the standard output.

The -I option is used to defined a search path for included file.
The current directory is always searched first. If the file is not
found, they it is searched for in the specified directories. More
than one -I option can be specified.

If the -l option is specified, the `line directive are not generated.

USAGE

    exit(1);
}

#
# Parse the command-line options
#
while ($#ARGV >= 0) {
  $_ = shift @ARGV;
  chomp($_);

  if (m/^-(.)(.*)$/) {
    $opt = $1;
    $arg = $2;

    if ($opt eq "h") {
      &usage();
    } elsif ($opt eq "p") {
      $opt_pkg = 1;
    } elsif ($opt eq "m") {
      $opt_macros = 1;
    } elsif ($opt eq "v" && $arg eq "mm") {
      $opt_vmm = 1;
    } elsif ($opt eq "l" && $arg eq "") {
      $opt_l = 1;
    } elsif ($opt eq "I") {
      if ($arg eq "") {
	if ($#ARGV < 0) {
	  print STDERR "ERROR: No argument specified for the -I option\n";
	  exit(-1);
	}
	$arg = shift @ARGV;
	chomp($arg);
      }
      push(@incdirs, $arg);
    } else {
      print STDERR "ERROR: Unknown command-line option: '$opt'\n";
      exit(-1);
    }
    next;
  }

#  if ($fname) {
#    print STDERR "ERROR: More than one source file specified\n";
#    exit(-1);
#  }
#
#  $fname = $_;
}

$fname = ($opt_pkg) ? "uvm_pkg.sv" : "uvm_vmm_pkg.sv";
$rc = &pp($fname);

exit($rc);


#
# Pre-process the specified file
# Returns non-zero on error
#
sub pp {
  local($fname) = @_;
  local($rc, $line) = (0, 0);
  local($_, $lname);

  $fname =~ m#([^/]*)$#;
  $lname = $1;
  print "`line 1 \"$lname\"\n" unless $opt_l;

  if ($fname eq "") {
    $fname = "STDIN";
  } else {
    if (!open($fname, "< $fname")) {
      print STDERR "ERROR: Cannot open $fname for reading: $!\n";
      return 1;
    }
  }

  while ($_ = <$fname>) {
    $line++;
    # Is this line an include directive?
    if (m/^\s*\`\s*include\s+"(.*)"/) {
      $incl = $1;
      # Ignore inclusion of SVI files
      if ($incl =~ m/\.svi$/) {
	print $_;
	next;
      }
      # Ignore inclusion of uvm_macros.svh
      if (!$opt_vmm && $incl eq "uvm_macros.svh") {
	print $_;
	next;
      }
      # Ignore inclusion if line contains "// DO NOT INLINE" pragma
      if ($_ =~ m#// DO NOT INLINE#) {
	print $_;
	next;
      }
      $incl = &look_for($incl, $fname);
      if ($incl eq "") {
	print STDERR "ERROR $fname, line $line: Unable to locate include file \"$1\"\n";
	return 1;
      }
      $rc = &pp($incl);
      return $rc if $rc;
      printf "`line %d \"$fname\"\n", $line+1 unless $opt_l;

      next;
    }

    print $_;
  }

  $line++;
  print "`line $line \"$lname\"\n" unless $opt_l;

  if ($fname ne "STDIN") {
    close($fname);
  }

  return 0;
}


#
# Look for the specified file, with respect to the
# location of the file that included it
#
sub look_for {
  local($incl, $by) = @_;
  local($_, $dir);

  # Where is the including file located?
  $by = &root($by);

  # First, try wrt to the including file...
  $_ = $incl;
  if ($by ne "") {
    $_ = "$by/$incl";
  }
  if (-e $_) {
    return $_;
  }

  # Next, try the search paths...
  foreach $dir (@incdirs) {
    $_ = "$dir/$incl";
    if (-e $_) {
      return $_;
    }
  }

  return "";
}


#
# Return the root path of a filename
#
sub root {
  local($_) = @_;

  if (m|^(.*)/|) {
    return $1;
  }
  return "";
}

