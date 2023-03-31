#----------------------------------------------------------------------------------------------------
# Functions to Write SOCSIM fertility and mortality input rate files using HFD and HMD data

#----------------------------------------------------------------------------------------------------
# Create a sub-folder called "rates" to save the rate files if it does not exist.
ifelse(!dir.exists("rates"), dir.create("rates"), FALSE)
# If the sub-folder name changes, 
# it must be also changed in the functions when opening the output file connection

# Prevent scientific notation
options(scipen=999999)

#----------------------------------------------------------------------------------------------------
#### Write SOCSIM input fertility rates from HFD ----

write_socsim_rates_HFD <- function(Country) {
  
  # Read HFD ASFR
  ASFR <- read.table(file = paste0("Input/", Country,"asfrRR.txt"), 
                    as.is=T, header=T, skip=2, stringsAsFactors=F)
  
  # Wrangle data and compute monthly fertility rates
  ASFR <- 
    ASFR %>% 
    mutate(Age = case_when(Age == "12-" ~ "12",
                           Age == "55+" ~ "55", 
                           TRUE ~ Age),
           Age = as.numeric(Age), 
           Age_up = Age + 1, # SOCSIM uses the upper age bound
           Month = 0, 
           ASFR_mo = ASFR/12) %>% 
    select(-ASFR)
  
  # Add rows with rates = 0 for ages 0-12 and 56-111
  ASFR <- 
    ASFR %>% 
    group_by(Year) %>% 
    group_split() %>% 
    map_df(~ add_row(.x,
                     Year = unique(.x$Year), 
                     Age = 0, Age_up = 12,  Month = 0, ASFR_mo = 0.0, 
                     .before = 1)) %>% 
    group_by(Year) %>% 
    group_split() %>% 
    map_df(~ add_row(.x, 
                     Year = unique(.x$Year), 
                     Age = 56, Age_up = 111, Month = 0, ASFR_mo = 0.0, 
                     .after = 45)) %>% 
    ungroup() %>% 
    select(-Age)
  
  # Extract the years available in HFD
  years <- ASFR %>% pull(Year) %>% unique()
  
  # Row numbers corresponding to sequence of years of age in ASFR
  rows_ageF <- ASFR %>% pull(Age_up) %>% unique() %>% seq_along()
  
  
  ## Write the fertility rate files for each year
  
  for(Year in years) {
    
    # Find the index of each year of the iteration
    n <- which(Year == years)
    n_row <- (n-1)*46 + rows_ageF
    
    # Open an output file connection
    outfilename <- file(paste0("rates/",Country,"fert",Year), "w") 
    # without ".txt" specification as the original files had no format. 
    
    # Include country and year of the corresponding rates
    cat(c("** Period (Monthly) Age-Specific Fertility Rates for", Country, "in", Year, "\n"), 
        file = outfilename)
    cat(c("* Retrieved from the Human Fertility Database, www.humanfertility.org", "\n"), 
        file = outfilename)
    cat(c("* Max Planck Institute for Demographic Research (Germany) and", "\n"), 
        file = outfilename)
    cat(c("* Vienna Institute of Demography (Austria)", "\n"), 
        file = outfilename)
    cat(c("* Data downloaded on ", format(Sys.time(), format= "%d %b %Y %X %Z"), "\n"), 
        file = outfilename)
    cat(c("** NB: The original HFD annual rates have been converted into monthly rates", "\n"), 
        file = outfilename)
    cat(c("** The open age interval (55+) is limited to one year [55-56)", "\n"), 
        file = outfilename)
    cat("\n", file = outfilename)
    
    # Print birth rates (single females)
    cat("birth", "1", "F", "single", "0", "\n", file = outfilename)
    for(i in n_row) {
      cat(c(as.matrix(ASFR)[i,-1], "\n"), file = outfilename) }
    cat("\n", file = outfilename)
    
    # Print birth rates (married females)
    cat("birth", "1", "F", "married", "0", "\n", file = outfilename)
    for(i in n_row) {
      cat(c(as.matrix(ASFR)[i,-1],"\n"), file = outfilename) }
    
    close(outfilename)
    
  }
  
}


#----------------------------------------------------------------------------------------------------
#### Write SOCSIM input mortality rates from HMD ----

write_socsim_rates_HMD <- function(Country) {
  
  # Read HMD female life tables
  ltf <- read.table(file= paste0("Input/","fltper_1x1.txt"),
                    as.is=T, header=T, skip=2, stringsAsFactors=F)
  
  # Read HMD male life tables
  ltm <- read.table(file= paste0("Input/", "mltper_1x1.txt"),
                    as.is=T, header=T, skip=2, stringsAsFactors=F)

  # Wrangle data and compute monthly mortality probabilities
  ASMP <- 
    ltf %>% 
    select(Year, Age, qx) %>% 
    left_join(ltm %>% select(Year, Age, qx), 
              by = c("Year","Age"), suffix = c("_F","_M")) %>% 
    mutate(Age = case_when(Age == "110+" ~ "110",
                           TRUE ~ Age),
           Age = as.numeric(Age), 
           qx_Fmo = ifelse(Age == 110, qx_F/12, 1-(1-qx_F)^(1/12)),
           qx_Mmo = ifelse(Age == 110, qx_M/12, 1-(1-qx_M)^(1/12)), 
           Age_up = Age + 1, # SOCSIM uses the upper age bound
           Month = 0) %>% 
    select(c(Year, Age_up, Month, qx_Fmo, qx_Mmo))
  
  # Extract the years available in HMD
  years <- ASMP %>% pull(Year) %>% unique()
  
  # Row numbers corresponding to sequence of years of age in ASMP
  rows_ageM <- ASMP %>% pull(Age_up) %>% unique() %>% seq_along()
  
  
  ## Write the mortality rate files for each year
  
  for(Year in years) {
    
    # Find the index of each year of the iteration
    n <- which(Year == years)
    n_row <- (n-1)*111 + rows_ageM
    
    # Open an output file connection
    outfilename <- file(paste0("rates/",Country,"mort",Year), "w") 
    # without ".txt" specification as the original files had no format. 
    
    # Include country and year of the corresponding probabilities
    cat(c("** Period (Monthly) Age-Specific Probabilities of Death for", Country, "in", Year, "\n"), 
        file = outfilename)
    cat(c("* Retrieved from the Human Mortality Database (Life tables), www.mortality.org.", "\n"), 
        file = outfilename)
    cat(c("* Max Planck Institute for Demographic Research (Germany),", "\n"), 
        file = outfilename)
    cat(c("* University of California, Berkeley (USA),", "\n"), 
        file = outfilename)
    cat(c("* and French Institute for Demographic Studies (France)", "\n"), 
        file = outfilename)
    cat(c("* Data downloaded on ", format(Sys.time(), format= "%d %b %Y %X %Z"), "\n"), 
        file = outfilename)
    cat(c("** NB: The original HMD annual probabilities have been converted into monthly probabilities", "\n"), 
        file = outfilename)
    cat(c("** The open age interval (110+) is limited to one year [110-111)", "\n"), 
        file = outfilename)
    cat("\n", file = outfilename)
    
    # Print mortality probabilities (single females)
    cat("death", "1", "F", "single", "\n", file = outfilename)
    for(i in n_row) {
      cat(c(as.matrix(ASMP)[i,-c(1,5)], "\n"), file = outfilename) }
    cat("\n", file = outfilename)
    
    # Print mortality probabilities (single males)
    cat("death", "1", "M", "single", "\n", file = outfilename)
    for(i in n_row) {
      cat(c(as.matrix(ASMP)[i,-c(1,4)], "\n"), file = outfilename) }
    
    close(outfilename)
    
  }
}