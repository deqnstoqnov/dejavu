#!/bin/bash

ln -s /usr/lib/dejavu/dejavu.pl /usr/bin/dejavu 
cpan -i Config::Simple
cpan -i File::Slurp
cpan -i DBI
