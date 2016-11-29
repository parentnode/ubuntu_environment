echo
echo "RACKSPACE TOOLS"

read -p "Install Rackspace Monitoring Agent (Y/n): " install_monitoring_agent
if test "$install_monitoring_agent" = "Y"; then

	# RACKSPACE MONITORING AGENT
	echo "deb http://stable.packages.cloudmonitoring.rackspace.com/ubuntu-14.04-x86_64 cloudmonitoring main" > /etc/apt/sources.list.d/rackspace-monitoring-agent.list
	curl https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc | apt-key add -
	aptitude update
	aptitude install rackspace-monitoring-agent
	rackspace-monitoring-agent --setup

	service rackspace-monitoring-agent start

else
	echo "Skipping Monitoring Agent"
fi

