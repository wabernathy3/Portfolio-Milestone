
# 
# Poster Project
# Waylon Abernathy
#
install.packages("mapdata")
#Packages
library(ggplot2)
library(tidyverse)
library(tmap)
library(sp)
library(usmap)
library(mapdata)
#Load Menu Data
menu.path <- "/Users/wa3/Syracuse/Term6/Viz/Poster/McMenu.csv"

menu <- read.csv(file = menu.path
                 , header = TRUE
                 , stringsAsFactors = FALSE)

#Load Mortality Data
mort.path <- "/Users/wa3/Syracuse/Term6/Viz/Poster/HeartDisease.csv"

mort <- read.csv(file = mort.path
                  , header = TRUE
                  , stringsAsFactors = FALSE)

#Load McDonalds per Capita
capita.path <- "/Users/wa3/Syracuse/Term6/Viz/Poster/Capita.csv"
cap <- read.csv(file = capita.path
                 , header = TRUE
                 , stringsAsFactors = FALSE)

#Load LatLon Data
ll.path <- "/Users/wa3/Syracuse/Term6/Viz/Poster/latlon.csv"
latlon <- read.csv(file = ll.path
                   , header = TRUE
                   , stringsAsFactors = FALSE)


#Filter Heart Disease for Mapping

heart <- mort[mort$Cause.Name == "Heart disease",]
heart <- merge(latlon, heart, by.x = "state", by.y = "State")
#Remove US and DC
heart <- heart[heart['State'] != "District of Columbia",]
heart <- heart[heart['State'] != "United States",]

scatter <- merge(cap, mort, by.x = "State", by.y = "State")

ggplot(scatter, aes(x= capita, y= Death.rate))

scatter2 <- scatter %>%
    select(State, capita, Cause.Name, Death.Rate) %>%
    filter(Cause.Name %in% c("Heart disease"))

ggplot(scatter2, aes(x= capita, y= Death.Rate)) +
    geom_point(aes(col = "green")) +
    geom_smooth() +
    geom_text(label = scatter2$State)

str(scatter2)
heart <- merge(heart, cap, by.x = "State", by.y = "State")
heart$state <- tolower(heart$state)
#Make A Map
library(maps)
library(mapproj)
library(plotrix)
library(ggmap)

#Heat Colors
num.cols <- 10
my.color.vec <- rev(heat.colors(num.cols))

heart$index <- round(rescale(x = heart$Death.Rate, c(1, num.cols)), 0 )

heart$color <- my.color.vec[heart$index]

m <- map("state")

state.order <- match.map(database = "state", regions = heart$State
                         , exact = F, warn = T)

cbind(m$names, heart$state[state.order])

map("state", col = heart$color[state.order]
    , fill = T
    , resolution = 0
    , lty = 1
    , projection = "polyconic", border = "tan"
    )


#Make a Better Map
num.cols2 <- 10
cap$index <- round(rescale(x = cap$capita, c(1, num.cols2)), 0)

cap$color <- my.color.vec[cap$index]

m <- map("state")

state.order <- match.map(database = "state", regions = cap$State
                         , exact = F, warn = T)

cbind(m$names, cap$State[state.order])

map("state", col = cap$color[state.order]
    , fill = T
    , resolution = 0
    , lty = 1
    , projection = "polyconic", border = "tan"
     )

#################
#
#Nutrition of McDonald's
#
##################

fda.path <- "/Users/wa3/Syracuse/Term6/Viz/Poster/FDA.csv"
fda <- read.csv(file = fda.path
                , header = TRUE
                , stringsAsFactors = FALSE)
drinks <- menu[menu$Category == "Beverages",]  
coke <- drinks[1:4,]  
coke <- data.frame(coke$Item, coke$Sugars)  
coke$coke.Item <- as.character(coke$coke.Item)
coke$coke.Sugars <- as.numeric(coke$coke.Sugars)
str(coke)

coke[nrow(coke) + 1,]  = c('FDA', '30')
coke$coke.Item <- as.factor(coke$coke.Item)

drinks <- menu[menu$Category == "Beverages",]
sugar <- drinks[1:4,]
coke <- data.frame(sugar$Item, sugar$Sugars)
colnames(coke) <- c("Item", "Sugars")
coke$Item <- as.character(coke$Item)
coke[nrow(coke) + 1,]  = c('FDA', '30')
coke$Item <- as.factor(coke$Item)
coke <- coke[-5,]
coke$Sugars <- as.numeric(coke$Sugars)
str(coke)


barplot(coke$Sugars, col = c("red", "red", "red", "red", "cornflowerblue" )
        , names.arg = c("Small", "Medium", "Large", "Child", "FDA"),
        , border = NA
        , xlab = "Beverage",
        , ylab = "Sugar (grams)",
        , main = "Sugar Content McDonald's Coke"
        , horiz = FALSE
        , las = 1
        , density = 50
        , #angle = c(45, 90, 12)
)
par(bg = "cornsilk")
barplot(coke$coke.Sugars)
barplot(sugar$Sugars, col = c("red", "maroon", "green", "orange")
        , names.arg = c("Coke", "Dr. Pepper", "Sprite", "Orange Juice"),
        , border = "white"
        , xlab = "Beverage",
        , ylab = "Sugar (grams)",
        , main = "Sugar Content of Large Size Drinks"
        , horiz = FALSE
        , las = 1
        , density = 50
        , #angle = c(45, 90, 12)
)
par(bg = "white")

#########################
#Sugar Content of All Drinks
#########################
unique(menu$Category)
library(dplyr)
drinks <- menu %>%
    select(Category, Item, Sugars) %>%
    filter(Category %in% c("Beverages", "Coffee & Tea", "Smoothies & Shakes"))

str(drinks)    
barplot(drinks$Sugars)    
hist(drinks$Sugars, breaks = 10, col = c("#FFC72C", "#DA291C"))

#######################
#Items with Processed Meat
#######################

pie(c(11, 103), col = c("#FFC72C", "#DA291C"), labels = c("Does Not Contain Processed Meats", "Contains Processed Meats")
    , main = "McDonald's Food Items")

###################
#Saturated Fat
###################
satfat <- menu %>%
    select(Category, Item, Saturated.Fat, Saturated.Fat....Daily.Value.) %>%
    filter(Category != "Beverages", Category %in% c("Beef & Pork"))

hist(satfat$Saturated.Fat....Daily.Value.,col = c("#FFC72C", "#DA291C"), breaks = 10)

barplot(satfat$Saturated.Fat, names.arg = satfat$Item, col = c("#FFC72C", "#DA291C"))
abline(h=13, col="black")

ggplot(satfat, aes(x= Item, y = Saturated.Fat)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme(axis.text.x = element_text(angle=45),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank()) +
    ggtitle("Burgers Saturated Fat in grams") +
    labs(y = "Grams", x = "Hamburgers") +
    geom_hline(yintercept = 13) 
    

ggplot(ark, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Arkansas") +
    labs(y = "Death Rate", x = "Cause of Death")
################
#Mortality Charts
################
barplot(ark$Death.Rate, names.arg = ark$Cause.Name)

barplot(wv$Death.Rate)


####Arkansas
ark <- mort %>%
    select(State, Cause.Name, Death.Rate) %>%
    filter(State == "Arkansas", Cause.Name != "All causes")

ap <- ggplot(ark, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Arkansas") +
    labs(y = "Death Rate", x = "Cause of Death")
ap

####West Virginia
wv <- mort %>%
    select(State, Cause.Name, Death.Rate) %>%
    filter(State == "West Virginia", Cause.Name != "All causes")

wp <- ggplot(wv, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("West Virginia") +
    labs(y = "Death Rate", x = "Cause of Death")
wp

####Kentucky
kent <- mort %>%
    select(State, Cause.Name, Death.Rate) %>%
    filter(State == "Kentucky", Cause.Name != "All causes")

kp <- ggplot(kent, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Kentucky") +
    labs(y = "Death Rate", x = "Cause of Death")
kp
####Michigan
mich <- mort %>%
    select(State, Cause.Name, Death.Rate) %>%
    filter(State == "Michigan", Cause.Name != "All causes")

mp <- ggplot(mich, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Michigan") +
    labs(y = "Death Rate", x = "Cause of Death")
mp
###Ohio
ohio <- mort %>%
    select(State, Cause.Name, Death.Rate) %>%
    filter(State == "Ohio", Cause.Name != "All causes")


op <- ggplot(ohio, aes(x= Cause.Name, y = Death.Rate)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Ohio") +
    labs(y = "Death Rate", x = "Cause of Death")
op   
    #install.packages("ggpubr")
library(ggpubr)
ggarrange(ap, wp, kp, mp, op + rremove("x.text"), 
          #labels = c("A", "B", "C"),
          ncol = 2, nrow = 3)
