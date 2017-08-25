# Tavern

Tavern is a cross platform package mananger that allows for organizations large and small to maintain a library of packages that can be downloaded at any time. Tavern is written in Ruby and tries to remain as lightweight as possible.

The packages one installs with Tavern are called Kegs. These are a collection of information about the package itself, as well as series of instructions on how to install and uninstall the package. Having the packages work like this allows for maximum flexibility for the maintainers of these works, and means they have the power to perform large, complex installs without having to bother the user beyond entering the tavern install command.

Installing a package with Tavern is simple:

``` shell
tavern install <package_name>
```

To remove a package from your system simple run:

``` shell
tavern uninstall <package_name>
```

Updating a package to a new version is easy:

``` shell
tavern update <package_name>
```

## Taps

Taps represent the libraries of Kegs that your Tavern instance can pull data from. Each Tap has a name, and a URL that it links to. Tavern can hold as many taps as you want, but will only search in one to download and install pacakges; this is the Tap your are 'pouring' from.

By default, all Tavern instances come with the EverwareIO tap preinstalled and set by default. To add a tap, execute this from your command line:

``` shell
tavern tap add <tap_name> <url>
```

To change the tap being used:

``` shell
tavern tap pour <tap_name>
```

Anyone can host a library, and give out the url to be tapped by Tavern instances. However over time, you may collect a large number of taps in Tavern, and want to see all of them. To do so, use the `list` command:

``` shell
tavern tap list
```

This will list all the taps you've added and also show their URLS. To remove a tap that you no longer need:

``` shell
tavern tap remove <tap_name>
```

To double check what tap you are currently using:

``` shell
tavern tap current
```

## Other Commands

`tavern info` will list all the package you have currently installed.