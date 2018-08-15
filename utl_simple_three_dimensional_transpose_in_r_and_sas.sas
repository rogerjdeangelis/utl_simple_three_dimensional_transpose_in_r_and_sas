Simple three dimensional transpose in R and SAS

 THREE SOLUTIONS

     1. One 'proc corresp'
     2. Proc sort and proc transpose
     3. R reshape

github
https://tinyurl.com/ybo737my
https://github.com/rogerjdeangelis/utl_simple_three_dimensional_transpose_in_r_and_sas

see
https://tinyurl.com/yakeeacr
https://stackoverflow.com/questions/51846611/spread-over-multiple-columns-in-r-dplyr-tidyr-solution

see Ryan profile
https://stackoverflow.com/users/6762755/ryan


INPUT
=====

 SD1.HAVE total obs=18

  ID    YEAR    MONTH    VALUE

  a     2015      1         1
  a     2015      2         1
  a     2015      3         1
  a     2016      1         2
  a     2016      2         2
  a     2016      3         2
  a     2017      1         3
  a     2017      2         3
  a     2017      3         3
  b     2015      1         6
  b     2015      2         7
  b     2015      3         8
  b     2016      1         9
  b     2016      2        10
  b     2016      3        11
  b     2017      1        12
  b     2017      2        13
  b     2017      3        14


EXAMPLE OUTPUT
--------------

 WORK.HAVXPO total obs=6

  ID    MONTH    _2015    _2016    _2017

  a       1        1         2        3
  a       2        1         2        3
  a       3        1         2        3

  b       1        6         9       12
  b       2        7        10       13
  b       3        8        11       14



PROCESS
=======

 1. One 'proc corresp'
 ---------------------

  ods exclude all;
  ods output observed=havCor;
  proc corresp data=sd1.have dim=1 observed cross=both;
  tables id month, year;
  weight value;
  run;quit;
  ods select all;

 2. Proc sort and proc transpose
 --------------------------------

  proc sort data=sd1.have out=havSrt;
  by id month year;
  run;quit;

  proc transpose data=havSrt out=havXpo(drop=_name_);
  by id month;
  id year;
  var value;
  run;quit;

 3. R reshape
 ------------

  %utl_submit_r64('
    library(reshape2);
    library(haven);
    have <-read_sas("d:/sd1/have.sas7bdat");
    want<-dcast(have, ID + MONTH ~ YEAR);
    save.image("d:/rda/work.Rdata");
  ');

  * create sas dataset from R dataframe;
  proc iml;
    submit / R;
    load("d:/rda/work.Rdata");
    want;
    endsubmit;
    run importdatasetfromr("work.want","want");
  run;quit;

  proc print data=work.want;
  run;quit;


OUTPUTS
======

1. One 'proc corresp'
---------------------

  WORK.HAVCOR total obs=7

    LABEL    _2015    _2016    _2017      SUM

    a * 1       1        2        3         6
    a * 2       1        2        3         6
    a * 3       1        2        3         6
    b * 1       6        9       12        27
    b * 2       7       10       13        30
    b * 3       8       11       14        33

    Sum        24       36       48       108


2. Proc sort and proc transpose
--------------------------------

  WORK.HAVXPO total obs=6

   ID    MONTH    _2015    _2016    _2017

   a       1        1         2        3
   a       2        1         2        3
   a       3        1         2        3
   b       1        6         9       12
   b       2        7        10       13
   b       3        8        11       14


3. R reshape
------------

  WORK.WANT total obs=6

    ID    MONTH    _015    _016    _017

    a       1        1       2       3
    a       2        1       2       3
    a       3        1       2       3
    b       1        6       9      12
    b       2        7      10      13
    b       3        8      11      14


*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input id$ Year$ Month$ Value ;
cards4;
a 2015 1 1
a 2015 2 1
a 2015 3 1
a 2016 1 2
a 2016 2 2
a 2016 3 2
a 2017 1 3
a 2017 2 3
a 2017 3 3
b 2015 1 6
b 2015 2 7
b 2015 3 8
b 2016 1 9
b 2016 2 10
b 2016 3 11
b 2017 1 12
b 2017 2 13
b 2017 3 14
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

see process
