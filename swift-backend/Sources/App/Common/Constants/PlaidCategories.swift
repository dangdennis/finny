struct PlaidCategoryKey: Hashable {
    let category: String
    let subcategory: String
}

typealias PlaidCategoryDict = [PlaidCategoryKey: String]

let PLAID_CATEGORIES: PlaidCategoryDict = [
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_DIVIDENDS"):
        "Dividends from investment accounts",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_INTEREST_EARNED"):
        "Income from interest on savings accounts",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_RETIREMENT_PENSION"):
        "Income from pension payments ",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_TAX_REFUND"):
        "Income from tax refunds",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_UNEMPLOYMENT"):
        "Income from unemployment benefits, including unemployment insurance and healthcare",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_WAGES"):
        "Income from salaries, gig-economy work, and tips earned",
    PlaidCategoryKey(category: "INCOME", subcategory: "INCOME_OTHER_INCOME"):
        "Other miscellaneous income, including alimony, social security, child support, and rental",
    PlaidCategoryKey(category: "TRANSFER_IN", subcategory: "TRANSFER_IN_CASH_ADVANCES_AND_LOANS"):
        "Loans and cash advances deposited into a bank account",
    PlaidCategoryKey(category: "TRANSFER_IN", subcategory: "TRANSFER_IN_DEPOSIT"):
        "Cash, checks, and ATM deposits into a bank account",
    PlaidCategoryKey(
        category: "TRANSFER_IN", subcategory: "TRANSFER_IN_INVESTMENT_AND_RETIREMENT_FUNDS"):
        "Inbound transfers to an investment or retirement account",
    PlaidCategoryKey(category: "TRANSFER_IN", subcategory: "TRANSFER_IN_SAVINGS"):
        "Inbound transfers to a savings account",
    PlaidCategoryKey(category: "TRANSFER_IN", subcategory: "TRANSFER_IN_ACCOUNT_TRANSFER"):
        "General inbound transfers from another account",
    PlaidCategoryKey(category: "TRANSFER_IN", subcategory: "TRANSFER_IN_OTHER_TRANSFER_IN"):
        "Other miscellaneous inbound transactions",
    PlaidCategoryKey(
        category: "TRANSFER_OUT", subcategory: "TRANSFER_OUT_INVESTMENT_AND_RETIREMENT_FUNDS"):
        "Transfers to an investment or retirement account, including investment apps such as Acorns, Betterment",
    PlaidCategoryKey(category: "TRANSFER_OUT", subcategory: "TRANSFER_OUT_SAVINGS"):
        "Outbound transfers to savings accounts",
    PlaidCategoryKey(category: "TRANSFER_OUT", subcategory: "TRANSFER_OUT_WITHDRAWAL"):
        "Withdrawals from a bank account",
    PlaidCategoryKey(category: "TRANSFER_OUT", subcategory: "TRANSFER_OUT_ACCOUNT_TRANSFER"):
        "General outbound transfers to another account",
    PlaidCategoryKey(category: "TRANSFER_OUT", subcategory: "TRANSFER_OUT_OTHER_TRANSFER_OUT"):
        "Other miscellaneous outbound transactions",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_CAR_PAYMENT"):
        "Car loans and leases",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_CREDIT_CARD_PAYMENT"):
        "Payments to a credit card. These are positive amounts for credit card subtypes and negative for depository subtypes",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_PERSONAL_LOAN_PAYMENT"):
        "Personal loans, including cash advances and buy now pay later repayments",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_MORTGAGE_PAYMENT"):
        "Payments on mortgages",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_STUDENT_LOAN_PAYMENT"):
        "Payments on student loans. For college tuition, refer to General Services - Education",
    PlaidCategoryKey(category: "LOAN_PAYMENTS", subcategory: "LOAN_PAYMENTS_OTHER_PAYMENT"):
        "Other miscellaneous debt payments",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_ATM_FEES"):
        "Fees incurred for out-of-network ATMs",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_FOREIGN_TRANSACTION_FEES"):
        "Fees incurred on non-domestic transactions",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_INSUFFICIENT_FUNDS"):
        "Fees relating to insufficient funds",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_INTEREST_CHARGE"):
        "Fees incurred for interest on purchases, including not-paid-in-full or interest on cash advances",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_OVERDRAFT_FEES"):
        "Fees incurred when an account is in overdraft",
    PlaidCategoryKey(category: "BANK_FEES", subcategory: "BANK_FEES_OTHER_BANK_FEES"):
        "Other miscellaneous bank fees",
    PlaidCategoryKey(category: "ENTERTAINMENT", subcategory: "ENTERTAINMENT_CASINOS_AND_GAMBLING"):
        "Gambling, casinos, and sports betting",
    PlaidCategoryKey(category: "ENTERTAINMENT", subcategory: "ENTERTAINMENT_MUSIC_AND_AUDIO"):
        "Digital and in-person music purchases, including music streaming services",
    PlaidCategoryKey(
        category: "ENTERTAINMENT",
        subcategory: "ENTERTAINMENT_SPORTING_EVENTS_AMUSEMENT_PARKS_AND_MUSEUMS"):
        "Purchases made at sporting events, music venues, concerts, museums, and amusement parks",
    PlaidCategoryKey(category: "ENTERTAINMENT", subcategory: "ENTERTAINMENT_TV_AND_MOVIES"):
        "In home movie streaming services and movie theaters",
    PlaidCategoryKey(category: "ENTERTAINMENT", subcategory: "ENTERTAINMENT_VIDEO_GAMES"):
        "Digital and in-person video game purchases",
    PlaidCategoryKey(category: "ENTERTAINMENT", subcategory: "ENTERTAINMENT_OTHER_ENTERTAINMENT"):
        "Other miscellaneous entertainment purchases, including night life and adult entertainment",
    PlaidCategoryKey(
        category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_BEER_WINE_AND_LIQUOR"):
        "Beer, Wine & Liquor Stores",
    PlaidCategoryKey(category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_COFFEE"):
        "Purchases at coffee shops or cafes",
    PlaidCategoryKey(category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_FAST_FOOD"):
        "Dining expenses for fast food chains",
    PlaidCategoryKey(category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_GROCERIES"):
        "Purchases for fresh produce and groceries, including farmers' markets",
    PlaidCategoryKey(category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_RESTAURANT"):
        "Dining expenses for restaurants, bars, gastropubs, and diners",
    PlaidCategoryKey(category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_VENDING_MACHINES"):
        "Purchases made at vending machine operators",
    PlaidCategoryKey(
        category: "FOOD_AND_DRINK", subcategory: "FOOD_AND_DRINK_OTHER_FOOD_AND_DRINK"):
        "Other miscellaneous food and drink, including desserts, juice bars, and delis",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE",
        subcategory: "GENERAL_MERCHANDISE_BOOKSTORES_AND_NEWSSTANDS"):
        "Books, magazines, and news ",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_CLOTHING_AND_ACCESSORIES"
    ):
        "Apparel, shoes, and jewelry",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_CONVENIENCE_STORES"):
        "Purchases at convenience stores",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_DEPARTMENT_STORES"):
        "Retail stores with wide ranges of consumer goods, typically specializing in clothing and home goods",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_DISCOUNT_STORES"):
        "Stores selling goods at a discounted price",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_ELECTRONICS"):
        "Electronics stores and websites",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_GIFTS_AND_NOVELTIES"):
        "Photo, gifts, cards, and floral stores",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_OFFICE_SUPPLIES"):
        "Stores that specialize in office goods",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_ONLINE_MARKETPLACES"):
        "Multi-purpose e-commerce platforms such as Etsy, Ebay and Amazon",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_PET_SUPPLIES"):
        "Pet supplies and pet food",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_SPORTING_GOODS"):
        "Sporting goods, camping gear, and outdoor equipment",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_SUPERSTORES"):
        "Superstores such as Target and Walmart, selling both groceries and general merchandise",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE", subcategory: "GENERAL_MERCHANDISE_TOBACCO_AND_VAPE"):
        "Purchases for tobacco and vaping products",
    PlaidCategoryKey(
        category: "GENERAL_MERCHANDISE",
        subcategory: "GENERAL_MERCHANDISE_OTHER_GENERAL_MERCHANDISE"):
        "Other miscellaneous merchandise, including toys, hobbies, and arts and crafts",
    PlaidCategoryKey(category: "HOME_IMPROVEMENT", subcategory: "HOME_IMPROVEMENT_FURNITURE"):
        "Furniture, bedding, and home accessories",
    PlaidCategoryKey(category: "HOME_IMPROVEMENT", subcategory: "HOME_IMPROVEMENT_HARDWARE"):
        "Building materials, hardware stores, paint, and wallpaper",
    PlaidCategoryKey(
        category: "HOME_IMPROVEMENT", subcategory: "HOME_IMPROVEMENT_REPAIR_AND_MAINTENANCE"):
        "Plumbing, lighting, gardening, and roofing",
    PlaidCategoryKey(category: "HOME_IMPROVEMENT", subcategory: "HOME_IMPROVEMENT_SECURITY"):
        "Home security system purchases",
    PlaidCategoryKey(
        category: "HOME_IMPROVEMENT", subcategory: "HOME_IMPROVEMENT_OTHER_HOME_IMPROVEMENT"):
        "Other miscellaneous home purchases, including pool installation and pest control",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_DENTAL_CARE"):
        "Dentists and general dental care",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_EYE_CARE"):
        "Optometrists, contacts, and glasses stores",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_NURSING_CARE"):
        "Nursing care and facilities",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_PHARMACIES_AND_SUPPLEMENTS"):
        "Pharmacies and nutrition shops",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_PRIMARY_CARE"):
        "Doctors and physicians",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_VETERINARY_SERVICES"):
        "Prevention and care procedures for animals",
    PlaidCategoryKey(category: "MEDICAL", subcategory: "MEDICAL_OTHER_MEDICAL"):
        "Other miscellaneous medical, including blood work, hospitals, and ambulances",
    PlaidCategoryKey(
        category: "PERSONAL_CARE", subcategory: "PERSONAL_CARE_GYMS_AND_FITNESS_CENTERS"):
        "Gyms, fitness centers, and workout classes",
    PlaidCategoryKey(category: "PERSONAL_CARE", subcategory: "PERSONAL_CARE_HAIR_AND_BEAUTY"):
        "Manicures, haircuts, waxing, spa/massages, and bath and beauty products ",
    PlaidCategoryKey(
        category: "PERSONAL_CARE", subcategory: "PERSONAL_CARE_LAUNDRY_AND_DRY_CLEANING"):
        "Wash and fold, and dry cleaning expenses",
    PlaidCategoryKey(category: "PERSONAL_CARE", subcategory: "PERSONAL_CARE_OTHER_PERSONAL_CARE"):
        "Other miscellaneous personal care, including mental health apps and services",
    PlaidCategoryKey(
        category: "GENERAL_SERVICES",
        subcategory: "GENERAL_SERVICES_ACCOUNTING_AND_FINANCIAL_PLANNING"):
        "Financial planning, and tax and accounting services",
    PlaidCategoryKey(category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_AUTOMOTIVE"):
        "Oil changes, car washes, repairs, and towing",
    PlaidCategoryKey(category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_CHILDCARE"):
        "Babysitters and daycare",
    PlaidCategoryKey(
        category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_CONSULTING_AND_LEGAL"):
        "Consulting and legal services",
    PlaidCategoryKey(category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_EDUCATION"):
        "Elementary, high school, professional schools, and college tuition",
    PlaidCategoryKey(category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_INSURANCE"):
        "Insurance for auto, home, and healthcare",
    PlaidCategoryKey(
        category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_POSTAGE_AND_SHIPPING"):
        "Mail, packaging, and shipping services",
    PlaidCategoryKey(category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_STORAGE"):
        "Storage services and facilities",
    PlaidCategoryKey(
        category: "GENERAL_SERVICES", subcategory: "GENERAL_SERVICES_OTHER_GENERAL_SERVICES"):
        "Other miscellaneous services, including advertising and cloud storage ",
    PlaidCategoryKey(
        category: "GOVERNMENT_AND_NON_PROFIT", subcategory: "GOVERNMENT_AND_NON_PROFIT_DONATIONS"):
        "Charitable, political, and religious donations",
    PlaidCategoryKey(
        category: "GOVERNMENT_AND_NON_PROFIT",
        subcategory: "GOVERNMENT_AND_NON_PROFIT_GOVERNMENT_DEPARTMENTS_AND_AGENCIES"):
        "Government departments and agencies, such as driving licences, and passport renewal",
    PlaidCategoryKey(
        category: "GOVERNMENT_AND_NON_PROFIT", subcategory: "GOVERNMENT_AND_NON_PROFIT_TAX_PAYMENT"):
        "Tax payments, including income and property taxes",
    PlaidCategoryKey(
        category: "GOVERNMENT_AND_NON_PROFIT",
        subcategory: "GOVERNMENT_AND_NON_PROFIT_OTHER_GOVERNMENT_AND_NON_PROFIT"):
        "Other miscellaneous government and non-profit agencies",
    PlaidCategoryKey(category: "TRANSPORTATION", subcategory: "TRANSPORTATION_BIKES_AND_SCOOTERS"):
        "Bike and scooter rentals",
    PlaidCategoryKey(category: "TRANSPORTATION", subcategory: "TRANSPORTATION_GAS"):
        "Purchases at a gas station",
    PlaidCategoryKey(category: "TRANSPORTATION", subcategory: "TRANSPORTATION_PARKING"):
        "Parking fees and expenses",
    PlaidCategoryKey(category: "TRANSPORTATION", subcategory: "TRANSPORTATION_PUBLIC_TRANSIT"):
        "Public transportation, including rail and train, buses, and metro",
    PlaidCategoryKey(
        category: "TRANSPORTATION", subcategory: "TRANSPORTATION_TAXIS_AND_RIDE_SHARES"):
        "Taxi and ride share services",
    PlaidCategoryKey(category: "TRANSPORTATION", subcategory: "TRANSPORTATION_TOLLS"):
        "Toll expenses",
    PlaidCategoryKey(
        category: "TRANSPORTATION", subcategory: "TRANSPORTATION_OTHER_TRANSPORTATION"):
        "Other miscellaneous transportation expenses",
    PlaidCategoryKey(category: "TRAVEL", subcategory: "TRAVEL_FLIGHTS"): "Airline expenses",
    PlaidCategoryKey(category: "TRAVEL", subcategory: "TRAVEL_LODGING"):
        "Hotels, motels, and hosted accommodation such as Airbnb",
    PlaidCategoryKey(category: "TRAVEL", subcategory: "TRAVEL_RENTAL_CARS"):
        "Rental cars, charter buses, and trucks",
    PlaidCategoryKey(category: "TRAVEL", subcategory: "TRAVEL_OTHER_TRAVEL"):
        "Other miscellaneous travel expenses",
    PlaidCategoryKey(
        category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_GAS_AND_ELECTRICITY"):
        "Gas and electricity bills",
    PlaidCategoryKey(
        category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_INTERNET_AND_CABLE"):
        "Internet and cable bills",
    PlaidCategoryKey(category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_RENT"):
        "Rent payment",
    PlaidCategoryKey(
        category: "RENT_AND_UTILITIES",
        subcategory: "RENT_AND_UTILITIES_SEWAGE_AND_WASTE_MANAGEMENT"):
        "Sewage and garbage disposal bills",
    PlaidCategoryKey(category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_TELEPHONE"):
        "Cell phone bills",
    PlaidCategoryKey(category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_WATER"):
        "Water bills",
    PlaidCategoryKey(
        category: "RENT_AND_UTILITIES", subcategory: "RENT_AND_UTILITIES_OTHER_UTILITIES"):
        "Other miscellaneous utility bills",
]
