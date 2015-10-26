##############################################
##############################################

##### THIS SCRIPT ASSUMES AN EMPTY ROOT PASSWORD FOR MYSQL

##############################################
##############################################


#Read the needed variables
mysqluser='root'
mysqlpass=''
wpdatabase='wordpress'
wppassword='W0rdpress!'
wpuser='wordpress'
webroot'/usr/local/nginx/html/'


# Create relevant database, user and set privileges

mysql -u $mysqluser -p$mysqlpass << EOF
CREATE DATABASE $wpdatabase;
CREATE USER $wpuser@localhost IDENTIFIED BY "$wppassword";
GRANT ALL PRIVILEGES ON $wpdatabase.* TO $wpuser@localhost;
FLUSH PRIVILEGES;
EOF

# Download latest WordPress and useful packages

cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
yes | sudo apt-get update
yes | sudo apt-get install php5-gd libssh2-php
cd ~/wordpress
cp wp-config-sample.php wp-config.php

# Do WordPress configuration

sed -i "s:database_name_here:$wpdatabase:g" ~/wordpress/wp-config.php
sed -i "s:username_here:$wpuser:g" ~/wordpress/wp-config.php
sed -i "s:password_here:$wppassword:g" ~/wordpress/wp-config.php

# Copy our files to the webroot

sudo rsync -avP ~/wordpress/ $webroot

# Set permissions

cd $webroot
sudo chown -R www-data:www-data *
mkdir wp-content/uploads
sudo chown -R :www-data wp-content/uploads
rm -rf ~/wordpress

# Tell user to finish using browser

clear
echo "Done! Approach your server through the browser now."