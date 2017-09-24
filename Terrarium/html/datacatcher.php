<?php
// This is the data catcher, but currently also the settings sender
// todo SPLIT THESE FILES

    include("functions/database_conf.php");

    // Connect to the database table
    try {
        $dbname="sensors";
        $dbh = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $dbh->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING );
    }
    catch(PDOException $e) {
        echo $e->getMessage();
    }

    // Parse the received JSON data from the http post body
    $receivedJSON = file_get_contents('php://input');
    $receivedData = json_decode($receivedJSON);

    // If we have received a reptile name and a temperature
    if (isset($receivedData->reptile) && isset($receivedData->temperature))
    {
      //Create Json data to send back
      $toSendData->hotSide = $receivedData->temperature;
      $toSendData->coldSide = 20.2;
      $toSendJson = json_encode($toSendData);
      echo $toSendJson;
    }

    // Place received data in database
    $sth = $dbh->prepare("INSERT INTO `temphotspot` (`Timestamp`, `Value`) VALUES (CURRENT_TIMESTAMP, $receivedData->temperature)");
    $sth->execute();

    //Make sure to close out the database connection
    $dbh = null;
    exit;
?>
