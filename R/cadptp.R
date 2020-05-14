#' The cadptp calculates pre-test probability (PTP) of having obstructive coronary artery disease in patients with chronic coronary syndrome 
#' 
#' @param sex A number.
#' @param age 
#' @param symp_gr3 
#' @param nb_rf 
#' @param cacs 
#'
#'
#' @return ptp 
#' @examples


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
  
  return(ptp)
  
}