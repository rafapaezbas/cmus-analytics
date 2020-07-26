module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Json.Decode exposing (Decoder, field, string, int)
import Html.Attributes exposing (class)
import Sample exposing (..)
import YearChart exposing (..)
import TopArtists exposing (..)
import TopAlbums exposing (..)


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
         ([ YearChart.chart model.samples ] ++ (artistsChart model) ++ (albumsChart model))

artistsChart : Model -> List (Html Msg)
artistsChart model =
    let
        topArtists: List ArtistData
        topArtists = TopArtists.getArtistsDataList model.samples |> TopArtists.sortArtistsByQuantity |> List.reverse |> List.take 10
    in
        List.map (\a -> Html.p [][text (.name a |> String.toLower)]) topArtists

albumsChart : Model -> List (Html Msg)
albumsChart model =
    let
        topAlbums: List AlbumData
        topAlbums = TopAlbums.getAlbumsDataList model.samples |> TopAlbums.sortAlbumsByQuantity |> List.reverse |> List.take 10
    in
        List.map (\a -> Html.p [][text (.artist a ++ " - " ++ .name a |> String.toLower)]) topAlbums

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
