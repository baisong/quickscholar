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

# Clears the openscholar git repository
if [ -d "$BASEDIR/openscholar" ]
then
    rm -rf $BASEDIR/openscholar
fi
git clone https://github.com/openscholar/openscholar
cd $BASEDIR/openscholar

# Wipes the www folder and rebuilds
chmod 777 www/sites/default
rm -rf www/
mkdir www
bash scripts/build
cd www

# runs the default install 
drush si -y openscholar --account-pass=admin --db-url=mysql://os_dev:os_dev@localhost/os_dev --uri=http://os.dev openscholar_flavor_form.os_profile_flavor=development openscholar_install_type.os_profile_type=vsite
drush vset purl_base_domain 'http://os.dev'
#drush en -y os_migrate_demo
#drush mi --all --user=1

cd $BASEDIR
if [ -d "os.dev" ]
then
    mv os.dev os.dev.quickstart_orig
fi
ln -s openscholar/www os.dev

echo " "
echo "Quickscholar: done!"
echo "You can now visit your site at:"
echo " "
echo "    http://os.dev"
echo " "
echo "If you haven't done so, you may wish to set up git:"
echo " "
echo "    git config --global user.name \"Your Name\""
echo "    git config --global user.email you@example.com"
echo " "

# Opens the installed site's front page
#chromium-browser& http://os.dev
#chromium-browser& http://os.dev/install.php?profile=openscholar&locale=en

