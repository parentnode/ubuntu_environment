<!DOCTYPE html>
<html lang="en">
<head>
	<!-- (c) & (p) parentnode.dk 2009-2014 //-->
	<!-- All material protected by copyrightlaws, as if you didnt know //-->
	<!-- If you want to help build the ultimate frontend-centered platform, visit parentnode.dk -->
	<title>Janitor AWstats</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="keywords" content="" />
	<meta name="description" content="" />
	<meta name="viewport" content="initial-scale=1, user-scalable=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<link type="text/css" rel="stylesheet" media="all" href="http://parentnode.dk/janitor/css/seg_desktop.css" />
	<script type="text/javascript" src="http://parentnode.dk/janitor/js/seg_desktop.js"></script>
</head>

<body class="awstats">

<div id="page" class="i:page">

	<div id="header">
		<ul class="servicenavigation">
			<li class="keynav front"><span class="janitor">Janitor AWStats</span></li>
		</ul>
		
	</div>

	<div id="content">

		<div class="scene">
			<h1>Available AWStats configurations</h1>
			<ul>
<?php
			$handle = opendir("/etc/awstats/");
			if($handle) {
				while(($file = readdir($handle)) !== false) {

					//	print "existing file:".$file."<br>\n";
					if(preg_match("/\.conf$/", $file) && $file != "awstats.conf" && $file != "awstats.conf.local") {

						$config = preg_replace("/awstats\./", "", preg_replace("/\.conf$/", "", $file));
						print '<li><a href="/awstats.pl?config='.$config.'">'.$config.'</a></li>';
					}
				}
			}
?>
			</ul>

			<p>
				If you don't see any options listed, ask your ServerAdmin to run the 
				<strong>update_awstats</strong> command.
			</p>

		</div>
	</div>

	<div id="navigation"></div>

	<div id="footer">
		<ul class="servicenavigation">
			<li class="copyright">Janitor, Manipulator, Modulator - parentNode - Copyright 2014</li>
		</ul>
	</div>

</div>

</body>
</html>
