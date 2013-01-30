package Database;

use Config::Simple;
use DBI;

my $cfg = new Config::Simple("/usr/lib/dejavu/dejavu.cfg");
my $dbh;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;

    my $db   = $cfg->param("db");
    my $user = $cfg->param("db_user");
    my $pass = $cfg->param("db_password");
    my $host = $cfg->param("db_host");
    $dbh = DBI->connect( "DBI:mysql:$db:$host", $user, $pass );

    return $self;
}

sub get_solution_by_id {
    my $class = shift;
    my $id    = shift;

    my $query = "select solution from dejavu where id = ?";
    my $statement = $dbh->prepare($query);
    $statement->execute($id);
    if ( $statement->rows != 0 ) {
        my @solution = $statement->fetchrow_array();
        return $solution[0];
    }
    else {
        return "";
    }
}

sub put_dejavu {
    my $class = shift;

    my $desc   = shift;
    my $labels = shift;
    my $user   = $cfg->param("confluence_user");

    my $query = "insert into dejavu ( user,description,labels, date_created) values (?, ?, ?, NOW())";
    my $statement = $dbh->prepare($query);
    $statement->execute( $user, $desc, $labels );
}

sub print_array{
    my $array = shift;

    my $count = scalar @$array;

    foreach (@$array) {
       print_dejavu($_);
    }

    print "---------------------------------------------\n";
    print "Total dejavu count: $count \n";
}

sub print_all {
    my $class = shift;

    my $query = "select id, user, labels, description, date_created, solution, date_resolved from dejavu";
    my $statement = $dbh->prepare($query);
    $statement->execute();

    print_array( $statement->fetchall_arrayref() ); 
}


sub print_unresolved {
    my $class = shift;

    my $query = "select id, user, labels, description, date_created, solution, date_resolved from dejavu where resolved = false";
    my $statement = $dbh->prepare($query);
    $statement->execute();

    print_array( $statement->fetchall_arrayref() ); 
}

sub print_dejavu_with {
    my $class = shift;
    my $labels = shift;
    my $description = shift;
    my $solution = shift;
    
    my @labels = split /\s*,\s*/, $labels;
    
    my $fulltext = "'";
    foreach my $label (@labels){
		    $fulltext.= "+$label ";	
    }
    $fulltext=~s/ $//;
    $fulltext.="'";

    my $query = "select id, user, labels, description, date_created, solution, date_resolved 
                 from dejavu 
                 where match(labels) against ($fulltext in boolean mode) or 
                       match(description) against ('*$description*' in boolean mode) or
                       match(solution) against ('*$solution*' in boolean mode)";
    my $statement = $dbh->prepare($query);
    $statement->execute();

    print_array( $statement->fetchall_arrayref() ); 
     
}

sub print_dejavu {
   my $data = shift;
   
   print("===============================================================================\n");
   printf("%-15s - %50.50s\n","ID",$data->[0]);
   printf("%-15s - %50.50s\n","User",$data->[1]);
   printf("%-15s - %50.50s\n","Labels",$data->[2]);
   printf("%-15s - %s\n","Description", beautify($data->[3]));
   printf("%-15s - %50.50s\n","Date created",$data->[4]);
   printf("%-15s - %s\n","Solution", beautify($data->[5]));
   printf("%-15s - %50.50s\n","Date solved",$data->[4]);
}

sub beautify{
   my $string = shift;
   
   $string =~ s/^\s*(.*)\s*$/$1/;
   $string =~ s/\n//g;

   return $string;
}

sub mark_as_resolved {
    my $class    = shift;
    my $id       = shift;
    my $solution = shift;

    my $query     = "update dejavu set resolved = true, solution = ? where id = ?";
    my $statement = $dbh->prepare($query);
    $statement->execute( $solution, $id );
}

1;
