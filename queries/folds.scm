
(class_definition body: (declaration_body) @fold)
(struct_definition body: (declaration_body) @fold)
(interface_definition body: (declaration_body) @fold)
(enum_definition body: (enum_body) @fold)
(extend_definition body: (declaration_body) @fold)
(foreign_declaration body: (declaration_body) @fold)

(primary_init) @fold

(block) @fold

(if_expression) @fold
(while_expression) @fold
(do_while_expression) @fold
(for_in_expression) @fold
(match_expression) @fold
(try_expression) @fold

(lambda_expression) @fold
(synchronized_expression) @fold
(unsafe_expression) @fold

(property_definition) @fold

(macro_expression) @fold
(quote_expression) @fold
