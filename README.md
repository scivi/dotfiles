#  .DOTFILES
_by Gwen Glaser_

-----------------------------------------------------------------

## Currently:

* `etc/bashrc`  -- An eclectic bash profile.

    Current state: Works For Me™, a.k.a. Βητα, a.k.a. Beta-eta-tau-alpha.
    See the comments.

    **Features:**

    * Distinguishes Darwin (BSD) and Linux.
   	* History per directory (default) or per terminal, plus a global command archive.
    * Directory stack aliased to `cd` / `pd`.
    * Directory change hook (in `prompt_callback`), e.g. to display a TODO or README file.
  	* "Session Restore" on startup: current per-tty directory is saved and cd'd into upon startup.
  	* Common aliases: shortcuts considered useful.
  	* Common path setup: the usual `*/bin` places plus `./script` (for Rails and the like).
  	* Git branch and status display in prompt.
  	* Can exec a command instead of dropping user to the prompt: Set `EXEC_IMMEDIATELY` to command before invoking bash.
  	* Uses color for `ls`, `grep`, `less`, `man`, and the prompt.
  	* Certainly abuses 'certainly'. But see the comments.

    ----

* `etc/gitconfig``  -- A basic git default config.

 	Needs editing to be useful: just insert your name and email address.

	* Defines some common aliases.
	* Enables colour.


* `etc/gitignore-global`  -- Global ignore settings for git.

* `etc/irbrc`  -- For Ruby's irb to load a ~/.railsrc when in a Rails project.

* `etc/psqlrc`  -- An eclectic psql (PostgreSQL interactive client) profile.

     It has neither known bugs nor comments.

     **Features:**

	  * Prompt showing user and database.
	  * Per-Database History.
	  * Always uses PAGER -- works well with less set to exit-if-single-page.

* `etc/toprc` -- A colourful config for top.
* `etc/railsrc`  -- Useful methods for Rails, grabbed from the internets.
* `etc/vimrc`  -- A basic Vim config, with syntax highlighting.
* `xemacs/init.el`  -- An eclectic init.el, with keybindings and stuff.

	   Actually works as well for Emacsen without X in their name.

* `xemacs/custom.el`  -- Emacs preferred colours and such.

* `Sublime Edit 2/My Hallow's Flat.tmTheme` -- A color scheme based on All Hallow's Eve.

    **Features:**

    * High readability, great for scanning code.
    * Function names in definitions stand out (white, bold and italic).
      You might want to use a font with good-looking italics, like Microsoft Consolas.
    * Punctuation is somewhat subdued.
    * Colors are distinct, but not too contrasty.
    * Loud colors from All Hallow's Eve are changed to more pleasant hues.
    * Colors match the Flatland theme.

* `Sublime Edit 2/My Flatland.sublime-theme` -- Tweaks for the awesome Flatland theme.

    * Square Tabs show more text while using less space.
    * Two-pixel black separator for multiple view layouts.

    Cf. [github.com/thinkpixellab/flatland](https://github.com/thinkpixellab/flatland)


## Installation

0. Install git (package git-core in Debian/Ubuntu and BSD ports)
1. `git clone git://github.com/scivi/dotfiles.git`
2. `cd dotfiles`
3. `sh ./install.sh`
	   It creates symlinks in your $HOME, so you can benefit
	   from future updates, easily merge your own changes etc, courtesy of git.
	   It keeps copies of existing files, date/time appended to their name.
4. edit .gitconfig: change name and email.
5. source ~/.bashrc
6. For Sublime Edit, install the Flatland theme (via Package Control).
7. Tell your Sublime Edit to use the Flatland theme and the My Hallow's Flat color scheme.


## Get Updates

0. cd $dotfiles-directory  # whereever you put it.
1. git pull

## Deinstallation:

1. remove symlinks to dotfile dir: `rm .psqlrc .bashrc .gitconfig`

2. restore backups made on installation: ignore the *, use tab completion.

	    mv .bashrc-*-* .bashrc
 	    # and so on for each file.


## Comments, Bug Reports, Enhancements

Via github at `https://github.com/scivi/dotfiles` or write to `dotfiles@gl.aser.de`.

### No Warranties!

The scripts are supplied "as-is". Use on your own risk. Read them first.

### No Licence

Some portions are gathered and copied from various places in the net.
See the comments.
Especially for xemacs/init.el I lost track where it came from.

