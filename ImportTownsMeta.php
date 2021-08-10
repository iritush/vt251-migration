<?php
    $csv = array_map('str_getcsv', file('/Users/irit/VT251/Site Migration/towns.csv')); 
    print "here";
    foreach ($csv as $entry) {
        $town_name = $entry[1];
        $legacy_id = $entry[0];
        $lon = $entry[6];
        $lat = $entry[7];

        $command = "wp post create --post_type=town --post_status=publish --post_title=\"" . $town_name . "\" --meta_input='{\"town_legacy_id\":\"" . $legacy_id . "\",\"town_name\":\"" . $town_name . "\",\"latitude\":\"" . $lat . "\",\"longitude\":\"". $lon . "\"}'";
        $output=null;
        $retval=null;
        exec($command, $output, $retval);
        if ($retval) {
            echo "Returned with status $retval. output:\n";
            print_r($output);
        }
    }
    print "Done!";