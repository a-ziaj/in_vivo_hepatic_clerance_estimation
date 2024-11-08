#!/usr/bin/env Rscript

# Define data
args <- commandArgs(trailingOnly = TRUE)

coumarin <- args[1]

if (coumarin == 'y') {
  concentration <- c(0, 0.195, 0.39, 0.78, 1.6, 3.1, 6.25, 12.5, 25, 50)
  rate <- c(0, 35.44745021, 67.94113082, 90.79732903, 123.7251799, 145.3289884, 152.9075721, 158.5608795, 135.6507252, 166.2718822)
} else {
  data <- read.csv("conc_rate_template.csv")
  concentration <- data[["Substrate.Concentration.uM"]]
  rate <- data[["Rate..pmol.min.mg.protein."]]
}




organism <- args[2]

# Save the data frame to a text file for the report
cat(paste("In vitro in vivo extrapolation (IVIVE) of clearance in", organism, '\n \n'), file = "results.txt")
df <- data.frame(concentration = concentration, rate = rate)
suppressWarnings(
		 write.table(df, file = "results.txt", sep = "\t", row.names = FALSE, col.names = TRUE, append = TRUE)
 )




# Fit the Michaelis-Menten model using
data <- data.frame(concentration, rate)
michaelis_menten_model <- nls(rate ~ (max_val * concentration) / (mean_val + concentration),
                              data = data,
                              start = list(max_val = max(rate), mean_val = mean(concentration)))

concentration_seq <- seq(min(concentration), max(concentration), length.out = 100)
fit_curve <- predict(michaelis_menten_model, newdata = data.frame(concentration = concentration_seq))

fit_data <- data.frame(concentration = concentration_seq, rate = fit_curve)

png("michaelis_menten_model.png", width = 600, height = 450)

plot(concentration, rate, 
     pch = 16, 
     xlab = "Concentration (uM)", 
     ylab = "Rate (pmol/min/mg protein)", 
     main = "Non-linear Fit: Michaelis-Menten Model")

lines(concentration_seq, fit_curve, lwd = 2)

legend("topright", legend = c("Data", "Fit"), pch = c(16, NA), lwd = c(NA, 2))

invisible(dev.off())

# Plotting Hanes-Woolf

sr <- concentration / rate
sr <- sr[-1]
concentration <- concentration[-1]

hanes_woolf_model <- lm(sr ~ concentration)

intercept <- unname(coef(hanes_woolf_model)[1])
slope <- unname(coef(hanes_woolf_model)[2])

png("hanes_woolf_plot.png", width = 600, height = 450)
plot(concentration, sr, 
     pch = 16, 
     xlab = "[S]", 
     ylab = "[S]/v", 
     main = "Hanes-Woolf Plot")

abline(hanes_woolf_model, lwd = 2)

legend("topright", legend = paste0("y = ", format(slope, digits = 6), "x + ", format(intercept, digits = 6)), lwd = 2)
Vmax <- 1 / slope
Km <- intercept * Vmax

invisible(dev.off())

#Cl calculations

example_params <- read.csv("example_parameters.csv")

#In vitro CLint
in_vitro_clint <- Vmax/Km
print(Vmax, Km, in_vitro_clint)

#cat("In vitro CLint:", in_vitro_clint, "X 10^-6 L/min per mg protein\n")

#Convert in vitro CLint to in vivo CLint

liver_weight <- example_params[2, organism]
Microsomal_protein_yield <- example_params[3, organism]
in_vivo_clint <- in_vitro_clint*10^(-6)*liver_weight*Microsomal_protein_yield*60



#Convert to hepatic clearance (CYP2A19 contribution)
QH_Lh <- example_params[6, organism]
standard_body_weight <- example_params[1, organism]

hepatic_clerance_kgh <- (in_vivo_clint*QH_Lh)/(in_vivo_clint+QH_Lh)
hepatic_clerance_Lh <- hepatic_clerance_kgh/standard_body_weight



#save the results
cat("\nResults of the calculations:\n", file = "results.txt", append = TRUE)
cat("Vmax:", Vmax, "\n", file = "results.txt", append = TRUE)
cat("Km:", Km, "\n", file = "results.txt", append = TRUE)
print('Vmax, Km values saved.')


cat("\nHanes-Woolf plot analysis: \n", file = "results.txt", append = TRUE)
cat("Intercept:", intercept, "\n", file = "results.txt", append = TRUE)
cat("Slope:", slope, "\n\n", file = "results.txt", append = TRUE)
print('Hanes-Woolf plot analysis results saved.')


cat("Organism data:\n", file = "results.txt", append = TRUE)
selected_columns <- example_params[, c(1, which(colnames(example_params) == organism))]
suppressWarnings(
		 write.table(selected_columns, file = "results.txt", sep = "\t", row.names = FALSE, col.names = TRUE, append = TRUE)
)
print('Organism data added to the file')


cat("\n\n", file = "results.txt", append = TRUE)
cat("In vitro CLint:", in_vitro_clint, "X 10^-6 L/min per mg protein \n", file = "results.txt", append = TRUE)
cat("In vivo Clint:", in_vivo_clint, "L/h  \n", file = "results.txt", append = TRUE)
cat("Hepatic clearance:", hepatic_clerance_kgh, "L/h ", hepatic_clerance_Lh,"L/h/kg\n", file = "results.txt", append = TRUE)
print('In vitro CLint, In vivo Clint and hepatic clereance values saved.')









