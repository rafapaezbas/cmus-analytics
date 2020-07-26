module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Json.Decode exposing (Decoder, field, string, int)
import Html.Attributes exposing (class)
import Sample exposing (..)
import YearChart exposing (..)
import TopArtists exposing (..)


-- MAIN

main : Program String Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Sample = { artist: String, album: String, title: String, year: String}
type alias Model = { samples : List Sample }

init : String -> ( Model, Cmd Msg )
init fileData =
    let
        decodeResult : List (Result Json.Decode.Error Sample)
        decodeResult = List.map decodeSample (String.split "\n" fileData)
     in
    ( { samples =  List.map extractSample decodeResult |> List.filter isNotDefaultSample }
    , Cmd.none
    )

-- UPDATE

type Msg = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
  ( model, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
     Html.div
         [ class "container" ]
         [     YearChart.chart model.samples,
               text (TopArtists.getArtistsDataList model.samples |> Debug.toString)
         ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
