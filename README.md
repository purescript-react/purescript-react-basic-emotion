# react-basic-emotion

[Emotion](https://emotion.sh/) support for [react-basic](https://github.com/lumihq/purescript-react-basic)!

[![Build Status](https://github.com/lumihq/purescript-react-basic-emotion/actions/workflows/ci.yml/badge.svg)](https://github.com/lumihq/purescript-react-basic-emotion/actions/workflows/ci.yml)
<a href="https://pursuit.purescript.org/packages/purescript-react-basic-emotion">
  <img src="https://pursuit.purescript.org/packages/purescript-react-basic-emotion/badge"
       alt="Fixed Precision on Pursuit">
  </img>
</a>

## Example usage:

```purescript
import React.Basic.DOM as R
import React.Basic.Hooks as React
import React.Basic.Emotion as E

myUnstyledDiv :: JSX
myUnstyledDiv = React.element R.div' 
    { children: [ R.text "I have no style :(" ] 
    }

myStyledDiv :: JSX
myStyledDiv = E.element R.div' 
  { className: "stylish-div" 
  , css: E.css 
      { color: E.str "rebeccapurple"
      , padding: E.px 4
      }
  } 
```

Note that you need to use the apostrophised variants of react components from `React.Basic.DOM` since these represent the raw `ReactComponent`s that `Emotion` expects to work with.

## Going beyond what `style` can give you

Emotion allows you to define real CSS rules rather than only inline styles.
Here's an example of something you can't do with inline styles:

```purescript
myStyle :: Style
myStyle = E.css 
  { "&:hover": E.nested (E.css { background: E.str "#fed" })
  }
```
