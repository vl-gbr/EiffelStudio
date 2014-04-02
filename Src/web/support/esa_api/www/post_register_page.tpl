<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="../../assets/ico/favicon.ico">
     {include file="optional_styling_css.tpl"/}     
  </head>

  <body>
     {include file="navbar.tpl"/}  

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="{$host/}/reports">Reports</a></li>
            {if isset="$user"}
                 <li><a href="{$host/}/user_reports/{$user/}">My Reports</a></li>
                 <li><a href="{$host/}/report_form">Report a Problem</a></li>
            {/if}
           </ul> 
         </div>
          <div class="container">
            <div class="row">
              <div class="span12">
                <div class="hero-unit center">
                  <h1>Eiffel Support Activation <small>
                  <br />
                  <p> An e-mail with an activation code was sent to your account.<br/>
                   Please check your email and use the provided link to <a href="{$host/}/activation">activate</a> your account.</p>
                  <p><b>Or you could just press this neat little button to go home:</b></p>
                  <a href="{$host/}" class="btn btn-large btn-info"><i class="glyphicon glyphicon-home"></i> Take Me Home</a>
                </div>
                <br />
          
            </div>
          </div>
         </div> 

      </div>
    </div>
    <!-- Placed at the end of the document so the pages load faster -->
    {include file="optional_enhancement_js.tpl"/}     
  </body>
</html>