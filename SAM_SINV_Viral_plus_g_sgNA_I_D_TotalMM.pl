#!/usr/bin/perl -w
use warnings;


$samfile = $ARGV[0];
open FILEONE, $samfile ;

$All_cellular = "All_cellular";

while (<FILEONE>)

{
chomp;
@array = split(/\t/, $_);


unless ($array[0] =~ m/@/) #ignore header
{	


#extract flag information 

$samflag=$array[1];

#extract read start information 

$Read_start=$array[3];

#start counting flags/chr information 
$All = "$samflag.all";
$genomic = "$samflag.genomic";
$subgenomic = "$samflag.subgenomic";

#the NM tag is standrad sam file flag for No.of nucleotide edits to match reference( be aware it includes splicing)
$NM = $array[-2];
@Number_of_mismatch = split(/\:/, $NM);
#the nm tag is STAR-specific, as far as I know, and it calculated per mate (for single read seq, it is the same), but it doesnot count splicing as edits
$nM = $array[-3];
@STAR_Numberofmismatch = split(/\:/, $nM);


	if ($array[2] =~ m/T7_SINV_mCherry/)
	{
		$Viral_RNA{$All}++;
		$STAR_Number_of_mismatch{$All} += $STAR_Numberofmismatch[2];
		$mismatch_counts{$All} += $Number_of_mismatch[2];
			if (  $array[5] =~ m/I/) { $Insertion_counts{$All}++ }
			if (  $array[5] =~ m/D/) { $deletion_counts{$All}++ }
			if (  $array[5] =~ m/N/) { $Splicing_counts{$All}++ }

		if ($Read_start < 7602 ) {
			$Viral_RNA{$genomic}++;
			if (  $array[5] =~ m/I/) { $Insertion_counts{$genomic}++ }
			if (  $array[5] =~ m/D/) { $deletion_counts{$genomic}++ }
			if (  $array[5] =~ m/N/) { $Splicing_counts{$genomic}++ }
			$mismatch_counts{$genomic} += $Number_of_mismatch[2];	
			$STAR_Number_of_mismatch{$genomic} += $STAR_Numberofmismatch[2];
				
							}
		if ($Read_start > 7601 ) {

			$Viral_RNA{$subgenomic}++;
			if (  $array[5] =~ m/I/) { $Insertion_counts{$subgenomic}++ }
			if (  $array[5] =~ m/D/) { $deletion_counts{$subgenomic}++ }
			if (  $array[5] =~ m/N/) { $Splicing_counts{$subgenomic}++ }
			$mismatch_counts{$subgenomic} += $Number_of_mismatch[2];
			$STAR_Number_of_mismatch{$subgenomic} += $STAR_Numberofmismatch[2];	

		}
	}
	if ($array[2] !~ m/T7_SINV_mCherry/)
	{
		$Viral_RNA{$All_cellular}++;
		$STAR_Number_of_mismatch{$All_cellular} += $STAR_Numberofmismatch[2];
		$mismatch_counts{$All_cellular} += $Number_of_mismatch[2];
			if (  $array[5] =~ m/I/) { $Insertion_counts{$All_cellular}++ }
			if (  $array[5] =~ m/D/) { $deletion_counts{$All_cellular}++ }
			if (  $array[5] =~ m/N/) { $Splicing_counts{$All_cellular}++ }
	}

}

}

#printing extracted information
	print" Viral_RNA\tcount\tInsertion\tdeletion\tSplicing\tSam_MisM\tStar_MisM\n" ;

foreach $key (sort keys %Viral_RNA)   
{
	$counts=$Viral_RNA{$key};
	$Insertion=$Insertion_counts{$key};
	$deletion=$deletion_counts{$key};
	$Splicing=$Splicing_counts{$key};
	$SAM_MM=$mismatch_counts{$key};
	$STAR_MM=$STAR_Number_of_mismatch{$key};


	print"$key\t$counts\t$Insertion\t$deletion\t$Splicing\t$SAM_MM\t$STAR_MM\n" 

}



