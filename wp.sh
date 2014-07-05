#!/bin/bash
# Set some colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m' #no color

# output codes
success="${green}Success!${NC}"
error="${red}Failed${NC}"

# Get user input
echo -e "Enter Database Name: "
read -e dbname
echo -e "Enter Database User: "
read -e dbuser
echo -e "Enter Database Password: "
read -s dbpass
echo -e "run install? (y/n)"
read -e run
if [ "$run" == n ]; then 
	echo -e "${red}Exiting... Goodbye${NC}"
	exit
else
	#download wordpress
	echo -e "Downloading from http://wordpress.org/latest.tar.gz"
	curl -O http://wordpress.org/latest.tar.gz
	echo -e $success
	#unzip wordpress
	echo -e "Extracting contents..."
	tar -zxf latest.tar.gz
	echo -e $success
	#change dir to wordpress
	echo -e "Changing to directory 'wordpress'"
	cd wordpress
	echo -e $success
	#copy file to parent dir
	echo -e "Copying files to root directory..."
	cp -rf . ..
	echo -e $success
	#move back to parent dir
	echo -e "Changing directory back to root directory"
	cd ..
	echo -e $success
	#remove files from wordpress folder
	echo -e "Removing old files..."
	rm -R wordpress
	echo -e $success
	
	#create wp config
	echo -e "Creating wp-config.php"
	mv wp-config-sample.php wp-config.php
	echo -e $success
	#set database details with perl find and replace
	echo -e "Replacing defaults.."
	sed -i "" "s/database_name_here/$dbname/g" wp-config.php
	echo -e "${green}database_name_here -> $dbname${NC}"
	sed -i "" "s/username_here/$dbuser/g" wp-config.php
	echo -e "${green}username_here -> $dbuser${NC}"
	sed -i "" "s/password_here/$dbpass/g" wp-config.php
	echo -e "${green}password_here -> YOUR_SECRET_PASSWORD ${NC}"
	curl https://api.wordpress.org/secret-key/1.1/salt/ > keys
	sed -e '45r keys' -e '45,52d' wp-config.php
	echo -e $success
	#set wp permissions
	echo -e "Setting Permissions"
	find . -type f -exec chmod 644 {} \;
	echo -e "${green} Files -> 644 ${NC}"
	find . -type d -exec chmod 755 {} \;
	echo -e "${green} Directories -> 755 ${NC}"
	#create uploads folder and set permissions
	echo -e "Creating wp-content/uploads"
	mkdir wp-content/uploads
	chmod 777 wp-content/uploads
	echo -e $success
	#create .htaccess
	echo -e "Creating .htaccess file..."
	touch .htaccess
	chmod 644 .htaccess
	echo -e $success
	#create databse
	echo -e "Create mysql database? (y/n)"
	read -e createDB
	if [ "$createDB" == y ]; then
		mysql -u "$dbuser" -p -e "create database $dbname"
		if ["$?" = "0"]; then
			echo -e "${green}Database Created${NC}"
		else
			dbFail =echo -e "${red}Database Creation failed${NC}"
		fi
	fi
	

	#remove zip file
	echo -e "Cleaning up install files..."
	rm latest.tar.gz
	rm index.html
	#remove bash script
	rm wp.sh
	echo -e $success
	if [ $dbFail ]; then
		echo -e "${yellow}WARN: Wordpress has been installed but you must create the database manually ${NC}"
	fi
	echo -e "${green}Wordpess install complete! ${NC}" 
fi
