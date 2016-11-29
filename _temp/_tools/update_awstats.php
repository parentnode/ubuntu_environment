#!/usr/bin/php
<?php

// read available apache logs
// create mathing awstats conf
copy("/srv/tools/configuration/awstats/index.php", "/srv/awstats/site/index.php");

$handle = opendir("/var/log/apache2/");
if($handle) {
	while(($file = readdir($handle)) !== false) {

		if(preg_match("/_access_log$/", $file) || $file == "access.log") {

			$name = preg_replace("/_access_log$/", "", $file);

			if(!file_exists("/etc/awstats/awstats.".$name.".conf")) {

				$logfile = "/var/log/apache2/".$file;

				print "Adding: ".$name."\n";
				$model = file_get_contents("/etc/awstats/awstats.conf");

				// replace relevant data
				$model = preg_replace("/LogFile=\"\/var\/log\/apache2\/access.log\"/", 'LogFile="'.$logfile.'"', $model);
				$model = preg_replace("/SiteDomain=\"\"/", 'SiteDomain="*"', $model);
				$model = preg_replace("/AllowToUpdateStatsFromBrowser=0/", 'AllowToUpdateStatsFromBrowser=1', $model);
#					$model = preg_replace("/AllowAccessFromWebToAuthenticatedUsersOnly=0/", 'AllowAccessFromWebToAuthenticatedUsersOnly=1', $model);

				// Write new conf file
				file_put_contents("/etc/awstats/awstats.".$name.".conf", $model);
			}
		}
	}
}

?>
