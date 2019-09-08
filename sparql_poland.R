###-------------------------------------------###
###      SPARQL from R to query WIKIDATA      ###
###             J.L. Losada 2019              ###
###-------------------------------------------###

# The idea of plotting on a map these Polish toponyms was taken from an article in Gazeta Wyborcza, 07.11.2014 <http://wiadomosci.gazeta.pl/wiadomosci/56,114871,16933671,Dlaczego_na_polnocy_jest_RedlOWO_i_MragOWO__a_na_poludniu.html>

# Query adapted from "Names of human settlements ending in "-ow" or "-itz" in Germany"

library(WikidataQueryServiceR)

sparql_query <- '
SELECT ?item ?itemLabel ?coord ?lon ?lat 
WHERE {
?item wdt:P31/wdt:P279* wd:Q486972;
                wdt:P17 wd:Q36;
                rdfs:label ?itemLabel;
                p:P625 ?coordinate.

          ?coordinate ps:P625 ?coord;
          psv:P625 ?coordinate_node.

          ?coordinate_node wikibase:geoLongitude ?lon;
          wikibase:geoLatitude ?lat;

FILTER (lang(?itemLabel) = "pl") . 
FILTER regex (?itemLabel, "(ów)$|(owo)$").
}'

places = query_wikidata(sparql_query)

# write.csv(places, "polish_owo_ow.csv")
places = read.csv("polish_owo_ow.csv")

library(leaflet)

leaflet() %>%
  addTiles() %>%    
  
  addCircleMarkers(places$lon, places$lat, label=places$itemLabel, popup = paste0(places$itemLabel, "<br>", "<a href=",places$item,">", places$item, "</a>"), radius = 1, color = ifelse(grepl("(owo)$",places$itemLabel),"blue","orange")) %>%
  
  addLegend(position = "bottomleft", opacity = 0.4, 
            colors = c("blue", "orange"), 
            labels = c("-owo (Hermanowo)", "-ów (Kraków)")) %>%

  addControl("<b>Polish locations ending in -owo vs ów</b> <br> Data: Wikidata · Script: github.com/editio", position='bottomleft')


