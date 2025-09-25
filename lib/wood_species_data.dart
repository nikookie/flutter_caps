class WoodSpeciesData {
  static const Map<String, Map<String, dynamic>> woodDatabase = {
    'oak': {
      'name': 'Oak',
      'scientificName': 'Quercus',
      'type': 'Hardwood',
      'density': 'High',
      'hardness': 'Very Hard',
      'durability': 'Excellent',
      'workability': 'Moderate',
      'grain': 'Prominent, open grain',
      'color': 'Light to medium brown',
      'characteristics': [
        'Strong and durable',
        'Prominent grain pattern',
        'Takes stain well',
        'Excellent for furniture',
        'High tannin content'
      ],
      'bestUses': [
        'Furniture making',
        'Flooring',
        'Cabinetry',
        'Construction',
        'Wine barrels'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Excellent'
      },
      'tips': [
        'Pre-drill to prevent splitting',
        'Use sharp tools due to hardness',
        'Apply wood conditioner before staining',
        'Excellent for traditional joinery'
      ],
      'priceRange': 'Medium to High',
      'sustainability': 'Good - widely available'
    },
    
    'pine': {
      'name': 'Pine',
      'scientificName': 'Pinus',
      'type': 'Softwood',
      'density': 'Low to Medium',
      'hardness': 'Soft',
      'durability': 'Moderate',
      'workability': 'Excellent',
      'grain': 'Straight, fine grain',
      'color': 'Pale yellow to light brown',
      'characteristics': [
        'Easy to work with',
        'Lightweight',
        'Resinous',
        'Knots common',
        'Takes paint well'
      ],
      'bestUses': [
        'Construction framing',
        'Furniture (painted)',
        'Crafts and hobbies',
        'Shelving',
        'Outdoor projects (treated)'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Fair',
        'cabinet': 'Good',
        'bookshelf': 'Excellent'
      },
      'tips': [
        'Seal knots before finishing',
        'Use wood conditioner for even staining',
        'Pre-drill near edges to prevent splitting',
        'Great for beginners'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Excellent - fast growing'
    },
    
    'maple': {
      'name': 'Maple',
      'scientificName': 'Acer',
      'type': 'Hardwood',
      'density': 'High',
      'hardness': 'Hard',
      'durability': 'Excellent',
      'workability': 'Good',
      'grain': 'Fine, even grain',
      'color': 'Light cream to pale brown',
      'characteristics': [
        'Very hard and strong',
        'Fine, uniform grain',
        'Takes finish beautifully',
        'Minimal grain pattern',
        'Excellent for detailed work'
      ],
      'bestUses': [
        'Fine furniture',
        'Cabinetry',
        'Flooring',
        'Musical instruments',
        'Cutting boards'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Good'
      },
      'tips': [
        'Use sharp tools to prevent tear-out',
        'Excellent for smooth finishes',
        'Can burn easily - feed slowly',
        'Perfect for painted furniture'
      ],
      'priceRange': 'Medium to High',
      'sustainability': 'Good - sustainable harvesting'
    },
    
    'walnut': {
      'name': 'Walnut',
      'scientificName': 'Juglans',
      'type': 'Hardwood',
      'density': 'Medium to High',
      'hardness': 'Medium Hard',
      'durability': 'Excellent',
      'workability': 'Excellent',
      'grain': 'Straight to wavy grain',
      'color': 'Rich chocolate brown',
      'characteristics': [
        'Beautiful natural color',
        'Premium appearance',
        'Excellent workability',
        'Stable when dried',
        'Takes oil finishes well'
      ],
      'bestUses': [
        'High-end furniture',
        'Gunstocks',
        'Decorative veneers',
        'Cabinetry',
        'Artistic projects'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Good'
      },
      'tips': [
        'Showcase natural grain with clear finishes',
        'Excellent for hand tool work',
        'Premium wood - plan cuts carefully',
        'Perfect for live-edge projects'
      ],
      'priceRange': 'High',
      'sustainability': 'Moderate - slower growing'
    },
    
    'cherry': {
      'name': 'Cherry',
      'scientificName': 'Prunus',
      'type': 'Hardwood',
      'density': 'Medium',
      'hardness': 'Medium Hard',
      'durability': 'Good',
      'workability': 'Excellent',
      'grain': 'Fine, straight grain',
      'color': 'Light pink to rich reddish brown',
      'characteristics': [
        'Ages to rich patina',
        'Fine, smooth grain',
        'Excellent for finishing',
        'Darkens with age and light',
        'Premium furniture wood'
      ],
      'bestUses': [
        'Fine furniture',
        'Cabinetry',
        'Interior trim',
        'Musical instruments',
        'Decorative items'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Good',
        'cabinet': 'Excellent',
        'bookshelf': 'Good'
      },
      'tips': [
        'Allow natural aging for best color',
        'Use gel stains for even color',
        'Excellent for traditional finishes',
        'Avoid over-sanding'
      ],
      'priceRange': 'High',
      'sustainability': 'Good - managed forests'
    },
    
    'cedar': {
      'name': 'Cedar',
      'scientificName': 'Cedrus',
      'type': 'Softwood',
      'density': 'Low',
      'hardness': 'Soft',
      'durability': 'Excellent (outdoor)',
      'workability': 'Good',
      'grain': 'Straight grain',
      'color': 'Light brown to reddish',
      'characteristics': [
        'Natural weather resistance',
        'Pleasant aroma',
        'Insect repellent properties',
        'Lightweight',
        'Naturally rot resistant'
      ],
      'bestUses': [
        'Outdoor furniture',
        'Decking',
        'Siding',
        'Closet lining',
        'Garden projects'
      ],
      'furnitureSuitability': {
        'table': 'Good (outdoor)',
        'chair': 'Good (outdoor)',
        'cabinet': 'Fair',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Perfect for outdoor projects',
        'No treatment needed for weather resistance',
        'Can cause allergic reactions in some people',
        'Pre-drill to prevent splitting'
      ],
      'priceRange': 'Medium',
      'sustainability': 'Excellent - renewable resource'
    },
    
    'birch': {
      'name': 'Birch',
      'scientificName': 'Betula',
      'type': 'Hardwood',
      'density': 'Medium to High',
      'hardness': 'Hard',
      'durability': 'Good',
      'workability': 'Good',
      'grain': 'Fine, even grain',
      'color': 'Light yellow to white',
      'characteristics': [
        'Fine, uniform grain',
        'Takes stain well',
        'Strong and stable',
        'Good for painted finishes',
        'Affordable hardwood'
      ],
      'bestUses': [
        'Plywood',
        'Furniture',
        'Cabinetry',
        'Flooring',
        'Turned objects'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Good',
        'cabinet': 'Excellent',
        'bookshelf': 'Excellent'
      },
      'tips': [
        'Excellent for painted furniture',
        'Use wood conditioner before staining',
        'Good substitute for more expensive hardwoods',
        'Works well with power tools'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Good - fast growing'
    },
    
    'mahogany': {
      'name': 'Mahogany',
      'scientificName': 'Swietenia',
      'type': 'Hardwood',
      'density': 'Medium',
      'hardness': 'Medium Hard',
      'durability': 'Excellent',
      'workability': 'Excellent',
      'grain': 'Straight to interlocked',
      'color': 'Reddish brown',
      'characteristics': [
        'Premium furniture wood',
        'Excellent stability',
        'Beautiful grain patterns',
        'Easy to work',
        'Takes finish beautifully'
      ],
      'bestUses': [
        'High-end furniture',
        'Boat building',
        'Musical instruments',
        'Decorative veneers',
        'Luxury cabinetry'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Good'
      },
      'tips': [
        'Premium wood - plan projects carefully',
        'Excellent for hand tool work',
        'Natural oils provide some protection',
        'Perfect for traditional furniture styles'
      ],
      'priceRange': 'Very High',
      'sustainability': 'Poor - endangered species (use alternatives)'
    },
    
    'teak': {
      'name': 'Teak',
      'scientificName': 'Tectona grandis',
      'type': 'Hardwood',
      'density': 'Medium to High',
      'hardness': 'Hard',
      'durability': 'Excellent',
      'workability': 'Good',
      'grain': 'Straight grain',
      'color': 'Golden brown',
      'characteristics': [
        'Naturally weather resistant',
        'High oil content',
        'Marine grade durability',
        'Dimensional stability',
        'Premium outdoor wood'
      ],
      'bestUses': [
        'Marine applications',
        'Outdoor furniture',
        'Decking',
        'High-end furniture',
        'Architectural elements'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Good',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Perfect for outdoor furniture',
        'Natural oils can interfere with gluing',
        'Use stainless steel fasteners',
        'Very expensive - use wisely'
      ],
      'priceRange': 'Very High',
      'sustainability': 'Poor - use plantation grown only'
    },
    
    'poplar': {
      'name': 'Poplar',
      'scientificName': 'Populus',
      'type': 'Hardwood',
      'density': 'Low to Medium',
      'hardness': 'Soft',
      'durability': 'Fair',
      'workability': 'Excellent',
      'grain': 'Straight, fine grain',
      'color': 'White to light brown',
      'characteristics': [
        'Inexpensive hardwood',
        'Easy to work',
        'Takes paint well',
        'Minimal grain pattern',
        'Good for beginners'
      ],
      'bestUses': [
        'Painted furniture',
        'Interior trim',
        'Utility projects',
        'Practice projects',
        'Secondary wood'
      ],
      'furnitureSuitability': {
        'table': 'Fair',
        'chair': 'Fair',
        'cabinet': 'Good',
        'bookshelf': 'Good'
      },
      'tips': [
        'Best when painted',
        'Use as secondary wood in projects',
        'Inexpensive option for learning',
        'Seal end grain well'
      ],
      'priceRange': 'Low',
      'sustainability': 'Excellent - fast growing'
    }
  };

  static Map<String, dynamic>? getWoodData(String woodType) {
    String normalizedType = woodType.toLowerCase().trim();
    
    // Direct match
    if (woodDatabase.containsKey(normalizedType)) {
      return woodDatabase[normalizedType];
    }
    
    // Partial match
    for (String key in woodDatabase.keys) {
      if (normalizedType.contains(key) || key.contains(normalizedType)) {
        return woodDatabase[key];
      }
    }
    
    return null;
  }

  static List<String> getAllWoodTypes() {
    return woodDatabase.keys.toList();
  }

  static List<String> getWoodsByType(String type) {
    return woodDatabase.entries
        .where((entry) => entry.value['type'].toLowerCase() == type.toLowerCase())
        .map((entry) => entry.key)
        .toList();
  }

  static List<String> getWoodsByUse(String use) {
    return woodDatabase.entries
        .where((entry) => 
            (entry.value['bestUses'] as List<String>)
                .any((woodUse) => woodUse.toLowerCase().contains(use.toLowerCase())))
        .map((entry) => entry.key)
        .toList();
  }

  static String getFurnitureSuitability(String woodType, String furnitureType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['furnitureSuitability'] != null) {
      return woodData['furnitureSuitability'][furnitureType] ?? 'Fair';
    }
    return 'Fair';
  }

  static List<String> getWoodTips(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['tips'] != null) {
      return List<String>.from(woodData['tips']);
    }
    return [
      'Research specific properties of this wood type',
      'Test on scrap pieces before final project',
      'Consider grain direction in your design'
    ];
  }

  static String getWoodDescription(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null) {
      return '${woodData['type']} • ${woodData['durability']} durability • ${woodData['workability']} workability';
    }
    return 'Wood properties being analyzed...';
  }

  static List<String> getBestUses(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['bestUses'] != null) {
      return List<String>.from(woodData['bestUses']);
    }
    return ['General woodworking'];
  }

  static String getPriceRange(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['priceRange'] != null) {
      return woodData['priceRange'];
    }
    return 'Medium';
  }

  static String getSustainability(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['sustainability'] != null) {
      return woodData['sustainability'];
    }
    return 'Check local sustainability practices';
  }

  static List<String> getCharacteristics(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['characteristics'] != null) {
      return List<String>.from(woodData['characteristics']);
    }
    return ['Analyzing wood characteristics...'];
  }
}