#!/bin/sh

mysql --skip-column-names -D YourWordPressDatabaseName -e "CALL CreateSiteMap();"   > /your/wordpress/document/root/sitemap.xml
