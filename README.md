# Larvae Locomotion Analysis Tools

This repository contains a collection of MATLAB scripts designed for the analysis of larvae locomotion. Developed with MATLAB R2022a, these scripts facilitate the processing and statistical analysis of movement data, including the calculation of delta values, generation of time plots, survival analysis, and comparison across different experimental groups.

## Prerequisites

- MATLAB R2022a or later
- Input data in CSV format


##Usage

Each script in this repository is designed to perform a specific type of analysis. Here's an overview of the main scripts and their functionalities:
#Table_maker

Purpose: Calculates delta values for specified time ranges and performs statistical comparison between groups.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.
    start_time and end_time: Time range for calculations.

Output: A table with each row representing a specific ID and columns displaying various attributes and mean values for the specified periods.
#Binned_table

Purpose: Generates time plots by segregating data by experimental group and calculating mean attribute values for all IDs within each group per second.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.
    start_time and end_time: Time range for calculations.

Output: Separate tables for each group, with rows representing one-second intervals and columns showing mean values for each attribute.
#Number_of_N_per_time

Purpose: Assesses the quantity of IDs in each frame and tracks the consistency of IDs across time steps.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.

Output: Two graphs; a survival plot showing count of individuals tracked from start to each time point, and a graph displaying the number of IDs at each specific time for every group.
#Attribute_boxplot_ranksum

Purpose: Compares delta values (Δ) across groups, where Δ represents the difference in mean values of each attribute for each ID between two time periods.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.
    start_time and end_time for first and second periods: Time ranges for calculations.

Output: A boxplot representing Δ values for specified attributes across groups, along with Kruskal-Wallis and Mann-Whitney U test results.
#Survivaltable

Purpose: Generates a table with data from IDs present from the start to the end of the specified time range.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.
    start_time and end_time: Time range for calculations.

Output: A table with data from relevant IDs.
#Random_Forest1

Purpose: Utilizes the Binned_table function to calculate delta values for each ID, aiding in result visualization and analysis.

Input Parameters:

    csv_file_path: Path to the CSV file containing data.
    start_time and end_time for first and second periods: Time ranges for calculations.
