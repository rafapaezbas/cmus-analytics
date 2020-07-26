module YearChart exposing (..)

import Html
import LineChart
import LineChart.Dots as Dots
import Color
import Sample exposing (..)

chart : List Sample -> Html.Html msg
chart entries =
  let
      line = createLine entries
  in
      LineChart.view .year .quantity [ LineChart.line Color.red Dots.diamond "Top years" (createLine entries) ]


type alias Point = { year : Float, quantity : Float }


createLine : List Sample -> List Point
createLine entries =
   let
       years = List.range (getMinYear entries) (getMaxYear entries)
   in
       List.map (\y -> getPointByYear y entries) years


getMaxYear : List Sample -> Int
getMaxYear entries =
    let
        years: List Int
        years = List.map ( \e -> .year e |> String.toInt |> Maybe.withDefault 0 ) entries
    in
        Maybe.withDefault 0 (List.maximum years)

getMinYear : List Sample -> Int
getMinYear entries =
    let
        years: List Int
        years = List.map ( \e -> .year e |> String.toInt |> Maybe.withDefault 9999 ) entries
    in
        Maybe.withDefault 0 (List.minimum years)


getPointByYear : Int -> List Sample -> Point
getPointByYear year entries =
    Point (toFloat year) (List.filter (\e -> .year e == (Debug.toString year)) entries |> List.length |> toFloat)
