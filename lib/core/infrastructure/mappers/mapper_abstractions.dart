abstract class IMapper<Remote, Domain> {
  Domain toDomain(Remote remote);
  Remote fromDomain(Domain domain);
}

abstract class IJsonMapper<Domain> extends IMapper<Map<String, dynamic>, Domain> {}

abstract class IEntityMapper<Domain> {
  Domain fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(Domain domain);
}
