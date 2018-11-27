#Packages

library(readtext)
library(stringr)
library(quanteda)
library(tidytext)
library(ggplot2)
library(dplyr)
library(tidyr)


#Having a look at our texts

readLines("sona_corpus/ramaphosa_sona_2018.txt")[1:20]

readLines("sona_corpus/maimane_sona_2018.txt")[1:9]

#Check if the encoding is the same
#Both files are saved as plain-text files, but are their character encodings the same? 
#The readtext package (linked to quanteda) has an encoding  function that tries to "guess" the encoding of files. 

encoding("sona_corpus/ramaphosa_sona_2018.txt")

encoding("sona_corpus/maimane_sona_2018.txt")

#Luckily the readtext function in the readtext package is designed to offer a solution for importing many types of data in a
#uniform format.

#Read in your documents

sona <- readtext("sona_corpus/*_sona_2018.txt")
sona

#Removing the greetings and read in again

ramaphosa <- readLines("sona_corpus/ramaphosa_sona_2018.txt")
ramaphosa <- ramaphosa[-(1:20)] 
writeLines(ramaphosa, "sona_corpus/ramaphosa_sona_2018.txt") #write with new name

sona <- readtext("sona_corpus/*_sona_2018.txt")
sona

#Remove salutations

salutations <- c("fellow south africans", "honourable members", "speaker")

sona$text <- tolower(sona$text)
salutation.regex <- paste(salutations, collapse = "|")
salutation.regex

sona$text <- str_remove_all(sona$text, pattern = salutation.regex)


#Creating a document-term matrix

sona.corpus <- corpus(sona) #convert to corpus object

sona.dtm <- dfm(sona.corpus,
                tolower = TRUE,
                stem = TRUE,
                remove_punct = TRUE,
                remove_numbers = TRUE,
                remove_hyphens = TRUE,
                remove_symbols = TRUE,
                remove = stopwords("english"))
sona.dtm

sona.dtm[, 1:12] #first 12 words


#Analysing the DTM

ntoken(sona.dtm) #tokens
ntype(sona.dtm) #unique tokens


topfeatures(sona.dtm, 10) #top 10 words

barplot(topfeatures(sona.dtm, 10), col = "purple")

textplot_wordcloud(sona.dtm, max_words = 100,
                   color = c("darkblue", "darkred"),
                   labelsize = 0.5, comparison = TRUE)


sona.df <- convert(t(sona.dtm), to = "data.frame") #convert to data frame for easy view
names(sona.df) <- c("word", "maimane", "ramaphosa")
sona.df

#Ramaphosa's top 10

ramaphosa10 <- head(sona.df[order(sona.df$ramaphosa,
                   decreasing = TRUE), ], 10)
ramaphosa10


#Maimane's top 10

maimane10 <-  head(sona.df[order(sona.df$maimane,
                   decreasing = TRUE), ], 10)

maimane10


#COnverting to tidy text

sona_tidy <- tidy(sona.dtm) 
sona_tidy 

#Sentiment analysis

#Bing dictionary

get_sentiments("bing")

sona_sentiments <- sona_tidy %>%
  inner_join(get_sentiments("bing"), by = c(term = "word"))

sona_sentiments %>%
  count(document, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(sentiment)


sona_sentiments %>%
  count(sentiment, term, wt = count) %>%
  filter(n >= 5) %>%
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>%
  mutate(term = reorder(term, n)) %>%
  ggplot(aes(term, n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Contribution to sentiment") +
  xlab("Term")

#NRC dictionary

get_sentiments("nrc")

sona_sentiments <- sona_tidy %>%
  inner_join(get_sentiments("nrc"), by = c(term = "word"))


sona_sentiments %>%
  count(document, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(sentiment)


sona_sentiments %>%
  count(sentiment, term, wt = count) %>%
  filter(n >= 5) %>%
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>%
  mutate(term = reorder(term, n)) %>%
  ggplot(aes(term, n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Contribution to sentiment") +
  xlab("Term")

