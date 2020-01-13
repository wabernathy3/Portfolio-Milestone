
# How to pay a Syracuse Football Coach

Waylon Abernathy

10.19.19


The goal of this project is to understand how different factors in the world of NCAA Football influence a coaches yearly salary.  This information will hopefully answer the key question of this project: what to pay a new Syracuse football coach.  I will be using multiple factors in order to shine some light on the issue.  



```python
import pandas as pd
import numpy as np
from scipy.stats import uniform  # for training-and-test split
import statsmodels.api as sm  # statistical models (including regression)
import statsmodels.formula.api as smf  # R-like model specification
import matplotlib.pyplot as plt  # 2D plotting
import statistics
import seaborn as sns  # PROVIDES TRELLIS AND SMALL MULTIPLE PLOTTING
```

# Step One: Import and Scrub Data

We begin by importing the data and scrubbing to better merge each dataframe with minimal loss of data.  We will be working with the Coach9 data provided for the exercise, graduation data pulled from the NCAA site, stadium data pulled from a github site, and Win-Loss Percentage data pulled from the sports reference website.  Apporpriate links to the data will be provided as necessary in each respective section.  



### Coach Data

We can see that we are working with 4 variables in this dataset.  

I was unable to ascertain if the TotalPay included the Bonus.  When working to subtract the Bonus from the TotalPay, I was left with some negative numbers for the salary.  This shines light on the inaccuracies within the provided dataframe, which should be considered when reviewing the analysis moving forward.  Further data research and scrubbing with regards to salary would likely provide higher accuracy in the results to follow. 

Additionally, conferences will be analyzed to see the role that this variable plays on salary.  




```python
#Coach9 data
coaches = pd.read_csv("Coaches9.csv")
coaches.head()

#Scrub columns for combine
coaches['TotalPay'] = coaches['TotalPay'].str.replace('$','')
coaches['TotalPay'] = coaches['TotalPay'].str.replace(',','')
coaches['TotalPay'] = coaches['TotalPay'].str.replace('--','0')

#Scrub columns for combine
#coaches['Bonus'] = coaches['Bonus'].str.replace('$','')
#coaches['Bonus'] = coaches['Bonus'].str.replace(',','')
#coaches['Bonus'] = coaches['Bonus'].str.replace('--','0')

coaches['TotalPay'] = coaches['TotalPay'].str.strip()
#coaches['Bonus'] = coaches['Bonus'].str.strip()

#Convert to integer for calc
coaches['TotalPay'] = coaches.TotalPay.astype(int)
#coaches['Bonus'] = coaches.Bonus.astype(int)

coaches.head()
#Salary Column
#newcoaches['Salary'] = coaches['TotalPay'] - coaches['Bonus']

#coaches.head()
#Drop Extra Variables


#print(coaches.to_string())

#newcoaches

#newcoaches.at[3, 'Salary'] = 900000
#newcoaches
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>SchoolPay</th>
      <th>TotalPay</th>
      <th>Bonus</th>
      <th>BonusPaid</th>
      <th>AssistantPay</th>
      <th>Buyout</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>100</th>
      <td>Southern Mississippi</td>
      <td>C-USA</td>
      <td>Jay Hopson</td>
      <td>$500,000</td>
      <td>500000</td>
      <td>$870,000</td>
      <td>$15,000</td>
      <td>$0</td>
      <td>$1,583,333</td>
    </tr>
    <tr>
      <th>101</th>
      <td>Stanford</td>
      <td>Pac-12</td>
      <td>David Shaw</td>
      <td>$4,311,543</td>
      <td>4311543</td>
      <td>--</td>
      <td>--</td>
      <td>$0</td>
      <td>--</td>
    </tr>
    <tr>
      <th>102</th>
      <td>Syracuse</td>
      <td>ACC</td>
      <td>Dino Babers</td>
      <td>$2,401,206</td>
      <td>2401206</td>
      <td>--</td>
      <td>--</td>
      <td>$0</td>
      <td>--</td>
    </tr>
    <tr>
      <th>103</th>
      <td>Tennessee</td>
      <td>SEC</td>
      <td>Jeremy Pruitt</td>
      <td>$3,846,000</td>
      <td>3846000</td>
      <td>$1,200,000</td>
      <td>--</td>
      <td>$0</td>
      <td>$11,780,000</td>
    </tr>
    <tr>
      <th>104</th>
      <td>Texas</td>
      <td>Big 12</td>
      <td>Tom Herman</td>
      <td>$5,500,000</td>
      <td>5500000</td>
      <td>$725,000</td>
      <td>$75,000</td>
      <td>$0</td>
      <td>$15,416,667</td>
    </tr>
    <tr>
      <th>105</th>
      <td>Texas A&amp;M</td>
      <td>SEC</td>
      <td>Jimbo Fisher</td>
      <td>$7,500,000</td>
      <td>7500000</td>
      <td>$1,350,000</td>
      <td>--</td>
      <td>$0</td>
      <td>$68,125,000</td>
    </tr>
    <tr>
      <th>106</th>
      <td>Texas Christian</td>
      <td>Big 12</td>
      <td>Gary Patterson</td>
      <td>$4,840,717</td>
      <td>4840717</td>
      <td>--</td>
      <td>--</td>
      <td>$0</td>
      <td>--</td>
    </tr>
    <tr>
      <th>107</th>
      <td>Texas State</td>
      <td>Sun Belt</td>
      <td>Everett Withers</td>
      <td>$700,000</td>
      <td>700000</td>
      <td>$70,833</td>
      <td>$0</td>
      <td>$0</td>
      <td>$773,958</td>
    </tr>
    <tr>
      <th>108</th>
      <td>Texas Tech</td>
      <td>Big 12</td>
      <td>Kliff Kingsbury</td>
      <td>$3,703,975</td>
      <td>3703975</td>
      <td>$1,500,000</td>
      <td>$25,000</td>
      <td>$0</td>
      <td>$4,231,250</td>
    </tr>
    <tr>
      <th>109</th>
      <td>Texas-El Paso</td>
      <td>C-USA</td>
      <td>Dana Dimel</td>
      <td>$700,000</td>
      <td>700000</td>
      <td>$741,665</td>
      <td>--</td>
      <td>$0</td>
      <td>$2,991,667</td>
    </tr>
  </tbody>
</table>
</div>




```python
coaches = coaches.drop(coaches.columns[[3,5, 6, 7, 8]], axis=1)
#coaches.School = coaches.School.replace({'Miami (Fla.)': 'Miami-Fla', 'Miami (Ohio)': 'Miami-OH'})
coaches.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Air Force</td>
      <td>Mt. West</td>
      <td>Troy Calhoun</td>
      <td>885000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>MAC</td>
      <td>Terry Bowden</td>
      <td>412500</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama</td>
      <td>SEC</td>
      <td>Nick Saban</td>
      <td>8307000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Alabama at Birmingham</td>
      <td>C-USA</td>
      <td>Bill Clark</td>
      <td>900000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Appalachian State</td>
      <td>Sun Belt</td>
      <td>Scott Satterfield</td>
      <td>712500</td>
    </tr>
  </tbody>
</table>
</div>



### Graduation Rate Data

Graduation rates will be used in the analysis to see the effects on salary.  The data was very inconsistent in terms of how the School names were listed.  These were extensively scrubbed so that the data would merge properly with the coaches dataframe.  This data was pulled from the http://www.ncaa.org/about/resources/research/graduation-rates website.  




```python
#Graduation Rate
grates = pd.read_csv("GradRates.csv")
grates.head()
#Removing unnecessary columns
grates = grates.drop(grates.columns[[0, 2, 3, 4, 7, 8]], axis=1)
grates.head()
#Cleaning data - School names for merge
grates.School = grates.School.replace({'University': ''}, regex=True)
grates.School = grates.School.replace({'of': ''}, regex=True)
#School Names for merge
grates.School = grates.School.replace({', Fayetteville':'', 'Bowling Green State': 'Bowling Green', 'at Buffalo, the State   New York': 'Buffalo',
                                      'California State , Fresno' :'Fresno State', 'Colorado, Boulder': 'Colorado', 'Georgia Institute  Technology': 'Georgia Tech', 'Hawaii, Manoa':'Hawaii',
                                      'Illinois Urbana-Champaign': 'Illinois', 'Indiana , Bloomington':'Indiana', 'Louisiana State': 'LSU', 'Maryland, College Park': 'Maryland', 'Massachusetts, Amherst': 'Massachusetts','Middle Tennessee State': 'Middle Tennessee'
                                      , 'Minnesota, Twin Cities':'Minnesota','Missouri, Columbia':'Missouri', 'North Carolina, Chapel Hill':'North Carolina','Nevada, Las Vegas':'Nevada-Las Vegas', 'Nevada, Reno':'Nevada', 'Louisiana Monroe': 'Louisiana-Monroe', 'The Ohio State':'Ohio State',
                                      'Pennsylvania State':'Penn State', 'South Carolina, Columbia':'South Carolina','Louisiana at Lafayette':'Louisiana-Lafayette', 'The   Southern Mississippi': 'Southern Mississippi', 'Tennessee, Knoxville':'Tennessee', 'Texas at Austin':'Texas','Texas A&M , College Station':'Texas A&M', 'The   Tulsa': 'Tulsa', 'Rutgers, The State   New Jersey, New Brunswick': 'Rutgers'
                                      ,'Wisconsin-Madison':'Wisconsin', 'California, Los Angeles': 'UCLA', 'Virginia Polytechnic Institute and State': 'Virginia Tech', 'U.S. Air Force Academy': 'Air Force', 'U.S. Military Academy':'Army','U.S. Naval Academy': 'Navy'
                                      ,'Miami  (Ohio) ': 'Miami-OH'}, regex=True)
grates.at[110, 'School']='Miami-OH'
grates.at[111, 'School']='Miami-Fla'
grates.at[31, 'School']='California'
grates.at[128, 'School']='Nebraska'
grates.at[209, 'School']='Texas-El Paso'
grates.at[210, 'School']='Texas-San Antonio'
grates.at[127, 'School']='Charlotte'

#grates["School"]= grates["School"].str.replace("Miami  (Ohio)", "Miami-OH", case = False)
#print(grates.to_string())
grates.head()

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>GSR</th>
      <th>FGR</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Abilene Christian</td>
      <td>61</td>
      <td>41.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>72</td>
      <td>61.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama A&amp;M</td>
      <td>62</td>
      <td>47.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Alabama State</td>
      <td>58</td>
      <td>42.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Alabama</td>
      <td>84</td>
      <td>63.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Convert to strings
coaches['School'] = coaches.School.astype(str)
grates['School'] = grates.School.astype(str)
#Strip whitespace
coaches['School'] = coaches['School'].str.strip()
grates['School'] = grates['School'].str.strip()
#print(grates.to_string())
```

### Stadium Data

The stadium data gives us the stadium capacity as well as the coordinates, which may be used later for visualizations if time allows.  This data was pulled from the github site: https://github.com/gboeing/data-visualization/blob/master/ncaa-football-stadiums/data/stadiums-geocoded.csv

The data names were scrubbed to merge with the other dataframes to ensure good merger without loss of team data.  




```python
#Stadium Size
stadium = pd.read_csv("stadiums.csv")
stadium.head()
#Remove columns
stadium = stadium.drop(stadium.columns[[0, 1, 2, 4, 6, 7, 8]], axis=1)
stadium.rename(columns={'team':'School'}, inplace=True)

#Check progress
stadium.head()

#Scrub school names for merge
stadium.at[33, 'School']='Brigham Young'
stadium.at[68, 'School']='Central Florida'
stadium.at[83, 'School']='Nevada-Las Vegas'
stadium.at[56, 'School']='Texas-El Paso'
stadium.at[32, 'School']='Texas-San Antonio'
stadium.at[71, 'School']='Texas Christian'
stadium.at[84, 'School']='Southern Mississippi'
stadium.at[92, 'School']='Southern Methodist'
stadium.at[46, 'School']='North Carolina State'
stadium.at[117, 'School']='Miami-OH'
stadium.at[31, 'School']='Miami-Fla'
stadium.at[121, 'School']='Florida International'
stadium.at[157, 'School']='Liberty'
stadium.at[114, 'School']='Northern Illinois'
stadium.at[30, 'School']='South Florida'
stadium.at[125, 'School']='Massachusetts'

stadium = stadium.sort_values('School', ascending=True)
#print(stadium.to_string())
stadium.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>176</th>
      <td>Abilene Christian Wildcats</td>
      <td>15075</td>
      <td>32.433802</td>
      <td>-99.697366</td>
    </tr>
    <tr>
      <th>66</th>
      <td>Air Force</td>
      <td>46692</td>
      <td>38.996907</td>
      <td>-104.843688</td>
    </tr>
    <tr>
      <th>105</th>
      <td>Akron</td>
      <td>30000</td>
      <td>41.072570</td>
      <td>-81.508384</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Alabama</td>
      <td>101821</td>
      <td>33.207490</td>
      <td>-87.550392</td>
    </tr>
    <tr>
      <th>150</th>
      <td>Alabama A&amp;M Bulldogs</td>
      <td>21000</td>
      <td>34.783215</td>
      <td>-86.579304</td>
    </tr>
  </tbody>
</table>
</div>



### Win Percentage Data

The data below was pulled from https://www.sports-reference.com/cfb/years/2018-standings.html to help determine if a coaches winning percentage has an effect on his salary.  We can use this data in our prediction modeling to determine if a winning coach makes more than a losing coach.  It should be noted that one season's worth of data may not be robust enough to provide a perfect reflection of a coaches performance with a school.  It would be beneficial to pull in multiple win-loss records for each coach and take the averages to yield more accurate results, but this evaluation is limited by time. 

In order to fit the data into our final dataframe, school names needed to be scrubbed to allow for the fit.  




```python
#Win-Loss Record
win = pd.read_csv("WLRecord.csv")
win = win.drop(win.columns[[0, 2, 3, 4, 6, 7, 8, 9 , 10, 11, 12, 13, 14, 15, 16]], axis=1)

#Cleaning up Win Percentage School Names for merging
win.School = win.School.replace({'UAB': 'Alabama at Birmingham', 'Bowling Green State': 'Bowling Green','UCF': 'Central Florida', 'Middle Tennessee State': 'Middle Tennessee', 'Ole Miss': 'Mississippi',
                                'USC': 'California'}, regex=True)
win.at[57, 'School']='Alabama at Birmingham'
win.at[74, 'School']='Bowling Green'
win.at[14, 'School']='Central Florida'
win.at[10, 'School']='Miami-Fla'
win.at[72, 'School']='Miami-OH'
win.at[50, 'School']='Middle Tennessee'
win.at[118, 'School']='Mississippi'
win.at[7,'School']='Pittsburgh'
win.at[23,'School']='Southern Methodist'
win.at[61,'School']='Texas-San Antonio'
win.at[63,'School']='Texas-El Paso'

win = win.sort_values('School', ascending=True)

win.head()
#print(win.to_string())
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>85</th>
      <td>Air Force</td>
      <td>0.417</td>
    </tr>
    <tr>
      <th>73</th>
      <td>Akron</td>
      <td>0.333</td>
    </tr>
    <tr>
      <th>113</th>
      <td>Alabama</td>
      <td>0.933</td>
    </tr>
    <tr>
      <th>57</th>
      <td>Alabama at Birmingham</td>
      <td>0.786</td>
    </tr>
    <tr>
      <th>120</th>
      <td>Appalachian State</td>
      <td>0.846</td>
    </tr>
  </tbody>
</table>
</div>



# Step Two: Create Dataframe

Finally, each dataframe can be merged in order to run our analysis on coach salary.  

It should be noted that the need to drop Baylor, Brigham Young, Rice, and Southern Methodist from our dataframe was due to a lack of salary data for these school.  This may or may not have an effect on our final result in predicting the Syracuse salary and this should be taken into consideration when evaluating the final results.  




```python
#Coach data with Grad Rates
data = coaches.merge(grates)
len(data)
#test = coaches.merge(grates)
#len(test)
```




    129




```python
#DF with Win Percentage
data = data.merge(win)
len(data)
```




    128




```python
#DF with Stadium data
data = data.merge(stadium)
len(data)
```




    126




```python
#Inspect new DF
data.head()
#print(data.to_string())
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>runiform</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Air Force</td>
      <td>Mt. West</td>
      <td>Troy Calhoun</td>
      <td>885000</td>
      <td>77</td>
      <td>NaN</td>
      <td>0.417</td>
      <td>46692</td>
      <td>38.996907</td>
      <td>-104.843688</td>
      <td>0.967030</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>MAC</td>
      <td>Terry Bowden</td>
      <td>412500</td>
      <td>72</td>
      <td>61.0</td>
      <td>0.333</td>
      <td>30000</td>
      <td>41.072570</td>
      <td>-81.508384</td>
      <td>0.547232</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama</td>
      <td>SEC</td>
      <td>Nick Saban</td>
      <td>8307000</td>
      <td>84</td>
      <td>63.0</td>
      <td>0.933</td>
      <td>101821</td>
      <td>33.207490</td>
      <td>-87.550392</td>
      <td>0.972684</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Appalachian State</td>
      <td>Sun Belt</td>
      <td>Scott Satterfield</td>
      <td>712500</td>
      <td>71</td>
      <td>67.0</td>
      <td>0.846</td>
      <td>24050</td>
      <td>36.211515</td>
      <td>-81.685506</td>
      <td>0.714816</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Arizona</td>
      <td>Pac-12</td>
      <td>Kevin Sumlin</td>
      <td>2000000</td>
      <td>76</td>
      <td>63.0</td>
      <td>0.417</td>
      <td>51811</td>
      <td>32.228340</td>
      <td>-110.949039</td>
      <td>0.697729</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Delete 2 rows missing Total Pay(Rice,Baylor,Brigham Young)
data = data.drop([11,15,89,96], axis = 0)
#print(data.to_string())

#Remove dollar signs
data['TotalPay'] = data['TotalPay'].str.replace('$','')
data['TotalPay'] = data['TotalPay'].str.replace(',','')
#data['TotalPay'] = data['TotalPay'].str.replace('--','0')
#Convert to int
#data['TotalPay'] = data.TotalPay.astype(int)
#print(data.to_string())
data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Air Force</td>
      <td>Mt. West</td>
      <td>Troy Calhoun</td>
      <td>885000</td>
      <td>77</td>
      <td>NaN</td>
      <td>0.417</td>
      <td>46692</td>
      <td>38.996907</td>
      <td>-104.843688</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>MAC</td>
      <td>Terry Bowden</td>
      <td>412500</td>
      <td>72</td>
      <td>61.0</td>
      <td>0.333</td>
      <td>30000</td>
      <td>41.072570</td>
      <td>-81.508384</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama</td>
      <td>SEC</td>
      <td>Nick Saban</td>
      <td>8307000</td>
      <td>84</td>
      <td>63.0</td>
      <td>0.933</td>
      <td>101821</td>
      <td>33.207490</td>
      <td>-87.550392</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Appalachian State</td>
      <td>Sun Belt</td>
      <td>Scott Satterfield</td>
      <td>712500</td>
      <td>71</td>
      <td>67.0</td>
      <td>0.846</td>
      <td>24050</td>
      <td>36.211515</td>
      <td>-81.685506</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Arizona</td>
      <td>Pac-12</td>
      <td>Kevin Sumlin</td>
      <td>2000000</td>
      <td>76</td>
      <td>63.0</td>
      <td>0.417</td>
      <td>51811</td>
      <td>32.228340</td>
      <td>-110.949039</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Ensure proper data types
data['TotalPay'] = data['TotalPay'].astype(int)
data['Pct'] = data['Pct'].astype(float)
data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Air Force</td>
      <td>Mt. West</td>
      <td>Troy Calhoun</td>
      <td>885000</td>
      <td>77</td>
      <td>NaN</td>
      <td>0.417</td>
      <td>46692</td>
      <td>38.996907</td>
      <td>-104.843688</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Akron</td>
      <td>MAC</td>
      <td>Terry Bowden</td>
      <td>412500</td>
      <td>72</td>
      <td>61.0</td>
      <td>0.333</td>
      <td>30000</td>
      <td>41.072570</td>
      <td>-81.508384</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Alabama</td>
      <td>SEC</td>
      <td>Nick Saban</td>
      <td>8307000</td>
      <td>84</td>
      <td>63.0</td>
      <td>0.933</td>
      <td>101821</td>
      <td>33.207490</td>
      <td>-87.550392</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Appalachian State</td>
      <td>Sun Belt</td>
      <td>Scott Satterfield</td>
      <td>712500</td>
      <td>71</td>
      <td>67.0</td>
      <td>0.846</td>
      <td>24050</td>
      <td>36.211515</td>
      <td>-81.685506</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Arizona</td>
      <td>Pac-12</td>
      <td>Kevin Sumlin</td>
      <td>2000000</td>
      <td>76</td>
      <td>63.0</td>
      <td>0.417</td>
      <td>51811</td>
      <td>32.228340</td>
      <td>-110.949039</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Check Work
data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 122 entries, 0 to 125
    Data columns (total 10 columns):
    School        122 non-null object
    Conference    122 non-null object
    Coach         122 non-null object
    TotalPay      122 non-null int64
    GSR           122 non-null int64
    FGR           119 non-null float64
    Pct           122 non-null float64
    capacity      122 non-null int64
    latitude      122 non-null float64
    longitude     122 non-null float64
    dtypes: float64(4), int64(3), object(3)
    memory usage: 10.5+ KB


# Step Three: Data Exploration

This section will be dedicated to exploring the data visually to get a better idea of the data we're working with.  We'll use boxplots, scatterplots, and heatmaps to see how our data is distributed and how the variables influence one another.  

### Boxplot of Conferences with Coach Salary

The boxplot shows that the SEC conference has the widest range of salaries and also the highest paid salaries in the division.  Looking to the ACC for evaluation of the Syracuse salary, we can see the salary range is much lower and overall pay is much lower than many of the more competitive conferences.  




```python
#Distribution of Coach Salary by Conference
plt.figure(figsize=(20,10))
chart = sns.boxplot(
    x="Conference", y="TotalPay",
    data=data,
    palette = 'Set1'
)

#chart.set_xticklabels(
    #chart.get_xticklabels(), 
    #rotation=45, 
    #horizontalalignment='right',
    #fontweight='light',
    #fontsize='x-large'
#)
```


![png](output_30_0.png)


### Heat Map: Variable Correlation

We can see from the heatmap that a coaches salary is effected strongly by the win percentage (Pct) + stadium size (capacity).  It can also be noted the two graduation stats are strongly correlated, which is unsurprising.  Furthermore, both graduation variables (GSR, FGR) show very low correlation to Total Pay.  




```python
# Calculate correlations
corr_data = data[['TotalPay', 'Conference', 'GSR', 'FGR', 'Pct', 'capacity']]
corr_data.head()
corr = corr_data.corr()
 
# Heatmap
sns.heatmap(corr)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1c36b0f5f8>




![png](output_33_1.png)


### Scatterplot: Total Pay vs Stadium Capacity

Here we work to see how much of an effect stadium capacity has on the total pay.  The R-squared shows that 69% of the variation in total pay can be attributed to the size of the stadium.  The p-value of 0 informs us that this is a reliable model based on the data provided.  




```python
plt.figure(figsize=(20,10))
sns.lmplot(x='capacity', y='TotalPay', data=data)

gsr_model = str('TotalPay ~ capacity')

#fit to df
gsr_train_model_fit = smf.ols(gsr_model, data = data).fit()
#summary of model
print(gsr_train_model_fit.summary())
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.685
    Model:                            OLS   Adj. R-squared:                  0.682
    Method:                 Least Squares   F-statistic:                     260.9
    Date:                Fri, 18 Oct 2019   Prob (F-statistic):           6.96e-32
    Time:                        21:21:33   Log-Likelihood:                -1866.7
    No. Observations:                 122   AIC:                             3737.
    Df Residuals:                     120   BIC:                             3743.
    Df Model:                           1                                         
    Covariance Type:            nonrobust                                         
    ==============================================================================
                     coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------
    Intercept  -1.022e+06   2.35e+05     -4.354      0.000   -1.49e+06   -5.57e+05
    capacity      67.6793      4.190     16.153      0.000      59.384      75.975
    ==============================================================================
    Omnibus:                        0.318   Durbin-Watson:                   1.904
    Prob(Omnibus):                  0.853   Jarque-Bera (JB):                0.073
    Skew:                          -0.021   Prob(JB):                        0.964
    Kurtosis:                       3.113   Cond. No.                     1.35e+05
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 1.35e+05. This might indicate that there are
    strong multicollinearity or other numerical problems.



    <Figure size 1440x720 with 0 Axes>



![png](output_36_2.png)


### Scatterplot: Total Pay vs Win Percentage

Win percentages have somewhat of a positive correlation to Total Pay based on the scatter plot and model seen below. Percentage makes up about 14% of the variance seen in Total Pay and has a p-value of 0, so this model is accurate.  Based off the coefficient of 3.17^+06, we can see that the higher the percentages add a lot of value to the salary.  If the coach has a perfect season, he would be making 3.17 million on this variable alone.  




```python
plt.figure(figsize=(20,10))
sns.lmplot(x='Pct', y='TotalPay', data=data)

gsr_model = str('TotalPay ~ Pct')

#fit to df
gsr_train_model_fit = smf.ols(gsr_model, data = data).fit()
#summary of model
print(gsr_train_model_fit.summary())
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.136
    Model:                            OLS   Adj. R-squared:                  0.129
    Method:                 Least Squares   F-statistic:                     18.94
    Date:                Sat, 19 Oct 2019   Prob (F-statistic):           2.85e-05
    Time:                        11:48:23   Log-Likelihood:                -1926.9
    No. Observations:                 122   AIC:                             3858.
    Df Residuals:                     120   BIC:                             3863.
    Df Model:                           1                                         
    Covariance Type:            nonrobust                                         
    ==============================================================================
                     coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------
    Intercept   7.907e+05   4.13e+05      1.913      0.058   -2.76e+04    1.61e+06
    Pct         3.178e+06    7.3e+05      4.352      0.000    1.73e+06    4.62e+06
    ==============================================================================
    Omnibus:                        7.465   Durbin-Watson:                   2.228
    Prob(Omnibus):                  0.024   Jarque-Bera (JB):                7.786
    Skew:                           0.596   Prob(JB):                       0.0204
    Kurtosis:                       2.666   Cond. No.                         5.86
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.



    <Figure size 1440x720 with 0 Axes>



![png](output_39_2.png)


### Scatterplot: Total Pay vs Graduation Rates

Here we see that Graduation Rates have little influence on coach salary. The R-squared shows us that only 3% of the variation in total pay can be explained by graduation rates.  Furthermore, our p-value on GSR is low enough to prove this a good model; however, the FGR is greater than 0.05 and cannot be interpretted with confidence.  




```python
sns.lmplot(x='GSR', y='TotalPay', data=data)

gsr_model = str('TotalPay ~ GSR + FGR')

#fit to df
gsr_train_model_fit = smf.ols(gsr_model, data = data).fit()
#summary of model
print(gsr_train_model_fit.summary())
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.033
    Model:                            OLS   Adj. R-squared:                  0.017
    Method:                 Least Squares   F-statistic:                     2.010
    Date:                Fri, 18 Oct 2019   Prob (F-statistic):              0.139
    Time:                        18:45:42   Log-Likelihood:                -1887.8
    No. Observations:                 119   AIC:                             3782.
    Df Residuals:                     116   BIC:                             3790.
    Df Model:                           2                                         
    Covariance Type:            nonrobust                                         
    ==============================================================================
                     coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------
    Intercept   4.875e+05   1.44e+06      0.340      0.735   -2.36e+06    3.33e+06
    GSR         5.504e+04   2.75e+04      2.004      0.047     635.395    1.09e+05
    FGR        -3.625e+04   2.37e+04     -1.530      0.129   -8.32e+04    1.07e+04
    ==============================================================================
    Omnibus:                       16.918   Durbin-Watson:                   2.085
    Prob(Omnibus):                  0.000   Jarque-Bera (JB):               19.548
    Skew:                           0.971   Prob(JB):                     5.69e-05
    Kurtosis:                       3.410   Cond. No.                         826.
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.



![png](output_42_1.png)


# Prediction Modeling

We can now use basic prediction modeling to get a better idea of what a Syracuse football salary should look like.  I will run through various models based on the questions listed by the exercise: Syracuse in ACC, Syracuse in Big 10, Syracuse in Big East.  I will also tailor the models based on the results of the standard model that will use every variable available.  Each section below will contain statistical evaluation of the models.  



### Prediction using all variables


```python
#Test and Training set for model validation
np.random.seed(4)
data['runiform'] = uniform.rvs(loc = 0, scale = 1, size = len(data))
data_train = data[data['runiform'] >= 0.33]
data_test = data[data['runiform'] < 0.33]
#data_test.at[94, 'Conference']='Big Ten'

#check training df
#print(data_train.head())
# test df
#print(data_test.head())

#simple model
my_model = str('TotalPay ~ Pct + Conference + GSR + capacity')

#fit to training df
train_model_fit = smf.ols(my_model, data = data_train).fit()
#summary of model
print(train_model_fit.summary())

#training set predictions
data_train['predict_pay'] = train_model_fit.fittedvalues

#test set predictions
data_test['predict_pay'] = train_model_fit.predict(data_test)
#print(data_test)

#locating syracuse
syr = data_test.loc[[99]]
syr['predict_pay'] = syr['predict_pay'].astype(int)
syr
syr['predict_pay'] = '$3,589,434'
syr
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.807
    Model:                            OLS   Adj. R-squared:                  0.776
    Method:                 Least Squares   F-statistic:                     25.48
    Date:                Sat, 19 Oct 2019   Prob (F-statistic):           5.68e-23
    Time:                        11:42:35   Log-Likelihood:                -1402.5
    No. Observations:                  93   AIC:                             2833.
    Df Residuals:                      79   BIC:                             2868.
    Df Model:                          13                                         
    Covariance Type:            nonrobust                                         
    ==========================================================================================
                                 coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------------------
    Intercept              -1.241e+06    1.1e+06     -1.128      0.263   -3.43e+06     9.5e+05
    Conference[T.ACC]       1.351e+06   4.66e+05      2.901      0.005    4.24e+05    2.28e+06
    Conference[T.Big 12]      1.7e+06   5.16e+05      3.291      0.001    6.72e+05    2.73e+06
    Conference[T.Big Ten]   1.727e+06   4.87e+05      3.547      0.001    7.58e+05     2.7e+06
    Conference[T.C-USA]    -3.775e+05   4.62e+05     -0.816      0.417    -1.3e+06    5.43e+05
    Conference[T.Ind.]      3.453e+04   7.69e+05      0.045      0.964    -1.5e+06    1.56e+06
    Conference[T.MAC]        -1.6e+05   4.97e+05     -0.322      0.749   -1.15e+06     8.3e+05
    Conference[T.Mt. West]  -3.95e+05    4.7e+05     -0.841      0.403   -1.33e+06     5.4e+05
    Conference[T.Pac-12]    9.622e+05   4.66e+05      2.066      0.042     3.5e+04    1.89e+06
    Conference[T.SEC]       1.519e+06   5.16e+05      2.946      0.004    4.93e+05    2.55e+06
    Conference[T.Sun Belt]  -3.73e+05   5.69e+05     -0.656      0.514   -1.51e+06    7.59e+05
    Pct                     1.709e+06   4.82e+05      3.548      0.001    7.51e+05    2.67e+06
    GSR                     4454.2559   1.29e+04      0.346      0.730   -2.12e+04    3.01e+04
    capacity                  36.2837      6.752      5.374      0.000      22.844      49.723
    ==============================================================================
    Omnibus:                        1.715   Durbin-Watson:                   2.106
    Prob(Omnibus):                  0.424   Jarque-Bera (JB):                1.148
    Skew:                           0.224   Prob(JB):                        0.563
    Kurtosis:                       3.309   Cond. No.                     7.98e+05
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 7.98e+05. This might indicate that there are
    strong multicollinearity or other numerical problems.


    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:22: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    
    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:25: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>runiform</th>
      <th>predict_pay</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>99</th>
      <td>Syracuse</td>
      <td>ACC</td>
      <td>Dino Babers</td>
      <td>2401206</td>
      <td>85</td>
      <td>70.0</td>
      <td>0.769</td>
      <td>49250</td>
      <td>43.036133</td>
      <td>-76.13652</td>
      <td>0.189026</td>
      <td>$3,589,434</td>
    </tr>
  </tbody>
</table>
</div>




#### Interpretation
According to the model, Dino (or the new coach) is likely due a raise.  The R-squared shows that this model accounts for 80% of the variation in the salary, and most of our coefficients maintain p-values of less than 0.05.  It must be stressed that this predicted salary of $3,589,434 includes bonuses due to some rough original salary data and should be considered as a loose value.   



### Predicting with Impactful Variables 


```python
#Test and Training set for model validation
np.random.seed(4)
data['runiform'] = uniform.rvs(loc = 0, scale = 1, size = len(data))
data_train = data[data['runiform'] >= 0.33]
data_test = data[data['runiform'] < 0.33]
#data_test.at[94, 'Conference']='Big Ten'

#check training df
#print(data_train.head())
# test df
#print(data_test.head())

#simple model
my_model = str('TotalPay ~ Pct + Conference + capacity')

#fit to training df
train_model_fit = smf.ols(my_model, data = data_train).fit()
#summary of model
print(train_model_fit.summary())

#training set predictions
data_train['predict_pay'] = train_model_fit.fittedvalues

#test set predictions
data_test['predict_pay'] = train_model_fit.predict(data_test)
#print(data_test)

#locating syracuse
syr1 = data_test.loc[[99]]
syr1['predict_pay'] = syr1['predict_pay'].astype(int)
syr1
syr1['predict_pay'] = '$3,551,163'
syr1
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.807
    Model:                            OLS   Adj. R-squared:                  0.778
    Method:                 Least Squares   F-statistic:                     27.90
    Date:                Sat, 19 Oct 2019   Prob (F-statistic):           1.11e-23
    Time:                        11:42:18   Log-Likelihood:                -1402.5
    No. Observations:                  93   AIC:                             2831.
    Df Residuals:                      80   BIC:                             2864.
    Df Model:                          12                                         
    Covariance Type:            nonrobust                                         
    ==========================================================================================
                                 coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------------------
    Intercept              -9.016e+05   4.94e+05     -1.826      0.072   -1.88e+06    8.08e+04
    Conference[T.ACC]       1.371e+06    4.6e+05      2.982      0.004    4.56e+05    2.29e+06
    Conference[T.Big 12]    1.699e+06   5.14e+05      3.308      0.001    6.77e+05    2.72e+06
    Conference[T.Big Ten]   1.763e+06   4.73e+05      3.725      0.000    8.21e+05     2.7e+06
    Conference[T.C-USA]    -3.759e+05    4.6e+05     -0.818      0.416   -1.29e+06    5.39e+05
    Conference[T.Ind.]      1630.3615   7.59e+05      0.002      0.998   -1.51e+06    1.51e+06
    Conference[T.MAC]      -1.617e+05   4.95e+05     -0.327      0.745   -1.15e+06    8.23e+05
    Conference[T.Mt. West] -3.963e+05   4.67e+05     -0.849      0.399   -1.33e+06    5.33e+05
    Conference[T.Pac-12]    9.763e+05   4.61e+05      2.116      0.037    5.79e+04    1.89e+06
    Conference[T.SEC]        1.52e+06   5.13e+05      2.965      0.004       5e+05    2.54e+06
    Conference[T.Sun Belt] -4.183e+05   5.51e+05     -0.760      0.450   -1.51e+06    6.77e+05
    Pct                     1.757e+06   4.59e+05      3.824      0.000    8.42e+05    2.67e+06
    capacity                  35.8134      6.577      5.445      0.000      22.724      48.902
    ==============================================================================
    Omnibus:                        1.852   Durbin-Watson:                   2.112
    Prob(Omnibus):                  0.396   Jarque-Bera (JB):                1.270
    Skew:                           0.238   Prob(JB):                        0.530
    Kurtosis:                       3.317   Cond. No.                     7.44e+05
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 7.44e+05. This might indicate that there are
    strong multicollinearity or other numerical problems.


    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:22: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    
    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:25: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>runiform</th>
      <th>predict_pay</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>99</th>
      <td>Syracuse</td>
      <td>ACC</td>
      <td>Dino Babers</td>
      <td>2401206</td>
      <td>85</td>
      <td>70.0</td>
      <td>0.769</td>
      <td>49250</td>
      <td>43.036133</td>
      <td>-76.13652</td>
      <td>0.189026</td>
      <td>$3,551,163</td>
    </tr>
  </tbody>
</table>
</div>




#### Interpretation
I decided to run a model that removed some of the variables that played a smaller role in a coaches salary (graduation data).  The result does decrease the recommended salary for the Syracuse coach, but only by about $30,000.  The R-squared was maintained at 80%, so we did not lose any predicting power by dropping the graduation rate data.  



### Syracuse to Big Ten


```python
#Test and Training set for model validation
np.random.seed(4)
data['runiform'] = uniform.rvs(loc = 0, scale = 1, size = len(data))
data_train = data[data['runiform'] >= 0.33]
data_test = data[data['runiform'] < 0.33]
data_test.at[99, 'Conference']='Big Ten'

#check training df
#print(data_train.head())
# test df
#print(data_test.head())

#simple model
my_model = str('TotalPay ~ Pct + Conference + capacity')

#fit to training df
train_model_fit = smf.ols(my_model, data = data_train).fit()
#summary of model
print(train_model_fit.summary())

#training set predictions
data_train['predict_pay'] = train_model_fit.fittedvalues

#test set predictions
data_test['predict_pay'] = train_model_fit.predict(data_test)
#print(data_test)

#locating syracuse
syr10 = data_test.loc[[99]]
syr10['predict_pay'] = syr10['predict_pay'].astype(int)
syr10
syr10['predict_pay'] = '$3,888,586'
syr10
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.807
    Model:                            OLS   Adj. R-squared:                  0.778
    Method:                 Least Squares   F-statistic:                     27.90
    Date:                Sat, 19 Oct 2019   Prob (F-statistic):           1.11e-23
    Time:                        11:41:57   Log-Likelihood:                -1402.5
    No. Observations:                  93   AIC:                             2831.
    Df Residuals:                      80   BIC:                             2864.
    Df Model:                          12                                         
    Covariance Type:            nonrobust                                         
    ==========================================================================================
                                 coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------------------
    Intercept              -9.016e+05   4.94e+05     -1.826      0.072   -1.88e+06    8.08e+04
    Conference[T.ACC]       1.371e+06    4.6e+05      2.982      0.004    4.56e+05    2.29e+06
    Conference[T.Big 12]    1.699e+06   5.14e+05      3.308      0.001    6.77e+05    2.72e+06
    Conference[T.Big Ten]   1.763e+06   4.73e+05      3.725      0.000    8.21e+05     2.7e+06
    Conference[T.C-USA]    -3.759e+05    4.6e+05     -0.818      0.416   -1.29e+06    5.39e+05
    Conference[T.Ind.]      1630.3615   7.59e+05      0.002      0.998   -1.51e+06    1.51e+06
    Conference[T.MAC]      -1.617e+05   4.95e+05     -0.327      0.745   -1.15e+06    8.23e+05
    Conference[T.Mt. West] -3.963e+05   4.67e+05     -0.849      0.399   -1.33e+06    5.33e+05
    Conference[T.Pac-12]    9.763e+05   4.61e+05      2.116      0.037    5.79e+04    1.89e+06
    Conference[T.SEC]        1.52e+06   5.13e+05      2.965      0.004       5e+05    2.54e+06
    Conference[T.Sun Belt] -4.183e+05   5.51e+05     -0.760      0.450   -1.51e+06    6.77e+05
    Pct                     1.757e+06   4.59e+05      3.824      0.000    8.42e+05    2.67e+06
    capacity                  35.8134      6.577      5.445      0.000      22.724      48.902
    ==============================================================================
    Omnibus:                        1.852   Durbin-Watson:                   2.112
    Prob(Omnibus):                  0.396   Jarque-Bera (JB):                1.270
    Skew:                           0.238   Prob(JB):                        0.530
    Kurtosis:                       3.317   Cond. No.                     7.44e+05
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 7.44e+05. This might indicate that there are
    strong multicollinearity or other numerical problems.


    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:22: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    
    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:25: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>runiform</th>
      <th>predict_pay</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>99</th>
      <td>Syracuse</td>
      <td>Big Ten</td>
      <td>Dino Babers</td>
      <td>2401206</td>
      <td>85</td>
      <td>70.0</td>
      <td>0.769</td>
      <td>49250</td>
      <td>43.036133</td>
      <td>-76.13652</td>
      <td>0.189026</td>
      <td>$3,888,586</td>
    </tr>
  </tbody>
</table>
</div>




#### Interpretation
If Syracuse moved to the Big Ten, the coach salary would increase to $3,888,586.  This is unsurprising when we reflect back on the boxplot distribution of coach salary based on conference.  Again, the r-squared remains at 80% with most coefficients p-values at less than 0.05.  



### Big East: Getting the Band Back Together


```python
#Test and Training set for model validation
np.random.seed(4)
data['runiform'] = uniform.rvs(loc = 0, scale = 1, size = len(data))
data_train = data[data['runiform'] >= 0.33]
data_test = data[data['runiform'] < 0.33]
data_test.at[99, 'Conference']='Big East' #Syracuse
data_train.at[22, 'Conference']='Big East' #Cincinnati
data_train.at[90, 'Conference']='Big East' #Rutgers
data_train.at[52, 'Conference']='Big East' #Louisville
data_train.at[30, 'Conference']='Big East' #Florida
data_train.at[58, 'Conference']='Big East' #Miami, Fl
data_train.at[121, 'Conference']='Big East' #W.Virginia
data_test.at[117, 'Conference']='Big East' #Virginia Tech

#print(data_train.to_string())
#check training df
#print(data_train.head())
# test df
#print(data_test.head())


#simple model
my_model = str('TotalPay ~ Pct + Conference + capacity')

#fit to training df
train_model_fit = smf.ols(my_model, data = data_train).fit()
#summary of model
print(train_model_fit.summary())

#training set predictions
data_train['predict_pay'] = train_model_fit.fittedvalues
#print(data_train)
#test set predictions
data_test['predict_pay'] = train_model_fit.predict(data_test)
#print(data_test)

#locating syracuse
syreast = data_test.loc[[99]]
syreast['predict_pay'] = syreast['predict_pay'].astype(int)
syreast
syreast['predict_pay'] = '$3,632,721'
syreast
```

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:               TotalPay   R-squared:                       0.804
    Model:                            OLS   Adj. R-squared:                  0.772
    Method:                 Least Squares   F-statistic:                     25.00
    Date:                Sat, 19 Oct 2019   Prob (F-statistic):           1.02e-22
    Time:                        11:41:25   Log-Likelihood:                -1403.2
    No. Observations:                  93   AIC:                             2834.
    Df Residuals:                      79   BIC:                             2870.
    Df Model:                          13                                         
    Covariance Type:            nonrobust                                         
    ==========================================================================================
                                 coef    std err          t      P>|t|      [0.025      0.975]
    ------------------------------------------------------------------------------------------
    Intercept               -9.28e+05   5.14e+05     -1.807      0.075   -1.95e+06    9.45e+04
    Conference[T.ACC]       1.177e+06   5.05e+05      2.330      0.022    1.72e+05    2.18e+06
    Conference[T.Big 12]    1.753e+06    5.6e+05      3.129      0.002    6.38e+05    2.87e+06
    Conference[T.Big East]  1.473e+06    5.5e+05      2.679      0.009    3.79e+05    2.57e+06
    Conference[T.Big Ten]   1.772e+06   5.08e+05      3.487      0.001     7.6e+05    2.78e+06
    Conference[T.C-USA]    -3.551e+05   4.89e+05     -0.726      0.470   -1.33e+06    6.18e+05
    Conference[T.Ind.]      1.867e+04    7.8e+05      0.024      0.981   -1.53e+06    1.57e+06
    Conference[T.MAC]      -1.323e+05   5.22e+05     -0.254      0.800   -1.17e+06    9.06e+05
    Conference[T.Mt. West] -3.873e+05   4.95e+05     -0.782      0.436   -1.37e+06    5.98e+05
    Conference[T.Pac-12]    9.618e+05   4.89e+05      1.966      0.053   -1.18e+04    1.94e+06
    Conference[T.SEC]       1.367e+06   5.42e+05      2.524      0.014    2.89e+05    2.45e+06
    Conference[T.Sun Belt] -3.844e+05   5.78e+05     -0.666      0.508   -1.53e+06    7.65e+05
    Pct                     1.626e+06   4.65e+05      3.498      0.001    7.01e+05    2.55e+06
    capacity                  37.8107      6.532      5.789      0.000      24.809      50.812
    ==============================================================================
    Omnibus:                        2.414   Durbin-Watson:                   2.217
    Prob(Omnibus):                  0.299   Jarque-Bera (JB):                1.767
    Skew:                           0.275   Prob(JB):                        0.413
    Kurtosis:                       3.393   Cond. No.                     8.29e+05
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 8.29e+05. This might indicate that there are
    strong multicollinearity or other numerical problems.


    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:31: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    
    /Users/wa3/anaconda3/lib/python3.7/site-packages/ipykernel_launcher.py:34: SettingWithCopyWarning:
    
    
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
    





<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School</th>
      <th>Conference</th>
      <th>Coach</th>
      <th>TotalPay</th>
      <th>GSR</th>
      <th>FGR</th>
      <th>Pct</th>
      <th>capacity</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>runiform</th>
      <th>predict_pay</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>99</th>
      <td>Syracuse</td>
      <td>Big East</td>
      <td>Dino Babers</td>
      <td>2401206</td>
      <td>85</td>
      <td>70.0</td>
      <td>0.769</td>
      <td>49250</td>
      <td>43.036133</td>
      <td>-76.13652</td>
      <td>0.189026</td>
      <td>$3,632,721</td>
    </tr>
  </tbody>
</table>
</div>




#### Interpretation
Finally, the hypothetical question of what would the salary be if Syracuse joined the Big East conference.  This was a difficult question to answer due to the fact that the Big East does not participate in NCAA football, so these teams lack any type of football-related data.  The solution I found best was to research what teams that play football now used to play for the Big East.  After converting these teams to the new Big East conference, we were able to run the model.  Again, this is a pure hypothetical answer to a hypothetical question, but Coach Dino would be happy to discover he would recieve a raise in this hypothetical world.  

# Results

We can see that with each model, the Syracuse coach should be payed about 3.5 million.  Results showed that conference, win-loss percentage, and stadium size can all play a sizable role in how to pay a football coach, while graduation rates have little to no effect on the salary.  The size of the stadium has the greatest influence on a coaches salary, but the analsis was able to show that win-loss percentage can also influence the number by millions of dollars based on the coefficient value.  Data issues reported above should be taken into account when reviewing the results, such as dropped school and the original salary figures in relation to bonus pay.

Other data that may have lended to better analysis include: updated yearly salary of all coaches, logs of freshman enrollment numbers (increase vs decrease), and more historical win-loss statistics.  



#### Further thoughts on the project

This was my first experience with Python and Jupyter notebook.  I was close to fitting the median salaries to a map, but need a little more time to play with Python before I can get it down.  I also struggled with the formatting of the lab and hope to gain more insight on how to proceed further when writing out a case study.  I think I would have been more successful using R, but I thought it would be personally beneficial to force myself to dive head-first into Python.  With that being said, I feel that I could have created a fairly accurate model if I were a little more familiar to Python coding.      
