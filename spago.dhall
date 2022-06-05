{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-basic-emotion"
, dependencies =
  [ "arrays"
  , "colors"
  , "either"
  , "foreign"
  , "foreign-object"
  , "functions"
  , "integers"
  , "numbers"
  , "prelude"
  , "react-basic"
  , "strings"
  , "transformers"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "Apache-2.0"
, repository = "https://github.com/lumihq/purescript-react-basic-emotion"
}
