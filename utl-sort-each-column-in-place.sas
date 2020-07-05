SAS-L: Sort each column in place                                                                                                        
 Sort each column in place                                                                                                               
                                                                                                                                        
   have     |    want                                                                                                                   
                                                                                                                                        
  c1   c2   |  c1   c2                                                                                                                  
                                                                                                                                        
   2    3   |   1    2                                                                                                                  
   5    9   |   2    3                                                                                                                  
   1    2   |   5    9                                                                                                                  
                                                                                                                                        
                                                                                                                                        
   Methods                                                                                                                              
                                                                                                                                        
      a. R has a function to sort  each column inplace                                                                                  
      b. sas                                                                                                                            
          1. Create macro variables with variable names ( c[1]=c1 c[2]=c2 )                                                             
          2. do i=1 to 2  sort each column                                                                                              
               proc sort data=have(keep=c[i]) out=c[i];                                                                                 
             end;                                                                                                                       
          3. merge output sasdatasets c[i] created above                                                                                
             merge do i=1 to 2 c[i] end;                                                                                                
                                                                                                                                        
      c. Vanilla base sas solution by                                                                                                   
         Basically, we dump this into a vertical dataset, sort that, add a counter,                                                     
         transpose N and C separately, then put them back into one nice dataset with                                                    
         the original dataset used as a template to retain formats/labels/lengths."                                                     
                                                                                                                                        
         Joe Matise <snoopy369@GMAIL.COM>                                                                                               
                                                                                                                                        
      d. Call execute sort merge  (like my dumb idea, dumb unless you multi-task? -rjd)                                                 
          sort each column separately and merge, for instance:                                                                          
                                                                                                                                        
         Paul Dorfman                                                                                                                   
         saslhole@gmail.com                                                                                                             
                                                                                                                                        
      e. Load datstep arrays and sortn/sortc                                                                                            
         Bartosz Jablonski                                                                                                              
         yabwon@gmail.com                                                                                                               
                                                                                                                                        
      f. Normalize sort and merge                                                                                                       
                                                                                                                                        
      g. SAS IML                                                                                                                        
         draycut <pnclemmensen@GMAIL.COM>                                                                                               
                                                                                                                                        
github                                                                                                                                  
https://tinyurl.com/y7fff4nh                                                                                                            
https://github.com/rogerjdeangelis/utl-sort-each-column-in-place                                                                        
                                                                                                                                        
macros                                                                                                                                  
https://tinyurl.com/y9nfugth                                                                                                            
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                              
                                                                                                                                        
                                                                                                                                        
/*                   _                                                                                                                  
(_)_ __  _ __  _   _| |_                                                                                                                
| | `_ \| `_ \| | | | __|                                                                                                               
| | | | | |_) | |_| | |_                                                                                                                
|_|_| |_| .__/ \__,_|\__|                                                                                                               
        |_|                                                                                                                             
*/                                                                                                                                      
                                                                                                                                        
options validvarname=upcase;                                                                                                            
libname sd1 "d:/sd1";                                                                                                                   
                                                                                                                                        
data sd1.have(drop=j);                                                                                                                  
                                                                                                                                        
  retain id;                                                                                                                            
                                                                                                                                        
  array cs[*] c1-c5;                                                                                                                    
                                                                                                                                        
  do id=1 to 10;                                                                                                                        
                                                                                                                                        
    do j=1 to dim(cs);                                                                                                                  
                                                                                                                                        
       cs[j]=int(100*uniform(4321)) + 1;                                                                                                
                                                                                                                                        
    end;                                                                                                                                
    output;                                                                                                                             
                                                                                                                                        
  end;                                                                                                                                  
                                                                                                                                        
run;quit;                                                                                                                               
                                                                                                                                        
/*                                                                                                                                      
SD1.HAVE total obs=10                                                                                                                   
                                                                                                                                        
  ID    C1    C2    C3    C4    C5                                                                                                      
                                                                                                                                        
   1    76    87    25    44    64                                                                                                      
   2    65    31    18    19    74                                                                                                      
   3    56    11    19    97     8                                                                                                      
   4     4    73    30    37    31                                                                                                      
   5     5    59    72    88    88                                                                                                      
   6    63    18    27    95    32                                                                                                      
   7    69    39    14    44    92                                                                                                      
   8    80    98    12    37    14                                                                                                      
   9    42    83    17    48    11                                                                                                      
  10    84    66    53    11    24                                                                                                      
*/                                                                                                                                      
                                                                                                                                        
/*           _               _                                                                                                          
  ___  _   _| |_ _ __  _   _| |_                                                                                                        
 / _ \| | | | __| `_ \| | | | __|                                                                                                       
| (_) | |_| | |_| |_) | |_| | |_                                                                                                        
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                       
                |_|                                                                                                                     
*/                                                                                                                                      
                                                                                                                                        
WORK.WANT total obs=10                                                                                                                  
                                                                                                                                        
  ID    C1    C2    C3    C4    C5                                                                                                      
                                                                                                                                        
   1     4    11    12    11     8                                                                                                      
   2     5    18    14    19    11                                                                                                      
   3    42    31    17    37    14                                                                                                      
   4    56    39    18    37    24                                                                                                      
   5    63    59    19    44    31                                                                                                      
   6    65    66    25    44    32                                                                                                      
   7    69    73    27    48    64                                                                                                      
   8    76    83    30    88    74                                                                                                      
   9    80    87    53    95    88                                                                                                      
  10    84    98    72    97    92                                                                                                      
                                                                                                                                        
/*         _       _   _                                                                                                                
 ___  ___ | |_   _| |_(_) ___  _ __  ___                                                                                                
/ __|/ _ \| | | | | __| |/ _ \| `_ \/ __|                                                                                               
\__ \ (_) | | |_| | |_| | (_) | | | \__ \                                                                                               
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/                                                                                               
 _ __                                                                                                                                   
| `__|                                                                                                                                  
| |                                                                                                                                     
|_|                                                                                                                                     
*/                                                                                                                                      
                                                                                                                                        
%utlfkil(d:/xpt/want.xpt);                                                                                                              
                                                                                                                                        
proc datasets lib=work;                                                                                                                 
 delete eant;                                                                                                                           
run;quit;                                                                                                                               
                                                                                                                                        
%utl_submit_r64('                                                                                                                       
  library(haven);                                                                                                                       
  library(data.table);                                                                                                                  
  library(SASxport);                                                                                                                    
  slots=as.matrix(read_sas("d:/sd1/have.sas7bdat"));                                                                                    
  want<-as.data.table(apply(slots,2,function(x) sort(x,na.last = FALSE)));                                                              
  str(want);                                                                                                                            
  write.xport(want,file="d:/xpt/want.xpt");                                                                                             
');                                                                                                                                     
                                                                                                                                        
libname xpt xport "d:/xpt/want.xpt";                                                                                                    
data want;                                                                                                                              
  set xpt.want;                                                                                                                         
run;quit;                                                                                                                               
libname xpt clear;                                                                                                                      
                                                                                                                                        
/*                                                                                                                                      
 ___  __ _ ___                                                                                                                          
/ __|/ _` / __|                                                                                                                         
\__ \ (_| \__ \                                                                                                                         
|___/\__,_|___/                                                                                                                         
                                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
                                                                                                                                        
proc datasets lib=work;                                                                                                                 
  delete want c:;;                                                                                                                      
run;quit;                                                                                                                               
                                                                                                                                        
%array(vars,values=%varlist(sd1.have));                                                                                                 
                                                                                                                                        
/* generated macro array                                                                                                                
                                                                                                                                        
GLOBAL VARS2 C1                                                                                                                         
GLOBAL VARS3 C2                                                                                                                         
GLOBAL VARS4 C3                                                                                                                         
GLOBAL VARS5 C4                                                                                                                         
GLOBAL VARS6 C5                                                                                                                         
GLOBAL VARS7 C6                                                                                                                         
GLOBAL VARSN 6                                                                                                                          
*/                                                                                                                                      
                                                                                                                                        
data want ;                                                                                                                             
                                                                                                                                        
    if _n_=0 then do; %dosubl('                                                                                                         
        %do_over(vars,phrase=%nrstr(                                                                                                    
           proc sort data=sd1.have(keep=?) out=? noequals;                                                                              
             by ?;                                                                                                                      
           run;quit;))');                                                                                                               
        /* generated sort code                                                                                                          
           proc sort data=sd1.have(keep=id) out=id noequals; by id; run;quit;                                                           
           proc sort data=sd1.have(keep=c1) out=c1 noequals; by c1; run;quit;                                                           
           proc sort data=sd1.have(keep=c2) out=c2 noequals; by c2; run;quit;                                                           
           proc sort data=sd1.have(keep=c3) out=c3 noequals; by c3; run;quit;                                                           
           proc sort data=sd1.have(keep=c4) out=c4 noequals; by c4; run;quit;                                                           
           proc sort data=sd1.have(keep=c5) out=c5 noequals; by c5; run;quit;                                                           
        */                                                                                                                              
    end;                                                                                                                                
                                                                                                                                        
    merge %do_over(vars,phrase=?) end=dne;                                                                                              
                                                                                                                                        
    /* generated code                                                                                                                   
       c1 c2 c3 c4 c5                                                                                                                   
    */                                                                                                                                  
run;quit;                                                                                                                               
                                                                                                                                        
/*            _                               _ _ _                                                                                     
  ___        | | ___   ___  __   ____ _ _ __ (_) | | __ _   ___  __ _ ___                                                               
 / __|    _  | |/ _ \ / _ \ \ \ / / _` | `_ \| | | |/ _` | / __|/ _` / __|                                                              
| (__ _  | |_| | (_) |  __/  \ V / (_| | | | | | | | (_| | \__ \ (_| \__ \                                                              
 \___(_)  \___/ \___/ \___|   \_/ \__,_|_| |_|_|_|_|\__,_| |___/\__,_|___/                                                              
                                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
                                                                                                                                        
"HoH could be fast, certainly, but going the opposite route the data step                                                               
solution is pretty idiotproof.  This is the dumbest version of it; it can                                                               
be made much better by paying more attention to character value lengths and                                                             
such, and doesn't actually need a truly vertical dataset.  But this is                                                                  
pretty easy to code and understand for basically anyone, and if SAS/DIS                                                                 
would have this functionality I bet it would implement it that way due to                                                               
it being very robust.  (There is one unavoidable warning at the end, unless                                                             
you disable warnings of that type, for the clean log crowd; it's possible                                                               
to work around using a modification of this method, but a pain.)                                                                        
                                                                                                                                        
Basically, we dump this into a vertical dataset, sort that, add a counter,                                                              
transpose N and C separately, then put them back into one nice dataset with                                                             
the original dataset used as a template to retain formats/labels/lengths."                                                              
                                                                                                                                        
-Joe                                                                                                                                    
                                                                                                                                        
options compress=char;                                                                                                                  
data vert;                                                                                                                              
  set sashelp.class;                                                                                                                    
  array nums _numeric_;                                                                                                                 
  array chars _character_;                                                                                                              
  length vname $32 value 8 cvalue $32767;                                                                                               
                                                                                                                                        
  do _i = 1 to dim(nums);                                                                                                               
    vname = vname(nums[_i]);                                                                                                            
    value = nums[_i];                                                                                                                   
    output;                                                                                                                             
  end;                                                                                                                                  
  call missing(value);                                                                                                                  
  do _i = 1 to dim(chars);                                                                                                              
    vname = vname(chars[_i]);                                                                                                           
    cvalue= chars[_i];                                                                                                                  
    output;                                                                                                                             
  end;                                                                                                                                  
run;                                                                                                                                    
                                                                                                                                        
proc sort data=vert;                                                                                                                    
  by vname value cvalue;                                                                                                                
run;                                                                                                                                    
                                                                                                                                        
data vert_counter;                                                                                                                      
  set vert;                                                                                                                             
  by vname;                                                                                                                             
  if first.vname then counter=0;                                                                                                        
  counter+1;                                                                                                                            
run;                                                                                                                                    
                                                                                                                                        
proc sort data=vert_counter;                                                                                                            
  by counter vname;                                                                                                                     
run;                                                                                                                                    
                                                                                                                                        
proc transpose data=vert_counter out=t_numeric;                                                                                         
  where not missing(value);                                                                                                             
  by counter;                                                                                                                           
  var value;                                                                                                                            
  id vname;                                                                                                                             
run;                                                                                                                                    
                                                                                                                                        
proc transpose data=vert_counter out=t_character;                                                                                       
  where not missing(cvalue);                                                                                                            
  by counter;                                                                                                                           
  var cvalue;                                                                                                                           
  id vname;                                                                                                                             
                                                                                                                                        
run;                                                                                                                                    
                                                                                                                                        
data want;                                                                                                                              
  if 0 then set sashelp.class;                                                                                                          
  merge t_numeric t_character;                                                                                                          
  by counter;                                                                                                                           
  drop _name_ counter;                                                                                                                  
run;                                                                                                                                    
                                                                                                                                        
                                                                                                                                        
Up to 40 obs from WANT total obs=19                                                                                                     
                                                                                                                                        
Obs    NAME       SEX    AGE    HEIGHT    WEIGHT                                                                                        
                                                                                                                                        
  1    Alfred      F      11     51.3       50.5                                                                                        
  2    Alice       F      11     56.3       77.0                                                                                        
  3    Barbara     F      12     56.5       83.0                                                                                        
  4    Carol       F      12     57.3       84.0                                                                                        
  5    Henry       F      12     57.5       84.0                                                                                        
  6    James       F      12     59.0       84.5                                                                                        
  7    Jane        F      12     59.8       85.0                                                                                        
  8    Janet       F      13     62.5       90.0                                                                                        
  9    Jeffrey     F      13     62.5       98.0                                                                                        
 10    John        M      13     62.8       99.5                                                                                        
 11    Joyce       M      14     63.5      102.5                                                                                        
 12    Judy        M      14     64.3      102.5                                                                                        
 13    Louise      M      14     64.8      112.0                                                                                        
 14    Mary        M      14     65.3      112.0                                                                                        
 15    Philip      M      15     66.5      112.5                                                                                        
 16    Robert      M      15     66.5      112.5                                                                                        
 17    Ronald      M      15     67.0      128.0                                                                                        
 18    Thomas      M      15     69.0      133.0                                                                                        
 19    William     M      16     72.0      150.0                                                                                        
                                                                                                                                        
                                                                                                                                        
/*   _               _ _                                   _                                                                            
  __| |     ___ __ _| | | __  _____  __ _   ___  ___  _ __| |_    _ __ ___   ___ _ __ __ _  ___                                         
 / _` |    / __/ _` | | | \ \/ / _ \/ _` | / __|/ _ \| `__| __|  | `_ ` _ \ / _ \ `__/ _` |/ _ \                                        
| (_| |_  | (_| (_| | | |  >  <  __/ (_| | \__ \ (_) | |  | |_   | | | | | |  __/ | | (_| |  __/                                        
 \__,_(_)  \___\__,_|_|_| /_/\_\___|\__, | |___/\___/|_|   \__|  |_| |_| |_|\___|_|  \__, |\___|                                        
*/                                       |_|                                           |___/                                            
                                                                                                                                        
data _null_ ;                                                                                                                           
  array vn [999999] $32 _temporary_ ;                                                                                                   
  do n = 1 by 1 until (z) ;                                                                                                             
    set sashelp.vcolumn (keep = libname memname memtype name) end = z ;                                                                 
    where libname = "SASHELP" and memname = "CLASS" and memtype = "DATA" ;                                                              
    call execute (catx (" ", "proc sort data=sashelp.class (keep=", name, ") out=", cats ("_s", n), "; by", name, ";run;")) ;           
    vn [n] = name ;                                                                                                                     
  end ;                                                                                                                                 
  call execute ("data sortcols ; merge") ;                                                                                              
  do n = 1 to n ;                                                                                                                       
    call execute (cats ("_s", n)) ;                                                                                                     
  end ;                                                                                                                                 
  call execute (";run;") ;                                                                                                              
  stop ;                                                                                                                                
run ;                                                                                                                                   
                                                                                                                                        
/*                                                                                                                                      
Up to 40 obs from WORK.SORTCOLS total obs=19                                                                                            
                                                                                                                                        
Obs    NAME       SEX    AGE    HEIGHT    WEIGHT                                                                                        
                                                                                                                                        
  1    Alfred      F      11     51.3       50.5                                                                                        
  2    Alice       F      11     56.3       77.0                                                                                        
  3    Barbara     F      12     56.5       83.0                                                                                        
  4    Carol       F      12     57.3       84.0                                                                                        
  5    Henry       F      12     57.5       84.0                                                                                        
  6    James       F      12     59.0       84.5                                                                                        
  7    Jane        F      12     59.8       85.0                                                                                        
*/                                                                                                                                      
                                                                                                                                        
/*        ____             _                                                 _                                                          
  ___    | __ )  __ _ _ __| |_    __ _ _ __ _ __ __ _ _   _   ___  ___  _ __| |_                                                        
 / _ \   |  _ \ / _` | `__| __|  / _` | `__| `__/ _` | | | | / __|/ _ \| `__| __|                                                       
|  __/_  | |_) | (_| | |  | |_  | (_| | |  | | | (_| | |_| | \__ \ (_) | |  | |_                                                        
 \___(_) |____/ \__,_|_|   \__|  \__,_|_|  |_|  \__,_|\__, | |___/\___/|_|   \__|                                                       
                                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
One more just for fun.                                                                                                                  
Bart                                                                                                                                    
                                                                                                                                        
data have(drop=j);                                                                                                                      
  retain id;                                                                                                                            
  array cs[*] $ 17 c1-c5;                                                                                                               
  array ns[*] n1-n5;                                                                                                                    
  do id=1 to 1000;                                                                                                                      
    do j=1 to dim(cs);                                                                                                                  
       ns[j]=int(100*uniform(4321)) + 1;                                                                                                
       cs[j]=put(ns[j], roman17.);                                                                                                      
    end;                                                                                                                                
    output;                                                                                                                             
  end;                                                                                                                                  
run;                                                                                                                                    
                                                                                                                                        
/*                                                                                                                                      
Up to 40 obs WORK.HAVE total obs=1,000                                                                                                  
                                                                                                                                        
  ID    C1          C2          C3          C4         C5          N1    N2    N3    N4     N5                                          
                                                                                                                                        
   1    XXIII       LXXVI       LXV         LXXXVII    XXV         23    76    65    87     25                                          
   2    XXV         XXII        XLIV        XVI        LXIV        25    22    44    16     64                                          
   3    XXVIII      LXV         LII         XXXI       XXXI        28    65    52    31     31                                          
   4    XVIII       XCVI        XIX         LXI        LXXIV       18    96    19    61     74                                          
   5    LXXXVIII    LVI         LII         XI         LXXXIX      88    56    52    11     89                                          
   6    XIX         LXXVIII     XCVII       XXXIV      VIII        19    78    97    34      8                                          
   7    XXVI        IV          LXXVIII     LXXIII     XCIII       26     4    78    73     93                                          
   8    XXX         LXX         XXXVII      XXIV       XXXI        30    70    37    24     31                                          
   9    LVI         V           VII         LIX        XCIV        56     5     7    59     94                                          
  ...                                                                                                                                   
*/                                                                                                                                      
                                                                                                                                        
options fullstimer;                                                                                                                     
ods trace on;                                                                                                                           
ods select none;                                                                                                                        
ods output Position=Position;                                                                                                           
proc contents data = have varnum;                                                                                                       
run;                                                                                                                                    
ods select all;                                                                                                                         
ods trace off;                                                                                                                          
                                                                                                                                        
/*                                                                                                                                      
Up to 40 obs from POSITION total obs=11                                                                                                 
                                                                                                                                        
Obs     MEMBER      NUM    VARIABLE    TYPE    LEN                                                                                      
                                                                                                                                        
  1    WORK.HAVE      1       ID       Num       8                                                                                      
  2    WORK.HAVE      2       C1       Char     17                                                                                      
  3    WORK.HAVE      3       C2       Char     17                                                                                      
  4    WORK.HAVE      4       C3       Char     17                                                                                      
  5    WORK.HAVE      5       C4       Char     17                                                                                      
  6    WORK.HAVE      6       C5       Char     17                                                                                      
  7    WORK.HAVE      7       N1       Num       8                                                                                      
  8    WORK.HAVE      8       N2       Num       8                                                                                      
  9    WORK.HAVE      9       N3       Num       8                                                                                      
 10    WORK.HAVE     10       N4       Num       8                                                                                      
 11    WORK.HAVE     11       N5       Num       8                                                                                      
*/                                                                                                                                      
                                                                                                                                        
filename t TEMP;                                                                                                                        
data _null_;                                                                                                                            
file t;                                                                                                                                 
if 0 then set have nobs = _haveNobs_;                                                                                                   
                                                                                                                                        
put "data want;";                                                                                                                       
                                                                                                                                        
do until(eof);                                                                                                                          
  set Position end=eof;                                                                                                                 
  select(type);                                                                                                                         
    when("Char") do;                                                                                                                    
        put " array _" variable "[" _haveNobs_ "] $ " len " _temporary_;";                                                              
      end;                                                                                                                              
    when("Num") do;                                                                                                                     
        put " array _" variable "[" _haveNobs_ "] _temporary_;";                                                                        
      end;                                                                                                                              
    otherwise;                                                                                                                          
  end;                                                                                                                                  
end;                                                                                                                                    
eof = 0;                                                                                                                                
                                                                                                                                        
put " set have curobs=curobs end = END nobs=nobs; ";                                                                                    
                                                                                                                                        
do until(eof);                                                                                                                          
  set Position end=eof;                                                                                                                 
  put "_" variable "[curobs] = " variable ";";                                                                                          
end;                                                                                                                                    
eof = 0;                                                                                                                                
                                                                                                                                        
put " if END; ";                                                                                                                        
                                                                                                                                        
                                                                                                                                        
do until(eof);                                                                                                                          
  set Position end=eof;                                                                                                                 
  put "call sort" type $1. " (of _" variable "[*]);";                                                                                   
end;                                                                                                                                    
eof = 0;                                                                                                                                
                                                                                                                                        
put " do _N_ = 1 to nobs;";                                                                                                             
                                                                                                                                        
do until(eof);                                                                                                                          
  set Position end=eof;                                                                                                                 
  put variable "  = _" variable "[_N_];";                                                                                               
end;                                                                                                                                    
eof = 0;                                                                                                                                
                                                                                                                                        
put " output; end;";                                                                                                                    
                                                                                                                                        
put "run;";                                                                                                                             
stop;                                                                                                                                   
run;                                                                                                                                    
                                                                                                                                        
%include t / source2;                                                                                                                   
filename t;                                                                                                                             
                                                                                                                                        
/* generated code                                                                                                                       
data want;                                                                                                                              
 array _ID [1000 ] _temporary_;                                                                                                         
 array _C1 [1000 ] $ 17  _temporary_;                                                                                                   
 array _C2 [1000 ] $ 17  _temporary_;                                                                                                   
 array _C3 [1000 ] $ 17  _temporary_;                                                                                                   
 array _C4 [1000 ] $ 17  _temporary_;                                                                                                   
 array _C5 [1000 ] $ 17  _temporary_;                                                                                                   
 array _N1 [1000 ] _temporary_;                                                                                                         
 array _N2 [1000 ] _temporary_;                                                                                                         
 array _N3 [1000 ] _temporary_;                                                                                                         
 array _N4 [1000 ] _temporary_;                                                                                                         
 array _N5 [1000 ] _temporary_;                                                                                                         
 set have curobs=curobs end = END nobs=nobs;                                                                                            
_ID [curobs] = ID ;                                                                                                                     
_C1 [curobs] = C1 ;                                                                                                                     
_C2 [curobs] = C2 ;                                                                                                                     
_C3 [curobs] = C3 ;                                                                                                                     
_C4 [curobs] = C4 ;                                                                                                                     
_C5 [curobs] = C5 ;                                                                                                                     
_N1 [curobs] = N1 ;                                                                                                                     
_N2 [curobs] = N2 ;                                                                                                                     
_N3 [curobs] = N3 ;                                                                                                                     
_N4 [curobs] = N4 ;                                                                                                                     
_N5 [curobs] = N5 ;                                                                                                                     
 if END;                                                                                                                                
call sortN (of _ID [*]);                                                                                                                
call sortC (of _C1 [*]);                                                                                                                
call sortC (of _C2 [*]);                                                                                                                
call sortC (of _C3 [*]);                                                                                                                
call sortC (of _C4 [*]);                                                                                                                
call sortC (of _C5 [*]);                                                                                                                
call sortN (of _N1 [*]);                                                                                                                
call sortN (of _N2 [*]);                                                                                                                
call sortN (of _N3 [*]);                                                                                                                
call sortN (of _N4 [*]);                                                                                                                
call sortN (of _N5 [*]);                                                                                                                
 do _N_ = 1 to nobs;                                                                                                                    
ID   = _ID [_N_];                                                                                                                       
C1   = _C1 [_N_];                                                                                                                       
C2   = _C2 [_N_];                                                                                                                       
C3   = _C3 [_N_];                                                                                                                       
C4   = _C4 [_N_];                                                                                                                       
C5   = _C5 [_N_];                                                                                                                       
N1   = _N1 [_N_];                                                                                                                       
N2   = _N2 [_N_];                                                                                                                       
N3   = _N3 [_N_];                                                                                                                       
N4   = _N4 [_N_];                                                                                                                       
N5   = _N5 [_N_];                                                                                                                       
 output; end;                                                                                                                           
run;                                                                                                                                    
*/                                                                                                                                      
                                                                                                                                        
Up to 40 obs from WANT total obs=1,000                                                                                                  
                                                                                                                                        
 Obs    ID    C1     C2     C3     C4     C5     N1    N2    N3    N4    N5                                                             
                                                                                                                                        
   1     1    C      C      C      C      C       1     1     1     1     1                                                             
   2     2    C      C      C      C      C       1     1     1     1     1                                                             
   3     3    C      C      C      C      C       1     1     1     1     1                                                             
   4     4    C      C      C      C      C       1     1     1     1     1                                                             
   5     5    C      C      C      C      C       1     1     1     1     1                                                             
   6     6    C      C      C      C      C       1     1     1     1     1                                                             
   7     7    C      C      C      C      C       1     1     1     1     1                                                             
   8     8    I      I      C      C      C       1     1     1     1     1                                                             
   9     9    I      I      C      C      C       1     1     1     1     1                                                             
  10    10    I      I      C      I      C       2     2     1     1     1                                                             
  11    11    I      I      C      I      I       2     2     1     1     1                                                             
  12    12    I      I      C      I      I       2     2     1     1     1                                                             
  13    13    I      I      I      I      I       2     2     1     1     1                                                             
  14    14    I      I      I      I      I       2     2     2     1     2                                                             
  15    15    I      I      I      I      I       2     3     2     1     2                                                             
  16    16    I      I      I      I      I       2     3     2     1     2                                                             
  17    17    II     II     I      I      I       3     3     2     1     2                                                             
                                                                                                                                        
                                                                                                                                        
/*__                                     _ _                          _                                                                 
 / _|   _ __   ___  _ __ _ __ ___   __ _| (_)_______   ___  ___  _ __| |_     _ __ ___   ___ _ __ __ _  ___                             
| |_   | `_ \ / _ \| `__| `_ ` _ \ / _` | | |_  / _ \ / __|/ _ \| `__| __|   | `_ ` _ \ / _ \ `__/ _` |/ _ \                            
|  _|  | | | | (_) | |  | | | | | | (_| | | |/ /  __/ \__ \ (_) | |  | |_    | | | | | |  __/ | | (_| |  __/                            
|_|(_) |_| |_|\___/|_|  |_| |_| |_|\__,_|_|_/___\___| |___/\___/|_|   \__|   |_| |_| |_|\___|_|  \__, |\___|                            
                                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
proc datasets lib=work nolist;                                                                                                          
  delete want;                                                                                                                          
run;quit;                                                                                                                               
                                                                                                                                        
%utl_gather(sashelp.class,var,val,,clsxpo,WithFormats=Y);                                                                               
                                                                                                                                        
/*                                                                                                                                      
Up to 40 obs WORK.CLSXPO total obs=95                                                                                                   
                                                                                                                                        
Obs    VAR       VAL       _COLFORMAT    _COLTYP                                                                                        
                                                                                                                                        
  1    NAME      Joyce      $8.             C                                                                                           
  2    SEX       F          $1.             C                                                                                           
  3    AGE       11         BEST12.         N                                                                                           
  4    HEIGHT    51.3       BEST12.         N                                                                                           
  5    WEIGHT    50.5       BEST12.         N                                                                                           
  6    NAME      Louise     $8.             C                                                                                           
  7    SEX       F          $1.             C                                                                                           
*/                                                                                                                                      
                                                                                                                                        
proc sort data=clsxpo out=clsSrt noequals sortseq=linguistic(Numeric_Collation=ON);                                                     
by var val;                                                                                                                             
run;quit;                                                                                                                               
                                                                                                                                        
/*                                                                                                                                      
Up to 40 obs WORK.CLSSRT total obs=95                                                                                                   
                                                                                                                                        
Obs    VAR       VAL       _COLFORMAT    _COLTYP                                                                                        
                                                                                                                                        
  1    AGE       11         BEST12.         N                                                                                           
  2    AGE       11         BEST12.         N                                                                                           
  3    AGE       12         BEST12.         N                                                                                           
  4    AGE       12         BEST12.         N                                                                                           
  5    AGE       12         BEST12.         N                                                                                           
  6    AGE       12         BEST12.         N                                                                                           
  7    AGE       12         BEST12.         N                                                                                           
  8    AGE       13         BEST12.         N                                                                                           
  9    AGE       13         BEST12.         N                                                                                           
 10    AGE       13         BEST12.         N                                                                                           
 11    AGE       14         BEST12.         N                                                                                           
 12    AGE       14         BEST12.         N                                                                                           
 13    AGE       14         BEST12.         N                                                                                           
 14    AGE       14         BEST12.         N                                                                                           
 15    AGE       15         BEST12.         N                                                                                           
 16    AGE       15         BEST12.         N                                                                                           
 17    AGE       15         BEST12.         N                                                                                           
 18    AGE       15         BEST12.         N                                                                                           
 19    AGE       16         BEST12.         N                                                                                           
 20    HEIGHT    51.3       BEST12.         N                                                                                           
*/                                                                                                                                      
                                                                                                                                        
data want(rename=( %do_over(nams,phrase=%str(x_?=?))));                                                                                 
  if _n_=0 then do; %dosubl('                                                                                                           
      proc sql;                                                                                                                         
        select distinct catx(" ",cats("x_",var),"8") into :_retain separated by " "                                                     
        from clsXpo where _coltyp="N";quit;');                                                                                          
  end;                                                                                                                                  
  retain &_retain;                                                                                                                      
  merge                                                                                                                                 
    %do_over(nams,phrase=%str(clsSrt(where=(var="?") rename=val=?)));                                                                   
    %do_over(nams,phrase=%str(x_?=?;));                                                                                                 
   keep x_:;                                                                                                                            
run;quit;                                                                                                                               
                                                                                                                                        
 Variables in Creation Order                                                                                                            
                                                                                                                                        
#    Variable    Type    Len                                                                                                            
                                                                                                                                        
1    AGE         Num       8                                                                                                            
2    HEIGHT      Num       8                                                                                                            
3    WEIGHT      Num       8                                                                                                            
4    NAME        Char    200                                                                                                            
5    SEX         Char    200                                                                                                            
                                                                                                                                        
Up to 40 obs from WANT total obs=19                                                                                                     
                                                                                                                                        
Obs    AGE    HEIGHT    WEIGHT    NAME       SEX                                                                                        
                                                                                                                                        
  1     11     51.3       50.5    Alfred      F                                                                                         
  2     11     56.3       77.0    Alice       F                                                                                         
  3     12     56.5       83.0    Barbara     F                                                                                         
  4     12     57.3       84.0    Carol       F                                                                                         
  5     12     57.5       84.0    Henry       F                                                                                         
  6     12     59.0       84.5    James       F                                                                                         
  7     12     59.8       85.0    Jane        F                                                                                         
  8     13     62.5       90.0    Janet       F                                                                                         
  9     13     62.5       98.0    Jeffrey     F                                                                                         
 10     13     62.8       99.5    John        M                                                                                         
 11     14     63.5      102.5    Joyce       M                                                                                         
 12     14     64.3      102.5    Judy        M                                                                                         
 13     14     64.8      112.0    Louise      M                                                                                         
 14     14     65.3      112.0    Mary        M                                                                                         
 15     15     66.5      112.5    Philip      M                                                                                         
 16     15     66.5      112.5    Robert      M                                                                                         
 17     15     67.0      128.0    Ronald      M                                                                                         
 18     15     69.0      133.0    Thomas      M                                                                                         
 19     16     72.0      150.0    William     M                                                                                         
                                                                                                                                        
                                                                                                                                        
/*         ___ __  __ _                                                                                                                 
  __ _    |_ _|  \/  | |                                                                                                                
 / _` |    | || |\/| | |                                                                                                                
| (_| |_   | || |  | | |___                                                                                                             
 \__, (_) |___|_|  |_|_____|                                                                                                            
 |___/                                                                                                                                  
*/                                                                                                                                      
                                                                                                                                        
                                                                                                                                        
data have(drop=j);                                                                                                                      
                                                                                                                                        
  retain id;                                                                                                                            
                                                                                                                                        
  array cs[*] c1-c5;                                                                                                                    
                                                                                                                                        
  do id=1 to 10;                                                                                                                        
                                                                                                                                        
    do j=1 to dim(cs);                                                                                                                  
       cs[j]=int(100*uniform(4321)) + 1;                                                                                                
    end;                                                                                                                                
                                                                                                                                        
    output;                                                                                                                             
                                                                                                                                        
  end;                                                                                                                                  
                                                                                                                                        
run;quit;                                                                                                                               
                                                                                                                                        
                                                                                                                                        
proc iml;                                                                                                                               
   use have;                                                                                                                            
      read all var _num_ into x[colname=varnames];                                                                                      
   close have;                                                                                                                          
                                                                                                                                        
   do i=1 to ncol(x);                                                                                                                   
      y = x[ ,i];                                                                                                                       
      call sort(y);                                                                                                                     
      x[, i] = y;                                                                                                                       
   end;                                                                                                                                 
                                                                                                                                        
   create want from x[colname=varnames];;                                                                                               
      append from x;                                                                                                                    
   close want;                                                                                                                          
quit;                                                                                                                                   
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
Up to 40 obs WORK.WANT total obs=10                                                                                                     
                                                                                                                                        
Obs    ID    C1    C2    C3    C4    C5                                                                                                 
                                                                                                                                        
  1     1    18     4     7    11     8                                                                                                 
  2     2    19     5    19    16    25                                                                                                 
  3     3    23     9    37    24    31                                                                                                 
  4     4    25    22    44    31    31                                                                                                 
  5     5    26    56    52    34    64                                                                                                 
  6     6    28    65    52    41    74                                                                                                 
  7     7    30    70    65    59    88                                                                                                 
  8     8    56    76    78    61    89                                                                                                 
  9     9    72    78    88    73    93                                                                                                 
 10    10    88    96    97    87    94                                                                                                 
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
