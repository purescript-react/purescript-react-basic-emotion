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
  , global
  , important
  , keyframes
  , nested
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
  , px, px', cm, mm, inches, pt, pc
  , em, ex, ch, rem, vw, vh, vmin, vmax, percent
  ) where

import Prelude

import Color (Color, cssStringHSLA)
import Control.Monad.Except (runExcept)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Int as Int
import Data.Number.Format (toString) as Number
import Foreign as F
import Prim.TypeError (class Warn, Text)
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

instance isStyleStyle :: IsStyle Style where
  style = identity

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

instance isStylePropertyStyleProperty :: IsStyleProperty StyleProperty where
  prop = identity

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

foreign import element_ ::
  forall props.
  Fn2
    (ReactComponent { className :: String | props })
    { className :: String, css :: Style | props }
    JSX

-- | Create a `JSX` node from a `ReactComponent`, by providing the props.
-- |
-- | This function is identical to `React.Basic.element` plus Emotion's
-- | `css` prop.
elementKeyed ::
  forall props.
  ReactComponent { className :: String | props } ->
  { key :: String, className :: String, css :: Style | props } ->
  JSX
elementKeyed = runFn2 elementKeyed_

foreign import elementKeyed_ ::
  forall props.
  Fn2
    (ReactComponent { className :: String | props })
    { key :: String, className :: String, css :: Style | props }
    JSX

foreign import global :: ReactComponent { styles :: Style }

foreign import css :: forall r. Homogeneous r StyleProperty => { | r } -> Style

foreign import important :: StyleProperty -> StyleProperty

foreign import keyframes :: forall r. Homogeneous r StyleProperty => { | r } -> StyleProperty

nested :: Style -> StyleProperty
nested = unsafeCoerce

merge :: Array Style -> Style
merge = unsafeCoerce

str :: String -> StyleProperty
str = unsafeCoerce

int
  :: Warn (Text "`int` is deprecated and may be removed in future versions. Prefer `str` or one of the unit combinators like `px` or `em` instead.")
  => Int
  -> StyleProperty
int = unsafeCoerce

num
  :: Warn (Text "`int` is deprecated and may be removed in future versions. Prefer `str` or one of the unit combinators like `px` or `em` instead.")
  => Number
  -> StyleProperty
num = unsafeCoerce

fallbacks :: Array StyleProperty -> StyleProperty
fallbacks = unsafeCoerce

url :: URL -> StyleProperty
url (URL url') = str ("url(" <> url' <> ")")

color :: Color -> StyleProperty
color = str <<< cssStringHSLA

none :: StyleProperty
none = str "none"

auto :: StyleProperty
auto = str "auto"

inherit :: StyleProperty
inherit = str "inherit"

unset :: StyleProperty
unset = str "unset"

hidden :: StyleProperty
hidden = str "hidden"

visible :: StyleProperty
visible = str "visible"

scroll :: StyleProperty
scroll = str "scroll"

wrap :: StyleProperty
wrap = str "wrap"

nowrap :: StyleProperty
nowrap = str "nowrap"

row :: StyleProperty
row = str "row"

column :: StyleProperty
column = str "column"

default :: StyleProperty
default = str "default"

manipulation :: StyleProperty
manipulation = str "manipulation"

pointer :: StyleProperty
pointer = str "pointer"

solid :: StyleProperty
solid = str "solid"

ellipsis :: StyleProperty
ellipsis = str "ellipsis"

block :: StyleProperty
block = str "block"

inlineBlock :: StyleProperty
inlineBlock = str "inline-block"

flex :: StyleProperty
flex = str "flex"

grid :: StyleProperty
grid = str "grid"

inlineGrid :: StyleProperty
inlineGrid = str "inline-grid"

inlineFlex :: StyleProperty
inlineFlex = str "inline-flex"

flexStart :: StyleProperty
flexStart = str "flex-start"

flexEnd :: StyleProperty
flexEnd = str "flex-end"

center :: StyleProperty
center = str "center"

stretch :: StyleProperty
stretch = str "stretch"

baseline :: StyleProperty
baseline = str "baseline"

spaceAround :: StyleProperty
spaceAround = str "space-around"

spaceBetween :: StyleProperty
spaceBetween = str "space-between"

spaceEvenly :: StyleProperty
spaceEvenly = str "space-evenly"

minContent :: StyleProperty
minContent = str "min-content"

maxContent :: StyleProperty
maxContent = str "max-content"

preWrap :: StyleProperty
preWrap = str "pre-wrap"

-- | Use a variable name as a property.
-- |
-- | Define a property somewhere:
-- | ```
-- | css { "--color-primary": color blue }
-- | ```
-- |
-- | Use the var:
-- | ```
-- | css { color: var "--color-primary" }
-- | ```
var :: String -> StyleProperty
var n = str ("var(" <> n <> ")")

-- Absolute length units

-- | Pixels. This function does not take a `Number` because approaches to
-- | subpixel rendering vary among browser implementations.
px :: Int -> StyleProperty
px x = str $ Int.toStringAs Int.decimal x <> "px"

-- | Pixels and subpixels.
-- |
-- | WARNING: Approaches to subpixel rendering vary among browser
-- | implementations. This means that non-integer pixel values may be displayed
-- | differently in different browsers.
px' :: Number -> StyleProperty
px' x = str $ Number.toString x <> "px"

-- | Centimeters
cm :: Number -> StyleProperty
cm x = str $ Number.toString x <> "cm"

-- | Milimeters
mm :: Number -> StyleProperty
mm x = str $ Number.toString x <> "mm"

-- | Inches (1in ≈ 2.54cm)
inches :: Number -> StyleProperty
inches x = str $ Number.toString x <> "in"

-- | Points (1pt = 1/72 of 1in)
pt :: Number -> StyleProperty
pt x = str $ Number.toString x <> "pt"

-- | Picas (1pc = 12 pt)
pc :: Number -> StyleProperty
pc x = str $ Number.toString x <> "pc"

-- Relative length units

-- | Relative to the font-size of the element (2em means 2 times the size of
-- | the current font).
em :: Number -> StyleProperty
em x = str $ Number.toString x <> "em"

-- | Relative to the x-height of the current font (rarely used).
ex :: Number -> StyleProperty
ex x = str $ Number.toString x <> "ex"

-- | Relative to the width of the "0" (zero) character.
ch :: Number -> StyleProperty
ch x = str $ Number.toString x <> "ch"

-- | Relative to font-size of the root element.
rem :: Number -> StyleProperty
rem x = str $ Number.toString x <> "rem"

-- | Relative to 1% of the width of the viewport.
vw :: Number -> StyleProperty
vw x = str $ Number.toString x <> "vw"

-- | Relative to 1% of the height of the viewport.
vh :: Number -> StyleProperty
vh x = str $ Number.toString x <> "vh"

-- | Relative to 1% of viewport's smaller dimension.
vmin :: Number -> StyleProperty
vmin x = str $ Number.toString x <> "vmin"

-- | Relative to 1% of viewport's larger dimension.
vmax :: Number -> StyleProperty
vmax x = str $ Number.toString x <> "vmax"

-- | Relative to the parent element.
percent :: Number -> StyleProperty
percent x = str $ Number.toString x <> "%"
