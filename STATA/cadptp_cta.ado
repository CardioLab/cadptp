program cadptp_cta, rclass
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

	capture confirm variable ptp_basic_cta`suffix'
	if !_rc {		   
				   drop ptp_basic_cta`suffix'
		   }
		   
	if "`grp'" !="" { 
	capture confirm variable ptp_basic_cta_grp`suffix'
	if !_rc {		   
				   drop ptp_basic_cta_grp`suffix'
		   }
    }
	
	
		   
	if "`nb_rf'" !="" { 
	
		capture confirm variable ptp_rf_cta`suffix'
		if !_rc {	   
					   drop ptp_rf_cta`suffix'
			   }
			   
		if "`grp'" !="" { 
		capture confirm variable ptp_rf_cta_grp`suffix'
		if !_rc {		   
						drop ptp_rf_cta_grp`suffix'
				   }
		}
		   
	}
	
	if "`cacs'" !="" { 
		capture confirm variable ptp_cacs_cta`suffix'
		if !_rc {
					   
					   drop ptp_cacs_cta`suffix'
			   }
			   
		if "`grp'" !="" { 
			capture confirm variable ptp_cacs_cta_grp`suffix'
			if !_rc {		   
						   drop ptp_cacs_cta_grp`suffix'
				   }
		}
			   
	}   
	

}



  
* Estimate PTP values
quietly {

	tempvar symp_non_anglinal  symp_typical nb_rf_3 cacs_1_9 cacs_10_99 cacs_100_399 cacs_400_999 cacs_1000  

	label define cadptp_riskgrp 0 "Very low risk (<=5%)" 1 "Low risk (5- <=15%)" 2 "Low intermed (15- <=50%)" 3 "High intermed (50- <=85%)" 4 "High (>85%)"  , replace

		* One hot encoding symptoms
	gen `symp_non_anglinal' = (`symp'==0)
	gen `symp_typical' = (`symp'==2)

	* basic model
	gen ptp_basic_cta`suffix' =.
	replace ptp_basic_cta`suffix' = 1./(1+exp(-(-5.3575 + (0.7952*`male') + (0.06168*`age') + (1.2329*`symp_typical') + (-0.58634*`symp_non_anglinal') + (-0.005448*`age'*`symp_typical') )))  if `touse' 
	label variable ptp_basic_cta`suffix' "Pre-test probability basic (CTA)"
	
	if "`grp'" !="" { 
		gen ptp_basic_cta_grp`suffix'=.
		replace ptp_basic_cta_grp`suffix' =0 if ptp_basic_cta >=0.00 & ptp_basic_cta <=.05
		replace ptp_basic_cta_grp`suffix'=1 if ptp_basic_cta >0.05 & ptp_basic_cta <=0.15
		replace ptp_basic_cta_grp`suffix' =2 if ptp_basic_cta >0.15 & ptp_basic_cta <=0.50
		replace ptp_basic_cta_grp`suffix' =3 if ptp_basic_cta >0.50 & ptp_basic_cta<=0.85
		replace ptp_basic_cta_grp`suffix' =4 if ptp_basic_cta >0.85 & ptp_basic_cta <=1.00

		label variable ptp_basic_cta_grp`suffix' "Pre-test probability groups basic (CTA)"
		label values ptp_basic_cta_grp`suffix' cadptp_riskgrp
	}
	
	* In case of number of risk factores is given estimate PTP_RF
	if "`nb_rf'" !="" { 
		gen `nb_rf_3'  =.
		replace `nb_rf_3' =1 if `nb_rf' < 2
		replace `nb_rf_3' =2 if `nb_rf' >= 2 & `nb_rf' < 4
		replace `nb_rf_3' =3 if `nb_rf' >= 4 

		gen ptp_rf_cta`suffix' =.
		replace ptp_rf_cta`suffix' = 1./(1+exp(-(-7.1076 + (1.1332*`male') + (0.072819*`age') +  (1.4252* `symp_typical' ) + (-0.55152*`symp_non_anglinal') + (1.1145*`nb_rf_3') + (-0.005578*`age'*`symp_typical') + (-0.0079662*`age'*`nb_rf_3') + (-0.11213*`symp_typical'*`nb_rf_3') + (-0.18948*`male'*`nb_rf_3')))) if  `nb_rf' !=. &  `touse' 
		label variable ptp_rf_cta`suffix' "Pre-test probability risk factor weighted (CTA)"
	
		if "`grp'" !="" { 	
			gen ptp_rf_cta_grp`suffix'=.
			replace ptp_rf_cta_grp`suffix' =0 if ptp_rf_cta >=0.00 & ptp_rf_cta <=.05
			replace ptp_rf_cta_grp`suffix'=1 if ptp_rf_cta >0.05 & ptp_rf_cta <=0.15
			replace ptp_rf_cta_grp`suffix' =2 if ptp_rf_cta >0.15 & ptp_rf_cta <=0.50
			replace ptp_rf_cta_grp`suffix' =3 if ptp_rf_cta >0.50 & ptp_rf_cta<=0.85
			replace ptp_rf_cta_grp`suffix' =4 if ptp_rf_cta >0.85 & ptp_rf_cta <=1.00

			label variable ptp_rf_cta_grp`suffix' "Pre-test probability groups risk factor weighted (CTA)"
			label values ptp_rf_cta_grp`suffix'  cadptp_riskgrp
		}
	}
	 

	 *	In case of CACS is given estimate PTP_CACS
	if "`cacs'" !="" { 
	
		gen `cacs_1_9' = cond(`cacs' >= 1 & `cacs' < 10, 1, 0)
		gen `cacs_10_99' = cond(`cacs' >= 10 & `cacs' < 100, 1, 0)
		gen `cacs_100_399' = cond(`cacs' >= 100 & `cacs' < 400, 1, 0)
		gen `cacs_400_999' = cond(`cacs' >= 400 & `cacs' < 1000, 1, 0)
		gen `cacs_1000' = cond(`cacs' >= 1000, 1, 0)
		
		
		gen ptp_cacs_cta`suffix' =.
		replace ptp_cacs_cta`suffix' = 0.014533 + (ptp_rf_cta * 0.27093)  + (`cacs_1_9'*0.047056) + (`cacs_10_99'* 0.1189) + (`cacs_100_399'*0.34417) + (`cacs_400_999'*0.5881) + (`cacs_1000'*0.73892) + (ptp_rf_cta*`cacs_1_9'*0.054423) + (ptp_rf_cta*`cacs_10_99'* 0.14347) + (ptp_rf_cta*`cacs_100_399'* 0.18439) + (ptp_rf_cta*`cacs_400_999'*0.085774) + (ptp_rf_cta*`cacs_1000'*-0.081776) if `cacs' !=. &  `nb_rf' !=. &  `touse'   
	    label variable ptp_cacs_cta`suffix' "Pre-test probability CACS (CTA)"
		
		if "`grp'" !="" { 
			gen ptp_cacs_cta_grp`suffix'=.
			replace ptp_cacs_cta_grp`suffix' =0 if ptp_cacs_cta >=0.00 & ptp_cacs_cta <=.05
			replace ptp_cacs_cta_grp`suffix'=1 if ptp_cacs_cta >0.05 & ptp_cacs_cta <=0.15
			replace ptp_cacs_cta_grp`suffix' =2 if ptp_cacs_cta >0.15 & ptp_cacs_cta <=0.50
			replace ptp_cacs_cta_grp`suffix' =3 if ptp_cacs_cta >0.50 & ptp_cacs_cta<=0.85
			replace ptp_cacs_cta_grp`suffix' =4 if ptp_cacs_cta >0.85 & ptp_cacs_cta <=1.00

			label variable ptp_cacs_cta_grp`suffix' "Pre-test probability groups CACS (CTA)"
			label values ptp_cacs_cta_grp`suffix' cadptp_riskgrp	
			
		}
	}

 }
  
end
