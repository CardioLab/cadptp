program cadptp, rclass
version 13.0
 	syntax [if] [in] ,  ///
		male(varname numeric)  	/// integer 0 or 1
		age(varname numeric)   	/// Years
		symp(varname numeric)   /// 0: Non-typical angina  1: Atypical angina or dyspnoea 2: Typical angina
		[nb_rf(varname numeric) /// integer: 0-5 
		cacs(varname numeric) /// integer: 0-inf
		replace  	 		///  replaces variables created by cadptp if they already exist
		grp					/// Estimates the PTP groups 0"Very low risk (<=5%)" 1 "Low risk (5- <=15%)" 2 "Low intermed (15- <=50%)" 3 "High intermed (50- <=85%)" 4 "High (>85%)" 
		suffix(str) *] ///   adds a suffix to the names of variables created by cadptp

		marksample touse 
	    markout `touse' `male' `symp' `age'
	
	
	
/* drop variables if option "replace" is chosen */
		 
if "`replace'" != "" { 

	capture confirm variable ptp_basic`suffix'
	if !_rc {		   
				   drop ptp_basic`suffix'
		   }
		   
	if "`grp'" !="" { 
	capture confirm variable ptp_basic_grp`suffix'
	if !_rc {		   
				   drop ptp_basic_grp`suffix'
		   }
    }
		   
	if "`nb_rf'" !="" { 
	
		capture confirm variable ptp_rf`suffix'
		if !_rc {	   
					   drop ptp_rf`suffix'
			   }
			   
		if "`grp'" !="" { 
		capture confirm variable ptp_rf_grp`suffix'
		if !_rc {		   
						drop ptp_rf_grp`suffix'
				   }
		}
		   
	}
	
	if "`cacs'" !="" { 
		capture confirm variable ptp_cacs`suffix'
		if !_rc {
					   
					   drop ptp_cacs`suffix'
			   }
			   
		if "`grp'" !="" { 
			capture confirm variable ptp_cacs_grp`suffix'
			if !_rc {		   
						   drop ptp_cacs_grp`suffix'
				   }
		}
			   
	}   
	

}



  
* Estimate PTP values
quietly {

	tempvar symp_non_anglinal  symp_typical nb_rf_3 cacs_1_9 cacs_10_99 cacs_100_399 cacs_400_999 cacs_1000 riskgrp5

	label define `riskgrp5' 0"Very low risk (<=5%)" 1 "Low risk (5- <=15%)" 2 "Low intermed (15- <=50%)" 3 "High intermed (50- <=85%)" 4 "High (>85%)" 

	* One hot encoding symptoms
	gen `symp_non_anglinal' = (`symp'==0)
	gen `symp_typical' = (`symp'==2)

	* basic model
	gen ptp_basic`suffix' =.
	replace ptp_basic`suffix' = 1./(1+exp(-(-7.0753 + (1.2308*`male') + (0.0642*`age') + (2.2501*`symp_typical') + (-0.5095*`symp_non_anglinal') + (-0.0191*`age'*`symp_typical') )))  if `touse' 
	label variable ptp_basic`suffix' "Pre-test probability basic"
	
	if "`grp'" !="" { 
		gen ptp_basic_grp`suffix'=.
		replace ptp_basic_grp`suffix' =0 if ptp_basic >=0.00 & ptp_basic <=.05
		replace ptp_basic_grp`suffix'=1 if ptp_basic >0.05 & ptp_basic <=0.15
		replace ptp_basic_grp`suffix' =2 if ptp_basic >0.15 & ptp_basic <=0.50
		replace ptp_basic_grp`suffix' =3 if ptp_basic >0.50 & ptp_basic<=0.85
		replace ptp_basic_grp`suffix' =4 if ptp_basic >0.85 & ptp_basic <=1.00

		label variable ptp_basic_grp`suffix' "Pre-test probability groups basic"
		label values ptp_basic_grp`suffix' `riskgrp5'
	}
	
	* In case of number of risk factores is given estimate PTP_RF
	if "`nb_rf'" !="" { 
		gen `nb_rf_3'  =.
		replace `nb_rf_3' =1 if `nb_rf' < 2
		replace `nb_rf_3' =2 if `nb_rf' >= 2 & `nb_rf' < 4
		replace `nb_rf_3' =3 if `nb_rf' >= 4 

		gen ptp_rf`suffix' =.
		replace ptp_rf`suffix' = 1./(1+exp(-(-9.5260 + (1.6128*`male') + (0.08440*`age') +  (2.7112* `symp_typical' ) + (-0.4675*`symp_non_anglinal') + (1.4940*`nb_rf_3') + (-0.0187*`age'*`symp_typical') + (-0.0131 *`age'*`nb_rf_3') + (-0.2799*`symp_typical'*`nb_rf_3') + (-0.2091*`male'*`nb_rf_3')))) if  `nb_rf' !=. &  `touse' 
		label variable ptp_rf`suffix' "Pre-test probability risk factor weighted"
	
		if "`grp'" !="" { 	
			gen ptp_rf_grp`suffix'=.
			replace ptp_rf_grp`suffix' =0 if ptp_rf >=0.00 & ptp_rf <=.05
			replace ptp_rf_grp`suffix'=1 if ptp_rf >0.05 & ptp_rf <=0.15
			replace ptp_rf_grp`suffix' =2 if ptp_rf >0.15 & ptp_rf <=0.50
			replace ptp_rf_grp`suffix' =3 if ptp_rf >0.50 & ptp_rf<=0.85
			replace ptp_rf_grp`suffix' =4 if ptp_rf >0.85 & ptp_rf <=1.00

			label variable ptp_rf_grp`suffix' "Pre-test probability groups basic"
			label values ptp_rf_grp`suffix' `riskgrp5'
		}
	}
	 

	 *	In case of CACS is given estimate PTP_CACS
	if "`cacs'" !="" { 
	
		gen `cacs_1_9' = cond(`cacs' >= 1 & `cacs' < 10, 1, 0)
		gen `cacs_10_99' = cond(`cacs' >= 10 & `cacs' < 100, 1, 0)
		gen `cacs_100_399' = cond(`cacs' >= 100 & `cacs' < 400, 1, 0)
		gen `cacs_400_999' = cond(`cacs' >= 400 & `cacs' < 1000, 1, 0)
		gen `cacs_1000' = cond(`cacs' >= 1000, 1, 0)
		
		
		gen ptp_cacs`suffix' =.
		replace ptp_cacs`suffix' = 0.0013 + (ptp_rf * 0.2021)  + (`cacs_1_9'*0.0082) + (`cacs_10_99'*0.0238) + (`cacs_100_399'*0.1131) + (`cacs_400_999'*0.2306) + (`cacs_1000'*0.4040) + (ptp_rf*`cacs_1_9'*0.1311) + (ptp_rf*`cacs_10_99'*0.2909) + (ptp_rf*`cacs_100_399'* 0.4077) + (ptp_rf*`cacs_400_999'*0.4658) + (ptp_rf*`cacs_1000'*0.4489) if `cacs' !=. &  `nb_rf' !=. &  `touse'   
	    label variable ptp_cacs`suffix' "Pre-test probability CACS"
		
		if "`grp'" !="" { 
			gen ptp_cacs_grp`suffix'=.
			replace ptp_cacs_grp`suffix' =0 if ptp_cacs >=0.00 & ptp_cacs <=.05
			replace ptp_cacs_grp`suffix'=1 if ptp_cacs >0.05 & ptp_cacs <=0.15
			replace ptp_cacs_grp`suffix' =2 if ptp_cacs >0.15 & ptp_cacs <=0.50
			replace ptp_cacs_grp`suffix' =3 if ptp_cacs >0.50 & ptp_cacs<=0.85
			replace ptp_cacs_grp`suffix' =4 if ptp_cacs >0.85 & ptp_cacs <=1.00

			label variable ptp_cacs_grp`suffix' "Pre-test probability groups basic"
			label values ptp_cacs_grp`suffix' `riskgrp5'	
			
		}
	}

 }
end
