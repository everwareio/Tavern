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

The most critical file for Tavern is the `Tavern.config` file. From it you can set the variables you need to make your Tavern client tick. In the name of simplicity, there are only two. You can indicate comments with a `$` sign, and variables are assigned with an `=`. Here is an example:

```
$ tell tavern what operating system it's running on (win for Windows, darwin for OSX)
os = win

$ tell tavern what library we are pulling from (the default is the stock Everware Tavern Library)
$ which is full of useful test and example packages to download
lib = https://storage.googleapis.com/tavernlibrary
```

### Creating your own Library
Creating your own Tavern library is simple, all you need is a file host willing to expose a directory like structure to the Internet, and to upload keg files (we'll get to those in a moment) to and you're done. To use your library, set the `lib` variable in the `Tavern.config` file to point to your URL and now your client will download from there.

### Creating your own packages
Creating packages in Tavern is possible, but the way that packages are handled is liable to change soon, as we try various methods, to make it as easy as possible for everyone. Currently, packages are called Kegs, and are stored in a JSON format like so:

```
{
    // the name of the package,
    "name": "example_package",

    // the version
       "version": "1.0.0",

    // a series of bash or batch commands to download and build your package
    // this is run before the install commands
    "build": []

    // a series of bash or batch commands to install your built package; these should
    // also link the file to PATH if that's necessary
    "install": []

    // a series of bash or batch commands to uninstall your package
    "uninstall": []
}
```

We figured that it's probably not super fun to have to remember that structure, so you can use the `tavern create` command to have a nice series of prompts that will guide you through creating a keg.

Note that this is likely to change as we try to come up with a more elegant and simple cross platform solution, but should be stable for a little while.

### Other commands
`tavern update <package_name>` will check if the keg stored in the library has a different version to the one installed locally, and if it does, will remove and reinstall the new one.

`tavern info` will list all the installed packages and their versions.
