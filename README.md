# Simple_AB_testing_data_analysis
Sharing code for a simple AB testing data analysis project

# The codes below implement the steps taken to load, clean and visualise the data. 

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("AB_data/ab_data.csv")
print(df.head()) # Looking at the columns and the top few rows of the data.

# Looking at the size of the data.
print(np.shape(df)) # The shape is (294478, 5).

# Finding out the number of unique user_id's.
print(df["user_id"].nunique()) # There are 290584 unique user id's.

# We need to only keep users in the 'control' group who have not landed in the 'new_page' or
# in the 'treatment' group who have not landed in the 'old_page'. That is a 'control'-'old_page' and 'treatment'-'new_page' alignment is needed.
df = df[((df['group'] == 'control') & (df['landing_page'] == 'old_page')) | ((df['group'] == 'treatment') & (df['landing_page'] == 'new_page'))]
print(np.shape(df))

# From the new shape, we can see that there are 290585 users. This means one user is still repeated in both cases. We can drop the second instance of the user_id.
df = df.drop_duplicates('user_id','first')
print(df['user_id'].nunique() == np.size(df['user_id'])) #This is true.

# To make sure that the data sample for each group is not going to be a problem, let us see the number of data points collected for each group.
control_group = df[df['group'] == 'control']
treatment_group = df[df['group'] == 'treatment']

n_control = np.size(control_group)
n_treatment = np.size(treatment_group)

n_control_vs_treatment = np.array([n_control, n_treatment])

# The means of each group.
control_mean = control_group['converted'].mean()
treatment_mean = treatment_group['converted'].mean()

# Getting a graph of the number of users belonging to each group.

fig, ax = plt.subplots()
con1, tre1 = plt.bar(['Control', 'Treatment'],n_control_vs_treatment, 0.35)
con1.set_facecolor('y')
tre1.set_facecolor('b')
ax.set_ylabel('Number of Users')
ax.set_title('Number of users in the control group vs treatment group')

plt.show()

# The data set is now quite ready for analysis. But we can first compare the proportion of users who were converted during the treatment condition vs. the control condition.
n_control_converted = np.size(df[((df['group'] == 'control') & (df['converted'] == 1))])
n_control_not_converted = np.size(df[((df['group'] == 'control') & (df['converted'] == 0))])

n_treatment_converted = np.size(df[((df['group'] == 'treatment') & (df['converted'] == 1))])
n_treatment_not_converted = np.size(df[((df['group'] == 'treatment') & (df['converted'] == 0))])

# The proportion of users that were converted.
total_converted = n_control_converted + n_treatment_converted
total_not_converted = n_treatment_not_converted + n_control_not_converted
proportion_converted = total_converted/(total_not_converted + total_converted)
proportion_not_converted = total_not_converted/(total_converted + total_not_converted)

total_converted_vs_not_converted = np.array([total_converted, total_not_converted])
converted_vs_not_converted = np.array([100*proportion_converted, 100*proportion_not_converted])

# Graph showing the proportion of users converted vs not converted.
fig1, ax1 = plt.subplots()
con, not_con = plt.bar(['Converted','Not Converted'],total_converted_vs_not_converted, 0.35)
con.set_facecolor('g')
not_con.set_facecolor('r')
ax1.set_title("Total number of users converted and not converted")
ax1.set_ylabel("Number of users")

plt.show()

# Of the users that were converted, what proportion of the users were converted to the new_page vs old_page.
proportion_control_converted = n_control_converted/(n_control_converted + n_treatment_converted)
proportion_treatment_converted = n_treatment_converted/(n_treatment_converted + n_control_converted)

proportion_converted_treatment_vs_control = np.array([100*proportion_control_converted, 100*proportion_treatment_converted])

# Graph showing the proportion of users converted to the new_page or old_page.
fig2, ax2 = plt.subplots()
opge, npge = plt.bar(['Old Page', 'New Page'], proportion_converted_treatment_vs_control, 0.35)
npge.set_facecolor('b')
opge.set_facecolor('y')
ax2.set_title("The proportion of users converted to the old page vs. new page")
ax2.set_ylabel('Percentage of Users')

plt.show()

# The question we now want to answer is if the difference between the proportion of users converted to the old vs new page is statistically significant.
# First save the new document into a new file.

only_converted_data = df[df['converted'] == 1]
only_converted_data.to_csv(r'AB_data/ab_data_analyse.csv')

df.to_csv(r'AB_data/cleaned_ab_data.csv')
