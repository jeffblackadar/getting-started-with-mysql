# Draft
## This is a draft lesson idea to tailor the Introduction to MySQL with R lesson to DH Box from dhbox.org.  The lesson modifications in this draft have not been reviewed.
---
title: Introduction to MySQL with R using DH Box
authors:
- Jeff Blackadar
date: 2018-05-03
editors:
- Amanda Visconti
reviewers:
- Jesse Sadler
- Simon Appleford
layout: lesson
difficulty: 2
review-ticket: https://github.com/programminghistorian/ph-submissions/issues/153
collection: lessons
slug: getting-started-with-mysql-using-r
activity: transforming
topics: [data-manipulation, distant-reading]
abstract: "This lesson will help you store large amounts of historical data in a structured manner, search and filter that data, and visualize some of the data as a graph."
redirect_from: /lessons/getting-started-with-mysql-using-r
---

This lesson is for you if you want to store large amounts of data from your digital history projects in a structured manner. We will use a database called MySQL to store data.

R can perform analysis and data storage without the use of a relational database. However, there are times when databases are very useful including:
 - Placing the results of an R script on a web site where the data can be interacted with.
 - Handling more data than R can store in memory alone.
 - When data is stored in a relational database already.
 - Working with the data of different entities that are related to one another.  An example would be a database of soldiers of two different armies that fought a battle where we wanted to know what squad, platoon, company and brigade each soldier was part of.
 
A further short discussion of this is on [Jason A. French's blog](http://www.jason-french.com/blog/2014/07/03/using-r-with-mysql-databases/)[^2].

By the end of this lesson you will be able to install a database system on your computer, create a database table, store information in the table and then query the data. At the conclusion of the lesson we'll use a query of the database to make a graph.

We are using the R computer language for the examples, but the techniques can be used with other languages such as Python.

To do this lesson you will need a computer where you have permission to install software such as R and RStudio, if you are not running that already. In addition to programming in R, we will be installing some components of a database system called MySQL which works on Windows, Mac and Linux.

Some knowledge of installing software as well as organizing data into fields is helpful for this lesson which is of medium difficulty.

{% include toc.html %}

# Introduction

MySQL is a relational database used to store and query information. This lesson will use the R language to provide a tutorial and examples to:
 - Set up and connect to a table in MySQL.
 - Store records to the table.
 - Query the table.

In this tutorial you will make a database of newspaper stories that contain words from a search of a newspaper archive. The program will store the title, date published and URL of each story in a database. We'll use another program to query the database and look for historically significant patterns. Sample data will be provided from the [Welsh Newspapers Online](http://newspapers.library.wales) newspaper archive. We are working toward having a list of stories we can query for information. At the end of the lesson, we will run a query to generate a graph of the number of newspaper stories in the database to see if there is a pattern that is significant.

# Required Software

## DH Box
The tutorial will use the virtual environment [DH Box](http://dhbox.org).
R, R Studio and the MySQL database are the pieces of software required for this lesson. This software is available on DH Box. 

Go to [DH Box](http://dhbox.org) and sign up for an account. If you have a different DH Box environment available to you, use that.

## R
In their lesson [Basic Text Processing in R](/lessons/basic-text-processing-in-r)[^3], Taylor Arnold and Lauren Tilton provide an excellent summary of the knowledge of R required for this lesson.  Only basic knowledge of R is assumed. Taryn Dewar's lesson ['R Basics with Tabular Data']( /lessons/r-basics-with-tabular-data)[^4]
covers how to install R and become familiar with it.

## RStudio
Examples in this lesson use RStudio which is software used for writing and running R programs.  This lesson uses the version of RStudio available on DH Box.

## MySQL

SQL stands for Structured Query Language which is a set of commands used to store and retrieve information using a relational database. MySQL is a type of relational database and there are many others such as Microsoft SQL Server, IBM DB2 and Microsoft Access. This lesson uses MySQL since it is open-source, used by a large community, has a long track record and has a freely downloadable version. We will use the version of MySQL on DH Box.

# Create a database
Here we will create a database which serves as a container for the tables we will store our information into. A table is the structure that holds the data we want to store. Tables hold many rows of records. An example record of basic contact information would contain fields for name, phone number and e-mail address. In a table, fields are organized into *columns*.

Here is a sample table with a row of data that represents a record.

| name | phone number | e-mail address |
| ------------- |---------------|---------------|
| Pat Abraham | 613-555-1212 | pat@zmail.ca |

## Open a MySQL session.

In DH Box click Command Line and log in:

```
63325939cc31 login: demonstration
Password: 
```
At the Command Line prompt, enter **sudo mysql** to start MySQL:
```
demonstration@63325939cc31:~$ sudo mysql
[sudo] password for demonstration: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.5.49-0ubuntu0.14.04.1 (Ubuntu)
Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> 
```
## MySQL Help

To see help, at the **mysql>** prompt enter **?**.

## CREATE DATABASE

1. At the **mysql>** prompt enter:
```
CREATE DATABASE newspaper_search_results;
```

2. Check that the database was created.  At the **mysql>** prompt type: **SHOW SCHEMAS;**
```
mysql> SHOW SCHEMAS;
+--------------------------+
| Database                 |
+--------------------------+
| information_schema       |
| mysql                    |
| newspaper_search_results |
| omeka                    |
| performance_schema       |
+--------------------------+
5 rows in set (0.00 sec)
```
3. The new database **newspaper_search_results** should be visible in the list of databases.

## USE database

Next, we will enter a USE statement to inform MySQL which database we want to work with. This becomes more important when you have you have more than one database on your machine.

At the **mysql>** prompt enter:
```
USE newspaper_search_results;
```

# Add a table

In the database **newspaper_search_results** we will create a table named **tbl_newspaper_search_results**.

## Columns in the table

The new table will have these columns:
1. **id** Data type: **INT**. This id column is also PK (Primary Key), NN (Not Null) and AI (Auto Increment).  The id column will be used to relate records in this table to records in other tables.
2. **story_title** Data type: **VARCHAR(99)**. This column will store the title of each article result we gather from the search.
3. **story_date_published** Data type: **DATETIME**. This column will store the date the newspaper was published.
4. **story_url** Data type: **VARCHAR(99)**. This column will store the URL of each result we gather from the search.
5. **search_term_used** Data type: **VARCHAR(45)**. This column will store the word we used to search the newspapers.

To create the new table with these columns, at the **mysql>** prompt enter:

```
CREATE TABLE newspaper_search_results.tbl_newspaper_search_results (
id INT NOT NULL AUTO_INCREMENT,
story_title VARCHAR(99) NULL,
story_date_published DATETIME NULL,
story_url VARCHAR(99) NULL,
search_term_used VARCHAR(45) NULL,
PRIMARY KEY (id));

```
*Tip: Take your time to think about table design and naming since a well designed database will be easier to work with and understand.*

### Verify the columns in the table

At the **mysql>** prompt enter **SHOW COLUMNS FROM tbl_newspaper_search_results;**
```
mysql> SHOW COLUMNS FROM tbl_newspaper_search_results;
+----------------------+-------------+------+-----+---------+----------------+
| Field                | Type        | Null | Key | Default | Extra          |
+----------------------+-------------+------+-----+---------+----------------+
| id                   | int(11)     | NO   | PRI | NULL    | auto_increment |
| story_title          | varchar(99) | YES  |     | NULL    |                |
| story_date_published | datetime    | YES  |     | NULL    |                |
| story_url            | varchar(99) | YES  |     | NULL    |                |
| search_term_used     | varchar(45) | YES  |     | NULL    |                |
+----------------------+-------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)
```
The columns in the table you created should match what is above.

## Add a user to connect to the database

A user is an account that has permission to connect to a database. Below, we are adding a new user so that this account connects only to the new database. Using this user account for one connection to this database limits exposure to other databases in case the password for this user is compromised. Giving a user the least privileges it needs to perform what you need it to do reduces the risk if someone else learns your user's password. For example, if a user can only read a database, it is less of a risk if the password is cracked than for a user that can also change or delete the database.


The user we will create will have these characteristics:
1. Login Name: **newspaper_user**
2. Authentication Type: **Standard**
3. Limit to Hosts Matching: **localhost**. This user can't be used to access the database from another computer.
4. Password: *SomethingDifficult*. Change this password to a dfficult to crack password. Write the password down and use it in place of *SomethingDifficult* when you see that later in the lesson.
5. **Object Rights**: SELECT, INSERT, UPDATE, SHOW VIEW. (This user will need to do many things later in the lesson so we are giving it many rights.)
6. No **Administrative Roles**. This account is for accessing the database only.

To create the user, at the **mysql>** prompt enter:
```
CREATE USER 'newspaper_user'@'localhost' IDENTIFIED BY 'SomethingDifficult';
```
To grant the user Object Rights to access database newspaper_search_results, at the **mysql>** prompt enter:
```
GRANT SELECT, INSERT, UPDATE, SHOW VIEW ON newspaper_search_results.* TO 'newspaper_user'@'localhost';
```
### Verify the newly created user

At the **mysql>** prompt enter **SHOW GRANTS FOR 'newspaper_user'@'localhost';**

```
mysql> SHOW GRANTS FOR 'newspaper_user'@'localhost';
+-----------------------------------------------------------------------------------------------------------------------+
| Grants for newspaper_user@localhost                                                                                   |
+-----------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'newspaper_user'@'localhost' IDENTIFIED BY PASSWORD '*A763D79E0FF91306B36ED8D70076D56364E236CA' |
| GRANT SELECT, INSERT, UPDATE, SHOW VIEW ON `newspaper_search_results`.* TO 'newspaper_user'@'localhost'               |
+-----------------------------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)
```

# Create an R Script that connects to the database

Open RStudio, which you installed earlier in this lesson.  See the [RStudio](#rstudio) section. 

We'll now use RStudio to make a new R Script and save the script with the name newspaper_search.R. (Sometimes in this lesson I will refer to an R Script as a program.)

Go to File > New File > R Script, then save that new file with the name newspaper_search.R.

## Preparing to install R package RMariaDB

We will use the RMariaDB package to connect to MySQL.  (If you're curious, documentation for the RMariaDB package is [here](https://cran.r-project.org/web/packages/RMariaDB/RMariaDB.pdf).)

Before we install, we need to install the libmariadbclient-dev, software the RMariaDB package will use to connect the MySQL.

Go to the Command Line in DH Box.  If you see the mysql> prompt you are in a MySQL session.  We need to leave that in order to do the installation, so that the mysql> prompt, type **quit**.

```
mysql> quit
Bye
```

Update the packages on DH Box using **sudo apt-get update**.
```
demonstration@07759f23c7be:~$ sudo apt-get update
```
Entering **sudo apt-get install libmariadbclient-dev** will install the database connection client we need for RMariaDB.
```
demonstration@07759f23c7be:~$ sudo apt-get install libmariadbclient-dev
```
## Installing R package RMariaDB

RMariaDB will be installed using the RStudio Console.  After opening RStudio, copy and paste the following into the left window at the > prompt, then press enter:

```
install.packages("RMariaDB")
```

Add this statement to the newspaper_search.R program

```
library(RMariaDB)
```

## Connecting to the database with a password

We will connect to the database at first using a password. (Later we'll use a better way to connect.)  For now, we will use a variable to store the password.  Each time you start R you'll need to reset this variable, but that is better than publishing a hardcoded password if you share your programs, like you may do using GitHub.

In the RStudio console type the command below, replacing *SomethingDifficult* with the password you created for newspaper_user in the steps you did above to add a user to connect to the database.

```
localuserpassword <- "SomethingDifficult"
```

Add the following R statements to your newspaper_search.R file and save it.

To run this script, select all the text and click the Run button. (There are other ways to run just a part of an R script or the whole script.  If you are curious, look in the menu under Code > Run Region. CTRL+ALT+R will run all of the R code in the script.)


```
library(RMariaDB)
# The connection method below uses a password stored in a variable.  
# To use this set localuserpassword="The password of newspaper_user" 

storiesDb <- dbConnect(RMariaDB::MariaDB(), user='newspaper_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')
dbListTables(storiesDb)
dbDisconnect(storiesDb)
```
In the console you should see:
```
> dbListTables(storiesDb)
[1] "tbl_newspaper_search_results"
> dbDisconnect(storiesDb)
```
Success! you have:
1. Connected to the database with dbConnect.
2. Listed the table in the database with dbListTables.
3. Disconnected from the database using dbDisconnect.

### Connecting to the database with a password stored in a configuration file

The above example to connect is one way to make a connection.  The connection method described below stores the database connection information in a configuration file so that you do not have to type a password into a variable every time you start a new session in R. I found this to be a finicky process, but it is a more standard and secure way of protecting the credentials used to log into your database.  This connection method will be used in the code for the remainder of this tutorial, but it can be subsituted with the simpler connection method above if you prefer.

#### Create the .cnf file to store the MySQL database connection information

1. Open a text editor, like notepad, nano or TextEdit, and paste in the items below, changing the password to the one you created for newspaper_user in the steps you did above to add a user to connect to the database.
```
[newspaper_search_results]
user=newspaper_user
password=SomethingDifficult
host=127.0.0.1
port=3306
database=newspaper_search_results
```
2. Save this file somewhere outside of your R working directory.  I have tested putting this file in different places, it just needs to be somewhere R can locate it when the program runs. In DH Box open the File Manager. Click the New Folder button and name the folder cnf. Name the file **newspaper_search_results.cnf** and save it in the cnf folder.

3. Update the newspaper_search.R program above to connect to the database using the configuration file.

```
library(RMariaDB)
# The connection method below uses a password stored in a settings file.  

# R needs a full path to find the settings file.
rmariadb.settingsfile<-"/home/demonstration/cnf/newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

# list the table. This confirms we connected to the database.
dbListTables(storiesDb)

# disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)
```

4. Run your script.

In the console, among other lines, you should see again:
```
> dbListTables(storiesDb)
[1] "tbl_newspaper_search_results"
```
You have successfully connected to the database using a configuration file.

# Storing data in a table with SQL

In this section of the lesson we'll create a SQL statement to insert a row of data into the database table about this [newspaper story](http://newspapers.library.wales/view/4121281/4121288/94/).  We'll insert the record first in MySQL and later we'll do it in R.

Begin a MySQL session. At the Command Line prompt, enter **sudo mysql** to start MySQL.
```
demonstration@07759f23c7be:~$ sudo mysql
[sudo] password for demonstration: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
(etc.)
```

Tell MySQL that you are using the newspaper_search_results database.

```
mysql> use newspaper_search_results;
```

Enter the statement below at the MySQL> prompt. This will insert a record into the table.
```
INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used) 
VALUES('THE LOST LUSITANIA.',
'1915-05-21',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'German+Submarine');
```

## Explanation of the INSERT statement

| SQL     | Meaning           |
| ------------- |---------------|
| INSERT INTO tbl_newspaper_search_results ( | INSERT a record into the table named tbl_newspaper_search_results    |
| story_title,     |  name of field to be populated by a value     |
| story_date_published, |  "      |
| story_url,   |  "  |
| search_term_used)    |  "  |
| VALUES('THE LOST LUSITANIA.',  | The value to be inserted into the story_title field   |
|'1915-05-21',   |  story_date_published field  |
| LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),  | story_url field.  This field is a VARCHAR(99) so it has a maximum length of 99 characters.  Inserting a URL longer than 99 characters would cause an error and so two functions are used to control for that.  RTRIM() trims trailing spaces to the right of the URL.  LEFT(value,99) returns only the leftmost 99 characters of the trimmed URL.  This URL is much shorter than that and so these functions are here for an example only.   |
| 'German+Submarine');  | search_term_used field   |


Optional: Modify the INSERT statement above and execute it a few more times. For example

```
INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used) 
VALUES('test insert.',
'1916-07-01',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'German+Submarine');
```

## Querying data in a table with SQL

In this section of the lesson we'll create a SQL statement to select a row of data from the database table we just inserted.  We'll select the record first in MySQL workbench and later we'll do it in R.

1. Paste this statement below into a query window in MySQL workbench. This will select records from the table.
```
SELECT story_title FROM tbl_newspaper_search_results;
```
Your results should look like this:
```
mysql> SELECT story_title FROM tbl_newspaper_search_results;
+---------------------+
| story_title         |
+---------------------+
| THE LOST LUSITANIA. |
+---------------------+
1 row in set (0.00 sec)
mysql>
```

Optional: Modify the SELECT statement above by changing the fields selected and run it again. Add more than one field to the SELECT statement and run it:
```
SELECT story_title, story_date_published FROM tbl_newspaper_search_results;
```
## Storing data in a table with SQL using R

Let's do this using R! Below is an expanded version of the R Script we used above to connect to the database. For brevity, the first 3 comments we had in the R Script above are removed.  We no longer need them.

In line 4 of the program below, remember to change the path to the rmariadb.settingsfile that matches your computer.

```
library(RMariaDB)
# The connection method below uses a password stored in a settings file.  

# R needs a full path to find the settings file.
rmariadb.settingsfile<-"/home/demonstration/cnf/newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

# Optional. List the table. This confirms we connected to the database.
dbListTables(storiesDb)

# Create the query statement.
query<-"INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used) 
VALUES('THE LOST LUSITANIA.',
'1915-05-21',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'German+Submarine');"

# Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# Clear the result.
dbClearResult(rsInsert)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

```
In the script above we do two steps to insert a record:
1. Define the INSERT statement in the line beginning with: query<-"INSERT INTO tbl_newspaper_search_results (
2. Execute the INSERT statement stored in the query variable with: rsInsert <- dbSendQuery(storiesDb, query)

Run the script above in R Studio and then execute a SELECT in MySQL. Do you see the new record you added?

### Clean up the test data

At this point you likely have more than one record with the story title of "THE LOST LUSITANIA." which is fine for testing, but we don't want duplicate data. We will remove the test data and start again.  Using MySQL in the Command Line this SQL statement:
```
TRUNCATE tbl_newspaper_search_results;
```
As output you should see:
```
mysql> TRUNCATE tbl_newspaper_search_results;
Query OK, 0 rows affected (0.00 sec)
mysql> 
```
To practice what we just did:
1. Run a SELECT statement again.  You should not get any rows back.
2. Re-run the R program above to insert a record.
3. Perform the SELECT statement.  You should see one row of data.

### Change the INSERT statement to use variables

We will be inserting a lot of data into the table using R, so we will change the INSERT statement to use variables. See the code below the *#Assemble the query* remark.

```
library(RMariaDB)
# The connection method below uses a password stored in a settings file.  

# R needs a full path to find the settings file.
rmariadb.settingsfile<-"/home/demonstration/cnf/newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

# Optional. List the table. This confirms we connected to the database.
dbListTables(storiesDb)

# Assemble the query.

# Assign variables.
entryTitle <- "THE LOST LUSITANIA."
entryPublished <- "21 MAY 1916"
#convert the string value to a date to store it into the database
entryPublishedDate <- as.Date(entryPublished, "%d %B %Y")
entryUrl <- "http://newspapers.library.wales/view/4121281/4121288/94/"
searchTermsSimple <- "German+Submarine"

# Create the query statement
query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used) 
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
  )

# Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# Clear the result.
dbClearResult(rsInsert)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

```
Let's test this program:
1. Run a SELECT statement and note the rows you have.
2. Run the R program above to insert another record.
3. Perform the SELECT statement.  You should see an additional row of data.

### SQL Errors
Let's create a simple error in SQL to see what happens.

In R change
```
entryTitle <- "THE LOST LUSITANIA."
```
to
```
entryTitle <- "THE LOST LUSITANIA'S RUDDER."
```
and re-run the program.

In the R Console there is an error:
```
> rsInsert <- dbSendQuery(storiesDb, query)
Error in result_create(conn@ptr, statement, is_statement) : 
  You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'S RUDDER.',
  '1916-05-21',
  LEFT(RTRIM('http://newspapers.library.wales/view/4' at line 6 [1064]
```
You can check with a SELECT statement that there is no record in the table with a story title of THE LOST LUSITANIA'S RUDDER. 

Single apostrophes are part of SQL syntax and they indicate a text value.  If they are in the wrong place, it causes an error.  We have to handle cases where we have data with apostrophes.  SQL accepts two apostrophes in an insert statement to represent an apostrophe in data ('').

We'll handle apostrophes by using a gsub function to replace a single apostrophe with a double one, as per below.

```
entryTitle <- "THE LOST LUSITANIA'S RUDDER."
# change a single apostrophe into a double apostrophe
entryTitle <- gsub("'", "''", entryTitle)
```
Now that you have handled the apostrophe in the title of the story, re-run the R program and then check with a SELECT statement in MySQL.

```
SELECT * FROM newspaper_search_results.tbl_newspaper_search_results WHERE story_title = "THE LOST LUSITANIA'S RUDDER.";
```
Once you see your test record, TRUNCATE tbl_newspaper_search_results to remove this test data.

# Storing a comma separated value .csv file into a MySQL database

In the next part of the lesson we'll query the database table.  Our goal is to have enough data in the table to make a graph. To prepare for that let's load some sample data from comma separated value (.csv) text files.

Download these .csv files to your R working directory. These files are stored in GitHub so download the Raw version of the files.
1. [sample-data-allotment-garden.csv](/assets/getting-started-with-mysql-using-r/sample-data-allotment-garden.csv) This is a list of Welsh newspaper stories published during World War I that match the search terms allotment and garden.
2. [sample-data-submarine.csv](/assets/getting-started-with-mysql-using-r/sample-data-submarine.csv) This is a list of Welsh newspaper stories published during World War I that match the search terms German and submarine.

In R, execute the following read.csv() function and then see what is in the sampleData data frame.

```
sampleGardenData <- read.csv(file="sample-data-allotment-garden.csv", header=TRUE, sep=",")
sampleGardenData
```
You should see a lot of data, including what is below. Check the Environment tab on the right side of RStudio. The sampleGardenData Data Frame should contain "1242 obs. of 4 variables".
```
                                                                                      story_title
1                                                                                                                                                                             -.&quote;&apos;N&apos;III GARDEN REQUISITES.
<...the result of the data frame results have been removed...>
     story_date_published                                                 story_url   search_term_used
1              1918-05-11  http://newspapers.library.wales/view/3581057/3581061/27/ AllotmentAndGarden
<...the result of the data frame results have been removed...>
```


Note that in this sample data, field names are included in the header for convenience:  story_title, story_date_published, story_url and search_term_used. 

As noted above, our goal here is to insert the sample data that is now stored in the sampleGardenData data frame into the MySQL table tbl_newspaper_search_results.  We can do this a couple different ways, including looping through each row of the data frame and executing an INSERT command like we did above. Here though, we'll use one command to insert all of the rows in sampleGardenData at one time: *dbWriteTable*. Don't run this statement yet, just read it.

```
dbWriteTable(storiesDb, value = sampleGardenData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 
```


| Function     | Meaning           |
| ------------- |---------------|
| dbWriteTable(storiesDb, | Use the MySQL database connection storiesDb. |
| value = sampleGardenData,     |  Write the values in the sampleData data frame to the table.   |
| row.names = FALSE, | No row names are specified. |
| name = "tbl_newspaper_search_results", | Insert the values from sampleData into the table tbl_newspaper_search_results.  |
| append = TRUE ) | Append these values to what is in the table already.  If this program is run again, all of the rows in sampleData will be appended to the same table again. |

We're not ready to run dbWriteTable() yet, we need to connect to the database first. Here is the program to do that, as well as load sample-data-submarine.csv too. Read through this and run it.

```
library(RMariaDB)
rmariadb.settingsfile<-"/home/demonstration/cnf/newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

setwd("C:\\a_orgs\\carleton\\hist3814\\R\\getting-started-with-mysql")

# read in the sample data from a newspaper search of Allotment And Garden
sampleGardenData <- read.csv(file="sample-data-allotment-garden.csv", header=TRUE, sep=",")

# The story_title column in the database table can store values up to 99 characters long.  
# This statement trims any story_titles that are any longer to 99 characters.
sampleGardenData$story_title <- substr(sampleGardenData$story_title,0,99)

# This statement formats story_date_published to represent a DATETIME.
sampleGardenData$story_date_published <- paste(sampleGardenData$story_date_published," 00:00:00",sep="")

dbWriteTable(storiesDb, value = sampleGardenData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 

# read in the sample data from a newspaper search of German+Submarine
sampleSubmarineData <- read.csv(file="sample-data-submarine.csv", header=TRUE, sep=",")

sampleSubmarineData$story_title <- substr(sampleSubmarineData$story_title,0,99)
sampleSubmarineData$story_date_published <- paste(sampleSubmarineData$story_date_published," 00:00:00",sep="")

dbWriteTable(storiesDb, value = sampleSubmarineData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)

```
If you run this more than once, you will have duplicate records.  If that happens, just TRUNCATE the table and run the program again, but only once.  You can check that you have the right number of records.  In MySQL this query:

```
SELECT COUNT(*) FROM tbl_newspaper_search_results;
```
You should have a count of 2880 records. 1242 from sampleGardenData and 1638 from sampleSubmarineData.

# Selecting data from a table with SQL using R
Our goal here is to use the table of newspaper stories we have imported and make a graph of the number of stories published in Welsh Newspapers during each month of World War I that match the search terms (allotment and garden) and (German and submarine)

The script below queries the database and produces the line graph plot below.  Read through the script to see what is happening. An explanation of script follows it.

```
library(RMariaDB)
rmariadb.settingsfile<-"/home/demonstration/cnf/newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

searchTermUsed="German+Submarine"
# Query a count of the number of stories matching searchTermUsed that were published each month.
query<-paste("SELECT ( COUNT(CONCAT(MONTH(story_date_published), ' ',YEAR(story_date_published)))) as 'count' 
    FROM tbl_newspaper_search_results
    WHERE search_term_used='",searchTermUsed,"'
    GROUP BY YEAR(story_date_published),MONTH(story_date_published)
    ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")

print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

countOfStories<-c(as.integer(dbRows$count))

# Put the results of the query into a time series.
qts1 = ts(countOfStories, frequency = 12, start = c(1914, 8))
print(qts1)

# Plot the qts1 time series data with a line width of 3 in the color red.
plot(qts1, 
    lwd=3,
    col = "red",
    xlab="Month of the war",
    ylab="Number of newspaper stories",
    xlim=c(1914,1919), 
    ylim=c(0,150), 
    main=paste("Number of stories in Welsh newspapers matching the search terms listed below.",sep=""),
    sub="Search term legend: Red = German+Submarine. Green = Allotment And Garden.")

searchTermUsed="AllotmentAndGarden"

# Query a count of the number of stories matching searchTermUsed that were published each month.
query<-paste("SELECT (  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count'   FROM tbl_newspaper_search_results   WHERE search_term_used='",searchTermUsed,"'   GROUP BY YEAR(story_date_published),MONTH(story_date_published)   ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")
print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

countOfStories<-c(as.integer(dbRows$count))

# Put the results of the query into a time series.
qts2 = ts(countOfStories, frequency = 12, start = c(1914, 8))

# Add this line with the qts2 time series data to the the existing plot.
lines(qts2, lwd=3,col="darkgreen")

# Clear the result
dbClearResult(rs)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

```
## Explanation of the select and plot data program.
The method to connect to the database is explained [above](#connecting-to-the-database-with-a-password).

This program selects two result sets of data and plots them on a graph. One of the result sets is newspaper stories matching the search German+Submarine.  They are queried with this SELECT statement:
```
SELECT (
  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count' 
  FROM tbl_newspaper_search_results 
  WHERE search_term_used='",searchTermUsed,"' 
  GROUP BY YEAR(story_date_published),MONTH(story_date_published) 
  ORDER BY YEAR(story_date_published),MONTH(story_date_published);
```

| SQL     | Meaning           |
| ------------- |---------------|
|SELECT (| SELECT data matching the condition in the WHERE clause FROM the database table named. |
|COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published))) as 'count' |This provides a count of the number of stories published that share the same month and year publishing date. CONCAT stands for concatenate which creates a single text value from two or more separate text values, in this case the month and the year. |
|FROM tbl_newspaper_search_results |This is the database table we're selecting data from.|
|GROUP BY YEAR(story_date_published),MONTH(story_date_published) | This GROUP BY statement is important for the COUNT above. Here the data is grouped by month and year so that we can count all of the records in the group.
|ORDER BY YEAR(story_date_published),MONTH(story_date_published);|This puts the result set in order by date, which is useful since we want to make a graph by date.|

The statements below run the query and puts the result set *rs* into data frame *dbRows*
```
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
```

Below the data frame *dbRows* is put into a time series with the *ts()* function so that it can be plotted for each month, starting from August 1914.
```
#Put the results of the query into a time series
qts1 = ts(countOfStories, frequency = 12, start = c(1914, 8))
```
Below, the data in the *qts1* time series is plotted on a graph
```
plot(qts1, 
    lwd=3,
    col = "red",
    xlab="Month of the war",
    ylab="Number of newspaper stories",
    xlim=c(1914,1919), 
    ylim=c(0,150), 
    main=paste("Number of stories in Welsh newspapers matching the search terms listed below.",sep=""),
    sub="Search term legend: Red = German+Submarine. Green = Allotment And Garden.")
```
What is different about the part of the program that plots the stories matching the search "Allotment And Garden"? Not very much at all.  We just use the *lines()* function to plot those results on the same plot we made above.
```
lines(qts2, lwd=3,col="darkgreen")
```
### Results of the select and plot data program.
Below is what the plot should look like:

{% include figure.html filename="getting-started-with-mysql-5.png" caption="Plot of number of newspaper stories published each month matching search terms" %}

# Going further with MySQL

If you wanted to put a database on a website, using MySQL as the database and the PHP language to build the pages of the site is one way to do this. An example of this type of website is one I built to [search issues of the Equity newspaper](http://www.jeffblackadar.ca/graham_fellowship/corpus_entities_equity/). Larry Ullman's book *PHP and MySQL for Dynamic Web Sites* covers how to set up and connect to a database using MySQL and PHP in a hacker resistant way.

For examples of using SQL to sort and group data as well as perform calculations, see: 
[MySQL by Examples for Beginners](http://web.archive.org/web/20171228130133/https://www.ntu.edu.sg/home/ehchua/programming/sql/MySQL_Beginner.html) or MySQL's [Examples of Common Queries](https://dev.mysql.com/doc/refman/5.7/en/examples.html).


# Conclusion
I hope that you now have the knowledge to set up a database table, connect to it and store records. Although we have only scratched the surface of the different ways to query data, I also hope that you now know the technique of using SELECT statements so that you can use them in your future digital history projects.



# Credits

I completed this lesson thanks to the support of the [George Garth Graham Undergraduate Digital History Research Fellowship](http://grahamresearchfellow.org/).

Thank you to Dr. Amanda Visconti for her guidance and support during the preparation of this lesson.

# References

Ullman, L. 2005. *PHP and MySQL for Dynamic Web Sites, 2nd ed.* Berkeley, Calif: Peachpit.

# Endnotes

[^1]: Lincoln Mullen, "Natural Language Processing," RPubs, [https://rpubs.com/lmullen/nlp-chapter](https://rpubs.com/lmullen/nlp-chapter).

[^2]: Jason A. French, "Using R With MySQL Databases," blog (3 July 2014), [http://www.jason-french.com/blog/2014/07/03/using-r-with-mysql-databases/](http://www.jason-french.com/blog/2014/07/03/using-r-with-mysql-databases/).

[^3]: Taylor Arnold and Lauren Tilton, "Basic Text Processing in R," Programming Historian (27 March 2017), [/lessons/basic-text-processing-in-r](/lessons/basic-text-processing-in-r).

[^4]: Taryn Dewar, "R Basics with Tabular Data," Programming Historian (05 September 2016), [/lessons/r-basics-with-tabular-data](/lessons/r-basics-with-tabular-data).

The R program I used to gather the sample data is [here](https://github.com/jeffblackadar/getting-started-with-mysql/blob/master/newspaper-search-and-store.R).
