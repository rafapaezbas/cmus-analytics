module TopAlbums exposing (..)

import Html
import List.Unique exposing (..)
import Sample exposing (..)

type alias AlbumData = { name : String, artist: String, quantity : Int }

getAlbumsDataList: List Sample -> List AlbumData
getAlbumsDataList samples =
    let
        albums: List.Unique.UniqueList String
        albums = getAlbumsSet samples
    in
        List.map (\a -> getAlbumDataByName (a) samples) (List.Unique.toList albums)

getAlbumsSet: List Sample -> List.Unique.UniqueList String
getAlbumsSet samples =
    List.Unique.fromList (List.map (\s -> .album s) samples)

getAlbumDataByName: String -> List Sample -> AlbumData
getAlbumDataByName name samples =
    AlbumData (name) (getArtistbyAlbumName name samples) (List.filter (\s -> .album s == name) samples |> List.length)

getArtistbyAlbumName: String -> List Sample -> String
getArtistbyAlbumName albumName samples =
    let
        defaultSample: Sample
        defaultSample = Sample "Unknown album" "Unknown artist" "Unknown title" "Unknown year"
    in
        Maybe.withDefault defaultSample (List.filter(\s -> .album s == albumName) samples |> List.head) |> .artist

sortAlbumsByQuantity: List AlbumData -> List AlbumData
sortAlbumsByQuantity albums =
    List.sortWith compareAlbumDataByQuantity albums

compareAlbumDataByQuantity: AlbumData -> AlbumData -> Order
compareAlbumDataByQuantity a b =
    case (.quantity a) > (.quantity b) of
        True ->
            GT
        False ->
            LT

