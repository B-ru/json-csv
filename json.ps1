#$args = number of threads
cd C:\scripts
$inputfiles = dir *.json
$outfile = "out.csv"
$result = @()
$filecount = $inputfiles.count;
echo "Starting JSON to CSV converting with $args threads and $filecount JSON files:"
#start filecycling
for($file_index = 0; $file_index -lt $inputfiles.Count;){
#start threadcycling
	$jobs = @()
	$i = 0
	for(; $i -lt "$args" -and $file_index -lt $inputfiles.Count; $i++, $file_index++ ){
		$file = $inputfiles[$file_index].Name
	        $jobs += Start-Job -FilePath "json_to_csv_fileway.ps1" -ArgumentList $file
		echo "$file converting initiated"
    	}
    	$receivedJobs = 0;
    	while ($receivedJobs -lt $i){
        	foreach($completedJob in ($jobs | where {$_.State -eq "Completed" -and $_.HasMoreData})){
        		$result += Receive-Job $completedJob;
            		$receivedJobs++;
        	}
		Start-Sleep -Milliseconds 500
 	}
	Add-Content $outfile $result
	"Saved " + $result.length + " lines to " + $outfile  	
    	Remove-Job $jobs
}
echo "Job done!"
