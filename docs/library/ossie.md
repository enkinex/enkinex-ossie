# enkinex-ossie

## Index

- [OssieDocument](#ossiedocument)
- catalog
  - [Dataset](#dataset)
  - [Dimension](#dimension)
  - [Field](#field)
  - [Relationship](#relationship)
- common
  - [AIContextObject](#aicontextobject)
  - [CustomExtension](#customextension)
  - [DialectExpression](#dialectexpression)
  - [Expression](#expression)
- metric
  - [Metric](#metric)
- model
  - [SemanticModel](#semanticmodel)

## Schemas

### OssieDocument

Root document for an Apache Ossie semantic model definition file.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**semantic_model** `required`|[[SemanticModel](#semanticmodel)]|Collection of semantic model definitions.||
|**version** `required` `readOnly`|"0.2.0.dev0"|Apache Ossie specification version.|"0.2.0.dev0"|
#### Examples

```
doc = OssieDocument {
    version = "0.2.0.dev0"
    semantic_model = [
        semantic_model.SemanticModel {
            name = "sales_analytics"
            datasets = [
                { name = "orders", source = "sales.public.orders" }
            ]
        }
    ]
}
```

### Dataset

Logical dataset representing a business entity or concept (a fact or dimension table). Contains fields and defines the structure of the data.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**ai_context**|str \| [AIContextObject](#aicontextobject) \| {str:}|Additional context for AI tools (e.g. synonyms, common terms).||
|**custom_extensions**|[[CustomExtension](#customextension)]|Vendor-specific attributes.||
|**description**|str|Human-readable description.||
|**fields**|[[Field](#field)]|Row-level attributes for grouping, filtering, and metric expressions.<br />Field names must be unique within the dataset.||
|**name** `required`|str|Unique identifier for the dataset.||
|**primary_key**|[str]|Primary key columns that uniquely identify rows (single or composite).<br />Examples: ["customer_id"], ["order_id", "line_number"].||
|**source** `required`|str|Reference to the underlying physical table/view (e.g.<br />"database.schema.table") or query.||
|**unique_keys**|[[str]]|Array of unique key definitions; each entry can be single or<br />composite. Example: [["email"], ["first_name", "last_name"]].||
#### Examples

```
orders = Dataset {
    name = "orders"
    source = "sales.public.orders"
    primary_key = ["order_id"]
    unique_keys = [["order_id"], ["order_number"]]
    description = "Order transactions"
    ai_context = { synonyms = ["purchases", "sales"] }
    fields = []
}
```

### Dimension

Dimension metadata attached to a field.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**is_time**|bool|Temporal-role marker. When true, consumers that distinguish time<br />dimensions (e.g. for time-series analysis or temporal filtering)<br />should treat this field as a time dimension. This is a role flag,<br />independent of the field&#39;s `datatype`: a field with `is_time: true`<br />may carry any datatype (e.g. "Integer" for a year grain, "String" for<br />a month name, as well as a temporal datatype).<br />When `is_time` is unset, the effective value defaults to true if the<br />field&#39;s `datatype` is one of "Date", "Time", "DateTime", "DateTimeTz",<br />and false otherwise — see `temporal.isTimeEffective`. Set<br />`is_time: false` explicitly to opt a temporal-typed column (such as<br />an audit timestamp) out of time-dimension treatment.||
### Field

Row-level attribute for grouping, filtering, and metric expressions. Can be a simple column reference or a computed expression.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**ai_context**|str \| [AIContextObject](#aicontextobject) \| {str:}|Additional context for AI tools (e.g. synonyms).||
|**custom_extensions**|[[CustomExtension](#customextension)]|Vendor-specific attributes.||
|**datatype**|"String" \| "Integer" \| "Decimal" \| "Float" \| "Boolean" \| "Date" \| "Time" \| "DateTime" \| "DateTimeTz" \| "Opaque"|Logical data type for this field, independent of role. Omit when the<br />type is unknown or unspecified.||
|**description**|str|Human-readable description.||
|**dimension**|[Dimension](#dimension)|Dimension metadata (e.g. the `is_time` flag).||
|**expression** `required`|[Expression](#expression)|Expression definition with dialect support.||
|**label**|str|Label for categorization.||
|**name** `required`|str|Unique identifier for the field within the dataset.||
#### Examples

```
timeDimension = Field {
    name = "order_date"
    expression = expression.Expression {
        dialects = [expression.DialectExpression { dialect = "ANSI_SQL", expression = "order_date" }]
    }
    datatype = "Date"
    dimension = Dimension { is_time = True }
    description = "Date when order was placed"
}
```

### Relationship

Foreign key relationship between two logical datasets, supporting simple and composite keys. The order of columns in `from_columns` must correspond to the order in `to_columns`; both arrays must have the same length.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**ai_context**|str \| [AIContextObject](#aicontextobject) \| {str:}|Additional context for AI tools.||
|**custom_extensions**|[[CustomExtension](#customextension)]|Vendor-specific attributes.||
|**from** `required`|str|The logical dataset on the many side of the relationship.||
|**from_columns** `required`|[str]|Foreign key columns in the "from" dataset, at least one.||
|**name** `required`|str|Unique identifier for the relationship.||
|**to** `required`|str|The logical dataset on the one side of the relationship.||
|**to_columns** `required`|[str]|Primary or unique key columns in the "to" dataset, at least one, same<br />length and order as `from_columns`.||
#### Examples

```
simple = Relationship {
    name = "orders_to_customers"
    from = "orders"
    to = "customers"
    from_columns = ["customer_id"]
    to_columns = ["id"]
}

composite = Relationship {
    # order_lines.product_id = products.id AND order_lines.variant_id = products.variant_id
    name = "order_lines_to_products"
    from = "order_lines"
    to = "products"
    from_columns = ["product_id", "variant_id"]
    to_columns = ["id", "variant_id"]
}
```

### AIContextObject

Structured additional context for AI tools.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**examples**|[str]|Sample questions or use cases.<br />||
|**instructions**|str|Instructions for AI on how to use this entity.||
|**synonyms**|[str]|Alternative names and terms.||
|**[index]**|str: any|||
### CustomExtension

Vendor-specific attributes for extensibility, without breaking core compatibility.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**data** `required`|str|JSON string containing vendor-specific data.||
|**vendor_name** `required`|str|Free-form string identifying the vendor. Well-known values include<br />"COMMON", "SNOWFLAKE", "SALESFORCE", "DBT", "DATABRICKS", "GOODDATA",<br />"WISDOM"; any string value is accepted.||
#### Examples

```
snowflakeExtension = CustomExtension {
    vendor_name = "SNOWFLAKE"
    data = '{"warehouse": "ANALYTICS_WH"}'
}
```

### DialectExpression

A scalar expression rendered in one specific dialect.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**dialect** `required`|"ANSI_SQL" \| "SNOWFLAKE" \| "MDX" \| "TABLEAU" \| "DATABRICKS" \| "MAQL" \| "BIGQUERY"|The SQL or expression language dialect this expression is written in.||
|**expression** `required`|str|Scalar expression in the given dialect (no aggregations). Can be a simple<br />column reference (e.g. "customer_id") or a computed expression<br />(e.g. "first_name \|\| &#39; &#39; \|\| last_name").||
#### Examples

```
ansiSql = DialectExpression {
    dialect = "ANSI_SQL"
    expression = "customer_id"
}
```

### Expression

Expression definition with multi-dialect support, attached to a field or metric.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**dialects** `required`|[[DialectExpression](#dialectexpression)]|At least one dialect-specific rendering of the expression. Multiple<br />dialect versions can be provided for the same field or metric, but each<br />dialect may appear at most once.||
#### Examples

```
multiDialect = Expression {
    dialects = [
        DialectExpression { dialect = "ANSI_SQL", expression = "LOWER(email)" }
        DialectExpression { dialect = "SNOWFLAKE", expression = "LOWER(email)::VARCHAR" }
    ]
}
```

### Metric

Quantitative measure defined on business data, representing key calculations like sums, averages, and ratios. Metrics are defined at the semantic model level and can span multiple datasets.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**ai_context**|str \| [AIContextObject](#aicontextobject) \| {str:}|Additional context for AI tools (e.g. synonyms).||
|**custom_extensions**|[[CustomExtension](#customextension)]|Vendor-specific attributes.||
|**datatype**|"String" \| "Integer" \| "Decimal" \| "Float" \| "Boolean" \| "Date" \| "Time" \| "DateTime" \| "DateTimeTz" \| "Opaque"|Logical data type for this metric.||
|**description**|str|Human-readable description of what the metric measures.||
|**expression** `required`|[Expression](#expression)|Expression definition with dialect support.||
|**name** `required`|str|Unique identifier for the metric.||
#### Examples

```
totalRevenue = Metric {
    name = "total_revenue"
    expression = expression.Expression {
        dialects = [expression.DialectExpression { dialect = "ANSI_SQL", expression = "SUM(orders.amount)" }]
    }
    description = "Total revenue across all orders"
    datatype = "Decimal"
    ai_context = { synonyms = ["total sales", "revenue"] }
}
```

### SemanticModel

Top-level container representing a complete semantic model, including datasets, relationships, and metrics.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**ai_context**|str \| [AIContextObject](#aicontextobject) \| {str:}|Additional context for AI tools (e.g. custom instructions).||
|**custom_extensions**|[[CustomExtension](#customextension)]|Vendor-specific attributes for extensibility.||
|**datasets** `required`|[[Dataset](#dataset)]|Collection of logical datasets (fact and dimension tables), at least<br />one. Dataset names must be unique within the model.||
|**description**|str|Human-readable description.||
|**metrics**|[[Metric](#metric)]|Quantifiable measures defined as aggregate expressions on fields from<br />logical datasets. Metric names must be unique within the model.||
|**name** `required`|str|Unique identifier for the semantic model.||
|**relationships**|[[Relationship](#relationship)]|Defines how logical datasets are connected. Relationship names must<br />be unique within the model.||
#### Examples

```
salesAnalytics = SemanticModel {
    name = "sales_analytics"
    description = "Sales and customer analytics model"
    ai_context = { instructions = "Use this model for sales analysis and customer insights" }
    datasets = [
        dataset.Dataset { name = "orders", source = "sales.public.orders" }
    ]
    relationships = []
    metrics = []
}
```

<!-- Auto generated by kcl-doc tool, please do not edit. -->
