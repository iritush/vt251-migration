<?
$db_conn = mysql_connect("localhost", "vt251_vt251", "9q;Gdu874jLi");
mysql_select_db("vt251_251", $db_conn);

$query = "SELECT member_id, 251_user_id, COUNT(member_id)
FROM 251_paid_map
GROUP BY member_id
HAVING COUNT(member_id)>1
ORDER BY member_id;";

$result = mysql_query($query, $db_conn);
$num_results = mysql_num_rows($result);

for ($i=0; $i <$num_results;$i++){
    $current_member_users = "";
    $member_id = mysql_result($result, $i, "member_id");
    $this_query = "SELECT 251_user_id from 251_paid_map WHERE member_id='$member_id';";
    $this_result = mysql_query($this_query, $db_conn);
    $num_this_result = mysql_num_rows($this_result);
    for ($j=0; $j<$num_this_result;$j++) {
        $current_user_id = mysql_result($this_result, $i, "251_user_id");
        $current_member_users = $current_member_users . ", " . $current_user_id;        
    }
    echo "Users for member " . $member_id . ": " . $current_member_users . "\n";
}
mysql_close($db_conn);
?>