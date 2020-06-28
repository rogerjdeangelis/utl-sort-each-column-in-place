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
                                                                                                                    
github                                                                                                              
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
                                                                                                                    
                                                                                                                    
