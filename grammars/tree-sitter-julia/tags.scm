(function_definition
  (signature) @name
  ) @definition.function

(assignment
  . (call_expression) @name
  ) @definition.function

(macro_definition
  (signature) @name) @definition.macro

(module_definition
  name: (identifier) @name) @definition.module

(struct_definition
  (type_head) @name) @definition.struct
