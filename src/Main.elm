module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Json.Decode exposing (Decoder, field, string, int)
import Html.Attributes exposing (class)
import Entry exposing (..)
import AlbumsPerYear exposing (..)


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

type alias Entry = { artist: String, album: String, title: String, year: String}
type alias Model = { entries : List Entry }

decodeEntry: String -> Result Json.Decode.Error Entry
decodeEntry entry =
    Json.Decode.decodeString (
                 Json.Decode.map4
                 Entry
                 (field "artist" string)
                 (field "album" string)
                 (field "title" string)
                 (field "year" string)
                 ) entry

extractEntry: Result Json.Decode.Error Entry -> Entry
extractEntry result =
    case result of
        Err _ ->
            { artist = "default", album = "default" , title = "default" , year = "default" }
        Ok entry ->
            entry

isNotDefaultEntry: Entry -> Bool
isNotDefaultEntry entry = .artist entry /= "default" || .album entry /= "default" || .title entry /= "default" || .year entry /= "default"

init : String -> ( Model, Cmd Msg )
init fileData =
    let
        decodeResult : List (Result Json.Decode.Error Entry)
        decodeResult = List.map decodeEntry (String.split "\n" fileData)
     in
    ( { entries =  List.map extractEntry decodeResult |> List.filter isNotDefaultEntry }
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
  --  text ((Result.withDefault {data = "defaultValue", number = 33}  model.entry).number |> String.fromInt)
     Html.div
         [ class "container" ]
         [ AlbumsPerYear.chart model.entries ]
    -- text(Debug.toString model.entries)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
