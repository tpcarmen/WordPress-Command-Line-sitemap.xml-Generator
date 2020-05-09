CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateSiteMap`()
BEGIN

	/* 
		MIT License
		
		Copyright (c) 2020 CNY Support, LLC
		
		https://www.terrys-service.com
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	*/

	DECLARE home_page_post_name varchar(1024);
	DECLARE siteurl varchar(512);
	DECLARE xmlheader varchar(4096);
	DECLARE xmlfooter varchar(64);
	
	SET home_page_post_name = 'request-service';   
	-- set this to the name of your home page post        
	
	SET siteurl = (SELECT `option_value` FROM `wp_options` WHERE `option_name` = 'siteurl');    
	
	SET xmlheader = '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
	
	SET xmlfooter = '</urlset>';
	
	-- these are pages you don't want included in the sitemap.
	DROP TEMPORARY TABLE IF EXISTS `IgnorePagesTable`;    
	
	CREATE TEMPORARY TABLE `IgnorePagesTable` 
	(
	pagename varchar(1024) NOT NULL
	);
	
	-- Add any pages you don't want to appear in your sitemap.
	INSERT INTO `IgnorePagesTable`(`pagename`) VALUE ('thank-you');
	INSERT INTO `IgnorePagesTable`(`pagename`) VALUE ('appointment-not-confirmed');
	
	-- This table contains the text that gets output as your sitemap
	DROP TEMPORARY TABLE IF EXISTS `SiteMapTempTable`;
	CREATE TEMPORARY TABLE `SiteMapTempTable` 
	(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,    
	s varchar(4096)    
	);
	
	-- text that gets output into sitemap.xml
	INSERT INTO `SiteMapTempTable` (s) SELECT xmlheader;
	INSERT INTO `SiteMapTempTable` (s) SELECT '<!-- Created by WordPress Command Line Sitemap Generator, https://www.terrys-service.com/sitemap-generator -->';
	
	-- add the homepage to the output table.
	-- the 1.0 priority assumes the home page is the most important page. You can change this if you want.  
	INSERT INTO `SiteMapTempTable` (s) SELECT 
	CONCAT(
	'<url>',
	'<loc>', siteurl, '/' , '</loc>',
	'<lastmod>', DATE_FORMAT(post_modified_gmt, '%Y-%m-%dT%H:%m:%s-05:00'), '</lastmod>',
	'<priority>', '1.0'  ,'</priority>',   
	'<changefreq>hourly</changefreq>',
	'</url>')
	FROM wp_posts p
	WHERE p.`post_type`= 'page'
	AND p.`post_status`='publish'
	AND `post_name` = home_page_post_name    
	ORDER BY `post_modified_gmt` DESC;
	
	-- this adds all the pages that are not the home page and are not excluded.
	INSERT INTO `SiteMapTempTable` (s) SELECT 
	CONCAT(
	'<url>',
	'<loc>', siteurl, '/', `post_name`, '/' , '</loc>',
	'<lastmod>', DATE_FORMAT(post_modified_gmt, '%Y-%m-%dT%H:%m:%s-05:00'), '</lastmod>',
	'<priority>', '0.5'  ,'</priority>',   
	'<changefreq>weekly</changefreq>',
	'</url>')
	FROM wp_posts p
	WHERE p.post_type= 'page'
	AND p.post_status='publish'
	AND `post_name` <> home_page_post_name    
	AND `post_name` NOT IN (SELECT `pagename` FROM `IgnorePagesTable`)
	ORDER BY post_modified_gmt DESC;
	
	INSERT INTO `SiteMapTempTable` (s) SELECT xmlfooter;
	
	SELECT s as '' FROM `SiteMapTempTable` ORDER BY ID;

END
