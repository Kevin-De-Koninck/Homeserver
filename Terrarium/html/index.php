<html>
    <head>
    <?php include('functions/website_layout/header.php'); ?>
    </head>

    <body>
        <?php include('functions/website_layout/menu.php'); ?>
    <main>

      <div class="container">

        <div class="jumbotron jumbotron-fluid">
          <div class="container">
            <h1 class="display-3">ReptiC</h1>
            <p class="lead">A terrarium and reptile controller.</p>
          </div>
        </div>






<!--

      <h2>Emphasis classes</h2>
<p class="text-muted">Fusce dapibus, tellus ac cursus commodo, tortor mauris nibh.</p>
<p class="text-primary">Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
<p class="text-warning">Etiam porta sem malesuada magna mollis euismod.</p>
<p class="text-danger">Donec ullamcorper nulla non metus auctor fringilla.</p>
<p class="text-success">Duis mollis, est non commodo luctus, nisi erat porttitor ligula.</p>
<p class="text-info">Maecenas sed diam eget risus varius blandit sit amet non magna.</p>

-->



<div class="card-deck">

  <div class="card">
    <div class="card-header">
      Reptile 1
    </div>
    <img class="card-img-top" src="/images/temp1.jpg" style="max-height:200px;">
    <div class="card-block">
      <p class="card-text">Boa Constrictor Imperator - 2m10 - 7.3kg.</p>
    </div>
    <ul class="list-group list-group-flush">
      <li class="list-group-item">
        <button type="button" class="btn btn-success" style="margin-right:30px">Reptile page</button>
        <button type="button" class="btn btn-primary">Terrarium page</button>
      </li>
    </ul>
  </div>

  <div class="card">
  <div class="card-header">
    Reptile 2
  </div>
  <img class="card-img-top" src="/images/temp2.jpg" style="max-height:200px;">
  <div class="card-block">
    <p class="card-text">Boa Constrictor Imperator - 2m10 - 7.3kg.</p>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item">
      <button type="button" class="btn btn-success" style="margin-right:30px">Reptile page</button>
      <button type="button" class="btn btn-primary">Terrarium page</button>
    </li>
  </ul>
</div>

</div>



<?php $reptileName = "Diablo" ?>
<div class="card">
  <div class="card-header">
    <?php echo $reptileName; ?>
  </div>
  <img class="card-img-top" src="/images/diablo.png" style="max-height:300px;">
  <div class="card-block">
    <p class="card-text">Boa Constrictor Imperator - 2m10 - 7.3kg.</p>
  </div>
  <ul class="list-group list-group-flush">
    <li class="list-group-item">
      <form action="reptile.php" method="post">
        <input type="hidden" name="reptileName" value=<?php echo $reptileName; ?>>
        <input type="submit" value="Reptile page" class="btn btn-success" style="margin-right:30px">
      </form>
      <form action="terrarium.php" method="post">
        <input type="hidden" name="reptileName" value=<?php echo $reptileName; ?>>
        <input type="submit" value="Terrarium page" class="btn btn-primary" style="margin-right:30px">
      </form>
    </li>
  </ul>
</div>






<!-- Container -->
</div>

        <!-- will initialise everything on the page -->
        <script>
        </script>

    </main>
        <?php include('functions/website_layout/footer.php'); ?>
    </body>

</html>
