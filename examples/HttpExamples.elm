module HttpExamples exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http


-- Model


type alias Model =
    { nicknames : List String
    , errorMessage : Maybe String
    }


type Msg
    = SendHttpRequest
    | GotText (Result Http.Error String)


url : String
url =
    "http://localhost:5016/old-school.txt"



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from server" ]
        , viewNicknamesOrError model
        ]


viewNicknamesOrError : Model -> Html Msg
viewNicknamesOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewNicknames model.nicknames


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch nicknames at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


viewNicknames : List String -> Html Msg
viewNicknames nicknames =
    div []
        [ h3 [] [ text "Old School Main Characters" ]
        , ul [] (List.map viewNickname nicknames)
        ]
        

viewNickname : String -> Html Msg
viewNickname nickname =
    li [] [ text nickname ]

    



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model
            , Http.get 
                { url = url
                , expect = Http.expectString GotText
                }
            )

        GotText (Ok nicknamesStr) ->
            let
                nicknames =
                    String.split "," nicknamesStr
            in
                ( { model | nicknames = nicknames }, Cmd.none )

        GotText (Err httpError) ->
            ( { model
                | errorMessage = Just (createErrorMessage httpError)
              }
            , Cmd.none
            )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            "Server Error"

        Http.BadBody message ->
            message


init : () -> ( Model, Cmd Msg )
init _ =
    ( { nicknames = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }