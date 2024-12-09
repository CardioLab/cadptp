#' The cadptp calculates pre-test probability (PTP) of having obstructive coronary artery disease in patients with chronic coronary syndrome 
#' 
#' @description
#' The cadptp command calculates pre-test probability (PTP) of having obstructive coronary artery disease defined from invasive angiography scanning in patients with chronic
#' coronary syndrome (symptoms suggestive of obstructive coronary artery disease) without previously documented coronary artery disease.
#' The model is based on data from >40,000 patients and validated in >15.000 (ref).  When only age, gender and symptoms are used as
#' input the basic PTP (ptp_basic) is calcualted.  If the number of risk factors are given the risk factor weighted clinical
#' likelihood of CAD (ptp_rf) is also calculated.  Finally, if CACS is given a CACS weighted clinical likelihood (ptp_cacs) is
#' estimated.
#'  See  Winther, S, Schmidt, S, Mayrhofer, T. et al. Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease. J Am Coll Cardiol. 2020 Nov, 76 (21) 2421–2432.https://doi.org/10.1016/j.jacc.2020.09.585
#' 
#' @param sex gender, where male = 1 and female = 0
#' @param age  Age in years
#' @param symp_gr   Symptoms, where Non-typical angina=0, Atypical angina or dyspnoea=1 and Typical angina =2
#' @param nb_rf  Number of risk factors (0-5) (Riskfactors: Family history of early CAD, Smoking, Dyslipidaemia, Hypertension or Diabetes)
#' @param cacs  Coronary artery calcium score determined by the Agatston method
#'
#'
#' @return ptp 
#' @examples 
#' The current example download a Synthetic dataset of patients with chronic coronary syndrome stored as STATA data and calculates PTPs
#' 
#' download.file('https://vbn.aau.dk/files/331937080/synthetic_cadptp.dta','synthetic_cadptp.dta')
#' library(haven)
#' heart <- read_dta("synthetic_cadptp.dta")
#' 
#' Estimae PTP:
#' cadptp(heart[,'sex'],heart[,'age'],heart[,'symp_gr3'],heart[,'nb_rf_5'],heart[,'calciumscoreagatston']) 


cadptp <- function(sex, age , symp_gr3, nb_rf, cacs) {
  
  
  # one hot encoding of symptoms
  symp_non_anglinal <- ifelse(symp_gr3 == 0, 1, 0)
  symp_typical <- ifelse(symp_gr3 == 2, 1, 0)
  
  # Basic PTP
  ptp_basic = 1. / (1 + exp(-(
    -7.0753 + (1.2308 * sex) + (0.0642 * age) + (2.2501 * symp_typical) + (-0.5095 *
                                                                             symp_non_anglinal) + (-0.0191 * age * symp_typical)
  )))
  
  ptp <- cbind(ptp_basic )
  
  
  # PTP if Number of risk factors is available
  if(!missing(nb_rf)) {
  nb_rf_3 <- (nb_rf >= 0) + (nb_rf >= 2) + (nb_rf >= 4)
  ptp_rf = 1. / (1 + exp(-(
    -9.5260 + (1.6128 * sex) + (0.08440 * age) +  (2.7112 * symp_typical) + (-0.4675 *
                                                                               symp_non_anglinal) + (1.4940 * nb_rf_3) + (-0.0187 * age * symp_typical) + (-0.0131 *
                                                                                                                                                             age * nb_rf_3) + (-0.2799 * symp_typical * nb_rf_3) + (-0.2091 * sex * nb_rf_3)
  )))
  ptp <- cbind(ptp, ptp_rf)
  }
  if(!missing(cacs)) {
  # PTP if CACS is available
  cacs_1_9 = cacs >= 1 & cacs < 10
  cacs_10_99 = cacs >= 10 & cacs < 100
  cacs_100_399 = cacs >= 100 & cacs < 400
  cacs_400_999 = cacs >= 400 & cacs < 1000
  cacs_1000 = cacs >= 1000
  
  
  ptp_cacs = 0.0013 + (ptp_rf * 0.2021)  + (cacs_1_9 * 0.0082) + (cacs_10_99 *
                                                                    0.0238) + (cacs_100_399 * 0.1131) + (cacs_400_999 * 0.2306) + (cacs_1000 *
                                                                                                                                     0.4040) + (ptp_rf * cacs_1_9 * 0.1311) + (ptp_rf * cacs_10_99 * 0.2909) + (ptp_rf *
                                                                                                                                                                                                               cacs_100_399 * 0.4077) + (ptp_rf * cacs_400_999 * 0.4658) + (ptp_rf * cacs_1000 *
                                                                                                                                                                                                                                                                                 0.4489)
  ptp <- cbind(ptp, ptp_cacs)
   }  
 
  ptp <- data.frame(ptp, row.names = NULL)
  
  if (ncol(ptp)==1)
    
    colnames( ptp) <- c('ptp_basic_cta') 
  
  else if (ncol(ptp)==2)
    
    colnames( ptp) <- c('ptp_basic_cta','ptp_rf_cta') 
  
  else if (ncol(ptp)==3)
    
    colnames( ptp) <- c('ptp_basic_cta','ptp_rf_cta','ptp_cacs_cta') 
  
  end
  
  return(ptp)
  
}
