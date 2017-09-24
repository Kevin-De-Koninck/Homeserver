<?php
//This page refreshes every 10s and shows a last received temperature from the database

    header("Refresh: 10");

    include("functions/database_conf.php");
    try {
        $dbname="sensors";
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );
    }
    catch(PDOException $e) {
        echo $e->getMessage();
    }

    $sql = "SELECT Value FROM temphotspot ORDER BY Timestamp DESC LIMIT 1";

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $row = $stmt->fetch();
    echo $row["Value"];
?>
