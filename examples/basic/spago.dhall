{-
Welcome to a Spago project!
You can edit this file as you like.
-}
let conf = ../../spago.dhall

in conf // {
  sources = conf.sources # [ "src/**/*.purs", "../../src/**/*.purs" ],
  dependencies = conf.dependencies # 
    [ "effect"
    , "exceptions"
    , "maybe"
    , "react-basic-dom"
    , "react-basic-hooks"
    , "web-dom"
    ]
}
