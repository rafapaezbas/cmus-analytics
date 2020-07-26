module Entry exposing (..)

import Json.Decode exposing (Decoder, field, string, int)

type alias Entry = { artist: String, album: String, title: String, year: String}

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

