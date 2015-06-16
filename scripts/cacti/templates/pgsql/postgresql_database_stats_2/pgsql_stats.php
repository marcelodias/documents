<?php
/* 
 * pgsql_stats.php
 * ----------------------------------------------------------------------
 * enables cacti to read PostgreSQL statistics
 * 
 * usage:
 * pgsql_stats.php db_host section [data_idx] [db_name]
 *
 * If you wonder what valid <section> are, run the script with invalid
 * arguments, and it'll tell you.
 *
*/

function getDBIndex() {

    $query = "SELECT datname FROM pg_stat_database";

    $result = pg_query($query);
    if (!$result) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $out_str = "";
    while($myrow = pg_fetch_assoc($result)) {
        if($myrow['datname'] == 'postgres' || $myrow['datname'] == 'template0' || $myrow['datname'] == 'template1'){
        } else {
	    if($out_str == ""){
	            $out_str = $myrow['datname'];
	    } else {
	            $out_str = $out_str . "\n" . $myrow['datname'];
	    }
        }
    }

    return $out_str; 
}

function get_allDB_value($data_idx,$host,$db_name,$pg_username,$pg_password) {

    $query = "SELECT datname FROM pg_stat_database";

    $result = pg_query($query);
    if (!$result) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $out_str = ""; 
    $db_count = 0;

    while($myrow = pg_fetch_assoc($result)) {
        if($myrow['datname'] == 'postgres' || $myrow['datname'] == 'template0' || $myrow['datname'] == 'template1'){
        } else {
	        $dbarr[$db_count] = $myrow['datname'];
		$db_count++;
		
        }
    }
    for($i = 0; $i < $db_count; $i++){
	$dbname = $dbarr[$i];
	if($data_idx == "xact_commit" || $data_idx == "xact_rollback" || $data_idx == "blks_read" || $data_idx == "blks_hit"){
		$status = get_pg_stat_database($host,$dbname,$pg_username,$pg_password);
	} else if($data_idx == "seq_scan" || $data_idx == "seq_tup_read" || $data_idx == "idx_scan" || $data_idx == "idx_tup_fetch" || $data_idx == "n_tup_ins" || $data_idx == "n_tup_upd" || $data_idx == "n_tup_del") {
		$status = get_pg_stat_user_tables($host,$dbname,$pg_username,$pg_password);
	} else if($data_idx == "heap_blks_read" || $data_idx == "heap_blks_hit" || $data_idx == "idx_blks_read" || $data_idx == "idx_blks_hit" || $data_idx == "toast_blks_read" || $data_idx == "toast_blks_hit" || $data_idx == "tidx_blks_read" || $data_idx == "tidx_blks_hit"){
		$status = get_pg_statio_user_tables($host,$dbname,$pg_username,$pg_password);
	} else if($data_idx == "db_size"){
		$status = get_db_size($host,$dbname,$pg_username,$pg_password);
	} else if($data_idx == "dbname"){
		$status["dbname"] = $dbname;
	}
	if($out_str == ""){
		$out_str = $out_str . $dbname . ':' . $status["$data_idx"];
	} else {
		$out_str = $out_str . "\n" . $dbname . ':' . $status["$data_idx"];
	}
    }
    return $out_str; 
}


function get_pg_stat_database($host,$db_name,$pg_username,$pg_password) {

    $db_connection = pg_connect("host=$host dbname=$db_name user=$pg_username password=$pg_password");

    $query = "SELECT * FROM pg_stat_database where datname='$db_name'";

    $result = pg_query($query);
    $rows = pg_num_rows($result);
    if (!$result || $rows > 1) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $myrow = pg_fetch_assoc($result);
    $status["xact_commit"] = $myrow['xact_commit'];
    $status["xact_rollback"] = $myrow['xact_rollback'];
    $status["blks_read"] = $myrow['blks_read'];
    $status["blks_hit"] = $myrow['blks_hit'];

    pg_close($db_connection);

    return $status;
}

function get_pg_stat_user_tables($host,$db_name,$pg_username,$pg_password) {

    $db_connection = pg_connect("host=$host dbname=$db_name user=$pg_username password=$pg_password");

    $query = "SELECT SUM(seq_scan) as a1, SUM(seq_tup_read) as a2, SUM(idx_scan) as a3, SUM(idx_tup_fetch) as a4, SUM(n_tup_ins) as a5, SUM(n_tup_upd) as a6, SUM(n_tup_del) as a7 FROM pg_stat_user_tables";

    $result = pg_query($query);
    $rows = pg_num_rows($result);
    if (!$result || $rows > 1) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $myrow = pg_fetch_assoc($result);
    $status["seq_scan"] = $myrow['a1'];
    $status["seq_tup_read"] = $myrow['a2'];
    $status["idx_scan"] = $myrow['a3'];
    $status["idx_tup_fetch"] = $myrow['a4'];
    $status["n_tup_ins"] = $myrow['a5'];
    $status["n_tup_upd"] = $myrow['a6'];
    $status["n_tup_del"] = $myrow['a7'];

    pg_close($db_connection);

    return $status;
}

function get_connections($host,$db_name,$pg_username,$pg_password,$data_idx) {

    $db_connection = pg_connect("host=$host dbname=postgres user=$pg_username password=$pg_password");

    $query = "SELECT count(*) as cnt from pg_stat_activity where usename = '$db_name'";

    if ($data_idx == 'con_idle') {
	$query = $query." and current_query = '<IDLE>'";
    } else if ($data_idx == 'con_active') {
	$query = $query." and current_query != '<IDLE>'";
    }
    
    $result = pg_query($query);
    if (!$result) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $myrow = pg_fetch_assoc($result);
    $status[$data_idx] = $myrow['cnt'];

    pg_close($db_connection);

    return $status;
}

function get_db_size($host,$db_name,$pg_username,$pg_password) {

    $db_connection = pg_connect("host=$host dbname=postgres user=$pg_username password=$pg_password");

    $query = "SELECT pg_database_size(pg_database.datname) AS db_size FROM pg_database WHERE pg_database.datname='$db_name'";

    $result = pg_query($query);
    $rows = pg_num_rows($result);
    if (!$result || $rows > 1) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }

    $myrow = pg_fetch_assoc($result);
    $status["db_size"] = $myrow['db_size'];

    pg_close($db_connection);

    return $status;
}



function get_pg_statio_user_tables($host,$db_name,$pg_username,$pg_password) {

    $db_connection = pg_connect("host=$host dbname=$db_name user=$pg_username password=$pg_password");

    $query = "SELECT SUM(heap_blks_read) as a1, SUM(heap_blks_hit) as a2, SUM(idx_blks_read) as a3, SUM(idx_blks_hit) as a4, SUM(toast_blks_read) as a5, SUM(toast_blks_hit) as a6, SUM(tidx_blks_read) as a7, SUM(tidx_blks_hit) as a8 FROM pg_statio_user_tables";

    $result = pg_query($query);
    $rows = pg_num_rows($result);
    if (!$result || $rows > 1) {
        echo "Problem with query " . $query . "<br/>";
        echo pg_last_error();
        exit();
    }
    $myrow = pg_fetch_assoc($result);
    $status["heap_blks_read"] = $myrow['a1'];
    $status["heap_blks_hit"] = $myrow['a2'];
    $status["idx_blks_read"] = $myrow['a3'];
    $status["idx_blks_hit"] = $myrow['a4'];
    $status["toast_blks_read"] = $myrow['a5'];
    $status["toast_blks_hit"] = $myrow['a6'];
    $status["tidx_blks_read"] = $myrow['a7'];
    $status["tidx_blks_hit"] = $myrow['a8'];

    pg_close($db_connection);

    return $status;
}

/*
 * TODO: There has got to be a better way of taking args, especially
 * having a default value if nothing is passed.
 */
if ($_SERVER["argc"] == 3 || $_SERVER["argc"] == 4 || $_SERVER["argc"] == 5) {

    $pg_username = 'monitor';
    $pg_password = 'monitor';
    $db_name  = "postgres";

    if ($_SERVER["argc"] == 3 && $_SERVER["argv"][2] == 'index') {
        $host     = $_SERVER["argv"][1];
        $db_name  = "postgres";
    } else if ($_SERVER["argc"] == 4 && $_SERVER["argv"][2] == 'query') {
        $host     = $_SERVER["argv"][1];
        $data_idx = $_SERVER["argv"][3];
        $db_name  = "postgres";
    } else if ($_SERVER["argc"] == 5 && $_SERVER["argv"][2] == 'get') {
        $host     = $_SERVER["argv"][1];
        $data_idx = $_SERVER["argv"][3];
        $db_name  = $_SERVER["argv"][4];
    } else {
	die("ERROR\n");
    }

    $db_connection = pg_connect("host=$host dbname=$db_name user=$pg_username password=$pg_password");

    if ($db_connection){

        switch($_SERVER["argv"][2]) {
            case "index" :
                $output = getDBIndex();
            break;
            case "get" :
    		pg_close($db_connection);
		if($data_idx == "xact_commit" || $data_idx == "xact_rollback" || $data_idx == "blks_read" || $data_idx == "blks_hit"){
			$status = get_pg_stat_database($host,$db_name,$pg_username,$pg_password);
		} else if($data_idx == "seq_scan" || $data_idx == "seq_tup_read" || $data_idx == "idx_scan" || $data_idx == "idx_tup_fetch" || $data_idx == "n_tup_ins" || $data_idx == "n_tup_upd" || $data_idx == "n_tup_del") {
			$status = get_pg_stat_user_tables($host,$db_name,$pg_username,$pg_password);
		} else if($data_idx == "heap_blks_read" || $data_idx == "heap_blks_hit" || $data_idx == "idx_blks_read" || $data_idx == "idx_blks_hit" || $data_idx == "toast_blks_read" || $data_idx == "toast_blks_hit" || $data_idx == "tidx_blks_read" || $data_idx == "tidx_blks_hit"){
			$status = get_pg_statio_user_tables($host,$db_name,$pg_username,$pg_password);
		} else if($data_idx == "db_size"){
			$status = get_db_size($host,$db_name,$pg_username,$pg_password);
		} else if($data_idx == "con_total" || $data_idx == "con_idle" || $data_idx == "con_active"){
			$status = get_connections($host,$db_name,$pg_username,$pg_password,$data_idx);
		} else {
			echo "ERROR, wrong DATA_IDX\n";
		}
		$output =  $status[$data_idx];
            break;
            case "query" :
		$output = get_allDB_value($data_idx,$host,$db_name,$pg_username,$pg_password);
            break;
    // I guess an invalid section was passed?
            default :
                echo "Error. Unknown section.\n";
                echo "Usage: pgsql_stats.php db_host section [data_idx] [db_name]\n";
                echo "Where <section> is one of:\n ";
                die ("");
        }

	echo $output;

    } else {
        echo pg_last_error();
        die("Error: PostgreSQL connect failed. Check PostgreSQL parameters ($host/username/password)\n");
    }
    
} else {
    // passed wrong number of params
    echo "Error. Wrong parameter count.\n";
    echo "Usage: pgsql_stats.php db_host section [data_idx] [db_name]\n";
    echo "Where <section> is one of: index\n ";
    die ("");
}
?>

