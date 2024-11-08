#!/bin/bash

#remove any previous results
if [ -d "results" ]; then
    rm -fr results	
    echo -e "previous results deleted."
    mkdir results
    echo -e "new results directory created"
else
	touch results.txt
	mkdir results
	echo -e "new results directory created"
fi

#ask if you want to run the script on example data
echo -e "Would like to run the script on example rate of elimination data (elimination of coumarin via metabolism to 7-hydroxycoumarin by CYP2A6). [Y/n]"

while true; do
	read coumarin_data

	if [[ "$coumarin_data" == "Y" || "$coumarin_data" == "y" ]]; then
		coumarin='y'
		echo -e "You chose to run the script on example data."
		break
	
	elif [[ "$coumarin_data" == "N" || "$coumarin_data" == "n" ]]; then
		coumarin='n'
		echo -e "Please, add your substrate concentration and elimination rate data to conc_rate_template.csv and save it in this directory."
		break
	else
		echo -e "Invalid input. Please enter Y or n."
	fi
done

#ask to specify parameters for extrapolation
echo -e "\nThis script by default uses Pig data from the table below, type 'Y' to proceed.\n\nIf you would like to extapolate in vitro data to a different organims from the table below type its name (e.g. 'Dog').\n\nIf you would like to specify your own parameters plase add them under 'other' column in example_parameters.csv and then type 'other'.\n"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| Parameters                                   | Mouse | Rat  | Cyno | Dog  | Pig  | Human |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| Standard body weight (kg)                    | 0.025 | 0.25 | 5    | 12   | 25   | 70    |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| Liver weight (g)                             | 1.5   | 10   | 160  | 384  | 588  | 1680  |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| Microsomal protein yield (mg/g liver)        | 45    | 61   | 45   | 55   | 34   | 32    |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| Hepatocellularity (10^6 cells/g liver)       | 125   | 163  | 120  | 169  | 750  | 137   |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| QH (mL/min/kg)                               | 152   | 72   | 44   | 55   | 25   | 20    |"
echo -e "--------------------------------------------------------------------------------------------"
echo -e "| QH (L/h)                                     | 1.228 | 1.08 | 13.2 | 39.6 | 37.5 | 84    |"
echo -e "--------------------------------------------------------------------------------------------"

while true; do
	read organism

        if [[ "$organism" == "Mouse" || "$organism" == "mouse" ]]; then
                organismm='Mouse'
                echo -e "You chose a mouse."
                break

        elif [[ "$organism" == "Rat" || "$organism" == "rat" ]]; then
                organismm='Rat'
                echo -e "You chose a rat"
                break
	elif [[ "$organism" == "Cyno" || "$organism" == "cyno" ]]; then
                organismm='Cyno'
		echo -e "You chose a cyno (macaque)"                                                                                                   
		break
        elif [[ "$organism" == "Dog" || "$organism" == "dog" ]]; then
                organismm='Dog'
                echo -e "You chose a dog"                                                                                                              
		break
        elif [[ "$organism" == "Pig" || "$organism" == "pig" ]]; then
                organismm='Pig'
                echo -e "You chose a pig"
		break
        elif [[ "$organism" == "Human" || "$organism" == "human" ]]; then
                organismm='Human'
                echo -e "You chose a human"
		break
        elif [[ "$organism" == "Y" || "$organism" == "y" ]]; then
                organismm='Pig'
                echo -e "You chose a Pig"
                break
        elif [[ "$organism" == "Other" || "$organism" == "other" ]]; then
                organismm='Other'
                echo -e "You chose 'other', make sure to specify your own parameters by adding them under 'other' column in example_parameters.csv"
		break
	else
                echo -e "Invalid input. Please enter a valid name of an organism or 'Other'."
        fi
done

Rscript generate_graphs_and_report.R "$coumarin" "$organismm"

mv results.txt results/
mv hanes_woolf_plot.png results/
mv michaelis_menten_model.png results/

echo -e "Michaelis-Menten model, Hanes-Woolf plot and results.txt were saved to the results folder." 
