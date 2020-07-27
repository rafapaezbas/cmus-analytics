module YearChart exposing (..)

import Html
import LineChart.Axis as Axis
import LineChart.Dots as Dots
import LineChart as LineChart
import LineChart.Junk as Junk exposing (..)
import LineChart.Dots as Dots
import LineChart.Colors as Colors
import LineChart.Container as Container
import LineChart.Interpolation as Interpolation
import LineChart.Axis.Intersection as Intersection
import LineChart.Legends as Legends
import LineChart.Line as Line
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Legends as Legends
import LineChart.Area as Area
import Color
import Sample exposing (..)

chart : List Sample -> Html.Html msg
chart samples =
  let
      line = createLine samples
  in
      LineChart.viewCustom chartConfig [LineChart.line Colors.pink Dots.diamond "Top years" (createLine samples |> List.filter (\p -> .quantity p /= 0)) ]

chartConfig = { y = Axis.default 450 "Quantity" .quantity
              , x = Axis.default 800 "Year" .year
              , container = Container.styled "line-chart-1" [("margin-top","-50px")]
              , interpolation = Interpolation.monotone
              , intersection = Intersection.default
              , legends = Legends.none
              , events = Events.default
              , junk = Junk.default
              , grid = Grid.default
              , area = Area.stacked 0.5
              , line = Line.default
              , dots = Dots.default
              }


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
