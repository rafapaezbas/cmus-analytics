module Sample exposing (..)

import Json.Decode exposing (Decoder, field, string, int)

type alias Sample = { artist: String, album: String, title: String, year: String}

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

