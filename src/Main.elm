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

decodeSample: String -> Result Json.Decode.Error Sample
decodeSample sample =
    Json.Decode.decodeString (
                 Json.Decode.map4
                 Sample
                 (field "artist" string)
                 (field "album" string)
                 (field "title" string)
                 (field "year" string)
                 ) sample

extractSample: Result Json.Decode.Error Sample -> Sample
extractSample result =
    case result of
        Err _ ->
            { artist = "default", album = "default" , title = "default" , year = "default" }
        Ok sample ->
            sample

isNotDefaultSample: Sample -> Bool
isNotDefaultSample sample = .artist sample /= "default" || .album sample /= "default" || .title sample /= "default" || .year sample /= "default"

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
