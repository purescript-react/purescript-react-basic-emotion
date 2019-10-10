module React.Basic.Emotion
  ( Style
  , StyleProperty
  , class IsStyle
  , style
  , class IsStyleProperty
  , prop
  , element
  , elementKeyed
  , css
  , selector
  , merge
  , str
  , int
  , num
  , fallbacks
  , none
  , inherit
  , unset
  , url
  , color
  ) where

import Prelude
import Color (Color, cssStringHSLA)
import Control.Monad.Except (runExcept)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, runFn2)
import Foreign as F
import React.Basic (JSX, ReactComponent)
import Type.Row.Homogeneous (class Homogeneous)
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML.History (URL(..))

data Style

instance semigroupStyle :: Semigroup Style where
  append x y =
    let
      xF = F.unsafeToForeign x

      yF = F.unsafeToForeign y
    in
      case runExcept $ F.readArray xF, runExcept $ F.readArray yF of
        Right xArr, Right yArr -> merge (unsafeCoerce xArr <> unsafeCoerce yArr)
        Left _, Right yArr -> merge (Array.cons x (unsafeCoerce yArr))
        Right xArr, Left _ -> merge (Array.snoc (unsafeCoerce xArr) y)
        Left _, Left _ -> merge [ x, y ]

instance monoidStyle :: Monoid Style where
  mempty = emptyStyle

foreign import emptyStyle :: Style

class IsStyle a where
  style :: a -> Style

data StyleProperty

instance semigroupStyleProperty :: Semigroup StyleProperty where
  append x y =
    let
      xF = F.unsafeToForeign x

      yF = F.unsafeToForeign y
    in
      case runExcept $ F.readArray xF, runExcept $ F.readArray yF of
        Right xArr, Right yArr -> fallbacks (unsafeCoerce xArr <> unsafeCoerce yArr)
        Left _, Right yArr -> fallbacks (Array.cons x (unsafeCoerce yArr))
        Right xArr, Left _ -> fallbacks (Array.snoc (unsafeCoerce xArr) y)
        Left _, Left _ -> fallbacks [ x, y ]

instance monoidStyleProperty :: Monoid StyleProperty where
  mempty = emptyStyleProperty

foreign import emptyStyleProperty :: StyleProperty

class IsStyleProperty a where
  prop :: a -> StyleProperty

-- | Create a `JSX` node from a `ReactComponent`, by providing the props.
-- |
-- | This function is identical to `React.Basic.element` plus Emotion's
-- | `css` prop.
element ::
  forall props.
  ReactComponent { className :: String | props } ->
  { className :: String, css :: Style | props } ->
  JSX
element = runFn2 element_

-- | Create a `JSX` node from a `ReactComponent`, by providing the props and a key.
-- |
-- | This function is identical to `React.Basic.elementKeyed` plus Emotion's
-- | `css` prop.
elementKeyed ::
  forall props.
  ReactComponent { className :: String | props } ->
  { key :: String, className :: String, css :: Style | props } ->
  JSX
elementKeyed = runFn2 elementKeyed_

foreign import element_ ::
  forall props.
  Fn2
    (ReactComponent { className :: String | props })
    { className :: String, css :: Style | props }
    JSX

foreign import elementKeyed_ ::
  forall props.
  Fn2
    (ReactComponent { className :: String | props })
    { key :: String, className :: String, css :: Style | props }
    JSX

foreign import global :: ReactComponent { styles :: Style }

css :: forall r. Homogeneous r StyleProperty => { | r } -> Style
css = unsafeCoerce

selector :: Style -> StyleProperty
selector = unsafeCoerce

merge :: Array Style -> Style
merge = unsafeCoerce

str :: String -> StyleProperty
str = unsafeCoerce

int :: Int -> StyleProperty
int = unsafeCoerce

num :: Number -> StyleProperty
num = unsafeCoerce

fallbacks :: Array StyleProperty -> StyleProperty
fallbacks = unsafeCoerce

none :: StyleProperty
none = str "none"

inherit :: StyleProperty
inherit = str "inherit"

unset :: StyleProperty
unset = str "unset"

url :: URL -> StyleProperty
url (URL url') = str ("url(" <> url' <> ")")

color :: Color -> StyleProperty
color = str <<< cssStringHSLA
