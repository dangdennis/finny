package api.models

case class Institution(
    countryCodes: List[String],
    dtcNumbers: List[String],
    institutionId: String,
    name: String,
    oauth: Boolean,
    products: List[String],
    routingNumbers: List[String],
    logo: Option[String],
    primaryColor: Option[String],
    url: Option[String]
)
