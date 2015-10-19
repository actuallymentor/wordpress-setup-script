
#Read the needed variables
clear
echo "What is your MySQL user? (This is usually 'root')"
read mysqluser
clear
echo "What is your MySQL root password? (this is not saved anywhere)"
echo "Typing your password will NOT be visible, you are typing though."
while true
do
    read -s -p "Password: " mysqlpass
    echo
    read -s -p "Password (again): " mysqlpass2
    echo
    [ "$mysqlpass" = "$mysqlpass2" ] && break
    echo "Please try again"
done
clear
echo "What database name do you want to use?"
read wpdatabase
clear
echo "What username do you want to use?"
read wpuser
clear
echo "What database password do you want to use?"
while true
do
    read -s -p "Password: " wppassword
    echo
    read -s -p "Password (again): " wppassword2
    echo
    [ "$wppassword" = "$wppassword2" ] && break
    echo "Please try again"
done
clear
echo "What is your webroot? Example /var/www/html"
read webroot
clear

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