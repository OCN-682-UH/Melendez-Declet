###### Working with Strings Script #######
# Carolina Melendez Declet
# cvmd@hawaii.edu
# 10/27/2026
# This script is to learn how to work with strings 

###### Load Libraries ######
library(here)
library(tidyverse)
library(tidytext)
library(wordcloud)
library(janeaustenr)

###### Intro to {stringr} ######
## You can tell something is a string by the presence of quotations 
words <- "This is a string"
words

words_vector <- c("Apples", "Bananas", "Oranges")
words_vector

##### There are 4 basic families of functions in the {stringr} package 

###### {stringr} family: Manipulation ######
# Functions that let you manipulate individual characters within the strings in character vectors 
paste("High temp", "Low pH")

paste("High temp", "Low pH", sep = "-") # you can do periods, dashes 

paste0("High temp", "Low pH") # removes the space in between the words 

# Working with vectors 
shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes) 

two_cities <- c("best", "worst")
paste("It was the", two_cities, "of times.")

## Individual Characters 
shapes # vector of shapes

str_length(shapes) # how many letters are in each word?

seq_data <- c("ATCCCGTC")

str_sub(seq_data, start = 2, end = 4) # extract the 2nd to 4th AA

str_sub(seq_data, start = 3, end = 3) <- "A" # add an A in the 3rd position
seq_data

str_dup(seq_data, times = c(2, 3)) # times is the number of times to duplicate each string

###### {stringr} family: Whitespace ######
## Say you have a column and you did not copy and paste your treatments like you learned in the first week of class.

## Extra white spaces 
badtreatments <- c("High", " High", "High ", "Low", "Low")
badtreatments

str_trim(badtreatments) # this removes both

# You can also just remove from one side or the other
str_trim(badtreatments, side = "left") # this removes left

# We can also do the opposite 
str_pad(badtreatments, 5, side = "right") # add a white space to the right side after the 5th character

# Add a character instead of white space 
str_pad(badtreatments, 5, side = "right", pad = "1") # add a 1 to the right side after the 5th character

###### {stringr} family: Locale ######
## Make everythig upper case
x <- "I love R!"

str_to_upper(x) 

str_to_lower(x) # Make it lower case 

str_to_title(x) # Make it title case 

###### {stringr} family: Pattern Matching ######
# {stringr} has functions to view, detect, locate, extract, match, replace, and split strings based on specific patterns.

data <- c("AAA", "TATA", "CTAG", "GCTT")

# find all the strings with an A
str_view(data, pattern = "A")

str_detect(data, pattern = "A")

str_detect(data, pattern = "AT")

str_locate(data, pattern = "AT")

###### regex: Regular Expressions ######

## Metacharacters 
vals <- c("a.b", "b.c", "c.d")

## What if you want to replace all the "." with a space 
# string, pattern, replace
str_replace(vals, "\\.", " ")

vals <- c("a.b.c", "b.c.d", "c.d.e")
# string, pattern, replace
str_replace(vals, "\\.", " ")

## str_replace() only replaces the first instance. Let's try str_replace_all():

# string, pattern, replace
str_replace_all(vals, "\\.", " ")

## Sequences: refer to the sequences of characters which can match
val2 <- c("test 123", "test 456", "test")

str_subset(val2, "\\d")

## Character Class: list of characters enclosed by square brackets [] 
str_count(val2, "[aeiou]")

# count any digit
str_count(val2, "[0-9]")

## Example 
strings <- c("550-153-7578",
             "banana",
             "435.114.7586",
             "home: 672-442-6739")

phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

# Which strings contain phone numbers?
str_detect(strings, phone)

# subset only the strings with phone numbers
test <- str_subset(strings, phone)
test

## Think, Pair, Share: Let’s replace all the “.” with “-” and extract only the numbers (leaving the letters behind). Remove any extra white space. You can use a sequence of pipes.

test_final <- str_replace_all(test, "\\.", "-") |> 
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") |> # remove all the things we don't want 
  str_trim() # trim the white space
  
test_final




###### {tidytext} ######
head(austen_books())


# Lets clean it up and add a column for line and chapter: 
original_books <- austen_books() |> # get all of Jane Austen's books
  group_by(book) |>
  mutate(line = row_number(), # find every line
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", # count the chapters (starts with the word chapter followed by a digit or roman numeral)
                                                 ignore_case = TRUE)))) |> # ignore lower or uppercase
  ungroup() # ungroup it so we have a dataframe again

# don't try to view the entire thing... it's >73000 lines...
head(original_books)

## The function to unnest the data so that it's only one word per row is unnest_tokens()
tidy_books <- original_books |>
  unnest_tokens(output = word, input = text) # add a column named word, with the input as the text column

head(tidy_books) # there are now >725,000 rows. Don't view the entire thing!

# see an example of all the stopwords
head(get_stopwords())

## Tidytext

cleaned_books <- tidy_books |>
  anti_join(get_stopwords()) # dataframe without the stopwords

head(cleaned_books)

# Lets count the most common words across all her books: 
cleaned_books |>
  count(word, sort = TRUE)

# Sentimenet Analysis 
sent_word_counts <- tidy_books |>
  inner_join(get_sentiments()) |> # only keep pos or negative words
  count(word, sentiment, sort = TRUE) # count them

head(sent_word_counts)[1:3, ]

# Lets plot it 
sent_word_counts |>
  filter(n > 150) |> # take only if there are over 150 instances of it
  mutate(n = ifelse(sentiment == "negative", -n, n)) |> # add a column where if the word is negative make the count negative
  mutate(word = reorder(word, n)) |> # sort it so it goes from largest to smallest
  ggplot(aes(x = n, y = word, fill = sentiment)) +
  geom_col() +
  labs(y = "Contribution to sentiment")

## Make a word cloud
words <- cleaned_books |>
  count(word) |> # count all the words
  arrange(desc(n)) |> # sort the words
  slice(1:100) # take the top 100

wordcloud(words = words$word, freq = words$n, colors = brewer.pal(8, "Dark2"))



