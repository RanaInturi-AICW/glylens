import 'package:equatable/equatable.dart';

import '../identifiers/entity_id.dart';

/// Base for domain entities identified by a stable [EntityId].
abstract base class Entity extends Equatable {
  const Entity(this.id);

  final EntityId id;

  @override
  List<Object?> get props => [id];
}
