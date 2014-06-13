#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use 5.018;
use Storable qw(dclone);

use_ok('Form::Diva');

my $diva1 = Form::Diva->new(
    label_class => 'testclass',
    input_class => 'form-control',
    form        => [
        { n => 'name', t => 'text', p => 'Your Name', l => 'Full Name' },
        { name => 'phone', type => 'tel', extra => 'required' },
        {qw / n email t email l Email c form-email /},
        { name => 'our_id', type => 'number', extra => 'disabled' },
        { name => 'biography', type => 'textarea' },
    ],
);

my %data1_diva1 = (
        name   => 'Maria Callas',
        phone  => '212-MU5-3767',
        email  => 'maria@yahoo.com',
        our_id => 1487,
    );

my @f1_d1 = @{ $diva1->generate( \%data1_diva1 ) };

for ( @f1_d1 ) { note( "$_->{label} $_->{input}" ) }

note( 'testing textarea');
my $test1_label = qq !<LABEL for="biography" class="testclass">Biography</LABEL>!;
is( $f1_d1[-1]->{label}, $test1_label, 'Test Generation of Label.');
like( $f1_d1[-1]->{input}, qr/name="biography"/, 'Test Generation of Name in Input.');
my @f2_d1 = @{ $diva1->generate( ) };
is( $f1_d1[-1]->{input}, $f2_d1[-1]->{input}, 
    'In this test the textarea should be identical as if we provided no data');
# need to test features placeholder, default, that when data is given placeholder
# and default get ignored, also test extra, class

done_testing();
