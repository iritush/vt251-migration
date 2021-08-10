<?
$db_conn = mysql_connect("localhost", "vt251_vt251", "9q;Gdu874jLi");
mysql_select_db("vt251_251", $db_conn);

$query = "SELECT * FROM `migration_members_web_users_minus_dups_email`;";
$result = mysql_query($query, $db_conn);
$num_results = mysql_num_rows($result);
echo "found " . $num_results . " lines\n";
    for ($i=0; $i <$num_results;$i++){
    $paid_thru = mysql_result($result, $i, "paid_thru");
    $is_match = preg_match('/^\d{4}$/', $paid_thru, $matches);
    if ($is_match) {
        $member_id = mysql_result($result, $i, "member_id");
        echo "match! for " . $member_id . ": " . $paid_thru . "\n";
        $new_value = $paid_thru . "-6-30";
        echo "New date: " . $new_value . "\n";
        $this_query = "UPDATE `migration_members_web_users_minus_dups_email` SET paid_thru = '$new_value' WHERE member_id='$member_id';";
        $this_result = mysql_query($this_query, $db_conn);
        print_r ($this_result);
    }
}
$query = "SELECT * FROM `migration_members_no_web_email`;";
$result = mysql_query($query, $db_conn);
$num_results = mysql_num_rows($result);
echo "found " . $num_results . " lines\n";
    for ($i=0; $i <$num_results;$i++){
    $paid_thru = mysql_result($result, $i, "paid_thru");
    $is_match = preg_match('/^\d{4}$/', $paid_thru, $matches);
    if ($is_match) {
        $member_id = mysql_result($result, $i, "member_id");
        echo "match! for " . $member_id . ": " . $paid_thru . "\n";
        $new_value = $paid_thru . "-6-30";
        echo "New date: " . $new_value . "\n";
        $this_query = "UPDATE `migration_members_no_web_email` SET paid_thru = '$new_value' WHERE member_id='$member_id';";
        $this_result = mysql_query($this_query, $db_conn);
        print_r ($this_result);
    }
}
mysql_close($db_conn);
?>