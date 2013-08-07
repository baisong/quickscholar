# Make sure we're in the right location.
BASEDIR="/home/quickstart/Desktop/websites"
if [ -d "$BASEDIR" ]
then
    cd $BASEDIR
else
    echo "$BASEDIR does not exist"
fi

# Runs quickstart-create, then swaps out the source to OpenScholar git repo.
drush quickstart-destroy os.dev -y
drush quickstart-create os.dev -y
git clone https://github.com/openscholar/openscholar

# Database config
#USERA="root"
#PASSA="quickstart"
#DB="os_dev"
#USER="os_dev"
#PASS="os_dev"

# Wipes and re-creates the database.
#mysql -u $USERA --password=$PASSA -e "drop database $DB;"
#mysqladmin -u $USERA --password=$PASSA create os_dev
#mysql -u $USERA --password=$PASSA -e "GRANT SELECT, INSERT, UPDATE,DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `os_dev`.* TO '$USER'@'localhost' IDENTIFIED BY '$PASS';"

# Moves over the settings files.
#cp $BASEDIR/os.dev.bak/sites/default/settings.php $BASEDIR/os.dev/sites/default
#chmod 777 $BASEDIR/os.dev/sites/default/settings.php
#cp -r $BASEDIR/os.dev.bak/sites/default/files $BASEDIR/os.dev/sites/default
#chmod 777 $BASEDIR/os.dev/sites/default/files

# Runs default install
cd $BASEDIR/openscholar

# wipes the www folder and rebuilds
chmod 777 www/sites/default
rm -rf www/
mkdir www
bash scripts/build
cd www

drush si -y openscholar --account-pass=admin --db-url=mysql://os_dev:os_dev@localhost/os_dev --uri=http://os.dev openscholar_flavor_form.os_profile_flavor=development openscholar_install_type.os_profile_type=vsite
drush vset purl_base_domain 'http://os.dev'
drush en -y os_migrate_demo
drush mi --all --user=1

cd $BASEDIR
mv os.dev os.dev.bak
ln -s $BASEDIR/openscholar/www os.dev

# Opens the installed site's front page
chromium-browser& http://os.dev
#chromium-browser& http://os.dev/install.php?profile=openscholar&locale=en

