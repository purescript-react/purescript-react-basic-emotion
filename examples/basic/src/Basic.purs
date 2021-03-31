module Basic where

import Prelude
import Effect (Effect)
import React.Basic.DOM as R
import React.Basic.Emotion as E
import React.Basic.Hooks (JSX, ReactComponent, element, fragment, reactComponent)

data Size
  = S
  | M
  | L

border :: forall r. { borderSize :: Size, borderColor :: String | r } -> E.Style
border { borderSize, borderColor } =
  E.css
    { borderWidth:
      E.int case borderSize of
        S -> 1
        M -> 2
        L -> 4
    , borderColor: E.str borderColor
    , borderRadius: E.int 4
    , borderStyle: E.str "solid"
    , padding: E.str "16px 24px"
    }

text :: Size -> E.Style
text size =
  E.css
    { fontFamily: E.str "sans-serif"
    , fontSize:
      E.int case size of
        S -> 14
        M -> 18
        L -> 32
    , fontWeight:
      E.int case size of
        S -> 400
        M -> 500
        L -> 800
    }

type SlatProps
  = { borderSize :: Size
    , borderColor :: String
    , className :: String
    , content :: Array JSX
    , css :: E.Style
    }

slatDefaults :: SlatProps
slatDefaults =
  { borderSize: M
  , borderColor: "grey"
  , className: ""
  , content: mempty
  , css: mempty
  }

mkSlat :: Effect (ReactComponent SlatProps)
mkSlat = do
  box <- mkBox
  reactComponent "Slat" \props ->
    pure
      $ E.element
          box
          { className: props.className
          , css:
            E.merge
              [ border props
              , text L
              , E.css { flexDirection: E.str "row" }
              , spaceChildrenEvenly
              ]
          , content: props.content
          }

mkEx :: Effect (ReactComponent {})
mkEx = do
  slat <- mkSlat
  reactComponent "BasicEx" \props -> React.do
    pure
      $ fragment
          [ element slat
              slatDefaults
                { content = map (R.span_ <<< pure <<< R.text) [ "Hello", "World" ]
                }
          , E.element
              slat
              slatDefaults
                { content = map (R.span_ <<< pure <<< R.text) [ "Hello", "World" ]
                , css =
                  E.merge
                    [ E.css
                        { padding: E.int 4
                        , maxWidth: E.int 200
                        }
                    , text S
                    ]
                }
          ]

type BoxProps
  = { className :: String
    , content :: Array JSX
    }

boxDefaults :: BoxProps
boxDefaults =
  { className: ""
  , content: mempty
  }

boxStyle :: E.Style
boxStyle =
  E.css
    { display: E.str "flex"
    , flexDirection: E.str "column"
    , justifyContent: E.str "center"
    , alignItems: E.str "stretch"
    }

mkBox :: Effect (ReactComponent BoxProps)
mkBox = do
  reactComponent "Box" \props ->
    pure
      $ E.element R.div'
          { className: props.className
          , css: boxStyle
          , children: props.content
          }

spaceChildrenEvenly :: E.Style
spaceChildrenEvenly =
  E.css
    { "& > *":
      E.nested
        $ E.css
            { flex: E.str "1 0 auto"
            }
    }
