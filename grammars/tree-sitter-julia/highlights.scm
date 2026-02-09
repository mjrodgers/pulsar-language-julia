; NOTES:
;
; (#set! capture.final "true") means that any later rule that matches this exact range
; will be ignored.
;
; (#set! shy "true") means that this rule will be ignored if any previous rule
; has marked this exact range, whether or not it was marked as final.

; TODO: Figure out what to do with
; fix "quote_expression" symbols that aren't simple
; fix PascalCase identifiers...
; operators: = and =>
; field_expression should behave like scoped_identifier
;    both are broken for things like Oscar.Hecke.Something
; function_definition uses field_expression, not scoped_identifier...
; complex where_clause is broken
; function/short_function return_type
; constructors - highlight as types???
; `outer` keyword - bug in tree-sitter
; adjoint/transposes - `'`/`.'` resp. (second no longer valid???)
; builtin types and methods

; -------
; SUPPORT
; -------
; Capture built-ins first and then ignore
((identifier) @support.type.exception.julia
  (#any-of? @support.type.exception.julia
    "ArgumentError" "AssertionError" "BoundsError" "ConcurrencyViolationError" "DivideError" "DomainError" "ErrorException" "Exception" "InexactError" "InitError" "InterruptException" "LoadError" "MethodError" "OutOfMemoryError" "OverflowError" "ReadOnlyMemoryError" "SegmentationFault" "StackOverflowError" "TypeError" "UndefKeywordError" "UndefRefError" "UndefVarError"
    "CanonicalIndexError" "CapturedException" "CompositeException" "DimensionMismatch" "EOFError" "InvalidStateException" "KeyError" "MissingException" "ProcessFailedException" "StringIndexError" "SystemError" "TaskFailedException")
  (#set! capture.final true))

; filter(name -> Base.eval(Core, name) isa Core.Builtin, names(Core))
((identifier) @support.function.builtin.julia
  (#any-of? @support.function.builtin.julia
    "applicable" "fieldtype" "getfield" "getglobal" "invoke" "isa" "isdefined" "modifyfield!" "nfields" "replacefield!" "setfield!" "setglobal!" "swapfield!" "throw" "tuple" "typeassert" "typeof")
  (#set! capture.final true))

; filter(name -> typeof(Base.eval(Core, name)) in [DataType, UnionAll], names(Core))
; filter(name -> typeof(Base.eval(Base, name)) in [DataType, UnionAll], names(Base)) @support.class.builtin
; a scoped module should be excluded here e.g. AbstractAlgebra.Module
; can check that parent != field expression
((identifier) @support.class.builtin
  (#any-of? @support.class.builtin
    "AbstractArray" "AbstractChar" "AbstractFloat" "AbstractString" "Any" "Array" "Bool" "Char" "Cvoid" "DataType" "DenseArray" "Expr" "Float16" "Float32" "Float64" "Function" "GlobalRef" "IO" "Int" "Int128" "Int16" "Int32" "Int64" "Int8" "Integer" "LineNumberNode" "Method" "Module" "NTuple" "NamedTuple" "Nothing" "Number" "Pair" "Ptr" "QuoteNode" "Real" "Ref" "Signed" "String" "Symbol" "Task" "Tuple" "Type" "TypeVar" "UInt" "UInt128" "UInt16" "UInt32" "UInt64" "UInt8" "UndefInitializer" "Union" "UnionAll" "Unsigned" "VecElement" "WeakRef"
    "AbstractChannel" "AbstractDict" "AbstractDisplay" "AbstractIrrational" "AbstractMatch" "AbstractMatrix" "AbstractPattern" "AbstractRange" "AbstractSet" "AbstractSlices" "AbstractUnitRange" "AbstractVecOrMat" "AbstractVector" "Array" "BigFloat" "BigInt" "BitArray" "BitMatrix" "BitSet" "BitVector" "CartesianIndex" "CartesianIndices" "Cchar" "Cdouble" "Cfloat" "Channel" "Cint" "Cintmax_t" "Clong" "Clonglong" "Cmd" "Colon" "ColumnSlices" "Complex" "ComplexF16" "ComplexF32" "ComplexF64" "ComposedFunction" "Condition" "Cptrdiff_t" "Cshort" "Csize_t" "Cssize_t" "Cstring" "Cuchar" "Cuint" "Cuintmax_t" "Culong" "Culonglong" "Cushort" "Cwchar_t" "Cwstring" "DenseMatrix" "DenseVecOrMat" "DenseVector" "Dict" "Dims" "Enum" "ExponentialBackOff" "HTML" "IOBuffer" "IOContext" "IOStream" "IdDict" "IndexCartesian" "IndexLinear" "IndexStyle" "Irrational" "LazyString" "LinRange" "LinearIndices" "MIME" "Matrix" "Missing" "NTuple" "OrdinalRange" "Pair" "PartialQuickSort" "PermutedDimsArray" "Pipe" "Rational" "RawFD" "ReentrantLock" "Regex" "RegexMatch" "Returns" "RoundingMode" "RowSlices" "Set" "Slices" "Some" "StepRange" "StepRangeLen" "StridedArray" "StridedMatrix" "StridedVecOrMat" "StridedVector" "SubArray" "SubString" "SubstitutionString" "Text" "TextDisplay" "Timer" "UnitRange" "Val" "VecOrMat" "Vector" "VersionNumber" "WeakKeyDict")
  (#set! capture.final true))


; -------------------
; MODULES AND IMPORTS
; -------------------

(module_definition
  . ["module" "baremodule"] @storage.type.module.julia
  name: (identifier) @entity.name.type.module.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))
(selected_import
  . (identifier) @support.namespace.julia
  (#set! capture.final true))
(selected_import
  (identifier) @entity.name.function.definition.julia
  (#is-not? test.first)
  (#set! capture.final true))
(selected_import
  ":" @punctuation.separator.import.colon.julia)
(import_statement
  . "import" @keyword.control.import.julia
  (#set! capture.final true))
(import_statement
  (identifier) @support.namespace.julia
  (#set! capture.final true))
(using_statement
  . "using" @keyword.control.import.julia
  (#set! capture.final true))
(using_statement
  (identifier) @support.namespace.julia
  (#set! capture.final true))
(import_alias
  "as" @keyword.operator.other.julia
  (#set! capture.final true))
(export_statement
  . "export" @keyword.control.export.julia
  (#set! capture.final true))
; (scoped_identifier
;   (identifier) @support.namespace.julia
;   (#is? test.descendantOfType import_statement)
;   (#set! capture.final true))
; (scoped_identifier
;   (identifier) @support.namespace.julia
;   (#is? test.descendantOfType using_statement)
;   (#set! capture.final true))
;
; -----
; TYPES
; -----

(abstract_definition
  . "abstract" @storage.modifier.abstract.julia
  "type" @storage.type.class.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))
(primitive_definition
  "primitive" @storage.modifier.primitive.julia
  "type" @storage.type.class.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))
; these are weird -
; they trigger an ERROR until the identifier name is typed,
; and they don't appear in the tree while in the ERROR state.
((ERROR) @storage.modifier.primitive.julia
  (#set! adjust.endAfterFirstMatchOf "^primitive"))
((ERROR) @storage.modifier.abstract.julia
  (#set! adjust.endAfterFirstMatchOf "^abstract"))
((ERROR) @storage.type.type.julia
  (#set! adjust.startAndEndAroundFirstMatchOf "\\btype\\b"))
(struct_definition
  . "mutable" @storage.modifier.mutable.julia
  (#set! capture.final true))
(struct_definition
  "struct" @storage.type.class.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))

; ; TODO - fix this: Type being defined should be highlighted differently
; ; This block works, but maybe highlighting is not what we want...
; ; ((identifier) @entity.name.type.class.julia
; ;   (#is? test.descendantOfType type_head)
; ;   (#set! capture.final true))
; ; ((identifier) @support.storage.type.julia
; ;   (#is? test.descendantOfType type_head)
; ;   (#set! capture.final true))
; ; (parametrized_type_expression
; ;   (identifier) @support.storage.type.julia
; ;   (curly_expression
; ;     (identifier) @support.storage.type.julia))
; ; (typed_expression
; ;   (identifier) @support.storage.type.julia . )
;
;
; ; ; these are complicated now, need to sort it out...
; ; (where_expression
; ;   (identifier) @support.storage.type.julia)
; ; (where_expression
; ;   (curly_expression
; ;     (identifier) @support.storage.type.julia))
;
;
; ; (function_definition
; ;   return_type: (identifier) @support.storage.type.julia)
;
;
; ; ; short_function_definition -> no longer exists
; ; (short_function_definition
; ;   return_type: (identifier) @support.storage.type.julia)
;
;

; FUNCTIONS

; Macros

(macro_definition
  . "macro" @storage.type.macro.julia
  (signature
    (call_expression
      (identifier) @entity.name.function.definition.julia))
  "end" @keyword.control.end.julia .)

(macro_identifier
  "@" @support.other.function.decorator.julia
  (identifier) @support.function.macro.julia)

(quote_statement
  . "quote" @storage.type.expression.julia
  "end" @keyword.control.end.julia .)

(quote_expression
  . ":" @punctuation.definition.symbol.julia)
(quote_expression
  [
    (identifier)
    (operator)
  ] @constant.other.symbol.julia)
(quote_expression
  (parenthesized_expression
    [
      (identifier)
      (operator)
    ] @constant.other.symbol.julia))



; Function definitions:
(function_definition
  . "function" @storage.type.function.julia
  "end" @keyword.control.end.julia .)
(function_definition
  (signature
    (call_expression
        (field_expression
          value: (identifier) @support.namespace.julia)))
  (#set! capture.final true))
(function_definition
  (signature
    (call_expression
      [
        (identifier) @entity.name.function.definition.julia
        (field_expression
          (identifier) @entity.name.function.definition.julia .)
    ]))
  ; prevent constructors (PascalCase) to be highlighted as functions
  (#match? @entity.name.function.definition.julia "^[^A-Z]")
  (#set! capture.final true))
(function_definition
  (signature
    (call_expression
      [
        (identifier) @support.storage.type.julia
        (field_expression
          (identifier) @support.storage.type.julia .)
    ]))
  ; constructors (PascalCase) highlighted differently
  (#set! capture.final true))

;
; ; (scoped_identifier
; ;   (identifier) @support.namespace.julia
; ;   (#is-not? test.lastOfType))
; ; ; ; (scoped_identifier
; ; ; ;     (identifier) @entity.name.function.definition.julia .)
; ; ;
; ; ; (
; ; ;   (short_function_definition
; ; ;     name: [
; ; ;       (identifier) @entity.name.function.definition.julia
; ; ;       (field_expression
; ; ;         (identifier) @entity.name.function.definition.julia .)
; ; ;     ])
; ; ;   ; prevent constructors (PascalCase) to be highlighted as functions
; ; ;   (#match? @entity.name.function.definition.julia "^[^A-Z]")
; ; ;   (#set! capture.final true))
; ; ; (
; ; ;   (short_function_definition
; ; ;     name: [
; ; ;       (identifier) @support.storage.type.julia
; ; ;       (field_expression
; ; ;         ; (identifier) @support.namespace.julia
; ; ;         (identifier) @support.storage.type.julia .)
; ; ;     ])
; ; ;   )
; ; ;
; ; ;
; ; ; (parameter_list
; ; ;   (identifier) @variable.parameter.julia)
; ; ;
; ; ; (typed_parameter
; ; ;   parameter: (identifier) @variable.parameter.julia
; ; ;   type: (_)? @support.storage.type.julia)
; ; ;
; ; ; (optional_parameter
; ; ;   . (identifier) @variable.parameter.julia)
; ; ;
; ; ; (slurp_parameter
; ; ;   (identifier) @variable.parameter.julia)
; ; ;
; ; ; (function_expression
; ; ;   . (identifier) @variable.parameter.julia)

; Function calls:

(
  (call_expression
    [
      (identifier) @support.other.function.julia
      (field_expression
        (identifier) @support.other.function.julia .)
    ])
  ; prevent constructors (PascalCase) to be highlighted as functions
  (#match? @support.other.function.julia "^[^A-Z]")
  (#set! capture.final true))
(
  (call_expression
    [
      (identifier) @support.storage.type.julia
      (field_expression
        (identifier) @support.storage.type.julia .)
    ])
  )

; ; ; (
; ; ;   (broadcast_call_expression
; ; ;     [
; ; ;       (identifier) @support.other.function.julia
; ; ;       (field_expression
; ; ;         (identifier) @support.other.function.julia .)
; ; ;     ])
; ; ;   ; prevent constructors (PascalCase) to be highlighted as functions
; ; ;   (#match? @support.other.function.julia "^[^A-Z]")
; ; ;   (#set! capture.final true))
; ; ; (
; ; ;   (broadcast_call_expression
; ; ;     [
; ; ;       (identifier) @support.storage.type.julia
; ; ;       (field_expression
; ; ;         (identifier) @support.storage.type.julia .)
; ; ;     ])
; ; ;   )



; COMMENTS

((line_comment) @comment.line.number-sign.julia)

((line_comment) @punctuation.definition.comment.julia
  (#match? @punctuation.definition.comment.julia "^#")
  (#set! adjust.startAndEndAroundFirstMatchOf "^#"))


; ; ; ; STRINGS
; ; ;
; ; ; ; NUMBERS
; ; ;
; CONSTANTS

((identifier) @constant.language.julia
  (#match? @constant.language.julia "^(nothing|missing|undef)$"))

((boolean_literal) @constant.language.boolean.julia)
((integer_literal) @constant.numeric.decimal.integer.julia)
((float_literal) @constant.numeric.decimal.float.julia)

((identifier) @constant.numeric.decimal.float.julia
  (#eq? @constant.numeric.decimal.float.julia "^((Inf|NaN)(16|32|64)?)$"))

(character_literal) @constant.character.julia
(escape_sequence) @constant.character.escape.julia
; Fix for embedded things? maybe check if it is a descendent of interpolation
(string_interpolation
  (identifier) @meta.embedded.line.julia)


; KEYWORDS

((identifier) @variable.language.julia
  (#any-of? @variable.language.julia "begin" "end")
  (#has-ancestor? @variable.language.julia range_expression)
  (#set! capture.final true))

((identifier) @variable.language.julia
  (#any-of? @variable.language.julia "begin" "end")
  (#has-ancestor? @variable.language.julia index_expression)
  (#set! capture.final true))


(compound_statement
  . "begin" @keyword.control.begin.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))

(let_statement
  . "let" @keyword.control.let.julia
  "end" @keyword.control.end.julia .
  (#set! capture.final true))

(if_statement
  . "if" @keyword.control.conditional._TYPE_.julia
  "end" @keyword.control.end.julia .)
(if_clause
  . "if" @keyword.control.conditional._TYPE_.julia)
(elseif_clause
  "elseif" @keyword.control.conditional._TYPE_.julia)
(else_clause
  "else" @keyword.control.conditional._TYPE_.julia)

(ternary_expression
  ["?" ":"] @keyword.operator.conditional.ternary.julia)

(for_statement
  . "for" @keyword.control.loop._TYPE_.julia
  "end" @keyword.control.end.julia .)
(for_binding
  (operator) @keyword.control.repeat.in.julia)
(for_clause
  "for" @keyword.control.repeat.for.julia)
(while_statement
  . "while" @keyword.control.loop._TYPE_.julia
  "end" @keyword.control.end.julia .)

(break_statement) @keyword.control.flow._TYPE_.julia
(continue_statement) @keyword.control.flow._TYPE_.julia
(return_statement
  . "return" @keyword.control.flow._TYPE_.julia)
; ; ;
; ; ; (try_statement
; ; ; ;   . "try" @keyword.control.exception._TYPE_.julia
; ; ;   "end" @keyword.control.end.julia .)
; ; ; ; (finally_clause
; ; ; ;   "finally" @keyword.control.exception._TYPE_.julia)
; ; ; ; (catch_clause
; ; ; ;   "catch" @keyword.control.exception._TYPE_.julia)
; ; ;
; ; ;
; ; ; (do_clause
; ; ; ;   . "do" @keyword.control.do.julia
; ; ;   "end" @keyword.control.end.julia .)
; ; ;
(const_statement
  . "const" @storage.type.constant.julia)
(local_statement
  . "local" @storage.type.local.julia)
(global_statement
  . "global" @storage.type.global.julia)


; ; ; ( ("begin") @keyword.control._TYPE_.julia
; ; ;   (#set! capture.shy true))
; ; ;
; ; ; [
; ; ;   "let"
; ; ;   "do"
; ; ; ] @keyword.control._TYPE_.julia
;
; ("where") @keyword.other.julia
;
; ; ; [
; ; ;   "if"
; ; ;   "else"
; ; ;   "elseif"
; ; ; ] @keyword.control.conditional._TYPE_.julia
; ; ;
; ; ; [
; ; ;   "for"
; ; ;   "in"
; ; ;   "while"
; ; ; ] @keyword.control.loop._TYPE_.julia
; ; ;
; ; ; [
; ; ;   "try"
; ; ;   "catch"
; ; ;   "finally"
; ; ; ] @keyword.control.exception._TYPE_.julia
; ; ;
; ; ; [
; ; ;   "function"
; ; ;   "macro"
; ; ;   ] @storage.type._TYPE_.julia
; ; ;
; ((identifier) @invalid.illegal.end.julia
;   (#eq? @invalid.illegal.end.julia "end")
;   (#set! capture.shy true))

; ---------
; OPERATORS
; ---------

(splat_expression
  ("...") @keyword.operator.splat.julia)

((operator) @keyword.operator.assignment.julia
  (#eq? @keyword.operator.assignment.julia "=")
  (#set! capture.final true)
)

((operator) @keyword.operator.assignment.compound.julia
  (#any-of? @keyword.operator.assignment.compound.julia "+=" "-=" "*=" "/=" "//=" "\\=" "%=" "^=" "&=" "|=" ">>>=" ">>=" "<<=")
  (#set! capture.final true)
)

((unary_expression
  (operator) @keyword.operator.unary.julia)
  (#any-of? @keyword.operator.unary.julia "+" "-")
  (#set! capture.final true)
)

( (binary_expression
  (operator) @keyword.operator.arithmetic.julia)
  (#any-of? @keyword.operator.arithmetic.julia "+" "-" "*" "/" "\\" "^" "%" "÷")
  (#set! capture.final true)
)

((operator) @keyword.operator.logical.julia
  (#any-of? @keyword.operator.logical.julia "||" "&&" "!")
  (#set! capture.final true)
)

((operator) @keyword.operator.bitwise.julia
  (#any-of? @keyword.operator.bitwise.julia "~" "&" "|" ">>>" ">>" "<<" "⊻" "⊼" "⊽")
  (#set! capture.final true)
)

((operator) @keyword.operator.comparison.julia
  (#any-of? @keyword.operator.comparison.julia "==" "!=" "≠" "<" "<=" "≤" ">" ">=" "≥" "===" "!==")
  (#set! capture.final true)
)

(field_expression
  (".") @keyword.operator.accessor.julia)


[
  (operator)
  "::"
  ":"
  "->"
  "$"
] @keyword.operator.julia

; ; These are broken??? but maybe classified as "operator"
; ; [
; ;   "<:"
; ;   "=>"
; ; ] @keyword.operator.julia


; -----------
; PUNCTUATION
; -----------


"," @punctuation.separator.list.julia
; some semicolons are terminators, and others are separators...
; ";" @punctuation.terminator.statement.julia


"{" @punctuation.definition.begin.bracket.curly.julia
"}" @punctuation.definition.end.bracket.curly.julia
"(" @punctuation.definition.begin.bracket.round.julia
")" @punctuation.definition.end.bracket.round.julia
"[" @punctuation.definition.begin.bracket.square.julia
"]" @punctuation.definition.end.bracket.square.julia


; ; ----------
; ; Primitives
; ; ----------

(string_literal) @string.quoted.julia

; we probably want some different ones depending on the prefix
; eg regex, interpolated
(prefixed_string_literal
  prefix: (identifier) @keyword.support.builtin.julia
  ) @string.quoted.other.julia

; ; ; ; ; ---------------------
; ; ; ; ; Remaining identifiers
; ; ; ; ; ---------------------
; ; ; ;
; ; ; ; (const_statement
; ; ; ;   (variable_declaration
; ; ; ;     . (identifier) @constant))
; ; ; ;
; ; ; ; ; SCREAMING_SNAKE_CASE
; ; ; ; (
; ; ; ;   (identifier) @constant
; ; ; ;   (match? @constant "^[A-Z][A-Z0-9_]*$"))
; ; ; ;
; ; ;
; ; ; ;
; ; ; ; ; Field expressions are either module content or struct fields.
; ; ; ; ; Module types and constants should already be captured, so this
; ; ; ; ; assumes the remaining identifiers to be struct fields.
; ; ; ; TODO : some field expressions are accessing struct fields...
; ; ; (field_expression
; ; ;   value: (identifier) @support.namespace.julia
; ; ;   (#set! capture.shy true)
; ; ; )
; ; ; ;
; ; ; ; (identifier) @variable
