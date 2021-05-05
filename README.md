# List WordPress plugin update info

Small shell script to list minimum WordPress and PHP version for each release of an WordPress Plugin

## Requirements

You'll need `svn` command available.

## Concept

Using the `svn` command, the plugin will checkout the `readme.txt` files of each SVN tag for the plugin, if it wasn't
already. Once you run the script for one plugin, it'll just check for newer tags instead of re-run for all. For each
tag, this file will be parsed to render the output.

Beside the plugins name, you can pass a version prefix to reduce / focus the output to your needs.

## Examples

Find here some examples to have a better understanding of the scripts benefit.

### Example output for 'WP-Piwik'

For the command `./list-plugin-update-info.sh wp-piwik` you'll see this output:

```log
...

plugins/wp-piwik/1.0.22
Last Changed Date: 2019-07-29 23:03:00 +0200 (Mon, 29 Jul 2019)
Requires at least: 4.0
Tested up to: 5.2.2

plugins/wp-piwik/1.0.24
Last Changed Date: 2020-09-21 13:23:09 +0200 (Mon, 21 Sep 2020)
Requires at least: 5.0
Tested up to: 5.5.1

...
```

So here you can see, that version 1.0.24 requires WP 5.0, but 1.0.22 required just WP 4.0.

### Example output for 'Contact Form 7'

For the command `./list-plugin-update-info.sh contact-form-7 4.9` you'll see this output:

```log
...

plugins/contact-form-7/4.9
Last Changed Date: 2017-08-18 08:08:36 +0200 (Fri, 18 Aug 2017)
Requires at least: 4.7
Tested up to: 4.8.1

plugins/contact-form-7/4.9.1
Last Changed Date: 2017-10-31 10:39:48 +0100 (Tue, 31 Oct 2017)
Requires at least: 4.7
Tested up to: 4.9

plugins/contact-form-7/4.9.2
Last Changed Date: 2017-12-09 08:32:34 +0100 (Sat, 09 Dec 2017)
Requires at least: 4.7
Tested up to: 4.9.1

...
```

### Example output for 'Wordfence'

For the command `./list-plugin-update-info.sh wordfence` you'll see this output:

```log
...

plugins/wordfence/7.4.5
Last Changed Date: 2020-01-16 17:25:20 +0100 (Thu, 16 Jan 2020)
Requires at least: 3.9
Tested up to: 5.3
Requires PHP: 5.3

plugins/wordfence/7.4.6
Last Changed Date: 2020-03-27 18:29:20 +0100 (Fri, 27 Mar 2020)
Requires at least: 3.9
Tested up to: 5.4
Requires PHP: 5.3

...
```

As you can see, version 7.4.6 was tested up to WP 5.4, but 7.4.5 was just tested up to WP 5.3.

## Future optimization

Instead of checking out the readme, maybe we can just parse the web svn directory. This would require some more complex
shell script, but maybe will be more fast.
