import SwiftUI

struct HelpContent {
    let title: String
    let sections: [HelpSection]
}

struct HelpSection {
    let action: String
    let description: String
    let icon: String
}

//Help content for different pages
enum HelpContentProvider {
    static let home = HelpContent(
        title: "Welcome to Smart Bus",
        sections: [
            HelpSection(
                action: "Order Coffee",
                description: "Select a coffee shop, browse menu items, and place your order for pickup at your bus stop",
                icon: "cup.and.saucer.fill"
            ),
            HelpSection(
                action: "Vacuum Service",
                description: "Select seat areas to clean, choose cleaning settings, and monitor the cleaning progress",
                icon: "wind"
            ),
            HelpSection(
                action: "Driver's View",
                description: "Experience the driver's perspective with real-time speed, location, and next stop information",
                icon: "car.fill"
            ),
            HelpSection(
                action: "Nearby Landmarks",
                description: "Discover Athens landmarks with audio guides, maps, and walking directions",
                icon: "building.columns.fill"
            ),
            HelpSection(
                action: "Driver Assistance",
                description: "Safety monitoring system with speed, lane, fatigue, and passenger alerts",
                icon: "shield.checkered"
            ),
            HelpSection(
                action: "Climate Control",
                description: "Adjust bus temperature, fan speed, and climate settings",
                icon: "thermometer.medium"
            ),
            HelpSection(
                action: "Roof Control",
                description: "Manage photovoltaic roof opening/closing with weather safety checks",
                icon: "rectangle.on.rectangle"
            ),
            HelpSection(
                action: "Energy Dashboard",
                description: "Monitor solar generation, battery status, and system energy consumption",
                icon: "bolt.batteryblock"
            )
        ]
    )

    static let driverView = HelpContent(
        title: "Driver's View Stream",
        sections: [
            HelpSection(
                action: "View Camera Feed",
                description: "See the simulated forward camera view as the driver sees it while driving through Athens",
                icon: "camera.fill"
            ),
            HelpSection(
                action: "Speed Monitor",
                description: "Real-time speed display in km/h shows current bus velocity",
                icon: "speedometer"
            ),
            HelpSection(
                action: "Location Info",
                description: "View current time, GPS location, and current stop information",
                icon: "location.fill"
            ),
            HelpSection(
                action: "Next Stop",
                description: "See upcoming stop name, estimated arrival time, and progress indicator",
                icon: "figure.walk"
            ),
            HelpSection(
                action: "Camera Angles",
                description: "Switch between forward view, left side view, and right side view perspectives",
                icon: "arrow.left.arrow.right"
            ),
            HelpSection(
                action: "Route Progress",
                description: "Track overall route progress and time elapsed in the 90-minute Athens tour",
                icon: "chart.line.uptrend.xyaxis"
            )
        ]
    )

    static let coffeeOrder = HelpContent(
        title: "Coffee Shop Selection",
        sections: [
            HelpSection(
                action: "Choose Coffee Shop",
                description: "Browse partnered coffee shops and view estimated arrival time",
                icon: "building.2.fill"
            ),
            HelpSection(
                action: "Check Distance",
                description: "See how many stops away each coffee shop is from your location",
                icon: "mappin.circle.fill"
            ),
            HelpSection(
                action: "Home Button",
                description: "Tap Home to return to the main screen at any time",
                icon: "house.fill"
            )
        ]
    )

    static let coffeeMenu = HelpContent(
        title: "Ordering Menu",
        sections: [
            HelpSection(
                action: "Browse Items",
                description: "View available coffee drinks, beverages, and snacks with prices",
                icon: "list.bullet"
            ),
            HelpSection(
                action: "Search",
                description: "Use the search bar to quickly find specific items",
                icon: "magnifyingglass"
            ),
            HelpSection(
                action: "Select Quantity",
                description: "Choose the quantity for each item (1-10)",
                icon: "number"
            ),
            HelpSection(
                action: "Add to Cart",
                description: "Tap 'Add to cart' to add items to your order",
                icon: "cart.badge.plus"
            ),
            HelpSection(
                action: "View Cart",
                description: "Tap the cart icon in the header to review your order",
                icon: "bag.fill"
            )
        ]
    )

    static let cart = HelpContent(
        title: "Shopping Cart",
        sections: [
            HelpSection(
                action: "Review Items",
                description: "Check all items, quantities, and prices in your cart",
                icon: "checklist"
            ),
            HelpSection(
                action: "Adjust Quantities",
                description: "Increase or decrease item quantities as needed",
                icon: "plus.forwardslash.minus"
            ),
            HelpSection(
                action: "Remove Items",
                description: "Swipe left or tap the remove button to delete items",
                icon: "trash"
            ),
            HelpSection(
                action: "Proceed to Payment",
                description: "Tap 'Proceed to Payment' to complete your order",
                icon: "creditcard"
            )
        ]
    )

    static let payment = HelpContent(
        title: "Payment",
        sections: [
            HelpSection(
                action: "Choose Payment Method",
                description: "Select between Credit Card, Debit Card, or Paypal",
                icon: "creditcard.fill"
            ),
            HelpSection(
                action: "Enter Card Details",
                description: "Provide your card number, expiry date, CVV, and billing address",
                icon: "keyboard"
            ),
            HelpSection(
                action: "Secure Payment",
                description: "All payments are processed securely",
                icon: "lock.shield.fill"
            ),
            HelpSection(
                action: "Confirm Order",
                description: "Review total and tap 'Pay' to complete your order",
                icon: "checkmark.circle.fill"
            )
        ]
    )

    static let orderConfirmation = HelpContent(
        title: "Order Confirmation",
        sections: [
            HelpSection(
                action: "Order ID",
                description: "Save your order ID for reference and tracking",
                icon: "number.circle.fill"
            ),
            HelpSection(
                action: "Estimated Time",
                description: "Your order will be ready at the estimated pickup time",
                icon: "clock.fill"
            ),
            HelpSection(
                action: "Notifications",
                description: "You'll receive updates about your order preparation and delivery",
                icon: "bell.fill"
            ),
            HelpSection(
                action: "Order Summary",
                description: "View complete details of your order including items and total",
                icon: "list.bullet.rectangle"
            )
        ]
    )

    static let vacuumService = HelpContent(
        title: "Vacuum Service - Area Selection",
        sections: [
            HelpSection(
                action: "View Seat Map",
                description: "See the bus layout with all available seats numbered 1-16",
                icon: "square.grid.3x3"
            ),
            HelpSection(
                action: "Select Seats",
                description: "Tap on seats to select areas for cleaning. Selected seats turn green",
                icon: "hand.tap.fill"
            ),
            HelpSection(
                action: "Legend",
                description: "White seats are available, green seats are selected for cleaning",
                icon: "square.on.square"
            ),
            HelpSection(
                action: "Selection Summary",
                description: "View count and list of selected seats below the map",
                icon: "list.number"
            ),
            HelpSection(
                action: "Continue",
                description: "Tap Continue to proceed to cleaning settings (requires at least one seat selected)",
                icon: "arrow.right.circle.fill"
            )
        ]
    )

    static let vacuumSettings = HelpContent(
        title: "Vacuum Settings",
        sections: [
            HelpSection(
                action: "Cleaning Mode",
                description: "Choose Standard (quick clean) or Deep Clean (thorough cleaning)",
                icon: "wand.and.stars"
            ),
            HelpSection(
                action: "Power Level",
                description: "Adjust suction power: Low (quiet), Medium (balanced), or High (maximum)",
                icon: "gauge.high"
            ),
            HelpSection(
                action: "Sanitization",
                description: "Enable deep clean with sanitization for extra hygiene",
                icon: "sparkles"
            ),
            HelpSection(
                action: "Duration",
                description: "Cleaning time depends on selected seats, mode, and power level",
                icon: "timer"
            ),
            HelpSection(
                action: "Start Cleaning",
                description: "Review settings and tap 'Start Cleaning' to begin the process",
                icon: "play.circle.fill"
            )
        ]
    )

    static let vacuumConfirmation = HelpContent(
        title: "Cleaning Progress",
        sections: [
            HelpSection(
                action: "Progress Monitoring",
                description: "Watch real-time progress with percentage completion and animated visual",
                icon: "chart.line.uptrend.xyaxis"
            ),
            HelpSection(
                action: "Current Status",
                description: "See which seat is being cleaned and current operation",
                icon: "info.circle.fill"
            ),
            HelpSection(
                action: "Service Details",
                description: "View service ID, cleaning mode, selected seats, and power level",
                icon: "doc.text.fill"
            ),
            HelpSection(
                action: "Lost Items",
                description: "If any items are found during cleaning, you'll be notified to alert the driver",
                icon: "exclamationmark.triangle.fill"
            ),
            HelpSection(
                action: "Completion",
                description: "After cleaning completes, tap Done to return home",
                icon: "checkmark.circle.fill"
            )
        ]
    )

    static let landmarks = HelpContent(
        title: "Nearby Landmarks",
        sections: [
            HelpSection(
                action: "Current Location",
                description: "View your current bus stop and number of landmarks nearby (within 1 km)",
                icon: "location.fill"
            ),
            HelpSection(
                action: "Search Landmarks",
                description: "Use the search bar to find specific landmarks by name or description",
                icon: "magnifyingglass"
            ),
            HelpSection(
                action: "Filter by Category",
                description: "Filter landmarks by type: Monuments, Museums, Parks, Historical Sites, Neighborhoods, or Viewpoints",
                icon: "line.3.horizontal.decrease.circle"
            ),
            HelpSection(
                action: "View Details",
                description: "Tap any landmark card to see full details, audio guide, map, and navigation",
                icon: "info.circle.fill"
            ),
            HelpSection(
                action: "Distance Information",
                description: "See distance from bus and recommended visit duration for each landmark",
                icon: "mappin.circle.fill"
            )
        ]
    )

    static let landmarkDetail = HelpContent(
        title: "Landmark Details",
        sections: [
            HelpSection(
                action: "Audio Guide",
                description: "Play detailed audio narration about the landmark's history and significance",
                icon: "play.circle.fill"
            ),
            HelpSection(
                action: "Full Description",
                description: "Read comprehensive information about the landmark, tap 'Read More' to expand",
                icon: "text.alignleft"
            ),
            HelpSection(
                action: "Interactive Map",
                description: "View landmark location on map with your current bus stop marked",
                icon: "map.fill"
            ),
            HelpSection(
                action: "Practical Info",
                description: "Check opening hours, entry fees, and recommended visit duration",
                icon: "info.circle.fill"
            ),
            HelpSection(
                action: "Walking Directions",
                description: "Get step-by-step walking directions from your current location",
                icon: "location.fill.viewfinder"
            )
        ]
    )

    static let touristNavigation = HelpContent(
        title: "Walking Navigation",
        sections: [
            HelpSection(
                action: "Route Overview",
                description: "View estimated walking time, distance, and map with start and end points",
                icon: "map.fill"
            ),
            HelpSection(
                action: "Turn-by-Turn Directions",
                description: "Tap 'Show Step-by-Step Directions' for detailed walking instructions",
                icon: "list.bullet"
            ),
            HelpSection(
                action: "Find Bus Stops",
                description: "Locate nearest bus stops when you're ready to rejoin the tour",
                icon: "bus.fill"
            ),
            HelpSection(
                action: "Navigation Steps",
                description: "Each step shows direction, distance, and visual icon for easy following",
                icon: "arrow.turn.up.right"
            )
        ]
    )

    static let nearbyBusStops = HelpContent(
        title: "Nearby Bus Stops",
        sections: [
            HelpSection(
                action: "Closest Stops",
                description: "View the 5 nearest bus stops sorted by distance from your location",
                icon: "bus.fill"
            ),
            HelpSection(
                action: "Distance & Time",
                description: "See walking distance and estimated time to reach each stop",
                icon: "figure.walk"
            ),
            HelpSection(
                action: "Return to Bus",
                description: "Select a stop to walk back and rejoin the Athens tour route",
                icon: "arrow.uturn.backward"
            )
        ]
    )

    static let driverDashboard = HelpContent(
        title: "Driver Assistance System",
        sections: [
            HelpSection(
                action: "Active Alerts",
                description: "View real-time safety alerts prioritized by severity. Tap X to dismiss alerts",
                icon: "exclamationmark.triangle.fill"
            ),
            HelpSection(
                action: "Speed Monitoring",
                description: "Monitor current speed vs. limit. Visual and audio alerts when exceeding speed limit",
                icon: "speedometer"
            ),
            HelpSection(
                action: "Lane Position",
                description: "Real-time lane positioning shows if vehicle is drifting from center",
                icon: "road.lanes"
            ),
            HelpSection(
                action: "Fatigue Detection",
                description: "System tracks driving duration and alerts when break is needed",
                icon: "bed.double.fill"
            ),
            HelpSection(
                action: "Passenger Safety",
                description: "Alerts if passengers are still boarding to prevent premature door closing",
                icon: "figure.walk.motion"
            ),
            HelpSection(
                action: "Alert History",
                description: "Review past safety alerts with timestamps for reporting and analysis",
                icon: "clock.arrow.circlepath"
            )
        ]
    )

    static let climateControl = HelpContent(
        title: "Climate Control",
        sections: [
            HelpSection(
                action: "Outdoor Weather",
                description: "View current outdoor temperature, humidity, wind speed, and conditions in Athens",
                icon: "cloud.sun.fill"
            ),
            HelpSection(
                action: "Indoor Temperature",
                description: "Monitor current bus interior temperature with visual gauge",
                icon: "thermometer.medium"
            ),
            HelpSection(
                action: "Climate Modes",
                description: "Select Auto, Cooling, Heating, or Off mode based on conditions and preference",
                icon: "arrow.triangle.2.circlepath"
            ),
            HelpSection(
                action: "Target Temperature",
                description: "Adjust desired temperature between 16°C and 30°C using slider or +/- buttons",
                icon: "slider.horizontal.3"
            ),
            HelpSection(
                action: "Fan Speed",
                description: "Control fan speed: Off, Low, Medium, or High to adjust cooling/heating rate",
                icon: "fan.fill"
            ),
            HelpSection(
                action: "Auto Recommendations",
                description: "System suggests optimal mode and temperature based on outdoor weather",
                icon: "lightbulb.fill"
            )
        ]
    )

    static let roofControl = HelpContent(
        title: "Roof Management",
        sections: [
            HelpSection(
                action: "Weather Status",
                description: "Current weather conditions affect roof operation. Roof cannot open during rain",
                icon: "cloud.sun.fill"
            ),
            HelpSection(
                action: "Roof Visualization",
                description: "Animated visual shows roof position and opening percentage in real-time",
                icon: "rectangle"
            ),
            HelpSection(
                action: "Open/Close Controls",
                description: "Use buttons to control roof movement. Buttons disabled when action not available",
                icon: "hand.tap.fill"
            ),
            HelpSection(
                action: "Solar Performance",
                description: "Monitor photovoltaic panel efficiency, output power, and total energy generated",
                icon: "sun.max.fill"
            ),
            HelpSection(
                action: "Safety Checks",
                description: "System prevents opening roof in rain and tracks operational status",
                icon: "checkmark.shield.fill"
            )
        ]
    )

    static let energyDashboard = HelpContent(
        title: "Energy Dashboard",
        sections: [
            HelpSection(
                action: "Quick Stats",
                description: "View solar generation, total consumption, and net energy at a glance",
                icon: "chart.bar.fill"
            ),
            HelpSection(
                action: "Battery Status",
                description: "Monitor battery charge level, capacity, health, and estimated operating range",
                icon: "battery.100"
            ),
            HelpSection(
                action: "Energy History",
                description: "Interactive chart shows solar generation vs consumption over time",
                icon: "chart.xyaxis.line"
            ),
            HelpSection(
                action: "System Breakdown",
                description: "Detailed view of energy consumption by system: propulsion, climate, lighting, etc.",
                icon: "list.bullet"
            ),
            HelpSection(
                action: "Efficiency Metrics",
                description: "Track solar efficiency, battery health, total generation, and self-sufficiency percentage",
                icon: "gauge.high"
            ),
            HelpSection(
                action: "Time Ranges",
                description: "Switch between 10 min, 30 min, and 1 hour views for historical data",
                icon: "clock.fill"
            )
        ]
    )
}
