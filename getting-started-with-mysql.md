---
title: Getting Started With MySQL
authors:
- Jeff Blackadar
date: 2017-11-05
reviewers:
- (not yet assigned)
layout: lesson
difficulty: 1
---

*draft* This is a draft.  More will be added, edits made, mistakes corrected.  If you have feedback on the draft I welcome it jeffblackadar( at}gmail{dot)com.

## Getting Started With MySQL

## Contents

## Introduction

## Downloading and Installing MySQL Workbench

MtSQL Installation instructions:  https://dev.mysql.com/doc/workbench/en/wb-installing.html

MySQL Workbench downloads:  http://dev.mysql.com/downloads/workbench/


## Create a database
![Creating a database in MySQL Workbench](http://jeffblackadar.ca/getting-started-with-mysql/getting-started-with-mysql-1.png "Creating a database in MySQL Workbench")

Using MySQL Workbench perform these steps:
1. In the Query window type:
```
CREATE DATABASE newspaper_search_results;
```
2. Run the CREATE DATABASE command.  Click on the lightning bolt or using the menu click Query | Execute Current Statement.
3. Beside SCHEMAS, if necessary, click the refresh icon.
4. The new database newspaper_search_results should be visible under SCHEMAS



In the Query window type:
```
USE newspaper_search_results;
```
The USE statement informs MySQL Workbench that you are working with the newspaper_search_results when you run commands.

## Add a user to connect to the database

We are adding a new user so that this user ID is used only to connect to the new database, limiting exposure in case its password is compromised.

In the MySQL Workbench menu click **Server | Users and Privileges**

Click the **Add Account** button and complete the Details for account newuser dialog box:
1. login name: **newspaper_search_results_user**
2. Authentication Type
3. Limit to hosts matching: **Localhost**
4. Enter and confirm a password
5. Click on the **Administrative Roles** tab.  Make sure nothing is checked.  This account is for accessing the database only.
6. Click on the **Schema Priviledges** tab and click **Add Entry**
7. In the **New Schema Priviledge Definition** diablog box, click the **Selected schema:** radio button and select **newspaper_search_results**.
8. Click all of the Object Rights: SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW as per the image below.
9. Click the **Apply** button.

![setting permissions for new account.](http://jeffblackadar.ca/getting-started-with-mysql/getting-started-with-mysql-2.png "setting permissions for new account")











## Create an R program that connects to the database

In RStudio create a program named newspaper_search.R

If you don't have the library RRMySQL installed, install it using the RStudio Console per below:
```
install.packages("RMySQL")
```
Add this statement to the newspaper_search.R program

```
library(RMySQL)
```


You can make headers, and see that they show up with the same styling that a published lesson has.

Code blocks work too:

```bash
echo "hello world!"
```

I can make [absolute links as normal](http://programminghistorian.org), though if I try to make a [relative link](../lessons/counting-frequencies) to a published lesson on the Programming Historian, that won't work, because this repo will only contain lessons that are works in progress.

However, I can add images for my lesson to the images directory here on the submissions repo, and then use the standard figure syntax to include it:

{% include figure.html src="../images/sample-lesson-1.png" caption="A sample image for my sample lesson, taken from Wikipedia entry for Digital History" %}

Voila!

## Another Sample Header

Everything appears to work when I put another sample header, too. This will allow reviewers to examine a lesson and see more or less exactly what it will look like.[^1]

## Tables

Here's a sample table from a different lesson:


| Command | What It Does |
|---------|--------------|
| `pwd` | Prints the 'present working directory,' letting you know where you are. |
| `ls` | Lists the files in the current directory
| `man *` | Lists the manual for the command, substituted for the `*`
| `cd *` | Changes the current directory to `*`
| `mkdir *` | Makes a directory named `*`
| `open` or `explorer` | On OS X, `open` followed by a file opens it; in Windows, the command `explorer` followed by a file name does the same thing.
| `cat *` | `cat` is a versatile command. It will read a file to you if you substitute a file for `*`, but can also be used to combine files.
| `head *` | Displays the first ten lines of `*`
| `tail *` | Displays the last ten lines of `*`
| `mv` | Moves a file
| `cp` | Copies a file
| `rm` | Deletes a file
| `vim` | Opens up the `vim` document editor.

[^1]: I say "more or less" so as not to court the vengeance of the Markdown gods!

## Credits and Citation

Made a copy of the sample lesson from here:

https://github.com/programminghistorian/ph-submissions/blob/gh-pages/lessons/sample-lesson.md

Based lesson structure on this:

https://programminghistorian.org/lessons/geoparsing-text-with-edinburgh

## References

Ullman, Larry. PHP and MySQL For Dyanamic Web Sites

