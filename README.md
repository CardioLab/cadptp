# CAD-PTP: Estimation of Clinical likelihood of coronary artery disease

The cadptp calculates pre-test probability (PTP) of having obstructive coronary artery disease in patients with chronic coronary syndrome (symptoms suggestive of obstructive coronary artery disease) without previously documented coronary artery disease. The model is based on data from >40,000 patients and validated in >15.000, see the publication by Winther et al. "Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease" in Journals of the American College of Cardiology. 

When only age, gender and symptoms are used as input the basic PTP (ptp_basic) is calcualted.  If  the number of risk factors are given the risk factor weighted clinical likelihood of CAD (ptp_rf) is also calculated.  
Finally, if CACS is given a CACS weighted clinical likelihood (ptp_cacs) is estimated.

# Instaltion in STATA
To install CAP-PTP from STATA write the full line below in STATA:

*net install cadptp, from(https://github.com/CardioLab/cadptp/raw/master/STATA)*


# Citation

The CAD-PTP toolbox is a free contribution to the research community, like a paper. Please cite it as such: 

Schmidt SE & Winther S (2020). cadptp: Statistical module for calculating Clinical likelihood of coronary artery disease 

And please cite it the orginal reseasch paper:

Winther et al. Incorporating Coronary Calcification Into Pre-Test Assessment of the Likelihood of Coronary Artery Disease, Journals of the American College of Cardiology, In press



# Authors

Samuel Emil Schmidt, Aalborg Univerisity, DK sschmidt@hst.aau.dk

Simon Winther, Hospital Unit West, DK sw@dadlnet.dk


