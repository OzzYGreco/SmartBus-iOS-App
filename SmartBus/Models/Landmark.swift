import Foundation
import CoreLocation

struct Landmark: Identifiable, Codable {
    let id: String
    let name: String
    let category: LandmarkCategory
    let shortDescription: String
    let fullDescription: String
    let coordinate: BusStop.Coordinate
    let imageNames: [String]
    let audioScript: String
    let historicalPeriod: String?
    let visitDurationMinutes: Int
    let entryFee: String?
    let openingHours: String
}

enum LandmarkCategory: String, Codable, CaseIterable {
    case monument = "Monument"
    case museum = "Museum"
    case park = "Park"
    case historicalSite = "Historical Site"
    case neighborhood = "Neighborhood"
    case viewpoint = "Viewpoint"

    var icon: String {
        switch self {
        case .monument: return "building.columns.fill"
        case .museum: return "building.2.fill"
        case .park: return "leaf.fill"
        case .historicalSite: return "clock.fill"
        case .neighborhood: return "house.fill"
        case .viewpoint: return "mountain.2.fill"
        }
    }

    var color: String {
        switch self {
        case .monument: return "purple"
        case .museum: return "blue"
        case .park: return "green"
        case .historicalSite: return "orange"
        case .neighborhood: return "pink"
        case .viewpoint: return "teal"
        }
    }
}

// Athens Landmarks Database
extension Landmark {
    static let athensLandmarks: [Landmark] = [
        Landmark(
            id: "acropolis",
            name: "Acropolis",
            category: .monument,
            shortDescription: "Ancient citadel on a rocky outcrop above the city",
            fullDescription: "The Acropolis of Athens is an ancient citadel located on a rocky outcrop above the city of Athens and contains the remains of several ancient buildings of great architectural and historical significance. The most famous building on the Acropolis is the Parthenon, a former temple dedicated to the goddess Athena. Built in the 5th century BC during the Golden Age of Athens, the Acropolis represents the pinnacle of ancient Greek architecture and is a UNESCO World Heritage Site.",
            coordinate: BusStop.Coordinate(latitude: 37.9715, longitude: 23.7257),
            imageNames: ["acropolis"],
            audioScript: "Welcome to the Acropolis of Athens, one of the most iconic archaeological sites in the world. This ancient citadel, perched on a rocky hill 150 meters above sea level, has been the heart of Athenian culture for over 2,500 years. The Parthenon, dedicated to Athena, goddess of wisdom and war, dominates the skyline. Construction began in 447 BC under Pericles during Athens' Golden Age. The precision of its architecture and the artistry of its sculptures remain unmatched. As you gaze upon these marble columns, you're witnessing the birthplace of democracy and Western civilization.",
            historicalPeriod: "5th Century BC",
            visitDurationMinutes: 120,
            entryFee: "€20 (Combined ticket)",
            openingHours: "8:00 AM - 8:00 PM (Summer)"
        ),
        Landmark(
            id: "parthenon",
            name: "Parthenon",
            category: .monument,
            shortDescription: "Iconic temple dedicated to goddess Athena",
            fullDescription: "The Parthenon is a former temple on the Athenian Acropolis dedicated to the goddess Athena, whom the people of Athens considered their patron. Construction began in 447 BC when the Athenian Empire was at the peak of its power. It was completed in 438 BC, although decoration continued until 432 BC. It is the most important surviving building of Classical Greece and one of the world's greatest cultural monuments.",
            coordinate: BusStop.Coordinate(latitude: 37.9715, longitude: 23.7266),
            imageNames: ["parthenon"],
            audioScript: "Behold the Parthenon, the crown jewel of ancient Greek architecture. This magnificent temple was built between 447 and 432 BC to honor Athena Parthenos, the virgin goddess of Athens. The building's perfect proportions create an optical illusion - the columns appear straight but are actually curved to counteract visual distortion. Once housing a 12-meter tall gold and ivory statue of Athena, the Parthenon has survived wars, fires, explosions, and looting. It stands today as an enduring symbol of ancient Greek glory and the foundation of Western civilization.",
            historicalPeriod: "447-432 BC",
            visitDurationMinutes: 45,
            entryFee: "Included in Acropolis ticket",
            openingHours: "8:00 AM - 8:00 PM (Summer)"
        ),
        Landmark(
            id: "ancient-agora",
            name: "Ancient Agora",
            category: .historicalSite,
            shortDescription: "Ancient marketplace and civic center",
            fullDescription: "The Ancient Agora of Athens was the center of ancient Athens' civic life. It was the focal point of political, commercial, administrative, and social activity, as well as the religious and cultural center. The Agora was also the site of philosophical discussions, with Socrates known to have frequented the area. Today, visitors can explore ruins of various stoas, temples, and public buildings that once lined the square.",
            coordinate: BusStop.Coordinate(latitude: 37.9753, longitude: 23.7225),
            imageNames: ["agora"],
            audioScript: "Step into the Ancient Agora, the beating heart of classical Athens. For over a thousand years, this was where democracy was born and flourished. Citizens gathered here to vote, philosophers like Socrates debated ideas, merchants sold their wares, and artists displayed their works. The word 'agora' means 'gathering place' in Greek. The Temple of Hephaestus, one of the best-preserved ancient Greek temples, still stands watch over the ruins. Walking these ancient paths, you're treading the same ground as Plato, Aristotle, and the founding fathers of Western philosophy.",
            historicalPeriod: "6th Century BC - 267 AD",
            visitDurationMinutes: 90,
            entryFee: "€10",
            openingHours: "8:00 AM - 8:00 PM (Summer)"
        ),
        Landmark(
            id: "plaka",
            name: "Plaka District",
            category: .neighborhood,
            shortDescription: "Historic neighborhood at the foot of the Acropolis",
            fullDescription: "Plaka is the oldest neighborhood of Athens, located directly beneath the Acropolis. Known as the 'Neighborhood of the Gods,' its labyrinthine streets are lined with neoclassical architecture, traditional tavernas, and souvenir shops. The area has been continuously inhabited since ancient times and retains much of its 19th-century character with colorful buildings, narrow cobblestone streets, and vine-covered terraces.",
            coordinate: BusStop.Coordinate(latitude: 37.9722, longitude: 23.7275),
            imageNames: ["plaka"],
            audioScript: "Welcome to Plaka, Athens' most picturesque neighborhood. These charming cobblestone streets have witnessed over 3,000 years of continuous habitation. The neoclassical mansions you see were built in the 19th century when Athens became the capital of modern Greece. Hidden among the souvenir shops and tavernas are Byzantine churches, ancient ruins, and traditional Greek houses with colorful shutters. At night, bouzouki music fills the air as locals and visitors dine under the glow of the illuminated Acropolis. This is where ancient Athens meets modern Greek culture.",
            historicalPeriod: "Ancient to Modern",
            visitDurationMinutes: 60,
            entryFee: "Free",
            openingHours: "Always accessible"
        ),
        Landmark(
            id: "syntagma",
            name: "Syntagma Square",
            category: .historicalSite,
            shortDescription: "Central square and site of the Greek Parliament",
            fullDescription: "Syntagma Square is the central square of Athens and home to the Greek Parliament building. The square is named after the Constitution that King Otto was forced to grant after a popular and military uprising on September 3, 1843. It is a popular meeting point and the site of demonstrations and celebrations. The Changing of the Guard ceremony at the Tomb of the Unknown Soldier occurs every hour.",
            coordinate: BusStop.Coordinate(latitude: 37.9755, longitude: 23.7348),
            imageNames: ["syntagma"],
            audioScript: "You're standing in Syntagma Square, the pulse of modern Athens. 'Syntagma' means constitution in Greek, commemorating the 1843 uprising that forced King Otto to grant Greece its first constitution. The Parliament building you see was originally built as a palace for Otto. Every hour, the Evzones, elite presidential guards in traditional costume, perform their distinctive slow-motion march at the Tomb of the Unknown Soldier. Their uniforms, with 400 pleats representing years of Ottoman occupation, honor all Greeks who died defending their nation. This square has witnessed protests, celebrations, and pivotal moments in Greek democracy.",
            historicalPeriod: "19th Century - Present",
            visitDurationMinutes: 30,
            entryFee: "Free",
            openingHours: "Always accessible"
        ),
        Landmark(
            id: "archaeological-museum",
            name: "National Archaeological Museum",
            category: .museum,
            shortDescription: "World's finest collection of ancient Greek artifacts",
            fullDescription: "The National Archaeological Museum in Athens houses the world's finest collection of ancient Greek artifacts. Founded in 1829, it contains more than 11,000 exhibits providing a panorama of Greek civilization from prehistory to late antiquity. Highlights include the Mask of Agamemnon, the Antikythera mechanism, and an extensive collection of sculptures, pottery, and jewelry from various periods of Greek history.",
            coordinate: BusStop.Coordinate(latitude: 37.9891, longitude: 23.7322),
            imageNames: ["museum"],
            audioScript: "Welcome to the National Archaeological Museum, home to the world's greatest collection of ancient Greek treasures. Founded in 1829, this neoclassical building houses over 11,000 artifacts spanning 5,000 years of Greek history. You'll encounter the famous golden Mask of Agamemnon from Mycenae, the mysterious Antikythera mechanism - an ancient astronomical calculator, and countless exquisite sculptures, pottery, and jewelry. Each room reveals a different chapter in the story of ancient Greece, from the Bronze Age to the Roman period. This is where the myths and legends of ancient Greece come to life through tangible artifacts.",
            historicalPeriod: "Collections: 6000 BC - 5th Century AD",
            visitDurationMinutes: 180,
            entryFee: "€12",
            openingHours: "9:00 AM - 4:00 PM (Closed Mondays)"
        ),
        Landmark(
            id: "temple-zeus",
            name: "Temple of Olympian Zeus",
            category: .monument,
            shortDescription: "Colossal ruined temple of Zeus",
            fullDescription: "The Temple of Olympian Zeus, also known as the Olympieion, was a giant temple that took nearly 700 years to complete. It was dedicated to Zeus, king of the Olympian gods. Construction began in the 6th century BC but wasn't completed until the 2nd century AD under Roman Emperor Hadrian. Of the original 104 Corinthian columns, only 15 remain standing today, yet they give a sense of the temple's massive scale.",
            coordinate: BusStop.Coordinate(latitude: 37.9692, longitude: 23.7331),
            imageNames: ["temple-zeus"],
            audioScript: "Before you stand the colossal ruins of the Temple of Olympian Zeus, one of the largest temples ever built in the ancient world. Construction began in the 6th century BC but took 700 years to complete - it wasn't finished until 132 AD under Roman Emperor Hadrian. Originally, 104 massive Corinthian columns, each 17 meters tall, supported the structure. Only 15 survive today, yet they still convey the temple's breathtaking scale. This temple once housed a chryselephantine statue of Zeus, matching the grandeur of the structure itself. The temple represents the ambition of ancient builders and the lasting legacy of classical architecture.",
            historicalPeriod: "6th Century BC - 2nd Century AD",
            visitDurationMinutes: 45,
            entryFee: "€8",
            openingHours: "8:00 AM - 8:00 PM (Summer)"
        ),
        Landmark(
            id: "panathenaic-stadium",
            name: "Panathenaic Stadium",
            category: .monument,
            shortDescription: "Historic stadium, site of first modern Olympics",
            fullDescription: "The Panathenaic Stadium, also known as Kallimarmaro (beautiful marble), is a multi-purpose stadium built entirely of white marble. It was originally built in the 4th century BC for the Panathenaic Games. The stadium was excavated and refurbished for the first modern Olympic Games in 1896 and has been used for various purposes since. It is the only stadium in the world built entirely of marble.",
            coordinate: BusStop.Coordinate(latitude: 37.9683, longitude: 23.7408),
            imageNames: ["stadium"],
            audioScript: "You're gazing at the Panathenaic Stadium, the world's only stadium built entirely of gleaming white marble. Originally constructed in 330 BC, it hosted the Panathenaic Games in honor of goddess Athena. In 1896, it was restored to host the first modern Olympic Games, reviving an ancient tradition after 1,500 years. Standing in the center of this horseshoe-shaped arena, you can almost hear the roar of 50,000 spectators. The Olympic flame ceremony still takes place here before each modern Olympics. This marble marvel connects ancient athletic traditions with the modern Olympic movement.",
            historicalPeriod: "4th Century BC, Restored 1896",
            visitDurationMinutes: 60,
            entryFee: "€5",
            openingHours: "8:00 AM - 7:00 PM"
        ),
        Landmark(
            id: "lycabettus",
            name: "Mount Lycabettus",
            category: .viewpoint,
            shortDescription: "Highest point in Athens with panoramic views",
            fullDescription: "Mount Lycabettus is a Cretaceous limestone hill in Athens that rises 300 meters above sea level. From its peak, visitors enjoy panoramic views of Athens, the Attica basin, and the Aegean Sea. According to Greek mythology, Lycabettus was created when the goddess Athena dropped a mountain she was carrying. At the summit sits the Chapel of St. George, a 19th-century church. The hill can be accessed by funicular railway or on foot.",
            coordinate: BusStop.Coordinate(latitude: 37.9812, longitude: 23.7423),
            imageNames: ["lycabettus"],
            audioScript: "You're at Mount Lycabettus, Athens' highest point at 300 meters above sea level. According to myth, the goddess Athena was carrying this mountain to fortify the Acropolis when she was startled by bad news and dropped it here. From this vantage point, all of Athens spreads before you - the Acropolis, the ancient Agora, Syntagma Square, and on clear days, you can see the Aegean Sea and the port of Piraeus. The whitewashed Chapel of St. George crowns the summit. At sunset, this becomes one of the most romantic spots in Athens, as the city lights begin to twinkle below.",
            historicalPeriod: "Ancient Mythological Site",
            visitDurationMinutes: 90,
            entryFee: "Free (Funicular: €7.50 round trip)",
            openingHours: "Always accessible"
        ),
        Landmark(
            id: "monastiraki",
            name: "Monastiraki Square",
            category: .neighborhood,
            shortDescription: "Vibrant flea market district",
            fullDescription: "Monastiraki is one of the principal shopping districts in Athens. The area is known for its flea market, small tavernas serving traditional food, and sidewalk vendors selling various goods. The square takes its name from the Pantanassa church (the small monastery), which gave the area its name. The district blends ancient ruins with Ottoman architecture and modern Greek culture.",
            coordinate: BusStop.Coordinate(latitude: 37.9762, longitude: 23.7254),
            imageNames: ["monastiraki"],
            audioScript: "Welcome to Monastiraki, Athens' most eclectic neighborhood where ancient ruins meet bustling markets. The name means 'little monastery' from the 10th-century church at the square's center. This has been a marketplace since ancient times - you're standing near the original Agora. Today, the Sunday flea market attracts treasure hunters searching for antiques, vintage items, and handcrafted goods. The distinctive Tzistarakis Mosque, built in 1759 during Ottoman rule, now houses the Museum of Greek Folk Art. Monastiraki perfectly captures Athens' layered history - Byzantine, Ottoman, and modern Greek culture all coexisting in one vibrant square.",
            historicalPeriod: "Ancient to Modern",
            visitDurationMinutes: 75,
            entryFee: "Free",
            openingHours: "Always accessible"
        ),
        Landmark(
            id: "acropolis-museum",
            name: "Acropolis Museum",
            category: .museum,
            shortDescription: "Modern museum housing Acropolis artifacts",
            fullDescription: "The Acropolis Museum is an archaeological museum focused on the findings from the archaeological site of the Acropolis of Athens. The museum was built to house every artifact found on the rock and on the surrounding slopes. It stands on the archaeological site of Makrygianni and the ruins of ancient Athenian buildings are visible below the museum's glass floors. The top floor houses the Parthenon Gallery with a 360-degree view.",
            coordinate: BusStop.Coordinate(latitude: 37.9688, longitude: 23.7282),
            imageNames: ["acropolis-museum"],
            audioScript: "You're entering the Acropolis Museum, a stunning modern building that brings ancient treasures to life. Opened in 2009, this architectural marvel features glass floors revealing ancient ruins excavated below. The galleries are organized to match the ascent to the Acropolis itself. As you climb through the museum, you journey through time. The crown jewel is the top-floor Parthenon Gallery, where the original friezes and sculptures are displayed in their exact positions, with plaster copies filling gaps where originals remain in foreign museums. The panoramic windows offer views of the Acropolis, creating a dialogue between past and present.",
            historicalPeriod: "Museum opened 2009, Collections: Ancient",
            visitDurationMinutes: 120,
            entryFee: "€10",
            openingHours: "9:00 AM - 5:00 PM (Extended hours Fridays)"
        ),
        Landmark(
            id: "national-gardens",
            name: "National Garden",
            category: .park,
            shortDescription: "Lush public park in the heart of Athens",
            fullDescription: "The National Garden is a public park of 15.5 hectares in the center of Athens. It was formerly the Royal Garden, commissioned by Queen Amalia in 1838. The garden features ancient ruins, busts of poets, thematic gardens, a duck pond, and over 500 plant species including exotic plants from around the world. It's a green oasis providing shade and tranquility in the bustling city center.",
            coordinate: BusStop.Coordinate(latitude: 37.9741, longitude: 23.7378),
            imageNames: ["gardens"],
            audioScript: "Step into the National Garden, Athens' green sanctuary. Created in 1840 by Queen Amalia, Greece's first modern queen, this 16-hectare oasis features over 500 plant species from around the world. As you stroll the shaded paths, you'll discover ancient ruins integrated into the landscape, Corinthian columns standing among the trees, a duck pond, and quiet benches perfect for contemplation. The garden was originally the Royal Garden, accessible only to the royal family. In 1923, it opened to the public. Today, it offers respite from the Mediterranean heat and urban bustle, a place where ancient history and natural beauty intertwine.",
            historicalPeriod: "Established 1840",
            visitDurationMinutes: 45,
            entryFee: "Free",
            openingHours: "Sunrise to Sunset"
        ),
        Landmark(
            id: "parliament",
            name: "Hellenic Parliament",
            category: .historicalSite,
            shortDescription: "Greek Parliament building and ceremonial guard",
            fullDescription: "The Hellenic Parliament is housed in the Old Royal Palace, overlooking Syntagma Square. Originally built between 1836-1843 to house the Greek royal family, it has served as the home of the Greek Parliament since 1934. The building is guarded by the Evzones, elite ceremonial guards in traditional costume. The Changing of the Guard ceremony occurs every hour and is a major tourist attraction.",
            coordinate: BusStop.Coordinate(latitude: 37.9756, longitude: 23.7350),
            imageNames: ["parliament"],
            audioScript: "Before you stands the Hellenic Parliament, housed in the former Royal Palace. Built in the 1840s for King Otto, Greece's first modern monarch, the neoclassical building overlooks Syntagma Square. Since 1934, it has served as Greece's parliament, where democracy continues the tradition started in ancient Athens. The Evzones guards, in their distinctive uniform with pom-pommed shoes and pleated fustanella skirts, stand watch at the Tomb of the Unknown Soldier. Their slow, deliberate movements during the changing of the guard honor all Greek soldiers who died for their country. This building represents the continuity of Greek democracy from ancient times to the present day.",
            historicalPeriod: "Built 1836-1843",
            visitDurationMinutes: 30,
            entryFee: "Free (Exterior viewing)",
            openingHours: "Always accessible"
        )
    ]
}
