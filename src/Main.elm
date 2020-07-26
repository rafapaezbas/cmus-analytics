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
type alias Model = { samples : List Sample }

init : String -> ( Model, Cmd Msg )
init fileData =
    let
        decodedSamples : List (Result Json.Decode.Error Sample)
        decodedSamples = List.map Sample.decodeSample (String.split "\n" fileData)
     in
    ( { samples =  List.map Sample.extractSample decodedSamples |> List.filter Sample.isNotDefaultSample }
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
         ([ YearChart.chart model.samples ] ++ (artistsChart model))

artistsChart : Model -> List (Html Msg)
artistsChart model =
    let
        topArtists: List ArtistData
        topArtists = TopArtists.getArtistsDataList model.samples |> TopArtists.sortArtistsByQuantity |> List.reverse |> List.take 10
    in
        List.map (\a -> Html.p [][text (.name a)]) topArtists

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
