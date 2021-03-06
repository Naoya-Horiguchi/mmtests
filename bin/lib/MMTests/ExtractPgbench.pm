# ExtractPgbench.pm
package MMTests::ExtractPgbench;
use MMTests::SummariseMultiops;
use VMR::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub initialise() {
	my ($self, $reportDir, $testName) = @_;
	$self->{_ModuleName} = "ExtractPgbench";
	$self->{_DataType}   = MMTests::Extract::DATA_TRANS_PER_SECOND;
	$self->{_PlotType}   = "client-errorlines";
	$self->{_PlotXaxis}  = "Clients";
	$self->{_FieldLength} = 12;
	$self->{_ExactSubheading} = 1;
	$self->{_ExactPlottype} = "simple";
	# $self->{_Variable}   = 1;
	$self->{_DefaultPlot} = "1";

	$self->SUPER::initialise($reportDir, $testName);
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($tm, $tput, $latency);
	my @clients;

	my @files = <$reportDir/noprofile/default/pgbench-raw-*>;
	foreach my $file (@files) {
		my @split = split /-/, $file;
		$split[-2] =~ s/.log//;
		push @clients, $split[-1];
	}
	@clients = sort { $a <=> $b } @clients;
	my $stallStart = 0;

	# Extract per-client transaction information
	foreach my $client (@clients) {
		my $sample = 0;
		my $stallStart = 0;
		my $stallThreshold = 0;
		my @values;
		my $startSamples = 0;
		my $endSamples = 0;

		my $file = "$reportDir/noprofile/default/pgbench-transactions-$client";
		open(INPUT, $file) || die("Failed to open $file\n");
		while (<INPUT>) {
			my @elements = split(/\s+/, $_);
			push @values, $elements[1];
			$endSamples++;
		}
		close(INPUT);
		$stallThreshold = int (calc_mean(@values) / 4);

		# Find where the shutdown cutoff is where transactions start to taper
		if ($endSamples > 60) {
			# Find where we should stop recording samples
			my $maxIndex = $endSamples - 30;
			my $maxValue = $values[$maxIndex];
			for (my $i = $endSamples - 30; $i < $endSamples; $i++) {
				if ($values[$i] >= $maxValue) {
					$maxIndex = $i;
					$maxValue = $values[$i];
				}
			}
			$endSamples = $maxIndex;

			# Find where we should start recording samples
			$maxIndex = 0;
			$maxValue = $values[$maxIndex];
			for (my $i = 0; $i < 30; $i++) {
				if ($values[$i] >= $maxValue) {
					$maxIndex = $i;
					$maxValue = $values[$i];
				}
			}
			$startSamples = $maxIndex;
		}

		my $testStart = 0;
		open(INPUT, $file) || die("Failed to open $file\n");
		while (<INPUT>) {
			# time num_of_transactions latency_sum latency_2_sum min_latency max_latency
			my @elements = split(/\s+/, $_);
			my $nrTransactions = $elements[1];
			if ($testStart == 0) {
				$testStart = $elements[0];
			}
			$sample++;
			if ($sample > $startSamples && $sample <= $endSamples) {
				if ($nrTransactions < $stallThreshold) {
					if ($stallStart == 0) {
						$stallStart = $elements[0];
					}
				} else {
					if ($stallStart) {
						my $stallDuration = $elements[0] - $stallStart;
						$nrTransactions /= $stallDuration;
						$stallStart = 0;
					}
					push @{$self->{_ResultData}}, [ $client, $elements[0] - $testStart, $nrTransactions ];
				}
			}
		}
		close INPUT;
	}

	$self->{_Operations} = \@clients;
}

1;
