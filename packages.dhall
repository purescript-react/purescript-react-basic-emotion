let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220706/packages.dhall
        sha256:7a24ebdbacb2bfa27b2fc6ce3da96f048093d64e54369965a2a7b5d9892b6031

in  upstream
  with react-basic =
    { dependencies = [ "effect", "prelude", "record" ]
    , repo = "https://github.com/lumihq/purescript-react-basic"
    , version = "v17.0.0"
    }
  with react-basic-dom.version = "v6.0.0"
