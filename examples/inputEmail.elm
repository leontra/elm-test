module InputEmail exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- Model


type alias Model =
    String


initialModel : Model
initialModel =
    ""



-- View


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Email", value model, onInput Email ] []
        ]



-- Update


type Msg
    = Email String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Email email ->
            email



-- Entry point


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
