(
  [
    (module_definition)
    (struct_definition)
    (macro_definition)
    (function_definition)
    (for_statement)
    (while_statement)
    (let_statement)
    (quote_statement)
    (do_clause)
    (compound_statement)
    (string_literal)
    (block_comment)
  ] @fold
)

; TODO want to treat these differently
; (if_statement) @fold
(try_statement) @fold


((if_statement
  alternative: [(elseif_clause) (else_clause)]) @fold
  (#set! fold.endAt lastNamedChild.startPosition)
  (#set! fold.adjustToEndOfPreviousRow true))

((elseif_clause) @fold
  (#set! fold.endAt endPosition))

((else_clause) @fold
  (#set! fold.endAt endPosition))

(if_statement) @fold
