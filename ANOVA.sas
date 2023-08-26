/*IMPORT DATA*/
proc import datafile="/home/u62868661/Datasets/ANOVA/Pain Thresholds.csv"
dbms=csv
out=df
replace;
run;

/*DESCRIPTIVE TABLE*/
proc means data=df chartype mean std min max median n range vardef=df clm 
		alpha=0.05 q1 q3 qrange qmethod=os;
	var 'Pain Tolerance'n;
	class 'Hair Color'n;
run;

/*HISTOGRAMS*/
proc univariate data=df vardef=df noprint;
	var 'Pain Tolerance'n;
	class 'Hair Color'n;
	histogram 'Pain Tolerance'n / normal(noprint) kernel;
	inset mean std min max median n range q1 q3 qrange / position=nw;
run;

/*BOXPLOTS*/
proc boxplot data=df;
	plot ('Pain Tolerance'n)*'Hair Color'n / boxstyle=schematic;
	insetgroup mean stddev min max n q1 q2 q3 range / position=top;
run;

/*ANOVA*/
proc glm data=df;
	class 'Hair Color'n;
	model 'Pain Tolerance'n='Hair Color'n;
	means 'Hair Color'n / hovtest=levene welch plots=none;
	lsmeans 'Hair Color'n / adjust=tukey pdiff alpha=.05;
	run;
	
/*NON-PARAMETRIC*/
proc npar1way data=df wilcoxon median dscf plots(only)=(medianplot);
	class 'Hair Color'n;
	var 'Pain Tolerance'n;
run;	