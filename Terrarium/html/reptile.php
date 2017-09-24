<?php
$reptileName = $_POST['reptileName'];
$database = &$reptileName;
?>

<html>
    <head>
    <?php include('functions/website_layout/header.php'); ?>
    <script src="frameworks/highcharts.js"></script>
    <script src="frameworks/bootstrapAlert.js"></script> <!-- http://www.jqueryscript.net/other/Toast-like-Alert-Popup-Plugin-With-jQuery-Bootstrap-bootstrapAlert.html -->
    </head>

    <body>
        <?php include('functions/website_layout/menu.php'); ?>
    <main>

      <div class="container">

        <div class="jumbotron jumbotron-fluid">
          <div class="container">
            <h1 class="display-3"><?php echo $reptileName; ?></h1>
            <p class="lead">Health care page.</p>
          </div>
        </div>







<ul class="nav nav-tabs nav-justified" id="myTab" role="tablist">
  <li class="nav-item" style="margin-right: 10px;">
    <a class="nav-link blue active" data-toggle="tab" href="#info" role="tab" aria-controls="info">Info</a>
  </li>
  <li class="nav-item" style="margin-right: 10px;">
    <a class="nav-link green" data-toggle="tab" href="#feedings" role="tab" aria-controls="feedings">Feedings</a>
  </li>
  <li class="nav-item" style="margin-right: 10px;">
    <a class="nav-link orange" data-toggle="tab" href="#length" id="lengthTab" role="tab" aria-controls="length">Length</a>
  </li>
  <li class="nav-item" style="margin-right: 10px;">
    <a class="nav-link purple" data-toggle="tab" href="#weight" id="weightTab" role="tab" aria-controls="weight">Weight</a>
  </li>
  <li class="nav-item" style="margin-right: 10px;">
    <a class="nav-link appleBlueSeeGreen" data-toggle="tab" href="#shedding" role="tab" aria-controls="shedding">Shedding</a>
  </li>
  <li class="nav-item">
  <a class="nav-link red" data-toggle="tab" href="#others" role="tab" aria-controls="others">Others</a>
</li>
</ul>

<div class="tab-content">
  <div class="tab-pane active" id="info" role="tabpanel">
    <?php $table="stats"; $columns=array("ID","Info","Value");
    include('functions/reptilePage/displayDatabaseAsTable.php'); /* include('functions/reptilePage/formHandlingDatabase.php'); */ ?>
  </div>

  <div class="tab-pane" id="feedings" role="tabpanel">
    <?php $table="food"; $columns=array("ID","Timestamp","What","Dead","Refused");
    include('functions/reptilePage/displayDatabaseAsTable.php');  include('functions/reptilePage/formHandlingDatabase.php'); ?>
  </div>

  <div class="tab-pane" id="length" role="tabpanel">
    <?php $table="length"; $columns=array("ID","Timestamp","Value"); ?>
    <br><div id="graphLength"></div>
    <?php include('functions/reptilePage/formHandlingDatabase.php'); ?>
  </div>

  <div class="tab-pane" id="weight" role="tabpanel">
    <?php $table="weight"; $columns=array("ID","Timestamp","Value"); ?>
    <br><div id="graphWeight"></div>
    <?php include('functions/reptilePage/formHandlingDatabase.php'); ?>
  </div>

  <div class="tab-pane" id="shedding" role="tabpanel">
    <?php $table="shedding"; $columns=array("ID","Timestamp","Result");
    include('functions/reptilePage/displayDatabaseAsTable.php'); include('functions/reptilePage/formHandlingDatabase.php'); ?>
  </div>

  <div class="tab-pane" id="others" role="tabpanel">
    <?php $table="others"; $columns=array("ID","Timestamp","What");
    include('functions/reptilePage/displayDatabaseAsTable.php'); include('functions/reptilePage/formHandlingDatabase.php'); ?>
  </div>
</div>






  <div class="form-horizontal">
    <fieldset>
      <legend>Administration</legend>

      <div class="form-group">
        <label for="toDo" class="col-lg-4 control-label">What do you want to do?</label>
        <div class="col-lg-6">
          <select class="form-control toDo" name="toDo" id="toDo">
            <option value="" disabled selected>Choose your option</option>
            <option value="Add">Add</option>
            <option value="Update">Update</option>
            <option value="Remove">Remove</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="" class="col-lg-4 control-label">Timestamp</label>
        <div class="col-lg-6">
          <div>
             <input required name='Timestamp' type='date' id='Timestamp' class='datepicker Timestamp form-control' placeholder='Date'>
           </div>
        </div>
      </div>

      <div class="form-group">
        <label for="ID" class="col-lg-4 control-label">ID</label>
        <div class="col-lg-6">
          <div>
              <input required name='ID' type='number' min'1' id='ID' type='text' class='validate ID form-control'>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label for="Value" class="col-lg-4 control-label">Value</label>
        <div class="col-lg-6">
          <div>
            <input required name='Value' id='Value' type='number' min='1' class='validate Value form-control'>
          </div>
        </div>
      </div>






      <div class="form-group">
        <div class="col-lg-12">
           <form action='functions/reptilePage/downloadDatabase.php' method='post'>
               <input type='hidden' name='reptileName' value=<?php echo $reptileName ?>>
               <input type='hidden' name='table' value=<?php echo $table ?>>
               <input type='submit' value='Download table (*.csv)' class='btn btn-primary col-lg-4' style='margin-right:30px'>
           </form>
         </div>
       </div>


    </fieldset>
  </div>











<!-- Container -->
</div>



<!-- Is executed when the page is loaded -->
<script>
    $( document ).ready(function() {
        hideAllInput();
        $('select').material_select();

        if($( window ).width()<775){
            to_small_window();
            display_toast = 0;
        }
    });
</script>

<!-- Will show first tab when page is loaded -->
<script>
  $(function () {
    $('#myTab a:first').tab('show')
  })
</script>

<!-- Is executed when the value of the dropdown menu changes -->
<script>
    $( ".toDo" ).change(function() {
        updateFields();
    });
</script>

<!-- Updates the input fields (dynamic enable/disable) based on dropdown menu -->
<script>
    function updateFields() {

        //get the selected value of the dropdown menu
        var e = document.getElementById("toDo");
        var toDoVal = e.options[e.selectedIndex].value;

        //this will dynamically change the value of all the inputs (class: todovalue) in formHandling.php
        var x = document.getElementsByClassName("todovalue");
        for(var i = 0; i < x.length; i++) {
            x[i].value = toDoVal;
        }

        //update input states to match dropdown menu selection
        if(toDoVal == "Add"){
            $('.ID').attr('disabled', true);
            $('.Timestamp').attr('disabled', true);
            $('.What').attr('disabled', false);
            $('.Dead').attr('disabled', false);
            $('.Refused').attr('disabled', false);
            $('.Result').attr('disabled', false);
            $('.Info').attr('disabled', false);
            $('.Value').attr('disabled', false);
            $('.Timestamp').attr('disabled', false);
            $('.btnSubmit').attr('disabled',false);
        }
        else if(toDoVal == "Update"){
            $('.ID').attr('disabled', false);
            $('.Timestamp').attr('disabled', true);
            $('.What').attr('disabled', false);
            $('.Dead').attr('disabled', false);
            $('.Refused').attr('disabled', false);
            $('.Result').attr('disabled', false);
            $('.Info').attr('disabled', true);
            $('.Value').attr('disabled', false);
            $('.Timestamp').attr('disabled', false);
            $('.btnSubmit').attr('disabled',false);
        }
        else{
            $('.ID').attr('disabled', false);
            $('.Timestamp').attr('disabled', true);
            $('.What').attr('disabled', true);
            $('.Dead').attr('disabled', true);
            $('.Refused').attr('disabled', true);
            $('.Result').attr('disabled', true);
            $('.Info').attr('disabled', true);
            $('.Value').attr('disabled', true);
            $('.Timestamp').attr('disabled', true);
            $('.btnSubmit').attr('disabled',false);
        }
    }
</script>

<!-- Disables all input fields when executed -->
<script>
    function hideAllInput(){
        $('.ID').attr('disabled', true);
        $('.Timestamp').attr('disabled', true);
        $('.What').attr('disabled', true);
        $('.Dead').attr('disabled', true);
        $('.Refused').attr('disabled', true);
        $('.Result').attr('disabled', true);
        $('.Info').attr('disabled', true);
        $('.Value').attr('disabled', true);
        $('.Timestamp').attr('disabled', true);
        $('.btnSubmit').attr('disabled',true);
    }
</script>

<!-- This will show a toast when the window is too narrow (impssible to display the tables correctly) -->
<script>
    function to_small_window(){
      BootstrapAlert.alert({
        title: "Warning!",
        message: "Your display or window is too narrow.\nPlease enlarge the window or use phone in landscape mode."
      });
    }

    var display_toast = 1;
    $(window).on('resize', function(){
        var win = $(this); //this = window
        if (win.width() > 775){
            $(".nav-justified").show();
            $(".tab-content").show();
        }
        else{
            $(".nav-justified").hide();
            $(".tab-content").hide();
            if(display_toast > 0){
                to_small_window();
                display_toast = 0;
            }
        }
    });
</script>

<!-- Will display the graph for the length -->
<script>
$(function () {
$('#graphLength').highcharts({
  chart: {
    type: 'spline'
  },
            title: {
    text: 'Length',
                style: {
                    display: 'none'
                }
  },
  xAxis: {
    type: 'datetime',
    dateTimeLabelFormats: { // don't display the dummy year
        millisecond: '%H:%M:%S.%L',
        second: '%H:%M:%S',
        minute: '%H:%M',
        hour: '%H:%M',
        day: '%e. %b',
        week: '%e. %b',
        month: '%b \'%y',
        year: '%Y'
    },
    title: {
      text: 'Date'
    }
  },
  yAxis: {
    title: {
      text: 'Length [cm]'
    }
  },
  tooltip: {
      formatter: function() {
        return  '<b>' + this.series.name +'</b><br/>' +
          Highcharts.dateFormat('%e %b %Y', new Date(this.point.x))
          + ' - ' + this.point.y + ' cm'
                            <?php
//                              if($user->is_loggedin())
//                                    echo "+ ' - ID: ' + this.point.z;";
//                                  else
                                    echo ";";
                            ?>
      }
  },

  plotOptions: {
    spline: {
      marker: {
        enabled: false
      }
    }
  },

  series: [{
                showInLegend: false,
                color: '#ff8800',
    name: 'Length',
    data: [
      <?php
        // Create connection
        $conn = new mysqli($servername, $username, $password, strtolower($reptileName));

        // Check connection
        if ($conn->connect_error) {
          die("Connection failed: " . $conn->connect_error);
        }

                        $sql = "SELECT * FROM (SELECT * FROM length ORDER BY Timestamp DESC)sub ORDER BY Timestamp ASC";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
          // output data of each row
          $iterator = 0;
          while($row = $result->fetch_assoc()) {
            //Put a "," when we have more than one data-point
            if($iterator>0){
              echo ",";
            }

            $timestamp = strtotime($row["Timestamp"])*1000;
            //dataformt: [epoch-timi-in-miliseconds, data]

//                                if($user->is_loggedin())
                                    echo "{x: ".$timestamp.", y: ".$row["Value"].", z: ".$row["ID"]."}";
//                                else
//                                    echo "{x: ".$timestamp.", y: ".$row["Value"]."}";

            $iterator = $iterator + 1;
          }
        }

        $conn->close();
      ?>
    ]
  }]
});
        $('#lengthTab').on('click', function () {
            setInterval(function () {
                $('#graphLength').highcharts().reflow();
            }, 10);
        });
});
</script>



<!-- Will display the graph for the weight -->
<script>
$(function () {
$('#graphWeight').highcharts({
  chart: {
    type: 'spline'
  },
            title: {
    text: 'Weight',
                style: {
                    display: 'none'
                }
  },
  xAxis: {
    type: 'datetime',
    dateTimeLabelFormats: { // don't display the dummy year
        millisecond: '%H:%M:%S.%L',
        second: '%H:%M:%S',
        minute: '%H:%M',
        hour: '%H:%M',
        day: '%e. %b',
        week: '%e. %b',
        month: '%b \'%y',
        year: '%Y'
    },
    title: {
      text: 'Date'
    }
  },
  yAxis: {
    title: {
      text: 'Weight'
    }
  },
  tooltip: {
      formatter: function() {
        return  '<b>' + this.series.name +'</b><br/>' +
          Highcharts.dateFormat('%e %b %Y', new Date(this.point.x))
          + ' - ' + this.point.y + ' gram'
                            <?php
//                            if($user->is_loggedin())
                                    echo "+ ' - ID: ' + this.point.z;";
//                                  else
//                                    echo ";";
                            ?>
      }
  },

  plotOptions: {
    spline: {
      marker: {
        enabled: false
      }
    }
  },

  series: [{
                showInLegend: false,
                color: '#9933cc',
    name: 'Weight',
    data: [
      <?php
        // Create connection
        $conn = new mysqli($servername, $username, $password, strtolower($reptileName));
        // Check connection
        if ($conn->connect_error) {
          die("Connection failed: " . $conn->connect_error);
        }

                        $sql = "SELECT * FROM (SELECT * FROM weight ORDER BY Timestamp DESC)sub ORDER BY Timestamp ASC";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
          // output data of each row
          $iterator = 0;
          while($row = $result->fetch_assoc()) {
            //Put a "," when we have more than one data-point
            if($iterator>0){
              echo ",";
            }

            $timestamp = strtotime($row["Timestamp"])*1000;
            //dataformt: [epoch-timi-in-miliseconds, data]

//                                if($user->is_loggedin())
                                    echo "{x: ".$timestamp.", y: ".$row["Value"].", z: ".$row["ID"]."}";
//                                else
//                                    echo "{x: ".$timestamp.", y: ".$row["Value"]."}";

            $iterator = $iterator + 1;
          }
        }

        $conn->close();
      ?>
    ]
  }]
});
        $('#weightTab').on('click', function () {
            setInterval(function () {
                $('#graphWeight').highcharts().reflow();
            }, 10);
        });
});
</script>




    </main>
        <?php include('functions/website_layout/footer.php'); ?>
    </body>

</html>
