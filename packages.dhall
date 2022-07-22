let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220612/packages.dhall
        sha256:9876aee1362a5dac10061768c68a7ecc4a59ca9267c3760f7d43ea9d3812ec11

in  upstream
  with react-basic =
    { dependencies = [ "effect", "prelude", "record" ]
    , repo = "https://github.com/lumihq/purescript-react-basic"
    , version = "v17.0.0"
    }
  -- React 18 Support
  with react-basic-dom.version = "4633ad95b47a5806ca559dfb3b16b5339564f0ad"
