# WordPress-Command-Line-sitemap.xml-Generator

I’ve grown tired of overly complex WordPress plugins and their endless bloat and random vulnerabilities, so I’ve been working towards eliminating as many as possible from my website.

Here is the latest addition that replaces a sitemap plugin I had been using.

Please note that it makes a couple of assumptions that work for me, but maybe not for you:

It assumes that the home page is the most important page.
It assumes that the other pages are all equal priority

This is free software. 

It’s not shareware, nagware, guiltware or anything else. It’s just free, and I have released it under the MIT Licence.

Once an hour, or whenever you want, it

* Queries the WordPress database for the page list
* Creates an updated sitemap.xml file

That’s it.

It doesn’t phone home, notify anybody, or do anything else. It creates your sitemap and exits.

Also, I believe that it is free from vulnerabilities, since it is not callable from the web and takes no user input of any sort.

You can download the source code from https://github.com/tpcarmen/WordPress-Command-Line-sitemap.xml-Generator
