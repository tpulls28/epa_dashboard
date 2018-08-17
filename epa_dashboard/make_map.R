make_map <- function(sp_df) {
  
  # make_map(parcel_data.shape)
  
  new_map <- leaflet(sp_df) %>% 
    addTiles() %>%
    addPolygons(stroke = TRUE,opacity = 1,fillOpacity = 0.65, smoothFactor = 0.5,
                color="forestgreen",weight = 1) 
  return(new_map)
}