import '../../domain/repositories/i_evidence_repository.dart';
import '../../domain/repositories/i_food_repository.dart';
import '../../domain/repositories/i_glycemic_profile_repository.dart';
import '../../domain/repositories/i_ingredient_repository.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../../domain/repositories/i_source_repository.dart';

class RepositoryContracts {
  final IFoodRepository foodRepository;
  final IGlycemicProfileRepository glycemicProfileRepository;
  final IIngredientRepository ingredientRepository;
  final IProductRepository productRepository;
  final ISourceRepository sourceRepository;
  final IEvidenceRepository evidenceRepository;

  RepositoryContracts({
    required this.foodRepository,
    required this.glycemicProfileRepository,
    required this.ingredientRepository,
    required this.productRepository,
    required this.sourceRepository,
    required this.evidenceRepository,
  });

  Map<String, Object> toMap() => {
        'foodRepository': foodRepository,
        'glycemicProfileRepository': glycemicProfileRepository,
        'ingredientRepository': ingredientRepository,
        'productRepository': productRepository,
        'sourceRepository': sourceRepository,
        'evidenceRepository': evidenceRepository,
      };
}
