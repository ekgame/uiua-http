# Experimental!

~ "utils" ~ InsertBoxed

SplitHeaderAndBody ← (
  ⊜□≠1⦷ "\r\n\r\n".
  °□⊢.
  ⟨""◌|°□⊡1⟩>1⧻.:
)

ParseStatusLine ← (
  ↙2 ⊜□¬≡(⍥(0◌)>2.) ⦷" ".
  ⍜(⊡1)(⋕)
  map {"protocol" "status"}
)

ParseHeaders ← (
  ⍚(⊜□≠1⦷ ": ".)
  ≡(⊡1°□).
  ≡(⊡0°□):
  map
)

ParseHeader ← (
  ⊜□¬⦷ "\r\n".
  ⊃(°□⊢)(↘1)
  ParseStatusLine
  ParseHeaders:
  InsertBoxed "headers"
)

ParseResponse ← (
  :SplitHeaderAndBody
  ParseHeader
  InsertBoxed "body" :
)
