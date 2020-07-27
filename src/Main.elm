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
         [yearChart model, artistsChart model, albumsChart model]

yearChart: Model -> Html Msg
yearChart model =
    Html.div [class "panel-year-chart"] ([Html.h2 [] [text "Samples/year"]] ++ [YearChart.chart model.samples])

artistsChart : Model -> Html Msg
artistsChart model =
    let
        topArtists: List ArtistData
        topArtists = TopArtists.getArtistsDataList model.samples |> TopArtists.sortArtistsByQuantity |> List.reverse |> List.take 10
        htmlTopArtistsList: List (Html Msg)
        htmlTopArtistsList = List.map (\a -> Html.p [class "caps-formated"][text (.name a |> String.toLower)]) topArtists
    in
        Html.div [class "panel-top-artists"] ([Html.h2 [] [text "Top 10 Artists"]] ++ htmlTopArtistsList)

albumsChart : Model -> Html Msg
albumsChart model =
    let
        topAlbums: List AlbumData
        topAlbums = TopAlbums.getAlbumsDataList model.samples |> TopAlbums.sortAlbumsByQuantity |> List.reverse |> List.take 10
        htmlTopAlbumsList: List (Html Msg)
        htmlTopAlbumsList = List.map (\a -> Html.p [class "caps-formated"][text (.artist a ++ " - " ++ .name a |> String.toLower)]) topAlbums
    in
        Html.div [class "panel-top-albums"] ([Html.h2 [] [text "Top 10 Albums"]] ++ htmlTopAlbumsList)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
