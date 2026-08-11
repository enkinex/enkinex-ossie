import .model.semantic_model

type ApiVersionType = "0.2.0.dev0"

schema OssieDocument:
    """
    Root document for an Apache Ossie semantic model definition file.

    Attributes
    ----------
    version: ApiVersionType, default is "0.2.0.dev0", required.
        Apache Ossie specification version.
    semantic_model: [semantic_model.SemanticModel], default is Undefined, required.
        Collection of semantic model definitions.

    Examples
    --------
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
    """
    version: ApiVersionType = "0.2.0.dev0"
    semantic_model: [semantic_model.SemanticModel]

    check:
        len(version) > 0, "version must not be empty"

