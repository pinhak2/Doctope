![D1-EM-D2 Overview](D1EMD2_Scripts.png)

# Getting Started with the NBLI DockTope repository

## Installing git on linux

You can use any package manager to install **git**. Althouth not "required", I also recommend to install **gitk** to be able to visualize the history (tree) and **kdiff3** to be able to solve the conflicts (more details later).

    sudo apt-get update
    sudo apt-get install git-core kdiff3 gitk

You should set up your git account, saving name and e-mail to the **~/.gitconfig** file. You should also setup kdiff3 as the default tool for solving conflicts.
You can do both things in different ways (read both before choosing one):

By executing commands like these (replace "testuser" by your github id and e-mail)....

    git config --global user.name "testuser"
    git config --global user.email "testuser@example.com"

    git config --global --add merge.tool kdiff3
    git config --global --add mergetool.kdiff3.path "/usr/bin/kdiff3"
    git config --global --add mergetool.kdiff3.trustExitCode false
    git config --global --add mergetool.prompt false

    git config --global --add diff.guitool kdiff3
    git config --global --add difftool.kdiff3.path "/usr/bin/kdiff3"
    git config --global --add difftool.kdiff3.trustExitCode false
    git config --global --add difftool.prompt false

...or by creating a **~/.gitconfig** with the following setup (recommended).

    [push]
        default = simple

    [user]
        email = testuser@example.com
        name = testuser

    [color]
         ui = auto

    [color]
         decorate = short

    [alias]
         ci = commit
         di = diff --color-words
         st = status

         # aliases that match the hg in / out commands
         out      = !git fetch && git log FETCH_HEAD..
         outgoing = !git fetch && git log FETCH_HEAD..
         in       = !git fetch && git log ..FETCH_HEAD
         incoming = !git fetch && git log ..FETCH_HEAD

    [merge]
        tool = kdiff3

    [mergetool "kdiff3"]
        path = /usr/bin/kdiff3
        trustExitCode = false

    [mergetool]
        prompt = false

    [diff]
        guitool = kdiff3

    [difftool "kdiff3"]
        path = /usr/bin/kdiff3
        trustExitCode = false

    [difftool]
        prompt = false

## Cloning the repository

If you haven't set up the SSH-Keys (see below) you can type your password interactively using this command for cloning:

    git clone http://@github.com/KavrakiLab/DockTope.git

But if you have added your SSH-Key on GitHub, then you should use a command like this:

    git clone -b master git@github.com:KavrakiLab/DockTope.git

FWY, while cloning you can also set the depth of the history (e.g. download only the last 5 commits) and give a different name to the folder (e.g. testfolder). Ex.:

    git clone -b master --depth 5 git@github.com:KavrakiLab/DockTope.git testfolder

## Usefull commands

The "normal" sequence of events will be as follows:
(i) make changes to one or multiple files
(ii) **add** files to the next commit
(iii) **commit** changes locally (which means you are saving this changeset into your local history)
(iv) **pull** any additional changes from the server
(v) if there were changes in the server, **merge** with your local changes
(vi) if needed, solve the conflicts with **git mergetool** (kdiff3 should pop up automatically)
(vii) make a new **commit** to save the merge
(viii) **push** your changes to the server

Below I list this and some additional commands:

    git log                         #Check history of changes
    git log | head                  #Check latest change
    git status                      #Check current status of the local repo (e.g. needed actions)
    git incoming                    #Check if there are changes to pull from the server
    git add filename                #Add file to next local commit (replace filename by the file of interest)
    git commit -m "title of commit" #Commit changes locally
    git outgoing                    #Check if there are local commits to push to the server
    git pull                        #Pull changes from server
    git merge                       #merge local commits with changes from the server
    git mergetool                   #It opens the conflicting files, in case kdiff3 does not open automatically

## Installing and running on Windows

You can do all of that on Windows...but the commands are different. You will have to search how to do it. In fact, there is plenty of documentation on how to use GitHub on windows, since many software developers do work on Windows. If you decide to look it up, please update this section of the README.

# "Advanced" settings (customizing your experience)

## How to automate Github login with SSH Key

This is usefull so that you don't need to type your _user_ and _password_ everytime you _push_ or
_pull_ something from the server. If you have no active SSH Keys in your system, you should just follow the first link below and things should just work. If you have active SSH Keys, you should pay attention to the instructions regarding checking available _keys_ (also mentioned in the link below) and how to use the **config** file to handle multiple _keys_ (additional links below).

[Intructions to access Github with SSH Key](https://help.github.com/articles/connecting-to-github-with-ssh/)

An ssh **config** file is a text file that you can create in the _~/.ssh_ folder, and it should look like the exemple below. In this case instead of saving the default _id_rsa_ file, I created different SSH key pairs for accessing the cluster (at tacc) and for github conections. With this setup I can even simply type _"ssh tacc"_ to get the conection to the cluster started. Note that for GitHub connections the _User_ and the _Hostname_ in the config file must match the _User_ and _Hostname_ used when you cloned the repo in the first place (and not your e-mail and user ID, which are instead documented in the **~/.gitconfig** file).

    #
    Host tacc
        HostName stampede2.tacc.utexas.edu
        User da21
        IdentityFile ~/.ssh/id_rsa_tacc
    #
    Host github
        User git
        HostName github.com
        IdentityFile ~/.ssh/id_rsa_git

[Using a ssh config file for multiple hosts](https://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/)

[More about config](https://gist.github.com/jexchan/2351996)

[Even more about config](https://gist.github.com/rbialek/1012262)

## Make terminal show the git branch

I recommend installing terminator (_apt-get install terminator_), since it allows you to break the same tab into smaller windows. You can add the lines below to the end of your **.bashrc** file to configure it. The branch parcing will also work for the regular Ubunutu terminal.

    ##TERMINATOR
    function parse_git_branch () {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    RED="\[\033[0;31m\]"
    YELLOW="\[\033[0;33m\]"
    GREEN="\[\033[0;32m\]"
    CYAN="\[\033[0;36m\]"
    NO_COLOR="\[\033[0m\]"

    #Setting colors on the command line. If you don't like the >>>, use the commented line (below) instead.
    PS1="$GREEN\u@\h$CYAN:\w$YELLOW\$(parse_git_branch)$CYAN\$\n$YELLOW>>> $NO_COLOR"
    #PS1="$GREEN\u@\h$CYAN:\w$YELLOW\$(parse_git_branch)$CYAN\$\n$NO_COLOR"

You can also go to Terminator settings and set the same background color as the default in your system.

## Usefull links for additional information:

[More details for git installation on linux](https://www.liquidweb.com/kb/install-git-ubuntu-16-04-lts/)

[More details about resolving conflicts with git](https://gist.github.com/karenyyng/f19ff75c60f18b4b8149)

[Using KDiff3 as merge tool and diff tool on Windows](https://stackoverflow.com/questions/33308482/git-how-configure-kdiff3-as-merge-tool-and-diff-tool)

[Markdown cheatsheet (to customize the README)](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[Mastering Markdown](https://guides.github.com/features/mastering-markdown/)

[How to pull till a particular commit](https://stackoverflow.com/questions/31462683/git-pull-till-a-particular-commit)

## Example of conflict solving (using previous commits in this repo)

Create another clone just to make this test

    git clone -b master --depth 10 git@github.com:KavrakiLab/DockTope.git docktest
    cd docktest
    grep Windows README.md
    git checkout 84c7ce2f8df387351d0e26f1f4321432f3cca4d6
    grep Windows README.md
    git merge 2d5cdb24a10aa4fdf350e1c76127871325225820
    git mergetool

## Repository initialization (Not needed anymore)

This was done once, to initialize this repo after Mark created the empty DockTope.git. I am saving for future reference, but it is not needed for the clones.

    echo "# DockTope" >> README.md
    git init
    git add README.md
    git add bioscripts_original
    git commit -m "first commit"
    git remote add origin https://github.com/KavrakiLab/DockTope.git
    git push -u origin master

# Doctope
