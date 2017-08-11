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

Packages can so be installed locally, by adding the `-l` flag at the end of the install command. Note that the flag MUST be at the end, like so:
```
$ tavern install <package_name> -l
```

### Configuration
The most critical file for Tavern is the `.tavernconfig` file. From it you can set the variables you need to make your Tavern client tick. In the name of simplicity, there are only two. You can indicate comments with a `$` sign, and variables are assigned with an `=`. Tavern configuration files are on a per directory basis, and Tavern will read the `.tavernconfig` from wherever is is executed from, this allows for different libraries to be referenced on a per project basis. Here is an example of a Tavern config:

```
$ tell tavern what operating system it's running on (win for Windows, darwin for OSX)
os = win

$ tell tavern what library we are pulling from (the default is the stock Everware Tavern Library)
$ which is full of useful test and example packages to download
lib = https://storage.googleapis.com/tavernlibrary
```

### Creating your own Library
Creating your own Tavern library is simple, all you need is a file host willing to expose a directory like structure to the Internet, and to upload keg files (we'll get to those in a moment) to and you're done. To use your library, set the `lib` variable in the `.tavernconfig` file to point to your URL and now your client will download from there.

### Other commands
`tavern update <package_name>` will check if the keg stored in the library has a different version to the one installed locally, and if it does, will remove and reinstall the new one.

`tavern info` will list all the installed packages and their versions.

`tavern config get <setting>` will print the value of the setting.

`tavern config set <setting>` will set the value of the setting.
