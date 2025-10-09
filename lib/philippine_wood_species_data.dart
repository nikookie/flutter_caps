/// Philippine Wood Species Database
/// Contains detailed information about Philippine native and common tree species
/// Focus on bark/wood identification and furniture-making properties

class PhilippineWoodSpeciesData {
  static const Map<String, Map<String, dynamic>> woodDatabase = {
    // PHILIPPINE NATIVE HARDWOODS (Premium)
    
    'narra': {
      'name': 'Narra',
      'scientificName': 'Pterocarpus indicus',
      'type': 'Hardwood',
      'origin': 'Native',
      'status': 'National Tree of the Philippines',
      'density': 'High',
      'hardness': 'Hard',
      'durability': 'Excellent',
      'workability': 'Good',
      'grain': 'Interlocked, medium to coarse texture',
      'color': 'Golden yellow to deep reddish-brown',
      'barkDescription': 'Grayish-brown, rough with vertical fissures',
      'characteristics': [
        'National tree of the Philippines',
        'Beautiful reddish color',
        'Excellent for fine furniture',
        'Highly valued and protected',
        'Natural luster when polished',
        'Resistant to termites'
      ],
      'bestUses': [
        'High-end furniture',
        'Cabinetry',
        'Musical instruments',
        'Decorative veneers',
        'Interior finishing',
        'Boat building'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Excellent'
      },
      'tips': [
        'Protected species - use only from legal sources',
        'Pre-drill to prevent splitting',
        'Takes oil finishes beautifully',
        'Showcase natural grain with clear finishes',
        'Premium wood - plan cuts carefully'
      ],
      'priceRange': 'Very High',
      'sustainability': 'Protected - plantation grown only',
      'localNames': ['Narra', 'Asana', 'Angsana']
    },
    
    'molave': {
      'name': 'Molave',
      'scientificName': 'Vitex parviflora',
      'type': 'Hardwood',
      'origin': 'Native',
      'status': 'Endangered',
      'density': 'Very High',
      'hardness': 'Very Hard',
      'durability': 'Excellent',
      'workability': 'Difficult',
      'grain': 'Interlocked, fine to medium texture',
      'color': 'Yellowish to greenish-brown',
      'barkDescription': 'Gray to brown, rough with shallow fissures',
      'characteristics': [
        'One of the hardest Philippine woods',
        'Extremely durable',
        'Resistant to decay and termites',
        'Heavy and strong',
        'Difficult to work but holds shape well'
      ],
      'bestUses': [
        'Heavy construction',
        'Posts and beams',
        'Marine construction',
        'Railroad ties',
        'Heavy-duty furniture',
        'Flooring'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Good',
        'cabinet': 'Good',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Use carbide-tipped tools',
        'Pre-drill all holes',
        'Difficult to nail - use screws',
        'Excellent for outdoor use',
        'Protected species - verify legal source'
      ],
      'priceRange': 'Very High',
      'sustainability': 'Endangered - use alternatives when possible',
      'localNames': ['Molave', 'Tugas', 'Balogo']
    },
    
    'yakal': {
      'name': 'Yakal',
      'scientificName': 'Shorea astylosa',
      'type': 'Hardwood',
      'origin': 'Native',
      'status': 'Vulnerable',
      'density': 'Very High',
      'hardness': 'Extremely Hard',
      'durability': 'Excellent',
      'workability': 'Very Difficult',
      'grain': 'Interlocked, coarse texture',
      'color': 'Light brown to reddish-brown',
      'barkDescription': 'Dark brown, deeply fissured with scaly plates',
      'characteristics': [
        'Extremely hard and heavy',
        'One of the strongest Philippine woods',
        'Excellent for heavy construction',
        'Very resistant to decay',
        'Difficult to work with hand tools'
      ],
      'bestUses': [
        'Heavy construction',
        'Bridge building',
        'Marine piling',
        'Industrial flooring',
        'Heavy machinery bases',
        'Structural beams'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Fair',
        'cabinet': 'Fair',
        'bookshelf': 'Poor'
      },
      'tips': [
        'Requires power tools with sharp blades',
        'Pre-drill all fastener holes',
        'Excellent for structural applications',
        'Not recommended for beginners',
        'Use for projects requiring maximum strength'
      ],
      'priceRange': 'Very High',
      'sustainability': 'Vulnerable - limited availability',
      'localNames': ['Yakal', 'Yakal-saplungan']
    },
    
    'kamagong': {
      'name': 'Kamagong',
      'scientificName': 'Diospyros blancoi',
      'type': 'Hardwood',
      'origin': 'Native',
      'status': 'Endangered',
      'density': 'Very High',
      'hardness': 'Extremely Hard',
      'durability': 'Excellent',
      'workability': 'Difficult',
      'grain': 'Fine, even texture',
      'color': 'Dark brown to black (ebony-like)',
      'barkDescription': 'Dark gray to black, rough with irregular fissures',
      'characteristics': [
        'Philippine ebony',
        'Very dark, almost black wood',
        'Extremely dense and heavy',
        'Beautiful when polished',
        'Highly prized for decorative work'
      ],
      'bestUses': [
        'Fine furniture',
        'Musical instruments',
        'Decorative items',
        'Carvings',
        'Inlay work',
        'Luxury items'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Good',
        'cabinet': 'Excellent',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Premium wood - use for special projects',
        'Takes high polish beautifully',
        'Use sharp tools to prevent tear-out',
        'Excellent for decorative accents',
        'Very expensive and rare'
      ],
      'priceRange': 'Extremely High',
      'sustainability': 'Endangered - very limited availability',
      'localNames': ['Kamagong', 'Mabolo', 'Bolongeta']
    },
    
    'ipil': {
      'name': 'Ipil',
      'scientificName': 'Intsia bijuga',
      'type': 'Hardwood',
      'origin': 'Native',
      'status': 'Vulnerable',
      'density': 'High',
      'hardness': 'Very Hard',
      'durability': 'Excellent',
      'workability': 'Moderate',
      'grain': 'Interlocked, coarse texture',
      'color': 'Yellowish-brown to dark brown',
      'barkDescription': 'Gray-brown, rough with vertical ridges',
      'characteristics': [
        'Excellent for marine use',
        'Very durable and strong',
        'Resistant to marine borers',
        'Good dimensional stability',
        'Natural oils provide protection'
      ],
      'bestUses': [
        'Marine construction',
        'Boat building',
        'Heavy construction',
        'Flooring',
        'Outdoor furniture',
        'Decking'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Good',
        'cabinet': 'Good',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Excellent for outdoor projects',
        'Pre-drill for nailing',
        'Natural oils can affect gluing',
        'Use stainless steel fasteners',
        'Good alternative to teak'
      ],
      'priceRange': 'High',
      'sustainability': 'Vulnerable - use sustainably sourced',
      'localNames': ['Ipil', 'Merbau', 'Kwila']
    },
    
    // PLANTATION & COMMON SPECIES
    
    'acacia': {
      'name': 'Acacia',
      'scientificName': 'Acacia mangium',
      'type': 'Hardwood',
      'origin': 'Introduced (widely planted)',
      'status': 'Common',
      'density': 'Medium',
      'hardness': 'Medium Hard',
      'durability': 'Good',
      'workability': 'Good',
      'grain': 'Interlocked, medium texture',
      'color': 'Light brown to golden brown',
      'barkDescription': 'Gray-brown, relatively smooth with shallow fissures',
      'characteristics': [
        'Fast-growing plantation species',
        'Widely available',
        'Good for furniture',
        'Affordable hardwood',
        'Easy to work with'
      ],
      'bestUses': [
        'Furniture',
        'Cabinetry',
        'Flooring',
        'Interior finishing',
        'General woodworking',
        'Plywood'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Good',
        'cabinet': 'Excellent',
        'bookshelf': 'Excellent'
      },
      'tips': [
        'Affordable alternative to premium hardwoods',
        'Takes stain well',
        'Good for beginners',
        'Pre-drill near edges',
        'Widely available in lumber yards'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Excellent - fast-growing plantation',
      'localNames': ['Acacia', 'Mangium']
    },
    
    'mahogany': {
      'name': 'Mahogany',
      'scientificName': 'Swietenia macrophylla',
      'type': 'Hardwood',
      'origin': 'Introduced (widely planted)',
      'status': 'Common',
      'density': 'Medium',
      'hardness': 'Medium Hard',
      'durability': 'Excellent',
      'workability': 'Excellent',
      'grain': 'Straight to interlocked, medium texture',
      'color': 'Reddish-brown',
      'barkDescription': 'Gray-brown, rough with vertical fissures',
      'characteristics': [
        'Premium furniture wood',
        'Excellent workability',
        'Beautiful grain patterns',
        'Stable when dried',
        'Takes finish beautifully'
      ],
      'bestUses': [
        'Fine furniture',
        'Cabinetry',
        'Musical instruments',
        'Boat building',
        'Interior finishing',
        'Decorative veneers'
      ],
      'furnitureSuitability': {
        'table': 'Excellent',
        'chair': 'Excellent',
        'cabinet': 'Excellent',
        'bookshelf': 'Good'
      },
      'tips': [
        'Excellent for hand tool work',
        'Showcase natural grain',
        'Good for traditional furniture',
        'Takes oil finishes well',
        'Widely available in Philippines'
      ],
      'priceRange': 'Medium to High',
      'sustainability': 'Good - plantation grown',
      'localNames': ['Mahogany', 'Kaobang']
    },
    
    'gmelina': {
      'name': 'Gmelina',
      'scientificName': 'Gmelina arborea',
      'type': 'Hardwood',
      'origin': 'Introduced (plantation)',
      'status': 'Common',
      'density': 'Low to Medium',
      'hardness': 'Soft to Medium',
      'durability': 'Moderate',
      'workability': 'Excellent',
      'grain': 'Straight, coarse texture',
      'color': 'Pale yellow to light brown',
      'barkDescription': 'Light gray, relatively smooth',
      'characteristics': [
        'Very fast-growing',
        'Lightweight',
        'Easy to work',
        'Affordable',
        'Good for light construction'
      ],
      'bestUses': [
        'Light construction',
        'Furniture (painted)',
        'Plywood',
        'Packaging',
        'General carpentry',
        'Interior work'
      ],
      'furnitureSuitability': {
        'table': 'Fair',
        'chair': 'Fair',
        'cabinet': 'Good',
        'bookshelf': 'Good'
      },
      'tips': [
        'Best when painted or stained',
        'Very affordable option',
        'Good for practice projects',
        'Not suitable for heavy loads',
        'Widely available'
      ],
      'priceRange': 'Low',
      'sustainability': 'Excellent - very fast-growing',
      'localNames': ['Gmelina', 'Yemane']
    },
    
    'falcata': {
      'name': 'Falcata',
      'scientificName': 'Paraserianthes falcataria',
      'type': 'Hardwood',
      'origin': 'Introduced (plantation)',
      'status': 'Common',
      'density': 'Very Low',
      'hardness': 'Very Soft',
      'durability': 'Poor',
      'workability': 'Excellent',
      'grain': 'Straight, coarse texture',
      'color': 'White to pale yellow',
      'barkDescription': 'Light gray, smooth to slightly rough',
      'characteristics': [
        'Fastest-growing tree in Philippines',
        'Very lightweight',
        'Easy to work',
        'Very affordable',
        'Not durable outdoors'
      ],
      'bestUses': [
        'Plywood core',
        'Packaging',
        'Light construction',
        'Temporary structures',
        'Pulpwood',
        'Practice projects'
      ],
      'furnitureSuitability': {
        'table': 'Poor',
        'chair': 'Poor',
        'cabinet': 'Fair',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Not suitable for structural use',
        'Best for non-load bearing applications',
        'Very affordable for practice',
        'Requires treatment for durability',
        'Good for learning woodworking'
      ],
      'priceRange': 'Very Low',
      'sustainability': 'Excellent - extremely fast-growing',
      'localNames': ['Falcata', 'Moluccan Sau', 'Batai']
    },
    
    // FRUIT TREES (Common in Philippines)
    
    'mango': {
      'name': 'Mango',
      'scientificName': 'Mangifera indica',
      'type': 'Hardwood',
      'origin': 'Naturalized',
      'status': 'Common',
      'density': 'Medium',
      'hardness': 'Medium Hard',
      'durability': 'Good',
      'workability': 'Good',
      'grain': 'Interlocked, medium texture',
      'color': 'Light brown with darker streaks',
      'barkDescription': 'Dark gray-brown, rough with vertical fissures',
      'characteristics': [
        'Beautiful grain patterns',
        'Good for furniture',
        'Readily available',
        'Interesting color variations',
        'Good workability'
      ],
      'bestUses': [
        'Furniture',
        'Decorative items',
        'Carvings',
        'Bowls and utensils',
        'Interior finishing',
        'Small projects'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Good',
        'cabinet': 'Good',
        'bookshelf': 'Good'
      },
      'tips': [
        'Often available from old fruit trees',
        'Interesting grain for decorative work',
        'Takes finish well',
        'Good for turning',
        'Affordable and accessible'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Good - from old fruit trees',
      'localNames': ['Mangga', 'Mango']
    },
    
    'jackfruit': {
      'name': 'Jackfruit',
      'scientificName': 'Artocarpus heterophyllus',
      'type': 'Hardwood',
      'origin': 'Naturalized',
      'status': 'Common',
      'density': 'Medium',
      'hardness': 'Medium',
      'durability': 'Good',
      'workability': 'Good',
      'grain': 'Straight to interlocked, medium texture',
      'color': 'Golden yellow to orange-brown',
      'barkDescription': 'Gray-brown, rough with small bumps',
      'characteristics': [
        'Beautiful golden color',
        'Good for musical instruments',
        'Stable when dried',
        'Interesting grain',
        'Traditional furniture wood'
      ],
      'bestUses': [
        'Musical instruments',
        'Furniture',
        'Decorative items',
        'Carvings',
        'Interior work',
        'Turned objects'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Fair',
        'cabinet': 'Good',
        'bookshelf': 'Good'
      },
      'tips': [
        'Excellent for musical instruments',
        'Beautiful natural color',
        'Takes oil finishes well',
        'Good for decorative work',
        'Often available from old trees'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Good - from old fruit trees',
      'localNames': ['Langka', 'Nangka']
    },
    
    'aratiles': {
      'name': 'Aratiles',
      'scientificName': 'Muntingia calabura',
      'type': 'Hardwood',
      'origin': 'Naturalized',
      'status': 'Very Common',
      'density': 'Low',
      'hardness': 'Soft',
      'durability': 'Poor',
      'workability': 'Excellent',
      'grain': 'Fine, even texture',
      'color': 'Pale yellow to light brown',
      'barkDescription': 'Light brown, smooth to slightly rough',
      'characteristics': [
        'Very fast-growing',
        'Lightweight',
        'Easy to work',
        'Not durable',
        'Good for small projects'
      ],
      'bestUses': [
        'Small crafts',
        'Practice projects',
        'Temporary structures',
        'Firewood',
        'Pulpwood',
        'Learning woodworking'
      ],
      'furnitureSuitability': {
        'table': 'Poor',
        'chair': 'Poor',
        'cabinet': 'Poor',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Good for beginners to practice',
        'Not suitable for structural use',
        'Very affordable',
        'Easy to find',
        'Use for non-critical projects'
      ],
      'priceRange': 'Very Low',
      'sustainability': 'Excellent - very fast-growing',
      'localNames': ['Aratiles', 'Aratilis', 'Sarisa']
    },
    
    'coconut': {
      'name': 'Coconut',
      'scientificName': 'Cocos nucifera',
      'type': 'Palm (not true wood)',
      'origin': 'Native',
      'status': 'Very Common',
      'density': 'Variable (outer hard, inner soft)',
      'hardness': 'Variable',
      'durability': 'Good (outer part)',
      'workability': 'Moderate',
      'grain': 'Fibrous, unique pattern',
      'color': 'Light to dark brown with streaks',
      'barkDescription': 'Smooth, gray-brown with ring scars',
      'characteristics': [
        'Unique fibrous structure',
        'Interesting appearance',
        'Widely available',
        'Sustainable resource',
        'Requires special techniques'
      ],
      'bestUses': [
        'Furniture (coconut lumber)',
        'Flooring',
        'Decorative items',
        'Bowls and utensils',
        'Handicrafts',
        'Sustainable building'
      ],
      'furnitureSuitability': {
        'table': 'Good',
        'chair': 'Fair',
        'cabinet': 'Good',
        'bookshelf': 'Fair'
      },
      'tips': [
        'Use outer part for structural work',
        'Unique appearance for decorative projects',
        'Requires carbide tools',
        'Sustainable alternative',
        'Good for eco-friendly projects'
      ],
      'priceRange': 'Low to Medium',
      'sustainability': 'Excellent - abundant resource',
      'localNames': ['Niyog', 'Coconut', 'Coco lumber']
    },
  };

  // Helper methods (same as original)
  
  static Map<String, dynamic>? getWoodData(String woodType) {
    String normalizedType = woodType.toLowerCase().trim();
    
    if (woodDatabase.containsKey(normalizedType)) {
      return woodDatabase[normalizedType];
    }
    
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

  static List<String> getNativeSpecies() {
    return woodDatabase.entries
        .where((entry) => entry.value['origin'] == 'Native')
        .map((entry) => entry.key)
        .toList();
  }

  static List<String> getEndangeredSpecies() {
    return woodDatabase.entries
        .where((entry) => 
            entry.value['status'] == 'Endangered' || 
            entry.value['status'] == 'Vulnerable')
        .map((entry) => entry.key)
        .toList();
  }

  static String getWoodDescription(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null) {
      return '${woodData['type']} • ${woodData['origin']} • ${woodData['durability']} durability';
    }
    return 'Wood properties being analyzed...';
  }

  static String getBarkDescription(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['barkDescription'] != null) {
      return woodData['barkDescription'];
    }
    return 'Bark characteristics being analyzed...';
  }

  static List<String> getLocalNames(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['localNames'] != null) {
      return List<String>.from(woodData['localNames']);
    }
    return [woodType];
  }

  // All other helper methods from original file...
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
