=head1 LICENSE

Copyright [2018-2020] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Bio::EnsEMBL::DataCheck::Checks::CompareOntologyTerm;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME           => 'CompareOntologyTerm',
  DESCRIPTION    => 'Compare Term counts between current and previous ontology database',
  GROUPS         => ['ontologies'],
  DATACHECK_TYPE => 'advisory',
  DB_TYPES       => ['ontology'],
  TABLES         => ['term']
};

sub tests {
  my ($self) = @_;
  SKIP: {
    my $old_dba = $self->get_old_dba();

    skip 'No old version of database', 1 unless defined $old_dba;

    my $desc = "Term count has not decreased in ".
               $self->dba->dbc->dbname.' compared to '.$old_dba->dbc->dbname;
    my $sql  = 'SELECT COUNT(*) FROM term';
    row_totals($self->dba, $old_dba, $sql, undef, 1.00, $desc);
  }
}

1;

