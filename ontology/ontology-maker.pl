#!/usr/bin/perl
use strict;
my @onts = ();
while(<>) {
    chomp;
    if (m@\-\s+(http\S+)@) {
        push(@onts, $1);
    }
}
mkdir "stage" unless -d "stage";
mkdir "target" unless -d "target";
my @tgts = ();
foreach my $ont (@onts) {
    print STDERR "MAKING: $ont\n";
    my @toks = split(/\//,$ont);
    my $fn = pop @toks;
    my $stage = "stage/$fn";
    my $tgt = "target/$fn";
    push(@tgts, $tgt);
    runcmd("wget --no-check-certificate $ont -O $stage.tmp && mv $stage.tmp $stage") unless -f $stage;
    runcmd("owltools $stage --merge-imports-closure --extract-mingraph -o -f ttl --prefix OBO http://purl.obolibrary.org/obo/ $tgt.tmp && mv $tgt.tmp $tgt") unless -f $tgt;
}

print STDERR "COMBINING\n";

runcmd("owltools @tgts --merge-support-ontologies  -o -f ttl --prefix OBO http://purl.obolibrary.org/obo/ merged.owl");
exit 0;

sub runcmd {
    my $cmd = shift;
    print STDERR "RUNNING: $cmd\n";
    my $err = system($cmd);
    if ($err) {
        die $cmd;
    }
}
