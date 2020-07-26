module YearChart exposing (..)

import Html
import LineChart
import LineChart.Dots as Dots
import Color
import Sample exposing (..)

chart : List Sample -> Html.Html msg
chart samples =
  let
      line = createLine samples
  in
      LineChart.view .year .quantity [ LineChart.line Color.red Dots.diamond "Top years" (createLine samples) ]


type alias Point = { year : Float, quantity : Float }


createLine : List Sample -> List Point
createLine samples =
   let
       years = List.range (getMinYear samples) (getMaxYear samples)
   in
       List.map (\y -> getPointByYear y samples) years


getMaxYear : List Sample -> Int
getMaxYear samples =
    let
        years: List Int
        years = List.map ( \s -> .year s |> String.toInt |> Maybe.withDefault 0 ) samples
    in
        Maybe.withDefault 0 (List.maximum years)

getMinYear : List Sample -> Int
getMinYear samples =
    let
        years: List Int
        years = List.map ( \s -> .year s |> String.toInt |> Maybe.withDefault 9999 ) samples
    in
        Maybe.withDefault 0 (List.minimum years)


getPointByYear : Int -> List Sample -> Point
getPointByYear year samples =
    Point (toFloat year) (List.filter (\s -> .year s == (Debug.toString year)) samples |> List.length |> toFloat)
