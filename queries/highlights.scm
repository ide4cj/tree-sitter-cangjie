; Patterns resolve by ORDER (last matching capture wins); @spell precedes color
; captures on shared nodes — the CLI renderer keeps only the last capture.


(line_comment) @spell @comment
(block_comment) @spell @comment


(string_start) @string
(string_end) @string
(string_content) @spell
(string_content) @string

(escape_sequence) @string.escape


(boolean_literal) @constant.builtin
(integer_literal) @number
(float_literal) @number.float
(rune_literal) @character
(byte_literal) @character


"_" @variable.parameter.builtin

(var_binding_pattern) @variable
(this_super_expression) @variable.builtin
(wildcard_pattern) @variable.builtin


(modifiers) @keyword.modifier


(field_access (identifier) @variable.member)


(parameter parameter_name: (identifier) @variable.parameter)
(named_parameter parameter_name: (identifier) @variable.parameter)
(unnamed_member_parameter parameter_name: (identifier) @variable.parameter)
(lambda_parameter (var_binding_pattern) @variable.parameter)
(property_definition setter: (identifier) @variable.parameter)
(macro_parameter name: (identifier) @variable.parameter)


(postfix_expression
    base: (postfix_expression (identifier) @function.call)
    suffix: (call_suffix))

; ident<T> colors as a type — bare generic calls f<T>(x) too (c_sharp precedent).
(postfix_expression
    base: (postfix_expression (identifier) @type)
    suffix: (type_arguments))

(postfix_expression
    base: (postfix_expression
            suffix: (field_access (identifier) @function.method.call))
    suffix: (call_suffix))

(postfix_expression
    base: (postfix_expression
            suffix: (field_access (identifier) @function.method.call))
    suffix: (type_arguments))

(postfix_expression
    base: (postfix_expression
            base: (postfix_expression
                    suffix: (field_access (identifier) @function.method.call))
            suffix: (type_arguments))
    suffix: (call_suffix))

(postfix_expression
    base: (postfix_expression
            suffix: (scope_resolution (identifier) @function.call))
    suffix: (call_suffix))

(postfix_expression
    base: (postfix_expression
            suffix: (scope_resolution (identifier) @function.call))
    suffix: (type_arguments))

(postfix_expression
    base: (postfix_expression (identifier) @function.call)
    (lambda_expression))

(postfix_expression
    base: (postfix_expression
            suffix: (field_access (identifier) @function.method.call))
    (lambda_expression))


; No global (identifier) capture: child captures paint over the parent's @type in nvim
; regardless of pattern order — type positions are captured explicitly below.

(class_name) @type
(struct_name) @type
(interface_name) @type
(enum_name) @type
(type_alias_name) @type.definition
(func_name) @function
(declaration_body (function_definition (func_name) @function.method))
(enum_body (function_definition (func_name) @function.method))
(main_definition "main" @function)
(macro_name) @function.macro
(property_name) @variable.member

; init is a hard keyword; bare Args() calls stay @function.call (no `new` to disambiguate).
"init" @keyword.function


(return_type type: (_) @type)

(type_name) @type
(type_name (identifier) @type)
(tuple_type type: (_) @type)
(prefix_type type: (_) @type)
(arrow_type type: (_) @type)

(generic_constraint
    (identifier) @type)

(super_or_interface) @type
(extend_type) @type

(feature_id (identifier) @type)

(type_parameter name: (identifier) @type)

; Hard-keyword primitives are @type.builtin (conversions Int64(x) too); soft builtins
; (String, HashMap, ...) are plain identifiers and color as plain @type. Unit's builtin
; highlight marks where a result is intentionally discarded.
[
    (Int8)
    (Int16)
    (Int32)
    (Int64)
    (IntNative)
    (UInt8)
    (UInt16)
    (UInt32)
    (UInt64)
    (UIntNative)
    (Float16)
    (Float32)
    (Float64)
    (Rune)
    (Bool)
    (Unit)
    (Nothing)
    (Thistype)
] @type.builtin

(enum_body enum_constant: (identifier) @constant)
(enum_constructor) @constant

(declaration_body
    (variable_declaration
        name: (variable_name (var_binding_pattern) @variable.member)))

(declaration_body
    (decorated_declaration
        (variable_declaration
            name: (variable_name (var_binding_pattern) @variable.member))))

(variable_declaration
    "const"
    name: (variable_name (var_binding_pattern) @constant))

(decorated_declaration
    (variable_declaration
        "const"
        name: (variable_name (var_binding_pattern) @constant)))

(get_keyword) @keyword
(set_keyword) @keyword

(ellipsis_parameter) @punctuation.delimiter

(const_generic "$" @punctuation.special)

(macro_package_declaration package_name: (scoped_identifier) @module)

(import_list package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)
(package_full package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)
(package_group package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)
(sub_group_of_package package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)
(package_alias package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)
(package_alias alias: (identifier) @module)
(package_declaration package_name: [(scoped_identifier) (identifier) (package_identifier)] @module)


(macro_call_sigil) @function.macro
(macro_input_open) @function.macro
(macro_input_close) @function.macro
(macro_attr_open) @function.macro
(macro_attr_close) @function.macro


[
    "struct"
    "enum"
    "class"
    "interface"
    "type"
] @keyword.type

"func" @keyword.function
"return" @keyword.return

[
    "for"
    "do"
    "while"
    "continue"
    "break"
] @keyword.repeat

[
    "try"
    "catch"
    "finally"
    "throw"
    "handle"
    "with"
    "throwing"
] @keyword.exception

[
    "if"
    "else"
    "match"
    "case"
] @keyword.conditional

[
    "is"
    "as"
    "in"
    "!in"
] @keyword.operator

"import" @keyword.import
"package" @keyword.import
"spawn" @keyword.coroutine

[
    "let"
    "var"
    "const"
    "where"
    "extend"
    "macro"
    "static"
    "operator"
    "foreign"
    "inout"
    "prop"
    "mut"
    "unsafe"
    "synchronized"
    "features"
] @keyword



[
    "**"
    "*"
    "%"
    "/"
    "+"
    "-"
    "&&"
    "||"
    "!"
    "&"
    "|"
    "^"
    "<<"
    ">>"
    "="
    "+="
    "-="
    "*="
    "**="
    "/="
    "%="
    "&="
    "|="
    "^="
    "<<="
    ">>="
    "&&="
    "||="
    "->"
    "<-"
    "=>"
    "..="
    ".."
    "?"
    "??"
    "<:"
    "<"
    ">"
    "<="
    ">="
    "!="
    "=="
    "|>"
    "~>"
    "~"
] @operator

(inc_or_dec) @operator


[
    "("
    ")"
    "["
    "]"
    "{"
    "}"
] @punctuation.bracket

[
    "."
    ","
    ";"
    ":"
    "::"
] @punctuation.delimiter

; (unit_literal) sits AFTER the bracket list and captures the '(' ')' tokens: a parent
; capture loses to the nested token capture in the CLI renderer; same-range wins by order.
(unit_literal
    [
        "("
        ")"
    ] @constant.builtin)

(type_arguments
    [
        "<"
        ">"
    ] @punctuation.delimiter)

(type_parameters
    [
        "<"
        ">"
    ] @punctuation.delimiter)

(enum_body "|" @punctuation.delimiter)
(package_full "*" @punctuation.special)


(quote_raw_token) @markup.raw

(quote_macro_head) @function.macro

(quote_paren) @markup.raw

(quote_expression
    "$" @variable.builtin .
    (identifier) @variable.builtin)


(call_suffix (identifier) @variable.parameter)
(macro_attribute_body (identifier) @variable.parameter)
(macro_call_body (identifier) @variable.parameter)


(interp_open) @punctuation.special
(interp_close) @punctuation.special
(quote_interp_open) @variable.builtin
(quote_interp_close) @variable.builtin


(perform_keyword) @keyword.exception
(resume_keyword) @keyword.exception
(quote_keyword) @keyword
(quote_close) @keyword
