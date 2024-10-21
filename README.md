## Table of Contents
- [About the Project](#about-the-project)
- [About the Example Data](#about-the-example-data)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Steps to Install R on Ubuntu](#steps-to-install-r-on-ubuntu)
- [Usage](#usage)
- [How it Works – a bit of math](#how-it-works--a-bit-of-math)
- [Contact](#contact)
- [References](#references)
---

## About the Project
The majority of drugs are eliminated through metabolism. Hepatic clearance prediction is crucial to estimate first in human doses and optimising new drug candidates. This project allows for estimation of in vivo hepatic clearance based on in vitro data (IVIVE ) using Hanes-Woolf plot for in vitro hepatic intrinsic clearance (Clint) determination and then extrapolation using physiological parameters. 

It is important to note IVIVE may not be reliable. For instance, Obach et al. (1997) showed that IVIVE predictions of 13 out of 29 drugs fell outside the two-fold range demonstrating variability in IVIVE predictions.

##About the example data
When you run the “IVIVE.sh” script, you have the option to enter your own data or use default data on the metabolism of coumarin to 7-hydroxycoumarin by the pig CYP2A19 enzyme. The example default collection is described below:

A series of 1:2 dilutions of coumarin was prepared, starting from 500µM, and added to wells 3-11 in a 96-well plate. A P450 reaction mixture, excluding pilocarpine, was prepared using Tris-HCl buffer, cofactors, glucose-6-phosphate dehydrogenase (G6PD), and microsomes, and added to wells in rows A-D. The plate was incubated at 37°C for 30 minutes, then moved on ice, and the reaction was stopped by adding 10% trichloroacetic acid. After stopping the reaction, sodium hydroxide-glycine buffer was added, and fluorescence was measured to calculate enzyme reaction rates for different coumarin concentrations.

You can easily load your own data by following the instructions provided in the script and modifying the files *conc_rate_template.csv* and *example_parameters.csv*  to fit your needs :)

## Technologies Used
- R, bash

## Installation
### Prerequisites 
Ensure that you have **R** installed on your system. 
#### Steps to Install R on Ubuntu: 

```bash 
# Update package index 
sudo apt update 

# Install R base package 
sudo apt install r-base 

# Verify R installation Rscript –version

## Usage

To run the analysis, execute the `IVIVE.sh` script which also invokes an R script ‘generate_graphs_and_report.R’ to perform the necessary computations and plotting. Follow all the instructions that will be provided during execution. Upon completion, the results will be automatically generated and saved in the `results` folder. This folder will contain the following files:

- **"michaelis_menten_model.png"**: A plot of the Michaelis-Menten model.
- **"hanes_woolf_plot.png"**: A Hanes-Woolf plot for enzyme kinetics.
- **"results.txt"**: A detailed output file containing the following calculated results:
  
  - **Vmax** and **Km** values for the enzyme kinetics.
  - Analysis from the Hanes-Woolf plot, including the **intercept** and **slope**.
  - Selected organism-specific data from the input file.
  - Calculations for **in vitro CLint** (X 10^-6 L/min per mg protein), **in vivo CLint** (L/h), and **hepatic clearance** (L/h and L/h/kg).

The results folder currently contains analysis based on the default data. Once you run the script, it will remove it and replace it with new data from your analysis. **Make sure** to save your data in a different directory before running the script again, as it will be deleted.
## How it works? – a bit of math

1. First, data is fitted to Michaelis-Menten model to visualise the relationship between the substate concentration e.g. coumarin and rate of elimination by CYP2A19 enzyme. It can be described by Michaelis-Menten equation: 

$$ v = \frac{V_{\text{max}} \cdot [S]}{K_m + [S]} $$

Where: 
- **v**: Reaction rate (velocity) 
- **Vmax**: Maximum reaction rate 
- **[S]**: Substrate concentration
 - **Km**: Michaelis constant (substrate concentration at half Vmax)

 
2. Then we multiply the inverse of Michaelis Menten by substrate concentration [s] to obtain Hanes-Woolf plot. It can be done using equation below:

$$\frac{[S]}{v} = \frac{1}{V_{m}} [S] + \frac{K_m}{V_{m}}$$

Where:
- **v**: Reaction rate (velocity) 
- **Vmax**: Maximum reaction rate 
- **[S]**: Substrate concentration
 - **Km**: Michaelis constant (substrate concentration at half Vmax)

One of the benefits of using Hanes-Wolf plot is it does not cluster low substrate concentrations [s] around the y-intercept contrary to e.g. Lineweaver – Burk plot that is prone to error when estimating Vmax and Km. A good alternative to Hanes-Woolf would be Eadie – Hofstee plot that also doesn’t cluster low [s] around y-intercept.

3. Vmax and Kmax are obtained from the slope and intercept of the linear equation *y=mx+by *
Where: - \( y \): is analogous to \( \frac{[S]}{v} \) 
- \( m \): is analogous to \( \frac{1}{V_{\text{max}}} \) 
- \( x \): is analogous to \( [S] \) 
- \( b \): is analogous to \( \frac{K_m}{V_{\text{max}}} \)

Hepatic intrinsic clearance (Clint) is obtained by simple $$ \text{CL}_{\text{int}} = \frac{V_{\text{max}}}{K_m} $$

4. Convert in vitro CLint to in vivo Clint
$$ \frac{V_{\text{max, enzyme}}}{K_{m, \text{enzyme}} \times \text{fumic}} = CL_{\text{int, enzyme, invitro}} $$

Assuming fumic is 1

$$ \text{In vivo } CL_{\text{int}} = CL_{\text{int}}(\text{in vitro}) \times \text{mg microsomal protein per gram of liver} \times \text{liver weight} $$

5. **Ta-da!**

##Contact
If you have any questions, feel free to reach out! 
- **Email**: [alicja.ziajowska@gmail.com](mailto: alicja.ziajowska@gmail.com) 
- **GitHub**: [a-ziaj](https://github.com/a-ziaj) 
- **LinkedIn**: [Alicja Ziajowska]( https://www.linkedin.com/in/alicja-ziajowska-b8a977180/)

##References
Obach, R. S., Baxter, J. G., Liston, T. E., Silber, B. M., Jones, B. C., MacIntyre, F., Rance, D. J., & Wastall, P. (1997). The prediction of human pharmacokinetic parameters from preclinical and in vitro metabolism data. *The Journal of pharmacology and experimental therapeutics, 283* (1), 46–58.
