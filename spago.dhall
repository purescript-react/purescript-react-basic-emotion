{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-basic-emotion"
, dependencies =
  [ "colors"
  , "console"
  , "effect"
  , "foreign"
  , "foreign-object"
  , "numbers"
  , "prelude"
  , "psci-support"
  , "react-basic"
  , "react-basic-hooks"
  , "typelevel-prelude"
  , "unsafe-reference"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "Apache-2.0"
, repository = "https://github.com/lumihq/purescript-react-basic-emotion"
}
