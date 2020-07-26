module AlbumsPerYear exposing (..)

import Html
import LineChart
import LineChart.Dots as Dots
import Color
import Entry exposing (..)


chart : List Entry -> Html.Html msg
chart entries =
  let
      line = createLine entries
  in
  LineChart.view .year .quantity [ LineChart.line Color.red Dots.diamond "Records/year" (createLine entries) ]


type alias Info = { year : Float, quantity : Float }


createLine : List Entry -> List Info
createLine entries =
   let
       years = List.range (getMinYear entries) (getMaxYear entries)
   in
       List.map (\y -> getInfoByYear y entries) years


getMaxYear : List Entry -> Int
getMaxYear entries =
    let
        years: List Int
        years = List.map ( \e -> .year e |> String.toInt |> Maybe.withDefault 0 ) entries
    in
        Maybe.withDefault 0 (List.maximum years)

getMinYear : List Entry -> Int
getMinYear entries =
    let
        years: List Int
        years = List.map ( \e -> .year e |> String.toInt |> Maybe.withDefault 9999 ) entries
    in
        Maybe.withDefault 0 (List.minimum years)


getInfoByYear : Int -> List Entry -> Info
getInfoByYear year entries =
    Info (toFloat year) (List.filter (\e -> .year e == (Debug.toString year)) entries |> List.length |> toFloat)
