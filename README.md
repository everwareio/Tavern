# Tavern
Tavern is a cross platform package manager designed with organizations in mind. Any organization or entity can host their own library that people can fetch packages from. Tavern is implemented in Ruby but has wrappers for Windows and OSX to allow for the seamless running of the application.

### How it works
You install packages by running
```
$ tavern install <package_name>
```

You can uninstall them using
```
$ tavern uninstall <package_name>
```

Tavern will search its library for a package with that name, and matching your operating system; and when found, attempt to install it, as instructed by the author.

### Configuration
The most critical file for Tavern is the `.tavernconfig` file. From it you can set the variables you need to make your Tavern client tick. To set or get settings in your instance of Tavern, use the 'config' command set:

`tavern config set <setting> <value>` will set the value of the specified setting to the given value

`tavern config get <setting>` will print the current value of the setting

### Taps
Taps represent the libraries of packages that Tavern can pull from. You can have as many taps as you want, and swap between them quickly. These taps are simply different URL's your Tavern instance looks for packages in and downloads them from. To interact with taps, use the 'tap' command set:

`tavern tap add <name> <url>` will add a tap to Tavern with the given name, and url.

`tavern tap remove <name>` will remove the named tap from Tavern

`tavern tap pour <name>` will make the named tap the one that Tavern pulls from and attempts to download files from

`tavern tap list` will list all the taps you have added to Tavern (with the URL's)

### Other commands
`tavern update <package_name>` will check if the keg stored in the library has a different version to the one installed locally, and if it does, will remove and reinstall the new one.

`tavern info` will list all the installed packages.
