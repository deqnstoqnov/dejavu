#!/usr/bin/perl
use Getopt::Long;
use Config::Simple;
use Database;
use File::Slurp;

my $cfg = new Config::Simple("dejavu.cfg");

my $add;
my $solve;
my $id;
my $find = $cfg->param("default_search");
my @labels; 
my $verbose;
my $list;
my $description;
my $solution;

$result = GetOptions(
    "add"      => \$add,
    "edit"     => \$edit,
    "find"     => \$find,
    "id=s"     => \$id,
    "labels=s@" => sub { 
                 my $a = shift;
                 my $b = shift;
                 @labels = split(/\s*,\s*/,$b);
                },
    "description=s" => \$description,
    "solution=s" => \$solution,

    "verbose"  => \$verbose
);

my $conn = Database->new();

if ($find ne '') {
    $conn->print_dejavu_with(join(',',@labels), $description, $solution); 
} elsif ($add ne '') {
    my $min_labels_count = $cfg->param("default_labels_count_min");
    die "You have to specify at least $min_labels_count labels" unless @labels >= $min_labels_count;

    my $file = $cfg->param("add_file");

    system "/usr/bin/vim -c 'startinsert' $file";

    my $desc = read_file($file);

    system "rm $file";

    $conn->put_dejavu( join( "\n", $desc ), join(',',@$labels) );

    $conn->print_unresolved();

} elsif ($edit ne '') {

    my $file = $cfg->param("edit_file");

    # read previous solution from db and write it to file
    my $previous = $conn->get_solution_by_id($id);

    print "The ID to be fetched: $id\n";
    print "Previous content from DB: $previous \n";
    write_file($file,$previous);
    system "/usr/bin/vim -c 'startinsert' $file";

    my $solution = read_file($file);

    system "rm $file";

    $conn->mark_as_resolved( $id, $solution );
}

