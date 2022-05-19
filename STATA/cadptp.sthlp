{smcl}
{* *! version 1.0.0 6 May 2020}{...}


{title:Title}

{p2colset 5 20 30 2}{...}
{p2col:{hi:cadptp} {hline 2}}CAD-PTP: Clinical likelihood of coronary artery disease {p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
cadptp using data in memory

{p 8 17 2}
				{cmdab:cadptp}
				{ifin}
				{cmd:,}
				{opt m:ale}({it:varname}) 
				{opt age:}({it:varname}) 
				{opt symp:}({it:varname}) 
				[ {opt nb_rf:}({it:varname}) 
				{{opt cacs:}({it:varname}) 
                {opt suff:ix}({it:string})
				{opt replace}
				{opt grp} 
				]



{pstd}



{synoptset 21 tabbed}{...}
{synopthdr:cadptp options}
{synoptline}
{syntab:Required}
{synopt:{opt m:ale(varname)}}gender, where male = 1 and female = 0{p_end}
{synopt:{opt age:}(varname)}age in years{p_end}
{synopt:{opt symp:}(varname)} Symptoms, where Non-typical angina=0, Atypical angina or dyspnoea=1 and Typical angina =2{p_end}


{syntab:Optional}
{synopt:{opt nb_rf}} Number of risk factors (0-5) (Riskfactors: Family history of early CAD, Smoking, Dyslipidaemia, Hypertension or Diabetes) {p_end}
{synopt:{opt cacs}} Coronary artery calcium score determined by the Agatston method  {p_end}
{synopt:{opt suffix}(string)} Adds a suffix to the names of variables created by {cmd:cadptp}{p_end}
{synopt:{opt replace}} Replaces variables created by {cmd:cadptp} if they already exist{p_end}
{synopt:{opt grp}} Estimates the pre-test probability groups: 0"Very low risk (<=5%)" 1 "Low risk (5- <=15%)" 2 "Low intermed (15- <=50%)" 3 "High intermed (50- <=85%)" 4 "High (>85%)" {p_end}
{synoptline}
{p 4 6 2}



	
{title:Description}

{pstd}
The {cmd:cadptp} command calculates pre-test probability (PTP) of having obstructive coronary artery disease in patients with chronic coronary syndrome (symptoms suggestive of obstructive coronary artery disease) without previously documented coronary artery disease. The model is based on data from >40,000 patients and validated in >15.000 [1].  
When only age, gender and symptoms are used as input the basic PTP (ptp_basic) is calcualted.  If  the number of risk factors are given the risk factor weighted clinical likelihood of CAD (ptp_rf) is also calculated.  
Finally, if CACS is given a CACS weighted clinical likelihood (ptp_cacs) is estimated.

 [1] Winther et al. Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease, Journals of the American College of Cardiology, 76.21 (2020): 2421-2432.

{title:Examples}

    {hline}
	


{pstd}  {com}. use https://vbn.aau.dk/files/331937080/synthetic_cadptp.dta
        {txt}(Synthetic dataset of patients with chronic coronary syndrome )
		{p_end}

{pstd}Run {cmd:cadptp} using data in memory{p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) }

{pstd}Run {cmd:cadptp} using data in memory including number of risk factors {p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) nb_rf(nb_rf_5 )  }

{pstd}Run {cmd:cadptp} using data in memory including number of risk factors & CACS  {p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) nb_rf(nb_rf_5 )  cacs(calciumscoreagatston) }

{pstd}Run command, specifying the variable suffix {p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) nb_rf(nb_rf_5 )  cacs(calciumscoreagatston) suffix("_newStudy")}

{pstd}Run {cmd:cadptp} using data in memory including number of risk factors & CACS  and  replace existing estimates{p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) nb_rf(nb_rf_5 )  cacs(calciumscoreagatston) replace }

{pstd}Run {cmd:cadptp} using data in memory including number of risk factors & CACS, replace existing estimates and estimates the pre-test probability groups  {p_end}
{phang2}{cmd:. cadptp , male(sex) age(age) symp(symp_gr3) nb_rf(nb_rf_5 )  cacs(calciumscoreagatston) replace  grp}



    {hline}



{title:Stored results}

{pstd}
{cmd:cadptp} stores the following in memory:

{synoptset 15 tabbed}{...}

{synopt:{cmd:ptp_basic}} Basic PTP {p_end}
{synopt:{cmd:ptp_rf}} Risk factor weighted clinical likelihood of CAD {p_end}
{synopt:{cmd:ptp_cacs}} CACS weighted clinical likelihood{p_end}



{marker citation}{title:Citation of {cmd:cadptp}}

{p 4 8 2}{cmd:cadptp} is not an official Stata command. It is a free contribution
to the research community, like a paper. Please cite it as such: {p_end}

{p 4 8 2}{it}
Schmidt SE & Winther S (2020). cadptp: Stata module for calculating Clinical likelihood of coronary artery disease, github.com/CardioLab/cadptp  {p_end} {reset}

{pstd} And please cite it the orginal reseasch paper: {p_end}
{p 4 8 2}

{pstd} {it} Winther et al. Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease, Journals of the American College of Cardiology, In press {p_end}
{p 4 8 2}

   {hline}
{title:Authors}

{p 4 8 2}	Samuel Emil Schmidt, Aalborg Univerisity, DK {p_end}
{p 4 8 2} {browse "mailto:sschmidt@hst.aau.dk":sschmidt@hst.aau.dk}{p_end}
{p 4 8 2}	Simon Winther, Hospital Unit West, DK {p_end}
{p 4 8 2}{browse "mailto:sw@dadlnet.dk":sw@dadlnet.dk}{p_end}



