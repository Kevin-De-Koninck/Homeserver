<?php
//include_once 'security/dbconfig.php';
?>

<?php

//if($user->is_loggedin()){
    $database = strtolower($database);

    //start of the form
    echo "<form method='post' action='functions/SnakeCareApp/modifyDB.php'>";

        //hidden inputs: used to pass variables
        echo "<input type='hidden' name='database' value='" . $database . "'>";   //database name
        echo "<input type='hidden' name='table' value='" . $table . "'>";         //table name
        echo "<input type='hidden' name='toDoVal' value='" . $toDoVal . "'>";     //dropdown menu value
        echo "<input type='hidden' class='todovalue' name='toDoVal'>";            //this value is dynamically adjusted in SnakeCareApp.php

        //for each element of the array, use a hidden input to pass the array variables
        foreach($columns as $value) {
          echo "<input type='hidden' name='columns[]' value='". $value. "'>";
        }
        for($i = 0; $i < count($columns); $i++){
            //we don't want to input or edit a Timestap

            if($columns[$i] == "Timestamp"){
                echo "<div>";
                echo "<input required name='Timestamp' type='date' id='Timestamp' class='datepicker Timestamp' placeholder='Date'>";
                echo "</div>";
            }
            elseif($columns[$i] == "ID"){
                echo "<div>";
                echo "<input required name='ID' type='number' min'1' id='ID' type='text' class='validate ID'>";
                echo "</div>";
            }
            elseif($columns[$i] == "Value"){
                echo "<div class='col'>";
                if($table == "stats")
                    echo "<input required name='Value' id='Value' type='text' class='validate Value'>";
                else
                    echo "<input required name='Value' id='Value' type='number' min='1' class='validate Value'>";
                echo "</div>";
            }
            else{
                echo "<div class='col'>";
                echo "<input required name='" . $columns[$i] . "' id='" . $columns[$i] . "' type='text' class='validate " . $columns[$i] . "'>";
                echo "</div>";
            }
        }

        //displays the submit button
        echo "<div class='row'>";
        echo "<button type='submit' name='action'>Submit</button>";
        echo "</div>";

    //end of the form
    echo "</form>";
//} //is user logged in


        echo "<div class='row' style='position: relative; bottom: 0px; left:10px'>";

//        if($user->is_loggedin())
//            echo "<div class='col s9 offset-s2' style='position: relative; bottom: 56px; left:0px'>";
//        else
//            echo "<div class='col s9' style='position: relative; bottom: -25px; left:0px'>";

        //form to download the complete table as CSV file
        echo "<form action='functions/reptilePage/downloadDatabase.php' method='post'>";
        echo "<input type='hidden' name='reptileName' value='$reptileName'>";
        echo "<input type='hidden' name='table' value='$table'>";
        echo "<input type='submit' value='Download table (*.csv)' class='btn btn-primary' style='margin-right:30px'>";
        echo "</form>";



        echo "</div>";

?>
