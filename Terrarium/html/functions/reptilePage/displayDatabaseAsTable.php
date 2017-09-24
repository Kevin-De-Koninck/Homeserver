<?php
    include("functions/database_conf.php");
    $database = strtolower($database);

    //start the database connection
    try {
    $dbh = new PDO("mysql:host=$servername;dbname=$database", $username, $password);
    }
    catch(PDOException $e)
    {
       echo $e->getMessage();
    }
    //http://stackoverflow.com/questions/279170/utf-8-all-the-way-through
    $dbh->query("SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8'");

    //Produces the query
    if($table == "stats")
        $query = "SELECT * FROM `" . $table . "` ORDER BY `" . $table . "` . `ID` ASC";
    elseif($table == "length" || $table == "weight")
        $query = "SELECT * FROM `" . $table . "` ORDER BY `" . $table . "` . `Timestamp` ASC";
    else
        $query = "SELECT * FROM (SELECT * FROM `".$table."` ORDER BY `".$table."` . `Timestamp` DESC LIMIT 10)sub ORDER BY `Timestamp` ASC";

    //executes the query and returns to the correct page
    $stmt = $dbh->prepare($query);
    $stmt->execute();

    //DISPLAY THE QUERY RESULT

            // start a table tag in the HTML
            echo "<table class=\"table table-hover\">";

                //start table head
                echo "<thead class=\"thead-inverse\"><tr>";
                    for($i = 0; $i < count($columns); $i++){

                        // if($user->is_loggedin()){
                        //     echo "<th>" . $columns[$i] . "</th>";
                        // }
                        // else{
                            if($columns[$i] == "Timestamp")
                                echo "<th class=\"w-15\">" . $columns[$i] . "</th>";
                            elseif ($columns[$i] != "ID")
                                echo "<th>" . $columns[$i] . "</th>";
                        //}

                    }
                //end table head
                echo "</tr></thead>";

                //open the table body
                echo "<tbody>";

                    //loop through results and display them
                    while($column = $stmt->fetch()){
                        echo "<tr>";
                        for($i = 0; $i < count($columns); $i++){
                            if($columns[$i] == "Timestamp"){
                                //strip date from the timestamp
                                $date = substr($column[$columns[$i]], 0, 10);

                                //get day, month and year
                                $day = substr($date,8,2);
                                $month = substr($date,5,2);
                                $year = substr($date,0,4);

                                //dd-mm-yyyy
                                echo "<td>" . $day . "-" . $month . "-" . $year . "</td>";
                            }
                            elseif($columns[$i] == "ID"){
                                // if($user->is_loggedin())
                                //     echo "<td>" . $column[$columns[$i]] . "</td>";
                            }
                            else
                                echo "<td>" . $column[$columns[$i]] . "</td>";
                        }
                        echo "</tr>";
                    }

                //Close the table body
                echo "</tbody>";

            //end the table
            echo "</table>";

    //END OF DISPLAYING THE QUERY RESULT

    //Make sure to close out the database connection
    $dbh = null;
?>
