# CAD-PTP: Estimation of Clinical likelihood of coronary artery disease

The cadptp calculates pre-test probability (PTP) of having obstructive coronary artery disease in patients with chronic coronary syndrome (symptoms suggestive of obstructive coronary artery disease) without previously documented coronary artery disease. The model is based on data from >40,000 patients and validated in >15.000, see the publication by Winther et al. "Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease" in Journals of the American College of Cardiology. 

When only age, gender and symptoms are used as input the basic PTP (ptp_basic) is calculated.  If  the number of risk factors are given the risk factor-weighted clinical likelihood of CAD (ptp_rf) is also calculated.  
Finally, if CACS is given a CACS weighted clinical likelihood (ptp_cacs) is estimated.

## Update 2023: Estimation of Clinical likelihood of CCTA-defined coronary artery disease
Where the "cadptp" function estimates the Clinical likelihood of CAD defined via invasive coronary angiography, the new "cadptp_cta" function estimates the Clinical likelihood of coronary artery disease defined from CCTA. This model was developed to adjust for the higher prevalence of CAD by CCTA compared to invasive angiography.  Paper under review. 


## Instaltion in STATA
To install CAP-PTP from STATA write the full line below in STATA:

**net install cadptp, from(https://github.com/CardioLab/cadptp/raw/master/STATA)**

**help cadptp**  
For Clinical likelihood of coronary artery disease defined by invasive coronary angiography

**help cadptp_cta**      
For Clinical likelihood of coronary artery disease defined by coronary computed tomography angiography

## Citation 

The CAD-PTP toolbox is a free contribution to the research community, like a paper. Please cite it as such: 

*Schmidt SE & Winther S (2020). cadptp: Statistical module for calculating Clinical likelihood of coronary artery disease. https://github.com/CardioLab/cadptp*

And please also cite the original research paper relate to the invasive coronary angiography calibrated model:

*Winther, Simon, et al. "Incorporating coronary calcification into pre-test assessment of the likelihood of coronary artery disease." Journal of the American College of Cardiology 76.21 (2020): 2421-2432.*
https://www.sciencedirect.com/science/article/abs/pii/S0735109720373678

Other publications:  
*Coronary Calcium Scoring Improves Risk Prediction in Patients With Suspected Obstructive Coronary Artery Disease S. Winther, S. E. Schmidt, B. Foldyna, T. Mayrhofer, L. D. Rasmussen, J. N. Dahl, et al. J Am Coll Cardiol 2022 Vol. 80 Issue 21 Pages 1965-1977*
10.1016/j.jacc.2022.08.805
https://www.jacc.org/doi/10.1016/j.jacc.2022.08.805

*Calcium Scoring Improves Clinical Management in Patients With Low Clinical Likelihood of Coronary Artery Disease G. S. Brix, L. D. Rasmussen, P. D. Rohde, S. E. Schmidt, M. Nyegaard, P. S. Douglas, et al. JACC Cardiovasc Imaging 2024 Vol. 17 Issue 6 Pages 625-639*
DOI: 10.1016/j.jcmg.2023.11.008
https://www.sciencedirect.com/science/article/pii/S1936878X23005272?via%3Dihub

*Clinical Likelihood Prediction of Hemodynamically Obstructive Coronary Artery Disease in Patients With Stable Chest Pain L. D. Rasmussen, S. R. Karim, J. Westra, L. Nissen, J. N. Dahl, G. S. Brix, et al. JACC Cardiovasc Imaging 2024 Vol. 17 Issue 10 Pages 1199-1210*
DOI: 10.1016/j.jcmg.2024.04.015
https://www.sciencedirect.com/science/article/pii/S1936878X24001852?via%3Dihub

*Clinical risk prediction, coronary computed tomography angiography, and cardiovascular events in new-onset chest pain: the PROMISE and SCOT-HEART trials L. D. Rasmussen, S. E. Schmidt, J. Knuuti, C. Vrints, M. Bottcher, B. Foldyna, et al. Eur Heart J 2024* 
DOI: 10.1093/eurheartj/ehae742
https://academic.oup.com/eurheartj/advance-article/doi/10.1093/eurheartj/ehae742/7841880

**The paper related to the CTA calibrated model is under review**


# Authors

Samuel Emil Schmidt, Aalborg Univerisity, DK sschmidt@hst.aau.dk

Simon Winther, Hospital Unit West, DK sw@dadlnet.dk


