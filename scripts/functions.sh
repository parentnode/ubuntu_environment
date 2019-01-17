checkPath()
{
	path=$1	
	if [ ! -d "$path" ]; then
		mkdir $path
	else 
		echo "Allready Exist"
	fi
}
export checkPath