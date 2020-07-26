module TopArtists exposing (..)

import Html
import List.Unique exposing (..)
import Sample exposing (..)

type alias ArtistData = { name : String, quantity : Int }

getArtistsDataList: List Sample -> List ArtistData
getArtistsDataList samples =
    let
        artists: List.Unique.UniqueList String
        artists = getArtistsSet samples
    in
        List.map (\a -> getArtistDataByName (a) samples) (List.Unique.toList artists)

getArtistsSet: List Sample -> List.Unique.UniqueList String
getArtistsSet samples =
    List.Unique.fromList (List.map (\s -> .artist s) samples)

getArtistDataByName: String -> List Sample -> ArtistData
getArtistDataByName name samples =
    ArtistData (name) (List.filter (\s -> .artist s == name) samples |> List.length)

sortArtistsByQuantity: List ArtistData -> List ArtistData
sortArtistsByQuantity artists =
    List.sortWith compareArtistDataByQuantity artists

compareArtistDataByQuantity: ArtistData -> ArtistData -> Order
compareArtistDataByQuantity a b =
    case (.quantity a) > (.quantity b) of
        True ->
            GT
        False ->
            LT


