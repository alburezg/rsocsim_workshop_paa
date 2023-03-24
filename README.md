Demographic microsimulations in R using SOCSIM: Modelling population and
kinship dynamics
================
Workshop coordinator: Diego Alburez-Gutierrez (MPIDR)
PAA2023 Member Initiated Meeting

- <a href="#1-preamble" id="toc-1-preamble">1. Preamble</a>
- <a
  href="#2-running-a-simulation-and-retrieveing-the-input-demographic-rates"
  id="toc-2-running-a-simulation-and-retrieveing-the-input-demographic-rates">2.
  Running a simulation and retrieveing the input demographic rates</a>
- <a
  href="#3-what-can-you-do-with-simulation-output-example-estimates-of-bereavement"
  id="toc-3-what-can-you-do-with-simulation-output-example-estimates-of-bereavement">3.
  What can you do with simulation output? Example: estimates of
  bereavement</a>

# 1. Preamble

## 1.1. Installation

Install the [development version from
GitHub](https://github.com/MPIDR/rsocsim). We made changes to the
`rsocsim` package ahead of this workshop If you had already installed
the package, please uninstall it and and install it again.

``` r
# remove.packages("rsocsim")
# install.packages("devtools")
devtools::install_github("MPIDR/rsocsim")
```

Let’s see if everything is working fine. `rsocsim` has a simple built-in
simulation that you can run to see if the package was installed
correctly. For now, let’s run the code without focusing on the technical
details:

``` r
library(rsocsim)

library("rsocsim")

# create a new folder for all the files related to a simulation.
# this will be in your home- or user-directory:
folder = rsocsim::create_simulation_folder()

# create a new supplement-file. Supplement-files tell socsim what
# to simulate. create_sup_file will create a very basic supplement filee
# and it copies some rate-files that will also be needed into the 
# simulation folder:
supfile = rsocsim::create_sup_file(folder)

# Choose a random-number seed:
seed = 300

# Start the simulation:
rsocsim::socsim(folder,supfile,seed)
```

    ## [1] "Start run1simulationwithfile"
    ## [1] "C:/Users/alburezgutierrez/socsim/socsim_sim_9241"
    ## [1] "300"
    ## Start socsim
    ## start socsim main. MAXUYEARS: 200; MAXUMONTHS: 2400
    ## ratefile: socsim.sup
    ## 
    ## v18a!-command-line argv[0]: zerothArgument| argv[1]: socsim.sup| argv[2]: 300| argv[3]: 1
    ## random_number seed: 300| command-line argv[1]: socsim.sup| argv[2]: 300
    ## compatibility_mode: 1| command-line argv[3]: 1
    ## Socsim Version: STANDARD-UNENHANCED-VERSION
    ## initialize_segment_vars
    ## initialize_segment_vars done
    ## 18b - loading -.sup-file: socsim.sup
    ## 18b-load.cpp->load . socsim.sup
    ## #load.cpp->load 4. socsim.sup
    ## 18b-load.cpp->load . SWEfert2022
    ## #load.cpp->load 4. SWEfert2022
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## 18b-load.cpp->load . SWEmort2022
    ## #load.cpp->load 4. SWEmort2022
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## Incomplete rate set: 12
    ## ------------4marriage_eval == DISTRIBUTION . socsim.sup
    ## ------------6------------7

    ## Warning in startSocsimWithFile(supfile, seed, compatibility_mode, result_suffix
    ## = suffix): can't openmarriage file Hope that's OK

    ## Warning in startSocsimWithFile(supfile, seed, compatibility_mode, result_suffix
    ## = suffix): can't open transition history file. Hope that's OK

    ## 
    ##  output file names:
    ##  init_new.opop|init_new.omar|init_new.opox|sim_results_socsim.sup_300_/result.pyr|sim_results_socsim.sup_300_/result.stat|init_new.otx|
    ## fix pop pointers..
    ## Starting month is 601
    ## Initial size of pop 8000  (living: 8000)
    ## ------------aa3s------------aa32New events generated for all living persons
    ## ------------b1month:  700 PopLive:  9414 Brths:  16 Dths:   0 Mrgs: 11 Dvs:  0 Mq: 3728 Fq:0 ti1: 0.6 ti2: 0.016000 1.1512
    ## month:  800 PopLive: 10926 Brths:  12 Dths:   1 Mrgs:  6 Dvs:  0 Mq: 3890 Fq:0 ti1: 0.9 ti2: 0.024000 1.5860
    ## month:  900 PopLive: 12260 Brths:  14 Dths:   0 Mrgs:  4 Dvs:  0 Mq: 4031 Fq:0 ti1: 1.3 ti2: 0.014000 0.8616
    ## month: 1000 PopLive: 13397 Brths:   9 Dths:   2 Mrgs:  4 Dvs:  0 Mq: 4134 Fq:0 ti1: 1.7 ti2: 0.017000 0.9947
    ## month: 1100 PopLive: 14172 Brths:  16 Dths:   6 Mrgs:  6 Dvs:  0 Mq: 4135 Fq:0 ti1: 2.1 ti2: 0.024000 1.4037
    ## month: 1200 PopLive: 14518 Brths:  13 Dths:  11 Mrgs:  6 Dvs:  0 Mq: 4000 Fq:0 ti1: 2.6 ti2: 0.017000 1.0625
    ## month: 1300 PopLive: 14323 Brths:  14 Dths:  20 Mrgs:  4 Dvs:  0 Mq: 3891 Fq:0 ti1: 3.1 ti2: 0.025000 1.6513
    ## month: 1400 PopLive: 13816 Brths:  13 Dths:  15 Mrgs:  4 Dvs:  0 Mq: 3746 Fq:0 ti1: 3.6 ti2: 0.017000 1.2115
    ## month: 1500 PopLive: 13330 Brths:  11 Dths:  11 Mrgs:  5 Dvs:  0 Mq: 3679 Fq:0 ti1: 4.0 ti2: 0.023000 1.6993
    ## month: 1600 PopLive: 12944 Brths:  10 Dths:  15 Mrgs:  4 Dvs:  0 Mq: 3593 Fq:0 ti1: 4.4 ti2: 0.018000 1.3943
    ## month: 1700 PopLive: 12525 Brths:  10 Dths:  20 Mrgs:  5 Dvs:  0 Mq: 3436 Fq:0 ti1: 4.8 ti2: 0.017000 1.4399
    ## month: 1800 PopLive: 12009 Brths:  10 Dths:  16 Mrgs:  7 Dvs:  0 Mq: 3275 Fq:0 ti1: 5.1 ti2: 0.016000 1.4918
    ## 
    ## 
    ## Socsim Main Done
    ## Socsim Done.
    ## [1] "restore previous working dir: C:/cloud2/_static/Conferences, symposiums, presentations, courses/20230412-15_PAA_new_orleans/workshop-socsim/7_materials/rsocsim_workshop_paa"

    ## [1] 1

You should see a long output in the console, at the end of which there
is a population pyramid and the message “Socsim done”. Ignore the wo
warning messages (they are expected).

For more details on the package, the SOCSIM simulator, its history and
applications, see `rsocsim`’s website:
<https://mpidr.github.io/rsocsim/>.

## 1.2. Other packages

Let’s load the packages we will need for this workshop:

``` r
library(rsocsim)
library(tidyverse)
```

# 2. Running a simulation and retrieveing the input demographic rates

> Instructor: Liliana P. Calderón, <https://twitter.com/lp_calderonb>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
commodo consequat.

# 3. What can you do with simulation output? Example: estimates of bereavement

> Instructor: Mallika Snyder, <https://twitter.com/mallika_snyder>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
commodo consequat.
