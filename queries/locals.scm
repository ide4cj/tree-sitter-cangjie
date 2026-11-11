

(source_file) @local.scope
(block) @local.scope
(declaration_body) @local.scope
(function_definition) @local.scope
(operator_function_definition) @local.scope
(macro_definition) @local.scope
(primary_init) @local.scope
(class_definition) @local.scope
(struct_definition) @local.scope
(interface_definition) @local.scope
(enum_definition) @local.scope
(extend_definition) @local.scope

(lambda_expression) @local.scope
(for_in_expression) @local.scope
(while_expression) @local.scope
(do_while_expression) @local.scope
(match_expression) @local.scope
(try_expression) @local.scope
(catch_clause) @local.scope


(variable_declaration
  name: (variable_name) @local.definition)

(parameter
  parameter_name: (identifier) @local.definition)

(named_parameter
  parameter_name: (identifier) @local.definition)

(unnamed_member_parameter
  parameter_name: (identifier) @local.definition)

(macro_parameter
  name: (identifier) @local.definition)

(lambda_parameter
  (var_binding_pattern) @local.definition)

(resource_specification
  (identifier) @local.definition)

(for_in_expression
  (var_binding_pattern) @local.definition)

(catch_clause
  (catch_pattern
    (var_binding_pattern) @local.definition))

(type_parameter
  name: (identifier) @local.definition)


(identifier) @local.reference
