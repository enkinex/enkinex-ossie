import ..common.ai_context
import ..common.enums
import ..common.expression
import ..common.extension

schema Metric:
    """
    Quantitative measure defined on business data, representing key
    calculations like sums, averages, and ratios. Metrics are defined at the
    semantic model level and can span multiple datasets.

    Attributes
    ----------
    name: str, default is Undefined, required.
        Unique identifier for the metric.
    expression: expression.Expression, default is Undefined, required.
        Expression definition with dialect support.
    description: str, default is Undefined, optional.
        Human-readable description of what the metric measures.
    datatype: enums.DataType, default is Undefined, optional.
        Logical data type for this metric.
    ai_context: ai_context.AIContext, default is Undefined, optional.
        Additional context for AI tools (e.g. synonyms).
    custom_extensions: [extension.CustomExtension], default is Undefined, optional.
        Vendor-specific attributes.

    Examples
    --------
    totalRevenue = Metric {
        name = "total_revenue"
        expression = expression.Expression {
            dialects = [expression.DialectExpression { dialect = "ANSI_SQL", expression = "SUM(orders.amount)" }]
        }
        description = "Total revenue across all orders"
        datatype = "Decimal"
        ai_context = { synonyms = ["total sales", "revenue"] }
    }
    """
    name: str
    expression: expression.Expression
    description?: str
    datatype?: enums.DataType
    ai_context?: ai_context.AIContext
    custom_extensions?: [extension.CustomExtension]
