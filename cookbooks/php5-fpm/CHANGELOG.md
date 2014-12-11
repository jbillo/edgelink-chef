php5-fpm CHANGELOG
=================

0.1.0
-----
- stajkowski - Intial Commit/Base Recipes.

0.1.3
-----
- stajkowski - Rework attribute structure, prepare for additional platforms.

- - -

0.2.0
-----
- stajkowski - Added Redhat and CentOS support.  Allow for the option to update package repos on the system.

- - -

0.2.1
-----
- stajkowski - Tested Fedora 20 support.  Generated Test Kitchen files and preparing for kitchen scripts.

- - -

0.2.2
-----
- stajkowski - Updated install receipe to fix the update/upgrade operation.  Now allows for the option and fully functional. Added and tested against more platforms, check .kitchen.yml.  Fixed 14.04 bug for service provider, will include this until the bug is fixed.  Added support for Debian 6.x and above and added support for Ubuntu 10.04 and above, this has a seperate JSON configuration due to recent configuration settings not supported in these earlier versions.

- - -

0.3.0
-----
- stajkowski - Created LWRP for pool create, modify and delete.  LWRP example receipe shows the potential usage.  The documentation outlines all available attributes.  Tested and verified.

- - -

0.3.1
-----
- rodriguez - Adjust installation script so that it doesn't restart php-fpm everytime chef-client is run.

- - -

0.3.2
-----
- stajkowski - Added PHP Overrides and Environment variables to LWRP.  Revised documentation and updated README.

- - -

0.3.3
-----
- stajkowski - Chef 12 Supported Now. Adjusted update, upgrade and install_php_modules for boolean values. Add attributes for Chef Server. Adjusted README to indicate configure_fpm a required recipe. Fixed Serverspec OS detection for v2.  Fixed CHEF 12 unsupported methods for calling attributes.

- - -