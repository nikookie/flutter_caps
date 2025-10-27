import 'package:flutter/material.dart';

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
      'localNames': ['Narra', 'Asana', 'Angsana'],
      'detailedDescription': 'The **Narra tree**, scientifically known as **Pterocarpus indicus**, is the national tree of the Philippines and stands as a symbol of strength and beauty. This magnificent hardwood tree can reach heights of up to **40 meters (131 feet)** and is characterized by its **grayish-brown trunk** with deep vertical fissures and a spreading crown. The wood displays a stunning **golden yellow to deep reddish-brown** color that deepens with age and exposure to light.\n\n**Cultural & Superstitious Beliefs:**\nIn Philippine folklore, the Narra tree is considered a symbol of **prosperity and good fortune**. It is believed that planting a Narra tree brings **blessings to the family** and ensures **long-lasting wealth**. The wood is traditionally used in **religious ceremonies** and is considered sacred in many Filipino communities. Furniture made from Narra is thought to bring **harmony and stability** to the home. However, according to local beliefs, Narra wood should **never be used for beds** as it is believed to cause **restlessness and insomnia** due to its strong spiritual energy. The wood is also traditionally used in **ancestral homes** to honor and preserve family heritage.',
      'superstition': 'Brings prosperity and good fortune. Do not use for beds as it may cause restlessness. Sacred in religious ceremonies.',
      'folklore': '**The Sacred Narra Legend**: In Tagalog mythology, the Narra tree is believed to be a gift from the gods to the Filipino people. It is said that planting a Narra tree on the day of a child\'s birth ensures the child will grow strong and prosperous. The tree is often planted in front of ancestral homes as a symbol of family permanence and protection.\n\n**Traditional Uses**: Narra wood has been used for centuries in the Philippines to craft religious statues, altar pieces, and ceremonial items. Skilled artisans believe that working with Narra wood brings spiritual clarity and artistic inspiration. The wood is traditionally used in **wedding ceremonies** to create marriage tokens that symbolize eternal love and commitment.',
      'regionalVariations': {
        'Tagalog': 'Considered the "Tree of Life" - planting one brings blessings for seven generations',
        'Visayan': 'Used in boat-building for protection during sea voyages; believed to guide sailors safely home',
        'Ilocano': 'Sacred wood for ancestral altars; used to honor deceased family members',
        'Mindanao': 'Traditionally carved into protective amulets and talismans for warriors'
      },
      'traditionalUses': [
        'Religious statues and altar pieces',
        'Wedding ceremony tokens',
        'Ancestral home protection symbols',
        'Healing amulets and talismans',
        'Ceremonial drums and instruments',
        'Royal furniture for important figures'
      ]
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
      'localNames': ['Molave', 'Tugas', 'Balogo'],
      'detailedDescription': 'The **Molave tree**, scientifically known as **Vitex parviflora**, is one of the hardest and most durable Philippine hardwoods. This magnificent tree can reach heights of up to **35 meters (115 feet)** and is characterized by its **gray to brown trunk** with shallow fissures and a dense crown. The wood displays a **yellowish to greenish-brown** color that becomes darker with age.\n\n**Cultural & Superstitious Beliefs:**\nIn Philippine folklore, Molave is considered a symbol of **strength and endurance**. It is believed that Molave wood brings **stability and protection** to the home. The wood is traditionally used in **ancestral homes** and is thought to provide **spiritual protection** against negative energies. However, according to local beliefs, Molave should **not be used for bedroom furniture** as it is believed to cause **restlessness and tension** in relationships. The wood is highly respected in Filipino culture and is often used in **important structures** to ensure **longevity and permanence**.',
      'superstition': 'Symbol of strength and endurance. Brings stability and protection. Do not use for bedroom furniture as it may cause restlessness. Used in ancestral homes for spiritual protection.',
      'folklore': '**The Warrior\'s Wood**: In Ilocano legend, Molave is known as the wood of warriors and leaders. It is believed that ancient Filipino warriors carved their shields and weapons from Molave to gain **invincibility in battle**. The wood is said to absorb the strength of those who work with it.\n\n**Ancestral Protection**: Molave is traditionally used in the construction of **bahay na bato** (stone houses) and ancestral homes. Filipinos believe that Molave beams protect the family from **calamities and misfortunes** for generations.',
      'regionalVariations': {
        'Ilocano': 'Sacred warrior wood - used for shields and weapons; believed to grant strength',
        'Tagalog': 'Used in ancestral homes for family protection and longevity',
        'Visayan': 'Considered a symbol of permanence; used in important structures',
        'Mindanao': 'Traditionally used in tribal council houses for authority and wisdom'
      },
      'traditionalUses': [
        'Warrior shields and weapons',
        'Ancestral home construction',
        'Tribal council house beams',
        'Protection amulets',
        'Important ceremonial structures',
        'Family heirloom furniture'
      ]
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
      'localNames': ['Yakal', 'Yakal-saplungan'],
      'detailedDescription': 'The **Yakal tree**, scientifically known as **Shorea astylosa**, is one of the strongest and most durable Philippine hardwoods. This massive tree can reach heights of up to **50 meters (164 feet)** and is characterized by its **dark brown trunk** with deep fissures and scaly plates. The wood displays a **light brown to reddish-brown** color that becomes darker with age and weathering.\n\n**Cultural & Superstitious Beliefs:**\nIn Philippine folklore, Yakal is considered a symbol of **permanence and strength**. It is believed that Yakal wood brings **stability and longevity** to structures. The wood is traditionally used in **important buildings** and **ancestral homes** to ensure they last for **generations**. According to local beliefs, Yakal should **not be used for bedroom furniture** as it is thought to bring **heaviness and oppression** to the spirit. The wood is highly respected and is often used in **sacred structures** and **important monuments**.',
      'superstition': 'Symbol of permanence and strength. Brings stability and longevity. Do not use for bedroom furniture as it may bring heaviness. Used in important structures for generations.',
      'folklore': '**The Foundation of Nations**: In Visayan legend, Yakal is the wood upon which the first Filipino settlements were built. It is believed that Yakal structures have **protected families for centuries** and will continue to do so. The wood is considered **sacred** in bridge-building traditions.\n\n**Strength Inheritance**: Families that use Yakal in their homes are believed to inherit the wood\'s **unbreakable strength** and **resilience** through generations.',
      'regionalVariations': {
        'Visayan': 'Foundation wood - used in first settlements; believed to protect for centuries',
        'Tagalog': 'Symbol of permanence; used in important government buildings',
        'Ilocano': 'Bridge-building wood; sacred in construction traditions',
        'Mindanao': 'Tribal stronghold wood; used in important community structures'
      },
      'traditionalUses': [
        'Bridge construction and support beams',
        'Ancestral home foundations',
        'Government building structures',
        'Sacred ceremonial halls',
        'Tribal council houses',
        'Important monument bases'
      ]
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
      'localNames': ['Acacia', 'Mangium'],
      'detailedDescription': 'The **Acacia tree**, scientifically known as **Acacia mangium**, is a fast-growing plantation hardwood widely cultivated throughout the Philippines. This tree can reach heights of up to **30 meters (98 feet)** and is characterized by its **gray-brown trunk** with relatively smooth bark and shallow fissures. The wood displays a beautiful **light brown to golden brown** color that becomes richer with age.\n\n**Cultural & Superstitious Beliefs:**\nIn Philippine culture, Acacia is considered a symbol of **growth and prosperity**. It is believed that Acacia wood brings **positive energy** and **abundance** to the home. The wood is traditionally used in **furniture making** and is thought to promote **harmony and balance** in living spaces. According to local beliefs, Acacia is a **safe wood for all furniture types**, including beds, as it is believed to bring **peaceful sleep** and **good dreams**. The wood is highly valued for its **affordability** and **accessibility**, making it a popular choice for Filipino families.',
      'superstition': 'Symbol of growth and prosperity. Brings positive energy and abundance. Safe for all furniture including beds. Promotes peaceful sleep and good dreams.'
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

  static String getDetailedDescription(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['detailedDescription'] != null) {
      return woodData['detailedDescription'];
    }
    return 'Detailed information about this wood species is being compiled...';
  }

  static String getSuperstition(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['superstition'] != null) {
      return woodData['superstition'];
    }
    return 'No superstitious beliefs recorded for this wood type.';
  }

  // ============================================
  // PROTECTED SPECIES ALERT SYSTEM
  // ============================================

  static bool isProtectedSpecies(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null) {
      final status = woodData['status'].toString().toLowerCase();
      return status.contains('endangered') || status.contains('vulnerable') || status.contains('protected') || status.contains('national tree');
    }
    return false;
  }

  static String getProtectionStatus(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null) {
      return woodData['status'].toString();
    }
    return 'Unknown';
  }

  static String getLegalImplications(String woodType) {
    final status = getProtectionStatus(woodType);
    
    if (status.contains('Endangered')) {
      return '🚫 CRITICALLY PROTECTED: This species is legally protected under Philippine law. Harvesting, trading, or possessing this wood without proper permits is ILLEGAL and subject to severe penalties including fines and imprisonment.';
    } else if (status.contains('Vulnerable')) {
      return '⚠️ PROTECTED: This species is vulnerable and protected under Philippine environmental laws. Harvesting requires special permits from DENR (Department of Environment and Natural Resources). Unauthorized possession may result in legal consequences.';
    } else if (status.contains('National Tree')) {
      return '🇵🇭 NATIONAL SYMBOL: This is the National Tree of the Philippines. While limited use is permitted, commercial harvesting is restricted. Only use wood from certified sustainable sources or plantations.';
    }
    return 'This wood species is not currently protected.';
  }

  static List<String> getSustainableAlternatives(String woodType) {
    final normalizedType = woodType.toLowerCase().trim();
    
    final alternatives = <String, List<String>>{
      'narra': ['Mahogany', 'Acacia', 'Mango'],
      'molave': ['Ipil (sustainably sourced)', 'Mahogany', 'Acacia'],
      'yakal': ['Ipil', 'Mahogany', 'Acacia'],
      'kamagong': ['Mahogany', 'Jackfruit', 'Mango'],
      'ipil': ['Mahogany', 'Acacia', 'Coconut lumber'],
    };

    return alternatives[normalizedType] ?? [];
  }

  static String getAlternativesDescription(String woodType) {
    final alternatives = getSustainableAlternatives(woodType);
    if (alternatives.isEmpty) {
      return 'This wood species is not restricted. You can use it responsibly.';
    }

    final altList = alternatives.join(', ');
    return '✅ SUSTAINABLE ALTERNATIVES:\n\n$altList\n\nThese alternatives offer similar properties while being sustainably sourced or fast-growing plantation species.';
  }

  static String getConservationMessage(String woodType) {
    final status = getProtectionStatus(woodType);
    
    if (status.contains('Endangered') || status.contains('Vulnerable')) {
      return '🌱 CONSERVATION EFFORT: By choosing sustainable alternatives, you help protect Philippine forests and endangered species. Support reforestation initiatives and use certified sustainable wood products.';
    }
    return '';
  }

  static Color getProtectionStatusColor(String woodType) {
    final status = getProtectionStatus(woodType);
    
    if (status.contains('Endangered')) {
      return Color(0xFFE17055);
    } else if (status.contains('Vulnerable')) {
      return Color(0xFFFFB74D);
    } else if (status.contains('National Tree')) {
      return Color(0xFF6C5CE7);
    }
    return Color(0xFF00B894);
  }

  // ============================================
  // PHILIPPINE SUPERSTITIONS & CULTURAL DATABASE
  // ============================================

  static String getFollklore(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['folklore'] != null) {
      return woodData['folklore'];
    }
    return 'No folklore recorded for this wood type.';
  }

  static Map<String, String> getRegionalVariations(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['regionalVariations'] != null) {
      return Map<String, String>.from(woodData['regionalVariations']);
    }
    return {};
  }

  static List<String> getTraditionalUses(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null && woodData['traditionalUses'] != null) {
      return List<String>.from(woodData['traditionalUses']);
    }
    return [];
  }

  static bool hasCulturalData(String woodType) {
    final woodData = getWoodData(woodType);
    if (woodData != null) {
      return woodData['folklore'] != null || 
             woodData['regionalVariations'] != null || 
             woodData['traditionalUses'] != null;
    }
    return false;
  }

  static String getCulturalSummary(String woodType) {
    final folklore = getFollklore(woodType);
    final variations = getRegionalVariations(woodType);
    final uses = getTraditionalUses(woodType);
    
    String summary = '';
    
    if (folklore.isNotEmpty && folklore != 'No folklore recorded for this wood type.') {
      summary += '📖 **Folklore**: $folklore\n\n';
    }
    
    if (uses.isNotEmpty) {
      summary += '🎨 **Traditional Uses**:\n';
      for (var use in uses) {
        summary += '• $use\n';
      }
      summary += '\n';
    }
    
    if (variations.isNotEmpty) {
      summary += '🗺️ **Regional Variations**:\n';
      variations.forEach((region, belief) {
        summary += '• **$region**: $belief\n';
      });
    }
    
    return summary.isEmpty ? 'No cultural data available.' : summary;
  }
}
