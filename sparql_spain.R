###-------------------------------------------###
###      SPARQL from R to query WIKIDATA      ###
###             J.L. Losada 2019              ###
###-------------------------------------------###

# Query adapted from "Names of human settlements ending in "-ow" or "-itz" in Germany"

library(WikidataQueryServiceR)

sparql_query <- '
SELECT ?item ?itemLabel ?coord ?lon ?lat 
WHERE {
?item wdt:P31/wdt:P279* wd:Q486972;
wdt:P17 wd:Q29;
rdfs:label ?itemLabel;
p:P625 ?coordinate.

?coordinate ps:P625 ?coord;
psv:P625 ?coordinate_node.

?coordinate_node wikibase:geoLongitude ?lon;
wikibase:geoLatitude ?lat;

FILTER (lang(?itemLabel) = "es") . 
FILTER regex (?itemLabel, "ñ|Ñ").
}'

places = query_wikidata(sparql_query)

# write.csv(places, "spain_ene.csv")
places = read.csv("spain_ene.csv")

library(leaflet)

leaflet() %>%
  addTiles() %>%    
  
  addCircleMarkers(places$lon, places$lat, label=places$itemLabel, popup = paste0(places$itemLabel, "<br>", "<a href=",places$item,">", places$item, "</a>"), radius = 1 ) %>%
  
  addControl("<b>Spanish locations with the letter ñ </b> <br> Data: Wikidata · Script: github.com/editio", position='bottomleft')


