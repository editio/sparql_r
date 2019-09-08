###-------------------------------------------###
###      SPARQL from R to query WIKIDATA      ###
###             J.L. Losada 2019              ###
###-------------------------------------------###

# After a twitter exchange between @jenniferisve and @JMFradeRue 

# Link to the Endpoint with the query <https://w.wiki/84N>

library(WikidataQueryServiceR)

sparql_query <- '

# wd:Q1630979 Planeta
# wd:Q1280377 Alfaguara
# wd:Q926015  Nadal
# wd:Q4663319 Gijón
# wd:Q3320346 Nacional de Narrativa
# wd:Q2248929 Nacional de las Letras Españolas
# wd:Q3326922 Crítica 
# wd:Q1420399 Biblioteca Breve  
# wd:Q1088492 Romúlo Gallegos (Venezuela)
# wd:Q3405924 Alfonso Reyes (México)
# wd:Q860699  Nacional (Chile)

# Poesía

# wd:Q3888785 Adonais


SELECT  ?prize ?prizeLabel ?person ?personLabel ?pic ?genderLabel ?placeLabel ?birth ?death ?coord 
WHERE { 

# You can add or remove here prizes 
VALUES ?prize { wd:Q1630979 wd:Q1280377 wd:Q926015 wd:Q4663319 wd:Q3888785 wd:Q9062255 wd:Q3320346 wd:Q3326922 wd:Q1088492 wd:Q3405924 wd:Q860699 wd:Q2248929}

?person wdt:P31 wd:Q5;  
wdt:P166 ?prize;
rdfs:label ?personLabel .
?prize rdfs:label ?prizeLabel .

FILTER (lang(?prizeLabel) = "es").
FILTER (lang(?personLabel) = "es").

OPTIONAL { ?person wdt:P18 ?pic} 
OPTIONAL { ?person wdt:P569 ?birth} 
OPTIONAL { ?person wdt:P570 ?death}
OPTIONAL { ?person wdt:P21 ?gender. ?gender rdfs:label ?genderLabel     FILTER (lang(?genderLabel) = "es")}
OPTIONAL { ?person wdt:P19 ?place. ?place wdt:P625 ?coord}
OPTIONAL { ?person wdt:P19 ?place. ?place rdfs:label ?placeLabel        FILTER (lang(?placeLabel) = "es")}

}'

premios_red = query_wikidata(sparql_query)

write.csv(premios_red, "premios_red.csv")

