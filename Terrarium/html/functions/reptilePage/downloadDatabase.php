<?php
    include("../database_conf.php");
    $reptileName = $_POST['reptileName'];
    $database = strtolower($reptileName);
    $table = $_POST['table'];

    //start the database connection
    try {
    $dbh = new PDO("mysql:host=$servername;dbname=$database", $username, $password);
    }
    catch(PDOException $e)
    {
       echo $e->getMessage();
    }

    //First get the column names (header)
    $query = "DESCRIBE $table";
    $stmt = $dbh->prepare($query);
    $stmt->execute();
    $table_fields = $stmt->fetchAll(PDO::FETCH_COLUMN);
    $output = implode(',', $table_fields) . "\r\n";

    // Next get the data
    //Produces the query
    if($table == "stats")
        $query = "SELECT * FROM $table ORDER BY $table . ID ASC";
    else
        $query = "SELECT * FROM $table ORDER BY $table . Timestamp ASC";

    //executes the query
    $stmt = $dbh->prepare($query);
    $stmt->execute();
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $output .= implode(',', $row) . "\r\n";
    }
    str_replace("ID","id",$output); // the first cell can't be named 'ID' in a csv file

    // Download the file
    $filename =  $table . ".csv";
    header('Content-type: application/csv');
    header('Content-Disposition: attachment; filename='.$filename);
    header("Pragma: no-cache");
    header("Expires: 0");
    echo $output;

    //Make sure to close out the database connection
    $dbh = null;
    exit;
?>
