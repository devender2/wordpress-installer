Wordpress-Installer
===================

###A shell script for automated Wordpress Installs

####Features
* Downloads the latest version of wordpress
* Sets correct permissions
* Creates .htaccess file
* Creates wp-config file
* Replaces default values of wp-config
  *  DB_NAME
  * DB_USER
  * DB_PASSOWRD
  * Authentication Unique Keys and Salts
* Creates MySQL Database

####How to use the Wordpress Install Script
1. Clone down this repo into the root directory of your WordPress site
```Shell
git clone https://github.com/devender2/wordpress-installer.git ./
```
2. Make the script executable
```Shell
chmod 755 wp.sh
```
3. Run the script and answer the questions in your terminal
```Shell
./wp.sh
``
