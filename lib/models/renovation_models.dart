// lib/models/renovation_models.dart

// Enum untuk kategori material
enum MaterialCategory {
  cat,        // Cacat/Perbaikan
  paint,      // Cat
  tile,       // Ubin
  wood,       // Kayu
  plumbing,   // Pipa/Air
  electric,   // Listrik
  cement,     // Semen/Pengecoran
  labor;      // Tenaga Kerja

  String get label {
    switch (this) {
      case MaterialCategory.cat:
        return 'Pengecatan';
      case MaterialCategory.paint:
        return 'Cat & Finishing';
      case MaterialCategory.tile:
        return 'Ubin & Lantai';
      case MaterialCategory.wood:
        return 'Kayu & Pintu';
      case MaterialCategory.plumbing:
        return 'Pipa & Air';
      case MaterialCategory.electric:
        return 'Listrik';
      case MaterialCategory.cement:
        return 'Semen & Pengecoran';
      case MaterialCategory.labor:
        return 'Tenaga Kerja';
    }
  }
}

// Model untuk item renovasi
class RenovationItem {
  final String id;
  final String name;
  final String description;
  final MaterialCategory category;
  double quantity;
  final String unit; // m2, pcs, kg, pack, jam, dll
  double unitPrice;
  final bool isEssential;

  RenovationItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.isEssential = true,
  });

  double get subtotal => quantity * unitPrice;

  RenovationItem copyWith({
    String? id,
    String? name,
    String? description,
    MaterialCategory? category,
    double? quantity,
    String? unit,
    double? unitPrice,
    bool? isEssential,
  }) {
    return RenovationItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      isEssential: isEssential ?? this.isEssential,
    );
  }
}

// Model untuk rekomendasi harga dari AI
class PriceRecommendation {
  final String itemId;
  final String itemName;
  final double currentPrice;
  final double recommendedPrice;
  final double savingPercentage;
  final String reason;
  final String supplier; // Rekomendasi supplier

  PriceRecommendation({
    required this.itemId,
    required this.itemName,
    required this.currentPrice,
    required this.recommendedPrice,
    required this.savingPercentage,
    required this.reason,
    required this.supplier,
  });
}

// Model untuk breakdown biaya
class CostBreakdown {
  final double essentialCost;
  final double optionalCost;
  final double laborCost;
  final double discountAmount;
  final double tax;
  final double adminFee;

  CostBreakdown({
    required this.essentialCost,
    required this.optionalCost,
    required this.laborCost,
    required this.discountAmount,
    required this.tax,
    required this.adminFee,
  });

  double get subtotal => essentialCost + optionalCost + laborCost;
  double get afterDiscount => subtotal - discountAmount;
  double get afterTax => afterDiscount + tax;
  double get total => afterTax + adminFee;

  double get discountPercentage {
    if (subtotal == 0) return 0;
    return (discountAmount / subtotal) * 100;
  }
}

// Model untuk rekomendasi potongan biaya
class CostCuttingRecommendation {
  final String title;
  final String description;
  final double potentialSaving;
  final String priority; // high, medium, low
  final String category;
  final List<String> suggestions;

  CostCuttingRecommendation({
    required this.title,
    required this.description,
    required this.potentialSaving,
    required this.priority,
    required this.category,
    required this.suggestions,
  });
}

// Model untuk proyek renovasi
class RenovationProject {
  final String id;
  final String projectName;
  final String description;
  final List<RenovationItem> items;
  final List<PriceRecommendation> recommendations;
  final List<CostCuttingRecommendation> costCuttingRecs;
  final CostBreakdown costBreakdown;
  final DateTime createdAt;
  final DateTime updatedAt;

  RenovationProject({
    required this.id,
    required this.projectName,
    required this.description,
    required this.items,
    required this.recommendations,
    required this.costCuttingRecs,
    required this.costBreakdown,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalCost => costBreakdown.total;
  double get essentialCost => costBreakdown.essentialCost;
}