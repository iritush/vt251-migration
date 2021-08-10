<?php
    $csv = array_map('str_getcsv', file('migration_map_users_w_towns_visited.csv'));
    $num_of_entries = count($csv);
    $current_user_name = $csv[0][0];
    $current_user_visited_towns_list = $csv[0][1];
    $logfile = "log.txt";
    if(!is_file($logfile)){
        touch($logfile);
    }
    $logcontent = "Total lines in file: " . $num_of_entries;
    $success_updates = 0;
    $fail_updates = 0;
    file_put_contents($logfile, $logcontent);
    for ($i=0;$i<$num_of_entries;$i++) {     
        if ($csv[$i][0] != $current_user_name and $i != $num_of_entries-1){
            $logcontent = file_get_contents($logfile);
            $logcontent .= "User " . $current_user_name . " visited towns: " . $current_user_visited_towns_list . "\n";
            file_put_contents($logfile, $logcontent);

            $command = "wp bp xprofile data set --user-id=" . "'" . $current_user_name . "'" . " --field-id=6 --value=" . "'" . $current_user_visited_towns_list . "'";
            $output=null;
            $result_code=null;
            exec($command, $output, $result_code);
            if ($result_code != 0) {
                $logcontent = file_get_contents($logfile);
                $logcontent .= "Failed to update xprofile for " . $current_user_name . "\n";
                file_put_contents($logfile, $logcontent);
                $fail_updates++;
            }
            else {
                $logcontent = file_get_contents($logfile);
                $logcontent .= $current_user_name . " towns successfuly updated\n";
                file_put_contents($logfile, $logcontent);
                $success_updates++;
            }
            $current_user_name = $csv[$i][0];
            $current_user_visited_towns_list = $csv[$i][1];
        }
        else {
            $current_user_visited_towns_list = $current_user_visited_towns_list . "," . $csv[$i][1];       
            if ($csv[$i][0] == $current_user_name and $i == $num_of_entries-1) {
                $logcontent = file_get_contents($logfile);
                $logcontent .= "User " . $current_user_name . " visited towns: " . $current_user_visited_towns_list . "\n";
                file_put_contents($logfile, $logcontent);
    
                $command = "wp bp xprofile data set --user-id=" . "'" . $current_user_name . "'" . " --field-id=6 --value=" . "'" . $current_user_visited_towns_list . "'";
                $output=null;
                $result_code=null;
                exec($command, $output, $result_code);
                if ($result_code != 0) {
                    $logcontent = file_get_contents($logfile);
                    $logcontent .= "Failed to update xprofile for " . $current_user_name . "\n";
                    file_put_contents($logfile, $logcontent);
                    $fail_updates++;
                }
                else {
                    $logcontent = file_get_contents($logfile);
                    $logcontent .= $current_user_name . " towns successfuly updated\n";
                    file_put_contents($logfile, $logcontent);
                    $success_updates++;
                }
            }
            
        }
    }
    $logcontent = file_get_contents($logfile);
    $logcontent .= $current_user_name . "script completed running with a total of " . $success_updates . " users updated and " . $fail_updates . " users failed to update\n";
    file_put_contents($logfile, $logcontent);
    echo "script completed running with a total of " . $success_updates . " users updated and " . $fail_updates . " users failed to update\n";
?>