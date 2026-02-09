; Prevent postfix modifiers from triggering indents on the next line.
(if_clause "if" @_IGNORE_
  (#set! capture.final true))
(for_clause "for" @_IGNORE_
  (#set! capture.final true))

[
  "function"
  ; (function_definition)
  ; (call_expression)
  "struct"
  ; (struct_definition)
  "macro"
  ; (macro_definition)
  "begin"
  ; (compound_statement)
  "if"
  "else"
  "elseif"
  ; (if_statement)
  "try"
  "catch"
  "finally"
  ; (try_statement)
  "for"
  ; (for_statement)
  "while"
  ; (while_statement)
  "let"
  ; (let_statement)
  "do"
  ; (do_clause)
  "quote"
  ; (quote_statement)
  (argument_list)
  "("
  "["
  "{"
] @indent



; [
;   ; (assignment)
;   ; (for_binding)
;   ; (parenthesized_expression)
;   ; (tuple_expression)
;   ; (comprehension_expression)
;   ; (matrix_expression)
;   ; (vector_expression)

; ] @indent

[
  ; (parameter_list)
  "end"
  "else"
  "elseif"
  "catch"
  "finally"
  ")"
  "]"
  "}"
] @dedent

[
  (line_comment)
  (block_comment)
] @ignore

(argument_list ")" @match
  (#set! indent.matchIndentOf parent.firstChild.startPosition))

(curly_expression "}" @match
  (#set! indent.matchIndentOf parent.firstChild.startPosition))

(vector_expression "]" @match
  (#set! indent.matchIndentOf parent.firstChild.startPosition))
