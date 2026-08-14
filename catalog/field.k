import ..common.ai_context
import ..common.enums
import ..common.expression
import ..common.extension

schema Dimension:
    """
    Dimension metadata attached to a field.

    Attributes
    ----------
    is_time: bool, default is Undefined, optional.
        Temporal-role marker. When true, consumers that distinguish time
        dimensions (e.g. for time-series analysis or temporal filtering)
        should treat this field as a time dimension. This is a role flag,
        independent of the field's `datatype`: a field with `is_time: true`
        may carry any datatype (e.g. "Integer" for a year grain, "String" for
        a month name, as well as a temporal datatype).
        When `is_time` is unset, the effective value defaults to true if the
        field's `datatype` is one of "Date", "Time", "DateTime", "DateTimeTz",
        and false otherwise — see `temporal.isTimeEffective`. Set
        `is_time: false` explicitly to opt a temporal-typed column (such as
        an audit timestamp) out of time-dimension treatment.
    """
    is_time?: bool

schema Field:
    """
    Row-level attribute for grouping, filtering, and metric expressions. Can
    be a simple column reference or a computed expression.

    Attributes
    ----------
    name: str, default is Undefined, required.
        Unique identifier for the field within the dataset.
    expression: expression.Expression, default is Undefined, required.
        Expression definition with dialect support.
    dimension: Dimension, default is Undefined, optional.
        Dimension metadata (e.g. the `is_time` flag).
    label: str, default is Undefined, optional.
        Label for categorization.
    description: str, default is Undefined, optional.
        Human-readable description.
    datatype: enums.DataType, default is Undefined, optional.
        Logical data type for this field, independent of role. Omit when the
        type is unknown or unspecified.
    ai_context: ai_context.AIContext, default is Undefined, optional.
        Additional context for AI tools (e.g. synonyms).
    custom_extensions: [extension.CustomExtension], default is Undefined, optional.
        Vendor-specific attributes.

    Examples
    --------
    timeDimension = Field {
        name = "order_date"
        expression = expression.Expression {
            dialects = [expression.DialectExpression { dialect = "ANSI_SQL", expression = "order_date" }]
        }
        datatype = "Date"
        dimension = Dimension { is_time = True }
        description = "Date when order was placed"
    }
    """
    name: str
    expression: expression.Expression
    dimension?: Dimension
    label?: str
    description?: str
    datatype?: enums.DataType
    ai_context?: ai_context.AIContext
    custom_extensions?: [extension.CustomExtension]
