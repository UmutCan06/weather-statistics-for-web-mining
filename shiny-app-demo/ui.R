library(shiny)

vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)

fluidPage(
  titlePanel("Weeather Statistics for Turkey"),
  includeHTML('svg-TR-map.html'),
  column(3, wellPanel(
      h2("Filter"),
      selectInput("city", "City", vars)
    )
  )
  
)
# 
# fluidPage(
#   textInput(inputId = "city", label = "City", placeholder = "Select or Enter a City"),
#   includeHTML('svg-TR-map.html'),
#   includeScript("js/jquery-1.12.4.min.js"),
#   includeScript("js/svg-turkiye-haritasi.js"),
#   HTML('<script>
#       $(document).on("ready", function () {
# 
#         // SVG Türkiye Haritası
#         // (js/svg-turkiye-haritasi.js)
#         svgturkiyeharitasi();
# 
#       });
#     </script>'),
#   textOutput(outputId="cityName")
# )