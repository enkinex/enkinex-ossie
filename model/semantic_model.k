import ..catalog.dataset
import ..catalog.relationship
import ..common.ai_context
import ..common.extension
import ..metric.metric

schema SemanticModel:
    """
    Top-level container representing a complete semantic model, including
    datasets, relationships, and metrics.

    Attributes
    ----------
    name: str, default is Undefined, required.
        Unique identifier for the semantic model.
    description: str, default is Undefined, optional.
        Human-readable description.
    ai_context: ai_context.AIContext, default is Undefined, optional.
        Additional context for AI tools (e.g. custom instructions).
    datasets: [dataset.Dataset], default is Undefined, required.
        Collection of logical datasets (fact and dimension tables), at least
        one. Dataset names must be unique within the model.
    relationships: [relationship.Relationship], default is Undefined, optional.
        Defines how logical datasets are connected. Relationship names must
        be unique within the model.
    metrics: [metric.Metric], default is Undefined, optional.
        Quantifiable measures defined as aggregate expressions on fields from
        logical datasets. Metric names must be unique within the model.
    custom_extensions: [extension.CustomExtension], default is Undefined, optional.
        Vendor-specific attributes for extensibility.

    Examples
    --------
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
    """
    name: str
    description?: str
    ai_context?: ai_context.AIContext
    datasets: [dataset.Dataset]
    relationships?: [relationship.Relationship]
    metrics?: [metric.Metric]
    custom_extensions?: [extension.CustomExtension]

    check:
        len(datasets) > 0, "datasets must contain at least one entry"
        len(datasets) == len({d.name: True for d in datasets}), "dataset names must be unique within the semantic model"
        relationships == Undefined or len(relationships) == len({r.name: True for r in relationships}), "relationship names must be unique within the semantic model"
        metrics == Undefined or len(metrics) == len({m.name: True for m in metrics}), "metric names must be unique within the semantic model"

