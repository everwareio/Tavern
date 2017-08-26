# Creating Packages (Kegs)

Packages in Tavern are defined using a language called KEGFILE. This is a metalanguage that makes it simple to define both information about a package, as well as installation instructions in a platform agnostic manner.

## Fields
Each package has a set of information about it, each of these values is called a field. These fields are:

* Name - the name of the package
* Author - the name and contact details of the author
* Version - version of the package
* License - the licence of the code
* (optional) Manpage - a documentation page
* (optional) Homepage - a homepage for the package/project

To set these fields (note that comments can be defined by placing a `;` at the beginning of the line:

``` shell
; a comment
name = <package_name>
author = <author_name> <author_email>
version = <version_number>
license = <license_name>s
manpage = <manpage_link>
homepage = <homepage_link>
```

## Commands

Commands are defined in blocks, which are delimted by parentheses. There are 9 commands to use:

1. `$remove <string:path>` removes the file or directory given
2. `$copy <string:from> <string:to>` copies the file, or contents of a directory in 'from' into 'to'
3. `$move <string:from> <string:to>` identical to copy, except it removes the 'from' directory after copying
4. `$download <string:url> <string:dest>` downloads a file from the given url into the specified path
5. `$exec <string:command>` executes the command, should be used carefully as it breaks platform independance normally
6. `$gitclone <string:url> <string:dest>` clones a git repo into the given folder
7. `$gitclean <string:path>` removes the `.git` and `.gitignore` files from a cloned repo
8. `$link <string:file> <number:argc> <string:executor>` creates an executable script in the Everware binary folder that allows a script to be executed from the command line. The command will be the `name` field from your package. The argc is the number of arguments from the command line your program expects. The executor is the program calling your script.
9. `$unlink <string:name>` unlink your package from the Everware binary folder.

There are also some special variables you can use in the arguments to access the filesystem much more easily across operating systems.

1. `$(HOME)` is the home directory, `~/` on Unix and OSX and generally the `C:` on Windows.
2. `$(EVERWARE)` is the Everware directory, `~/everwareio` on Unix and OSX and `C:/EverwareIO` on Windows.
3. `$(PACKAGE)` is the path to your package in the Tavern Storeroom.

There are two blocks that must be present in your package for it to be valid. These are `install` and `uninstall`. They can be defined as below:

``` shell
install = (
    ; clone the git repo into the package directory
    $gitclone https://github.com/some_example_repo.git $(PACKAGE)/src
     
    ; clean up the repo
    $gitclean $(PACKAGE)/src

    ; create an executable link
    $link $(PACKAGE)/src/some_script_to_execute.rb 3 ruby
)

uninstall = (
    ; remove the package
    $remove $(PACKAGE)

    ; unlink the script
    $unlink the_package_name
)
```

## Naming the Keg

Convention: Name the file `<package_name>.keg`. This makes it way easier to install from a library, trust me. Everything else is up to you.