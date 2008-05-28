package urpmi_backend::filters;

use MDK::Common;
use perl_packagekit::enums;
use urpmi_backend::tools;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(filter);

my @gui_pkgs = map { chomp; $_ } cat_('/usr/share/rpmdrake/gui.lst');

sub filter {
  my ($pkg, $filters, $enabled_filters) = @_;

  my %e_filters = %{$enabled_filters};

  foreach my $filter (@{$filters}) {
    if($filter eq FILTER_INSTALLED || $filter eq FILTER_NOT_INSTALLED) {
      if($e_filters{FILTER_INSTALLED}) {
        return 0 if not filter_installed($pkg, $filter);
      }
    }
    elsif($filter eq FILTER_DEVELOPMENT || $filter eq FILTER_NOT_DEVELOPMENT) {
      if($e_filters{FILTER_DEVELOPMENT}) {
        return 0 if not filter_devel($pkg, $filter);
      }
    }
    elsif($filter eq FILTER_GUI || $filter eq FILTER_NOT_GUI) {
      if($e_filters{FILTER_GUI}) {
        return 0 if not filter_gui($pkg, $filter);
      }
    }
  }
  return 1;
}

sub filter_installed {
  my ($pkg, $filter) = @_;
  my $installed;
  $installed = 1 if(find_installed_version($pkg));
  if($filter eq FILTER_INSTALLED && $installed) {
    return 1;
  }
  if($filter eq FILTER_NOT_INSTALLED && !$installed) {
    return 1;
  }
  return 0;
}

sub filter_devel {
  my ($pkg, $filter) = @_;
  my $pkgname = $pkg->name;
  my $devel = ($pkgname =~ /-devel$/);
  if($filter eq FILTER_DEVELOPMENT && $devel) {
    return 1;
  }
  if($filter eq FILTER_NOT_DEVELOPMENT && !$devel) {
    return 1;
  }
  return 0;
}

sub filter_gui {
  my ($pkg, $filter) = @_;
  my $pkgname = $pkg->name;
  my $gui = member($pkgname, @gui_pkgs);

  if($filter eq FILTER_NOT_GUI && !$gui) {
    return 1;
  }
  if($filter eq FILTER_GUI && $gui) {
    return 1;
  }
  return 0;
}

1;
