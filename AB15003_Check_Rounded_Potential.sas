/*********************************************************************************************************************
STUDY         AB15003 check a rounded potential               				  

AUTHOR        Dadi Abel DIEDHIOU
	
VERSION       n°1										
DATE          20210501
/*********************************************************************************************************************/
/*TO UPDATE to declare library of SAS DATASETS*/
/*>>>>>>>>>>>>>ALL DATA EXPORTED in SAS >>>>>*/ libname AB15003 "H:\AB15003\01_Data Bases\01_LS_Prod" access=readonly; 
option fmtsearch=(AB15003);

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*CHECK ROUNDED POTENTIAL FOR Systolic Blood Pressure (mmHg)*/
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/

DATA REP_VS (KEEP = COUNTRYID SITEID SBP LASTDIGIT);
RETAIN COUNTRYID SITEID SBP LASTDIGIT;
SET AB15003.REP_VS;
SBP1 = PUT(SBP,3.);
IF LENGTH(SBP1) = 3 
THEN LASTDIGIT = SUBSTR(SBP1,3,1);
IF LENGTH(SBP1) = 2 
THEN LASTDIGIT = SUBSTR(SBP1,2,1);
RUN;

PROC SORT DATA = REP_VS; BY SITEID; RUN;

proc sql ;
	create table REP_VS1 as
	select distinct SITEID,LASTDIGIT,count(LASTDIGIT) as OCCURENCE
	from REP_VS
	group by SITEID,LASTDIGIT;
run;

proc sql ;
	create table REP_VS2 as
	select distinct SITEID,LASTDIGIT, OCCURENCE, sum(OCCURENCE) as TOTAL_OCC
	from REP_VS1
	group by SITEID;
run;

DATA RESULT;
SET REP_VS2;
LENGTH RESULT $25.;
IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 > 50
THEN RESULT = "POTENTIAL ROUNDING";
ELSE IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 <= 50
THEN RESULT = "NO POTENTIAL ROUNDING";
DROP TOTAL_OCC;
RUN;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*CHECK ROUNDED POTENTIAL FOR Diastolic Blood Pressure (mmHg)*/
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/

DATA REP_VS_DBP (KEEP = COUNTRYID SITEID DBP LASTDIGIT);
RETAIN COUNTRYID SITEID DBP LASTDIGIT;
SET AB15003.REP_VS;
DBP1 = PUT(DBP,3.);
IF LENGTH(DBP1) = 3 
THEN LASTDIGIT = SUBSTR(DBP1,3,1);
IF LENGTH(DBP1) = 2 
THEN LASTDIGIT = SUBSTR(DBP1,2,1);
RUN;

PROC SORT DATA = REP_VS_DBP; BY SITEID; RUN;

proc sql ;
	create table REP_VS_DBP1 as
	select distinct SITEID,LASTDIGIT,count(LASTDIGIT) as OCCURENCE
	from REP_VS_DBP
	group by SITEID,LASTDIGIT;
run;

proc sql ;
	create table REP_VS_DBP2 as
	select distinct SITEID,LASTDIGIT, OCCURENCE, sum(OCCURENCE) as TOTAL_OCC
	from REP_VS_DBP1
	group by SITEID;
run;

DATA RESULT_DBP;
SET REP_VS_DBP2;
LENGTH RESULT $25.;
IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 > 50
THEN RESULT = "POTENTIAL ROUNDING";
ELSE IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 <= 50
THEN RESULT = "NO POTENTIAL ROUNDING";
DROP TOTAL_OCC;
RUN;

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*CHECK ROUNDED POTENTIAL FOR THE WEIGHT)    					 */
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<*/

DATA REP_VS_WEIGHT (KEEP = COUNTRYID SITEID WEIGHT LASTDIGIT);
RETAIN COUNTRYID SITEID WEIGHT LASTDIGIT ;
SET AB15003.REP_VS;
DEC = SCAN(WEIGHT,2 , '.');
WEIGHT1 = PUT(WEIGHT,3.);

IF DEC EQ "" AND LENGTH(WEIGHT1) = 3
THEN LASTDIGIT = SUBSTR(WEIGHT1,3,1);

ELSE IF DEC EQ "" AND LENGTH(WEIGHT1) = 2
THEN LASTDIGIT = SUBSTR(WEIGHT1,2,1);

ELSE LASTDIGIT = "";

RUN;

DATA REP_VS_WEIGHT; SET REP_VS_WEIGHT; WHERE LASTDIGIT NE "" ; RUN;

PROC SORT DATA = REP_VS_WEIGHT; BY SITEID; RUN;

proc sql ;
	create table REP_VS_WEIGHT1 as
	select distinct SITEID,LASTDIGIT,count(LASTDIGIT) as OCCURENCE
	from REP_VS_WEIGHT
	group by SITEID,LASTDIGIT;
run;

proc sql ;
	create table REP_VS_WEIGHT2 as
	select distinct SITEID,LASTDIGIT, OCCURENCE, sum(OCCURENCE) as TOTAL_OCC
	from REP_VS_WEIGHT1
	group by SITEID;
run;

DATA RESULT_WEIGHT;
SET REP_VS_WEIGHT2;
LENGTH RESULT $25.;
IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 > 50
THEN RESULT = "POTENTIAL ROUNDING";
ELSE IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 <= 50
THEN RESULT = "NO POTENTIAL ROUNDING";
DROP TOTAL_OCC;
RUN;

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*CHECK ROUNDED POTENTIAL FOR THE HEIGHT     					 */
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<*/

DATA REP_VS_HEIGHT (KEEP = COUNTRYID SITEID HEIGHT LASTDIGIT);
RETAIN COUNTRYID SITEID HEIGHT LASTDIGIT ;
SET AB15003.REP_VS;
DEC = SCAN(HEIGHT,2 , '.');
HEIGHT1 = PUT(HEIGHT,3.);

IF DEC EQ "" AND LENGTH(HEIGHT1) = 3
THEN LASTDIGIT = SUBSTR(HEIGHT1,3,1);

ELSE IF DEC EQ "" AND LENGTH(HEIGHT1) = 2
THEN LASTDIGIT = SUBSTR(HEIGHT1,2,1);

ELSE LASTDIGIT = "";

RUN;

DATA REP_VS_HEIGHT; SET REP_VS_HEIGHT; WHERE LASTDIGIT NE "." AND  LASTDIGIT NE " " ; RUN;

PROC SORT DATA = REP_VS_HEIGHT; BY SITEID; RUN;

proc sql ;
	create table REP_VS_HEIGHT1 as
	select distinct SITEID,LASTDIGIT,count(LASTDIGIT) as OCCURENCE
	from REP_VS_HEIGHT
	group by SITEID,LASTDIGIT;
run;

proc sql ;
	create table REP_VS_HEIGHT2 as
	select distinct SITEID,LASTDIGIT, OCCURENCE, sum(OCCURENCE) as TOTAL_OCC
	from REP_VS_HEIGHT1
	group by SITEID;
run;

DATA RESULT_HEIGHT;
SET REP_VS_HEIGHT2;
LENGTH RESULT $25.;
IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 > 50
THEN RESULT = "POTENTIAL ROUNDING";
ELSE IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 <= 50
THEN RESULT = "NO POTENTIAL ROUNDING";
DROP TOTAL_OCC;
RUN;

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*CHECK ROUNDED POTENTIAL FOR THE TEMPERATURE     				 */
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<*/

DATA REP_VS_TEMP (KEEP = COUNTRYID SITEID TEMP LASTDIGIT);
RETAIN COUNTRYID SITEID TEMP LASTDIGIT ;
SET AB15003.REP_VS;
DEC = SCAN(TEMP,2 , '.');
TEMP1 = PUT(TEMP,3.);

IF DEC EQ "" AND LENGTH(TEMP1) = 3
THEN LASTDIGIT = SUBSTR(TEMP1,3,1);

ELSE IF DEC EQ "" AND LENGTH(TEMP1) = 2
THEN LASTDIGIT = SUBSTR(TEMP1,2,1);

ELSE LASTDIGIT = "";

RUN;

DATA REP_VS_TEMP; SET REP_VS_TEMP; WHERE LASTDIGIT NE "." AND  LASTDIGIT NE " " ; RUN;

PROC SORT DATA = REP_VS_TEMP; BY SITEID; RUN;

proc sql ;
	create table REP_VS_TEMP1 as
	select distinct SITEID,LASTDIGIT,count(LASTDIGIT) as OCCURENCE
	from REP_VS_TEMP
	group by SITEID,LASTDIGIT;
run;

proc sql ;
	create table REP_VS_TEMP2 as
	select distinct SITEID,LASTDIGIT, OCCURENCE, sum(OCCURENCE) as TOTAL_OCC
	from REP_VS_TEMP1
	group by SITEID;
run;

DATA RESULT_TEMP;
SET REP_VS_TEMP2;
LENGTH RESULT $25.;
IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 > 50
THEN RESULT = "POTENTIAL ROUNDING";
ELSE IF LASTDIGIT IN ("0", "5")
AND (OCCURENCE/TOTAL_OCC)*100 <= 50
THEN RESULT = "NO POTENTIAL ROUNDING";
DROP TOTAL_OCC;
RUN;

/*EXPORT FILE EXCEL*/
ODS  tagsets.excelxp  
	FILE = "H:\AB15003\02_SAS Programs\Metrics\Data_Out\AB15003_CHECK_ROUNDED_POTENTIAL_%sysfunc(date(), date9.).xls"
	options( embedded_titles="yes" sheet_name="Monitoring" orientation='landscape');
	Footnote j=l "Output on %sysfunc(date(), date9.)";

ODS tagsets.excelxp OPTIONS(FROZEN_HEADERS = "3" sheet_interval='none' SHEET_NAME = 'Systolic Blood Pressure (mmHg)');

PROC REPORT DATA = RESULT

	nowd headline headskip missing ls=256 ps=90 
	Style(header)=[  cellspacing = 3  borderwidth = 1 bordercolordark = black background=grey foreground=white just=center vjust=center font_size=2 font_weight=bold]
	Style(column)=[CELLWIDTH=150  cellspacing = 3  borderwidth = 1 bordercolordark = black background=white just=center vjust=center font_size=2];
	title j=c "Systolic Blood Pressure (mmHg)";
	
	COMPUTE RESULT ;
	IF RESULT = "POTENTIAL ROUNDING" THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTPINK]");
	ELSE IF RESULT = "NO POTENTIAL ROUNDING" THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTGREEN]");
	ENDCOMP;

RUN;

ODS tagsets.excelxp OPTIONS(FROZEN_HEADERS = "3" sheet_interval='none' SHEET_NAME = 'Diastolic Blood Pressure (mmHg)');
PROC REPORT DATA = RESULT_DBP

	nowd headline headskip missing ls=256 ps=90 
	Style(header)=[  cellspacing = 3  borderwidth = 1 bordercolordark = black background=grey foreground=white just=center vjust=center font_size=2 font_weight=bold]
	Style(column)=[CELLWIDTH=150  cellspacing = 3  borderwidth = 1 bordercolordark = black background=white just=center vjust=center font_size=2];
	title j=c "Diastolic Blood Pressure (mmHg)";
	
	COMPUTE RESULT ;
	IF RESULT = "POTENTIAL ROUNDING" THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTPINK]");
	ELSE IF RESULT = "NO POTENTIAL ROUNDING" THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTGREEN]");
	ENDCOMP;

RUN;

ODS tagsets.excelxp OPTIONS(FROZEN_HEADERS = "3" sheet_interval='none' SHEET_NAME = 'WEIGHT');
PROC REPORT DATA = RESULT_WEIGHT

	nowd headline headskip missing ls=256 ps=90 
	Style(header)=[  cellspacing = 3  borderwidth = 1 bordercolordark = black background=grey foreground=white just=center vjust=center font_size=2 font_weight=bold]
	Style(column)=[CELLWIDTH=150  cellspacing = 3  borderwidth = 1 bordercolordark = black background=white just=center vjust=center font_size=2];
	title j=c "Weight";
	
	COMPUTE RESULT ;
	IF RESULT = "POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTPINK]");
	ELSE IF RESULT = "NO POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTGREEN]");
	ENDCOMP;

RUN;

ODS tagsets.excelxp OPTIONS(FROZEN_HEADERS = "3" sheet_interval='none' SHEET_NAME = 'HEIGHT');
PROC REPORT DATA = RESULT_HEIGHT

	nowd headline headskip missing ls=256 ps=90 
	Style(header)=[  cellspacing = 3  borderwidth = 1 bordercolordark = black background=grey foreground=white just=center vjust=center font_size=2 font_weight=bold]
	Style(column)=[CELLWIDTH=150  cellspacing = 3  borderwidth = 1 bordercolordark = black background=white just=center vjust=center font_size=2];
	title j=c "Height";
	
	COMPUTE RESULT ;
	IF RESULT = "POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTPINK]");
	ELSE IF RESULT = "NO POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTGREEN]");
	ENDCOMP;

RUN;

ODS tagsets.excelxp OPTIONS(FROZEN_HEADERS = "3" sheet_interval='none' SHEET_NAME = 'TEMPERATURE');
PROC REPORT DATA = RESULT_TEMP

	nowd headline headskip missing ls=256 ps=90 
	Style(header)=[  cellspacing = 3  borderwidth = 1 bordercolordark = black background=grey foreground=white just=center vjust=center font_size=2 font_weight=bold]
	Style(column)=[CELLWIDTH=150  cellspacing = 3  borderwidth = 1 bordercolordark = black background=white just=center vjust=center font_size=2];
	title j=c "Temperature";
	
	COMPUTE RESULT ;
	IF RESULT = "POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTPINK]");
	ELSE IF RESULT = "NO POTENTIAL ROUNDING"  THEN CALL DEFINE (_ROW_, "STYLE", "STYLE = [BACKGROUNDCOLOR = LIGHTGREEN]");
	ENDCOMP;

RUN;
/*Close file*/

ODS tagsets.excelxp CLOSE;
