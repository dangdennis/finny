import 'dart:convert';

class Institution {
  final List<String> countryCodes;
  final String institutionId;
  final String name;
  final bool oauth;
  final List<String> products;
  final List<String> routingNumbers;

  Institution({
    required this.countryCodes,
    required this.institutionId,
    required this.name,
    required this.oauth,
    required this.products,
    required this.routingNumbers,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      countryCodes: List<String>.from(json['country_codes']),
      institutionId: json['institution_id'],
      name: json['name'],
      oauth: json['oauth'],
      products: List<String>.from(json['products']),
      routingNumbers: List<String>.from(json['routing_numbers']),
    );
  }
}

Map<String, Institution> createInstitutions() {
  final jsonList = jsonDecode(institutionsJson)['institutions'];
  return {
    for (var item in jsonList)
      item['institution_id'] as String: Institution.fromJson(item)
  };
}

final institutions = createInstitutions();

const institutionsJson = """
{
    "institutions": [
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0235"
            ],
            "institution_id": "ins_115617",
            "name": "Wealthfront",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "pay_by_bank",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "044111191",
                "061120000",
                "096017418",
                "124085024",
                "124302529",
                "124303120",
                "124303214",
                "124303230",
                "124303269"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130958",
            "name": "Bridge",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130347",
            "name": "Chiphone Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "271290597"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130253",
            "name": "Conservation Employees Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity",
                "processor_payments",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "286580807"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130358",
            "name": "Equitable Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "304971932"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130332",
            "name": "First Community Bank & Trust (IL) - Personal",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129736",
            "name": "First National Bank of Pana",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "071103509"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130088",
            "name": "GW Wade - MyStreetscape",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130479",
            "name": "L.C.E. Credit Union",
            "oauth": false,
            "products": [
                "balance",
                "transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129920",
            "name": "National Bank of St. Anne",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "071922337"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130242",
            "name": "Ocala Community Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "263181151"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129756",
            "name": "Shell Western States Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "321173218"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130084",
            "name": "TFNB",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "111904480"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131862",
            "name": "A+ Federal Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "314977104"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130217",
            "name": "Ally Bank - Home Loan",
            "oauth": false,
            "products": [
                "balance",
                "identity_match",
                "identity",
                "liabilities"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_25",
            "name": "Ally Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031176136",
                "124003116",
                "124085011"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131968",
            "name": "AngelList Stack",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115054",
            "name": "Bank of Clarkson",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "083904660"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129571",
            "name": "Bank21",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101908988"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131957",
            "name": "Benepass",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051409702"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129570",
            "name": "card.com - Premium Bank Account",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073972181"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_35",
            "name": "Chime",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031101169",
                "031101279",
                "103100195",
                "103113357"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132254",
            "name": "Citizens Bank (Amsterdam, MO)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101217514"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131894",
            "name": "Citizens Bank Of Chatsworth (IL)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "071108313"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130022",
            "name": "Clair",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073972181",
                "273070278"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129892",
            "name": "Community Bank (Wichita, KS)",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101114879"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131939",
            "name": "Creative Juice",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129272",
            "name": "Cred",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031101059",
                "031901097",
                "031908485",
                "031976200",
                "036002069",
                "036076299",
                "231371964",
                "231375096",
                "236074156",
                "236075689"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116949",
            "name": "Discover - Student Loans",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_33",
            "name": "Discover",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031100649"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109535",
            "name": "Educational Employees Credit Union (EECU)",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "321172594"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131986",
            "name": "Ellis",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130962",
            "name": "Enzo",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114115",
            "name": "Farmers & Merchants Bank (ME Banking) - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "082901033",
                "082901619",
                "082907477",
                "084102979"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_118597",
            "name": "Fifth Third Bank - Securities",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2116"
            ],
            "institution_id": "ins_26",
            "name": "Fifth Third Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "041002711",
                "041200050",
                "042000314",
                "042100230",
                "042100272",
                "042101190",
                "042202196",
                "042207735",
                "043018868",
                "044002161",
                "044002679",
                "051504665",
                "053100737",
                "053104843",
                "053111658",
                "053111726",
                "053111849",
                "053111991",
                "061119422",
                "063103915",
                "063109935",
                "063113057",
                "063115738",
                "064103833",
                "064108757",
                "067013700",
                "067091719",
                "071000343",
                "071001737",
                "071002419",
                "071002503",
                "071004161",
                "071025849",
                "071121471",
                "071214126",
                "071900799",
                "071903123",
                "071905985",
                "071906641",
                "071909062",
                "071909211",
                "071909240",
                "071909253",
                "071916408",
                "071917232",
                "071920957",
                "071921244",
                "071922298",
                "071922340",
                "071922421",
                "071922476",
                "071923190",
                "071923255",
                "071923310",
                "071923323",
                "071923909",
                "071925046",
                "071925130",
                "071925156",
                "071925169",
                "071925350",
                "071925716",
                "071926252",
                "072400052",
                "072400447",
                "072401404",
                "072401608",
                "072401682",
                "072401831",
                "072402034",
                "072402115",
                "072402348",
                "072402364",
                "072402704",
                "072402788",
                "072403907",
                "072404841",
                "072405455",
                "072405662",
                "072408504",
                "072409888",
                "072411643",
                "072413175",
                "072413298",
                "074906826",
                "074908594",
                "081019104",
                "081309364",
                "083002342",
                "083902374",
                "083905449",
                "083913949",
                "086300041",
                "122244184",
                "236074732",
                "242071758",
                "242272188",
                "242272447",
                "242272968",
                "253070201",
                "253170282",
                "263190812",
                "271070733",
                "271071169",
                "271071295",
                "271970147",
                "271971829",
                "271973403",
                "271973487",
                "272471438",
                "274970937"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130978",
            "name": "First Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "103104120"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116525",
            "name": "First Hawaiian Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "121301015",
                "121403065",
                "121405238"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131858",
            "name": "First National Bank (Manning, IA)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073904890"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131827",
            "name": "First New Mexico Bank - Las Cruces, NM",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "112207335"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131893",
            "name": "First New Mexico Bank - Deming, NM",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "112202372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132150",
            "name": "First State Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "083901210",
                "083903564"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129418",
            "name": "Found",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021414125",
                "026015053",
                "121145307",
                "211075086"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131512",
            "name": "Freedom Bank (Elkader, IA)",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073913218"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131902",
            "name": "Fundbox",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073972181",
                "124384974"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132201",
            "name": "Fundomate",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_127892",
            "name": "GO2bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "deposit_switch",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "124303162"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132109",
            "name": "Grant County Bank - Ulysses, KS",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101109648"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130054",
            "name": "Hightop",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "084106768"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2305"
            ],
            "institution_id": "ins_21",
            "name": "Huntington Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "041000153",
                "041200555",
                "041215016",
                "041215032",
                "042015422",
                "042100191",
                "042101459",
                "042107602",
                "042215060",
                "044000024",
                "044108641",
                "044115090",
                "044115126",
                "051903761",
                "057000697",
                "072400528",
                "072403473",
                "072409464",
                "072410013",
                "072413900",
                "072414255",
                "074000078",
                "074905173",
                "107006444",
                "122106183",
                "241271957",
                "271972572",
                "272471548",
                "272471551",
                "275071385",
                "291070001"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_113806",
            "name": "Idaho Central Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "324172708",
                "324173626"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131815",
            "name": "Invoice2go Money",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132255",
            "name": "Ivella",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130259",
            "name": "Jelli",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026014928"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109701",
            "name": "Jovia Financial Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026084602",
                "221480807"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_127953",
            "name": "KeyBank - Key2Benefits",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2205"
            ],
            "institution_id": "ins_29",
            "name": "KeyBank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011200022",
                "011200608",
                "011402008",
                "011807043",
                "021110209",
                "021300077",
                "021300381",
                "021300556",
                "021313569",
                "021372953",
                "021905977",
                "021906934",
                "022000839",
                "022072692",
                "031302803",
                "031305253",
                "031911812",
                "031918527",
                "041001039",
                "041002957",
                "041200089",
                "041200775",
                "041201703",
                "041207040",
                "042200295",
                "044000642",
                "067014181",
                "071200538",
                "072401048",
                "074001048",
                "123002011",
                "124000737",
                "124101555",
                "124303007",
                "125000574",
                "125200879",
                "125200947",
                "211170130",
                "211170185",
                "211174369",
                "211672531",
                "221370616",
                "222370440",
                "231372170",
                "231375575",
                "307070267"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131976",
            "name": "Levro",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372",
                "064209588"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_126340",
            "name": "Lili",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "091017138",
                "091302966",
                "091311229",
                "091311232",
                "096001013"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132134",
            "name": "Lincoln Federal Savings Bank of Nebraska",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "304971990"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110464",
            "name": "Lincoln Savings Bank (IA) - Online Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073905527",
                "073923033",
                "073923114",
                "073923127"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_27",
            "name": "M&T Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011104131",
                "011104199",
                "011110633",
                "011110646",
                "011175319",
                "011201432",
                "011201500",
                "011201526",
                "011302616",
                "011302768",
                "011307116",
                "011401876",
                "011401960",
                "011600062",
                "011600486",
                "011600622",
                "011601265",
                "011802488",
                "021300336",
                "021302978",
                "021405464",
                "021408597",
                "021906471",
                "021907577",
                "022000046",
                "031100092",
                "031100173",
                "031300834",
                "031301192",
                "031301532",
                "031302955",
                "031304720",
                "031318619",
                "031901929",
                "051008828",
                "052000113",
                "052000634",
                "052100408",
                "052173464",
                "052204346",
                "055000110",
                "055073532",
                "056005363",
                "056009233",
                "211072911",
                "211170169",
                "211170318",
                "211170334",
                "211170347",
                "211174194",
                "211371162",
                "211371434",
                "211371764",
                "211372129",
                "211373542",
                "211373623",
                "211470115",
                "211470186",
                "211672722",
                "211770161",
                "211871154",
                "211872027",
                "211973049",
                "221172186",
                "221272316",
                "221272374",
                "221370108",
                "221370632",
                "221371165",
                "221972085",
                "221972153",
                "231375520",
                "251472636",
                "252070435",
                "252070817",
                "252073018",
                "255072317",
                "255072427",
                "256073302",
                "256073373"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131989",
            "name": "MIDFLORIDA Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "063114360",
                "263177547",
                "263177563",
                "263179804",
                "263182671",
                "263189218",
                "267083239"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130955",
            "name": "MoneyLion - RoarMoney",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073972181"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131897",
            "name": "Mos",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115035",
            "name": "Mountain Valley Bank (Dunlap, TN)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "064103697"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_125686",
            "name": "Mountain Valley Bank (Walden, CO)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "102104846",
                "107006389"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131089",
            "name": "Moves",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_15",
            "name": "Navy Federal Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "114017714",
                "256074974"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129579",
            "name": "Nearside Business Checking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026015121",
                "211075086"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131973",
            "name": "Novel",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "022315207",
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129417",
            "name": "ONE",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "125108405",
                "125108997",
                "125109006",
                "125109019",
                "125109022"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_118390",
            "name": "Oxygen",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031101114",
                "031101169",
                "031101279",
                "031302696",
                "031307688",
                "031919225",
                "114924742",
                "236070545"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_22",
            "name": "PayPal",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132135",
            "name": "Prime Alliance Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "124303081"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111436",
            "name": "Qualstar Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "325081966"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115686",
            "name": "Randolph Brooks Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "314088239",
                "314088705",
                "314089681"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131919",
            "name": "Sagewell",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "091311229"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132257",
            "name": "Security Bank Midwest",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "091408695"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_36",
            "name": "State Employees' Credit Union (NC)",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "253177049"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129591",
            "name": "The Bank (Oberlin, KS)",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101105969"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111611",
            "name": "The Commercial & Savings Bank (Millersburg, OH)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "041206135",
                "041215825",
                "241271135"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132204",
            "name": "The Farmers Savings Bank (Spencer, OH)",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "041211609"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132117",
            "name": "Tri-Valley Bank - Randolph, IA",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "104919275"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130966",
            "name": "Tribevest",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0642"
            ],
            "institution_id": "ins_129907",
            "name": "UBS - Online Services",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "investments",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_7",
            "name": "USAA",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "122487129",
                "314074269"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132285",
            "name": "WaFd Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "312270450",
                "321181297",
                "324170085",
                "325070980",
                "325170631"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130957",
            "name": "Wethos",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051402372"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_32",
            "name": "Woodforest National Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031319058",
                "044115809",
                "053112592",
                "071926809",
                "081226829",
                "113001394",
                "113008465",
                "113023136",
                "113111909",
                "314972853"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131926",
            "name": "X1 Card",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111573",
            "name": "Y-12 Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "264281432"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129896",
            "name": "Zeta",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026015053",
                "211075086"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2104"
            ],
            "institution_id": "ins_113973",
            "name": "Zions Bank",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "122237625",
                "124000054",
                "124002829",
                "124101128",
                "124301850"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129642",
            "name": "Zions Bank - Mortgage",
            "oauth": false,
            "products": [
                "balance",
                "liabilities"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111972",
            "name": "Arvest Bank - Online Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "082900872",
                "082904991",
                "082908816",
                "084101514",
                "101289432",
                "103112976"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_128026",
            "name": "Capital One",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021200407",
                "021407912",
                "021408704",
                "021409567",
                "026011507",
                "031176110",
                "051405515",
                "056009482",
                "056073502",
                "056073612",
                "065000090",
                "065001426",
                "065002030",
                "065002548",
                "065200188",
                "065200243",
                "065200722",
                "065201064",
                "065202791",
                "065204760",
                "065400140",
                "065400687",
                "065400755",
                "065400894",
                "065401000",
                "065401246",
                "065402313",
                "065402339",
                "065402494",
                "065404418",
                "065405132",
                "065405145",
                "111101157",
                "111101461",
                "111104507",
                "111104785",
                "111104798",
                "111104853",
                "111104879",
                "111104947",
                "111900455",
                "111901014",
                "111915709",
                "113024915",
                "113101809",
                "211170363",
                "221471227",
                "221471858",
                "221472776",
                "226070555",
                "226070652",
                "226070856",
                "226072375",
                "255071981",
                "313072819",
                "313173349"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_101550",
            "name": "ESL Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "222371863"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110603",
            "name": "ESL Federal Credit Union - Business",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "222371863"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110938",
            "name": "First National Bank Texas & First Convenience Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "111906271",
                "111926057",
                "113010217",
                "122106455"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_118197",
            "name": "Green Dot Prepaid Debit Card",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021214891",
                "041215663",
                "044111191",
                "053902197",
                "061120000",
                "073972181",
                "084106768",
                "096017418",
                "101019521",
                "103100195",
                "124085024",
                "124302529",
                "124303104",
                "124303120",
                "124303162",
                "124303214",
                "124303230",
                "124303269"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130973",
            "name": "Hancock Whitney",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "062205610",
                "063112786",
                "063206139",
                "063209505",
                "065000171",
                "065005435",
                "065104116",
                "065106619",
                "065201585",
                "065201611",
                "065203224",
                "065203431",
                "065303771",
                "065400153",
                "065401505",
                "065503681",
                "111017827",
                "111102842",
                "113000968",
                "113123447",
                "263290220",
                "265070516",
                "265070736"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117706",
            "name": "Local Government Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments"
            ],
            "routing_numbers": [
                "253176901",
                "253184537"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116953",
            "name": "Netspend All-Access Account by MetaBank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026013356",
                "031101114",
                "031101169",
                "031101279",
                "031302696",
                "031307688",
                "031919225",
                "041215663",
                "042287027",
                "044111191",
                "053101561",
                "062202150",
                "063106750",
                "063192926",
                "063192971",
                "067011294",
                "071922476",
                "072413764",
                "073923033",
                "073972181",
                "083001314",
                "083901809",
                "084003997",
                "091016993",
                "091017620",
                "091409843",
                "091409869",
                "101089742",
                "103100195",
                "103113357",
                "111000025",
                "114924742",
                "122287675",
                "124085244",
                "124303120",
                "125108997",
                "236070545",
                "264171241",
                "273070278",
                "273970116",
                "283972036",
                "291471024"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_113976",
            "name": "OnPoint Community Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "323075880"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2616"
            ],
            "institution_id": "ins_13",
            "name": "PNC",
            "oauth": true,
            "products": [
                "assets",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "021200012",
                "021200575",
                "021201943",
                "021202191",
                "021202311",
                "021202447",
                "031000053",
                "031001175",
                "031100089",
                "031100490",
                "031203999",
                "031205913",
                "031207607",
                "031300012",
                "031300562",
                "031302447",
                "031306100",
                "031307426",
                "031307604",
                "031312738",
                "031313562",
                "031316967",
                "031902766",
                "041000124",
                "041001246",
                "041200144",
                "041203895",
                "041204166",
                "041211298",
                "041213814",
                "042000398",
                "042000424",
                "042100049",
                "042100188",
                "042104249",
                "042200279",
                "042202426",
                "043000096",
                "043000122",
                "043002900",
                "043300738",
                "043305131",
                "044000011",
                "051401331",
                "051403517",
                "051403630",
                "051403915",
                "051404118",
                "052000618",
                "052100547",
                "052100725",
                "052100893",
                "052100929",
                "052101106",
                "052101588",
                "052102215",
                "052102590",
                "053100850",
                "054000030",
                "055000262",
                "055000288",
                "055000372",
                "055000657",
                "055000770",
                "055001054",
                "055001122",
                "055001384",
                "055001698",
                "055001766",
                "055001876",
                "055002244",
                "055002286",
                "055002558",
                "056004720",
                "056008852",
                "061103360",
                "061119639",
                "061192630",
                "061203257",
                "062001186",
                "062001209",
                "062200880",
                "062201164",
                "062201601",
                "062202082",
                "062203298",
                "062205665",
                "062205908",
                "063013924",
                "063110791",
                "063114386",
                "063114548",
                "063114632",
                "063114784",
                "063214312",
                "065103625",
                "065103887",
                "067003671",
                "067012057",
                "067012882",
                "067014194",
                "071001630",
                "071100049",
                "071100706",
                "071201647",
                "071921891",
                "072000915",
                "072400353",
                "072400421",
                "072400670",
                "072401006",
                "072401585",
                "072402199",
                "072412176",
                "074000065",
                "074000515",
                "074900194",
                "074912577",
                "074912988",
                "081000702",
                "081000728",
                "081001727",
                "081004517",
                "081010860",
                "083000056",
                "083000108",
                "083000920",
                "083009060",
                "083902154",
                "107000783",
                "107005319",
                "107006936",
                "107006949",
                "111317857",
                "111907445",
                "113010547",
                "113122325",
                "114900313",
                "114909013",
                "122101010",
                "122105744",
                "122105948",
                "231371579",
                "242070966",
                "242071237",
                "242071305",
                "242071583",
                "242072715",
                "242170031",
                "255072207",
                "261170546",
                "262285184",
                "263290576",
                "267084199",
                "267087358",
                "271070607",
                "271070791",
                "271971560",
                "271971816",
                "275071408",
                "281073458",
                "281073568",
                "314970664",
                "321170538",
                "322270408",
                "322271850"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_106769",
            "name": "Quakertown National Bank (QNB)",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "031907790"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "4204"
            ],
            "institution_id": "ins_19",
            "name": "Regions Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051009296",
                "053012029",
                "053201814",
                "061101375",
                "061104712",
                "062000019",
                "062005690",
                "062202150",
                "062203735",
                "063104668",
                "063206663",
                "063210112",
                "064000017",
                "064002280",
                "064003962",
                "064102397",
                "064103079",
                "064200765",
                "064200914",
                "064206594",
                "065301155",
                "065305436",
                "065305902",
                "065402892",
                "065403626",
                "065403875",
                "065404913",
                "067008414",
                "067010583",
                "071122661",
                "073900438",
                "074014213",
                "081001387",
                "081503500",
                "082000109",
                "082901347",
                "083901744",
                "084000084",
                "084302614",
                "084306953",
                "111900785",
                "261170740",
                "264071590",
                "284073808"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_28",
            "name": "Santander - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011075150",
                "011075202",
                "011375245",
                "011401135",
                "021206074",
                "021206676",
                "021207002",
                "021207028",
                "021207358",
                "026010058",
                "031302117",
                "031902038",
                "211073499",
                "211370299",
                "211371191",
                "211371308",
                "211371450",
                "221270758",
                "221271265",
                "221271456",
                "221272332",
                "221272361",
                "226071211",
                "226071237",
                "231170181",
                "231271161",
                "231271404",
                "231371663",
                "231372264",
                "231372387",
                "231372691",
                "231374945",
                "231375630"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2803"
            ],
            "institution_id": "ins_127990",
            "name": "U.S. Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011501747",
                "026005050",
                "041202582",
                "042000013",
                "042100175",
                "042201948",
                "042205038",
                "064000059",
                "064103707",
                "071000521",
                "071001041",
                "071004200",
                "071174431",
                "071904779",
                "071920559",
                "073000545",
                "073921514",
                "074900783",
                "075000022",
                "075000103",
                "075900465",
                "075911603",
                "081000210",
                "081202759",
                "081517693",
                "082000549",
                "082901444",
                "083900363",
                "083900732",
                "086500346",
                "091000022",
                "091015224",
                "091215927",
                "091300023",
                "091408501",
                "091800293",
                "092900383",
                "092904554",
                "101000187",
                "101200453",
                "102000021",
                "102101645",
                "104000029",
                "104101575",
                "107001452",
                "107002312",
                "111026041",
                "121000497",
                "121122676",
                "121139313",
                "121139685",
                "121140713",
                "121140742",
                "121141864",
                "121181798",
                "121201652",
                "121201694",
                "122000496",
                "122038442",
                "122043518",
                "122105155",
                "122220593",
                "122235821",
                "122238077",
                "122238310",
                "122238682",
                "122240683",
                "122241501",
                "122241941",
                "122242034",
                "122401781",
                "123000068",
                "123000220",
                "123000848",
                "123103729",
                "123206516",
                "123206613",
                "123206707",
                "123206710",
                "123306160",
                "124302150",
                "125000105",
                "125000118",
                "125008288",
                "125107260",
                "125107626",
                "125107736",
                "273970514",
                "307070115",
                "312270379",
                "321170318",
                "321181271",
                "322270356",
                "322270495",
                "322271326",
                "322284892",
                "322285846"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115581",
            "name": "VyStar Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "063106501",
                "263079276",
                "263079425"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120473",
            "name": "XCEL Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "income",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "226078230",
                "226092009"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109904",
            "name": "Zeal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "272476378",
                "272477694",
                "272484218"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_130209",
            "name": "5th Bank of Eastern Fargo",
            "oauth": true,
            "products": [
                "auth",
                "balance",
                "transactions",
                "processor_payments"
            ],
            "routing_numbers": [
                "011401533",
                "063107513"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120013",
            "name": "America First Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "124384521",
                "322172852",
                "322484142",
                "322484304",
                "322484414",
                "324079542",
                "324377516"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2108"
            ],
            "institution_id": "ins_100103",
            "name": "Comerica Bank - Web Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "067012099",
                "072000096",
                "072000339",
                "072401064",
                "072404485",
                "072404786",
                "072409794",
                "072413133",
                "072413256",
                "111000753",
                "113015584",
                "114912288",
                "121137522",
                "122236037"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115586",
            "name": "Delta Community Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "061092947",
                "261071315"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117145",
            "name": "Eastern Bank (MA) - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments"
            ],
            "routing_numbers": [
                "011002550",
                "011301390",
                "011301798",
                "011303110",
                "011402024",
                "211370257",
                "211370448",
                "211370846",
                "211371476"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110019",
            "name": "First Citizens Bank - Digital Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031207856",
                "051401836",
                "051503174",
                "053010445",
                "053100300",
                "053201487",
                "053906041",
                "055003463",
                "061107816",
                "061191848",
                "061192669",
                "064008970",
                "066015767",
                "067013124",
                "067015478",
                "067092022",
                "072471939",
                "075011930",
                "091071598",
                "101089810",
                "101089823",
                "102089644",
                "103089834",
                "104002894",
                "107005979",
                "107089652",
                "114993906",
                "121182014",
                "122037760",
                "122105469",
                "122105757",
                "122187335",
                "122242597",
                "122243923",
                "122287361",
                "122401723",
                "123084958",
                "125084969",
                "125107671",
                "253271974",
                "275071288",
                "304973985"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120000",
            "name": "Golden 1 Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "121182852",
                "321175261"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116799",
            "name": "HAPO Community Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "323274526",
                "323276647",
                "325181264"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110417",
            "name": "IBC Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "103012869",
                "111903999",
                "113000861",
                "113003389",
                "113014077",
                "113105025",
                "114012641",
                "114013284",
                "114902528",
                "114902612",
                "114902793",
                "114904652",
                "114905567",
                "114909505",
                "114909903",
                "114911580",
                "114912275",
                "114912709",
                "114915081",
                "114917623",
                "125108609",
                "303072793",
                "314973412"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_113128",
            "name": "KEMBA Financial Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "244077556"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116196",
            "name": "Lake Michigan Credit Union - Personal and Business",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "063102592",
                "063113028",
                "067016192",
                "272480678"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_118491",
            "name": "Lake Michigan Credit Union - Business Plus",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "063113028",
                "067016192",
                "272480678"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_103549",
            "name": "OneUnited Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011001276",
                "067006762",
                "322070239",
                "322070598"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117003",
            "name": "Police and Fire Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "236084285"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_127312",
            "name": "Qapital",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "073905527",
                "073923033",
                "073923114",
                "073923127"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111636",
            "name": "RadiFi Federal Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "263078921",
                "263079027",
                "263079108",
                "263079234"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_101554",
            "name": "Redstone Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "262275835"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114869",
            "name": "Veridian Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "091071585",
                "273975700",
                "273976369",
                "273976479"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111998",
            "name": "Walmart MoneyCard by Green Dot",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "061120000",
                "096017418",
                "124085024",
                "124302529",
                "124303120",
                "124303214",
                "124303230",
                "124303269"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0141"
            ],
            "institution_id": "ins_127991",
            "name": "Wells Fargo",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011100106",
                "021101108",
                "021200025",
                "021200559",
                "021201011",
                "026012881",
                "026073079",
                "031000011",
                "031000503",
                "031100225",
                "031100869",
                "031200730",
                "031201467",
                "031302777",
                "031901686",
                "041203824",
                "041215537",
                "051000253",
                "051001414",
                "051006778",
                "051400549",
                "051402961",
                "051404985",
                "052000016",
                "052001963",
                "053000183",
                "053000219",
                "053100355",
                "053100494",
                "053101273",
                "053101529",
                "053101561",
                "053101626",
                "053107633",
                "053107963",
                "053108580",
                "053110112",
                "053110303",
                "053110400",
                "053200019",
                "053207766",
                "053900225",
                "053901473",
                "054000807",
                "054001220",
                "055003201",
                "056004089",
                "056007604",
                "061000010",
                "061000227",
                "061000256",
                "061101155",
                "061103056",
                "061113279",
                "061209756",
                "062000080",
                "062203751",
                "063000021",
                "063107513",
                "063109430",
                "063210125",
                "064003768",
                "067006432",
                "067013564",
                "067091780",
                "071101307",
                "071974372",
                "073000228",
                "074900275",
                "075911988",
                "091000019",
                "091071611",
                "091101455",
                "091300010",
                "091400046",
                "091900465",
                "091900533",
                "092905168",
                "092905278",
                "101089292",
                "102000076",
                "102100918",
                "102189285",
                "102300242",
                "102301092",
                "102307164",
                "104000058",
                "104900323",
                "107000275",
                "107002192",
                "107005432",
                "111015159",
                "111025013",
                "111900659",
                "111904215",
                "111909634",
                "112000066",
                "113017870",
                "113024520",
                "113102138",
                "113105449",
                "113117767",
                "114900685",
                "121000248",
                "121042882",
                "121141288",
                "121141534",
                "121181866",
                "122000247",
                "122101191",
                "122105278",
                "122105524",
                "122187076",
                "122237955",
                "122242607",
                "122242704",
                "122287170",
                "122402049",
                "122487307",
                "123006800",
                "124000012",
                "124000025",
                "124002971",
                "124084672",
                "124100064",
                "124100080",
                "124103799",
                "125008547",
                "125200057",
                "125200963",
                "253170305",
                "254070019",
                "255072935",
                "256072701",
                "321270742",
                "323270436"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109903",
            "name": "Xplore Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "265076125"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109454",
            "name": "Yampa Valley Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "102106705"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132151",
            "name": "Yampa Valley Bank - Business",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117248",
            "name": "ACE Flare Account by Metabank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "041215663",
                "042287027",
                "053101561",
                "062201601",
                "067011294",
                "072413764",
                "073972181",
                "084003997",
                "091409843",
                "091409869",
                "101089742",
                "103100195",
                "103113357",
                "111906271",
                "114924742",
                "124085244",
                "124303120",
                "124303162",
                "264171241",
                "273070278",
                "273970116",
                "291471024"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0052"
            ],
            "institution_id": "ins_116862",
            "name": "Axos Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011575236",
                "044072324",
                "053112505",
                "071174512",
                "073922623",
                "101089700",
                "122287251",
                "122287675",
                "244077637"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_100866",
            "name": "Bank of America - Charitable Gift Fund",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "investments",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2236"
            ],
            "institution_id": "ins_127989",
            "name": "Bank of America",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011000138",
                "011000206",
                "011000390",
                "011001742",
                "011100012",
                "011100805",
                "011104047",
                "011200365",
                "011201539",
                "011300605",
                "011302357",
                "011302438",
                "011400495",
                "011500010",
                "011501035",
                "011900254",
                "011900445",
                "011900571",
                "011900652",
                "021000322",
                "021001318",
                "021200339",
                "021202162",
                "021202609",
                "021300019",
                "021404465",
                "022000127",
                "022300160",
                "026009593",
                "028000325",
                "031100160",
                "031202084",
                "031304050",
                "051000017",
                "051000101",
                "051400361",
                "051400507",
                "052001633",
                "053000196",
                "053100258",
                "053100559",
                "053101396",
                "053107989",
                "053200446",
                "053201610",
                "053900377",
                "053904483",
                "054001204",
                "055002341",
                "056007387",
                "061000052",
                "061000078",
                "061112788",
                "063000047",
                "063100277",
                "063100552",
                "063100714",
                "063103193",
                "063104697",
                "063104972",
                "063105683",
                "063106006",
                "063106129",
                "063106145",
                "063106268",
                "063107393",
                "063107610",
                "063109058",
                "063110092",
                "063112294",
                "063200407",
                "064000020",
                "064100852",
                "064101178",
                "064101385",
                "064101673",
                "064107046",
                "064208194",
                "066007681",
                "067002436",
                "067003985",
                "067005679",
                "067006238",
                "067007130",
                "067007949",
                "067008579",
                "067008582",
                "067011294",
                "067014026",
                "071000039",
                "071000505",
                "071103619",
                "071214579",
                "071923284",
                "072000805",
                "072413609",
                "073000176",
                "081000032",
                "081500875",
                "081517897",
                "081904808",
                "082000073",
                "082900429",
                "084000819",
                "084301767",
                "086500087",
                "101000035",
                "101001173",
                "101001911",
                "101100045",
                "101901820",
                "102201244",
                "103000017",
                "107000327",
                "107000796",
                "107005607",
                "111000012",
                "111000025",
                "111300945",
                "111901302",
                "113000023",
                "114000019",
                "114000653",
                "121000044",
                "121000345",
                "121000358",
                "121103886",
                "121108250",
                "122000030",
                "122000616",
                "122000661",
                "122101706",
                "122400724",
                "123103716",
                "123308825",
                "124303065",
                "125000024",
                "211470319",
                "221172513",
                "231371841",
                "236073474",
                "267090536",
                "272471674",
                "307072278",
                "311093120",
                "322170692",
                "323070380"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116728",
            "name": "Citibank Online - Private Bank Investments",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "income",
                "investments",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0908"
            ],
            "institution_id": "ins_5",
            "name": "Citibank Online",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "credit_details",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021000089",
                "021001486",
                "021272655",
                "021308176",
                "021502040",
                "022000868",
                "022309239",
                "022310422",
                "026005652",
                "026009645",
                "026011882",
                "028000082",
                "028001489",
                "031100209",
                "031100908",
                "052002166",
                "066014085",
                "067004764",
                "067007156",
                "067011993",
                "091408983",
                "091409571",
                "091409681",
                "091409704",
                "091409717",
                "111901962",
                "111909867",
                "111915686",
                "113102329",
                "113193532",
                "122217056",
                "122220849",
                "122231935",
                "122401710",
                "122402159",
                "221172610",
                "226070238",
                "254070116",
                "266086554",
                "271070801",
                "271071402",
                "271970066",
                "271970312",
                "271971777",
                "271972064",
                "311972652",
                "321070007",
                "321070104",
                "321170282",
                "321170444",
                "321171184",
                "322070019",
                "322270055",
                "322270262",
                "322271096",
                "322271724",
                "322271779"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117179",
            "name": "Dave",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "084106768"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117414",
            "name": "Empower",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "084106768",
                "101015347"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "2445"
            ],
            "institution_id": "ins_115587",
            "name": "First Horizon Bank - Digital Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "053012087",
                "053102191",
                "053103637",
                "053110374",
                "053110633",
                "053111810",
                "053112042",
                "053112055",
                "053112068",
                "053112097",
                "053112136",
                "053112217",
                "053112343",
                "053208037",
                "053908081",
                "061020317",
                "061020977",
                "061120152",
                "061120741",
                "061300367",
                "062004099",
                "062202749",
                "062206415",
                "063016154",
                "063111169",
                "063112249",
                "063112825",
                "063115178",
                "063115372",
                "063115521",
                "063116494",
                "063116588",
                "064005203",
                "064101398",
                "064101550",
                "064101903",
                "064103914",
                "064104379",
                "064105200",
                "064107091",
                "064107376",
                "064107622",
                "064108249",
                "064200930",
                "064201324",
                "064201450",
                "064201560",
                "064201832",
                "064202514",
                "064203021",
                "064203610",
                "064204347",
                "064205087",
                "064207195",
                "064207292",
                "064207771",
                "064208042",
                "064208123",
                "064208301",
                "064208437",
                "065003453",
                "065201349",
                "065202568",
                "065405349",
                "065405417",
                "066006349",
                "067009280",
                "067009646",
                "067010169",
                "067011760",
                "067011825",
                "067014123",
                "067014343",
                "067015119",
                "067092200",
                "082007791",
                "082901826",
                "082904483",
                "082908874",
                "084000026",
                "084002781",
                "084004284",
                "084008853",
                "084101323",
                "084107055",
                "084107893",
                "084202293",
                "084204657",
                "084301372",
                "084303749",
                "111025518",
                "111103197",
                "111105234",
                "253170143",
                "253170253",
                "263091128",
                "263190757",
                "264071752",
                "264172156",
                "264271303",
                "264271361",
                "264272027",
                "265270222",
                "265270316",
                "265270413",
                "265270769",
                "265470381",
                "267090455",
                "267090691",
                "267091250",
                "282970437",
                "284170510",
                "284273970"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_129666",
            "name": "First Horizon Bank - Business",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "053112055",
                "084000026"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_101559",
            "name": "Hudson Valley Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "221973589",
                "221975024",
                "221979363",
                "221982091"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111025",
            "name": "Indiana Members Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "274073711",
                "274074040",
                "274074600",
                "274086533",
                "274976216"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_104809",
            "name": "Keesler Federal Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "263178452",
                "265377002",
                "265377400",
                "265577585"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120018",
            "name": "Langley Federal Credit Union - Personal",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "251480738",
                "251483214"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_103548",
            "name": "Old National Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "071003007",
                "071004378",
                "071004527",
                "071900663",
                "071900883",
                "071901604",
                "071904517",
                "071908827",
                "071909363",
                "071911788",
                "071917326",
                "071919117",
                "071922366",
                "071922379",
                "071922670",
                "071923378",
                "071923569",
                "071925172",
                "071925923",
                "071925965",
                "075000666",
                "086300012",
                "091014267",
                "091903462",
                "091915654",
                "096000687",
                "096008825",
                "096015232",
                "271971735",
                "271973775",
                "271973937",
                "291971469"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_137271",
            "name": "Old National Bank - Mortgage Loan",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_123314",
            "name": "Prosperity Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "103912668",
                "111000805",
                "111001189",
                "111024849",
                "111025534",
                "111322583",
                "111901234",
                "111901632",
                "111903850",
                "111905638",
                "111913756",
                "111915398",
                "113000939",
                "113001255",
                "113008766",
                "113015267",
                "113024504",
                "113102303",
                "113104521",
                "113105368",
                "113105478",
                "113114595",
                "113118012",
                "113122655",
                "114904979",
                "114909929",
                "114993731",
                "114993786",
                "311987773",
                "313172052"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109726",
            "name": "Quincy Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "211385297"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "6769"
            ],
            "institution_id": "ins_54",
            "name": "Robinhood",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021409169",
                "041208777",
                "041215663",
                "041215980"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_14",
            "name": "TD Bank",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011103093",
                "011202910",
                "011305749",
                "011400071",
                "011600033",
                "011600525",
                "011600570",
                "021200957",
                "021201503",
                "021205871",
                "021207138",
                "021207413",
                "021302567",
                "021307708",
                "021912915",
                "026003243",
                "026013673",
                "026014193",
                "031101017",
                "031201328",
                "031201360",
                "031207801",
                "031901482",
                "036001808",
                "053201885",
                "053902197",
                "054001725",
                "063112809",
                "063113772",
                "063115631",
                "067011142",
                "067014822",
                "211274450",
                "211370095",
                "211370493",
                "211370545",
                "263170175"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_127948",
            "name": "U.S. Bank ReliaCard",
            "oauth": true,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0062"
            ],
            "institution_id": "ins_115616",
            "name": "Vanguard",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120162",
            "name": "Wellby Financial",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "313083992"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114860",
            "name": "Wisely",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "071922476",
                "073972181",
                "122244184"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_101561",
            "name": "Wright-Patt Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "242279408"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114437",
            "name": "Yakima Federal Savings & Loan - Online Banking",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "325171122"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_10",
            "name": "American Express",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "liabilities",
                "processor_payments",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "124085066",
                "124303243"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114512",
            "name": "Bank 7 - Personal",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "101111319",
                "103103778",
                "103109345",
                "103112329"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_131533",
            "name": "Bank 7 - Business",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "103103778"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_115585",
            "name": "Boeing Employees Credit Union (BECU) - Personal Online Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "325081403"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_132102",
            "name": "Boeing Employees Credit Union (BECU) - Business Online Banking",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "325081403"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_118580",
            "name": "Citizens Bank - Investment Services",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_20",
            "name": "Citizens Bank",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "011001331",
                "011304517",
                "011401533",
                "011500120",
                "011601443",
                "021213449",
                "021272794",
                "021313103",
                "021414455",
                "026011701",
                "026012166",
                "031101143",
                "031207652",
                "036076150",
                "072402076",
                "111320006",
                "211070175",
                "211170114",
                "211574613",
                "221270075",
                "221271414",
                "221272031",
                "221370030",
                "222371054",
                "226072346",
                "231270340",
                "231271145",
                "231271378",
                "231373069",
                "236074619",
                "241070417",
                "271071321"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114213",
            "name": "Desert Financial Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "122187238"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109719",
            "name": "GECU",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "312081089"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_112779",
            "name": "Happy State Bank - Online Banking",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "082902757",
                "111017791",
                "111305115",
                "111307265",
                "111307469",
                "111310870",
                "111311840",
                "111321144",
                "111321649",
                "111321717",
                "111322729",
                "111322965"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_119510",
            "name": "Happy State Bank - Cash Management",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "liabilities",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "082902757",
                "111017791",
                "111305115",
                "111307265",
                "111307469",
                "111310870",
                "111311840",
                "111321144",
                "111321649",
                "111321717",
                "111322729",
                "111322965"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109551",
            "name": "IH Mississippi Valley Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "271183662"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111013",
            "name": "Kemba Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "242076588",
                "242076889",
                "242076973",
                "242077338",
                "242086031",
                "274975709",
                "274975754"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_52",
            "name": "Marcus by Goldman Sachs",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "026015079",
                "124085082",
                "124085260"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_114054",
            "name": "OceanFirst Bank - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031207843",
                "031207937",
                "031276120",
                "031918996",
                "231270353"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_125503",
            "name": "OceanFirst Bank - Business",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "031207843",
                "031207937",
                "031276120",
                "031918996",
                "231270353"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116798",
            "name": "PenFed Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "256078446",
                "304982251"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_123320",
            "name": "Pinnacle Financial Partners - TN",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "051405450",
                "053012265",
                "053100685",
                "053111577",
                "053112039",
                "053112738",
                "053174103",
                "053202321",
                "053207944",
                "053208176",
                "053274223",
                "061309229",
                "064008637",
                "064009241",
                "064009254",
                "064108621",
                "064108715",
                "064108744",
                "084074395",
                "253170020",
                "253173496",
                "253278498",
                "264171542"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_112521",
            "name": "Queenstown Bank - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "052101957"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110429",
            "name": "Robins Financial Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity",
                "processor_payments",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "061102620",
                "061103409",
                "061104644",
                "061213001",
                "261171587"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110465",
            "name": "Trustmark",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "062103259",
                "062103903",
                "062104203",
                "062105338",
                "062200482",
                "062203269",
                "062203706",
                "062206305",
                "063205208",
                "063212987",
                "065103654",
                "065300279",
                "065300703",
                "065305151",
                "084006729",
                "084008028",
                "084008358",
                "084302122",
                "084304573",
                "113024177",
                "284272670",
                "313074493"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116939",
            "name": "Trustmark - Mortgage",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "income",
                "investments",
                "recurring_transactions"
            ],
            "routing_numbers": []
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_110430",
            "name": "Umpqua Bank - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "121105156",
                "121136785",
                "121138741",
                "121140276",
                "121140823",
                "121140933",
                "121141042",
                "121141107",
                "121141819",
                "121142517",
                "121142627",
                "121142902",
                "121143118",
                "121181730",
                "121202185",
                "122239584",
                "122243703",
                "123202125",
                "123204835",
                "123205054",
                "123206053",
                "123206781",
                "123305378",
                "123308553",
                "125006390",
                "125108272",
                "125108450",
                "125184746",
                "292970841",
                "323170112",
                "323270216",
                "323270300",
                "325171740",
                "325182946"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_119490",
            "name": "Umpqua Bank - Business",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "121105156",
                "121136785",
                "121138741",
                "121140276",
                "121140823",
                "121140933",
                "121141042",
                "121141107",
                "121141819",
                "121142517",
                "121142627",
                "121142902",
                "121143118",
                "121181730",
                "121202185",
                "122239584",
                "122243703",
                "123202125",
                "123204835",
                "123205054",
                "123206053",
                "123206781",
                "123305378",
                "123308553",
                "125006390",
                "125108450",
                "125184746",
                "292970841",
                "323170112",
                "323270216",
                "323270300",
                "325171740",
                "325182946"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111997",
            "name": "Walmart - Money Network Pay Card",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "084003997"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_113824",
            "name": "ZIA Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "307084240"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_117321",
            "name": "Aspiration",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "125108405",
                "125108997",
                "125109006",
                "125109019",
                "125109022"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "dtc_numbers": [
                "0352"
            ],
            "institution_id": "ins_56",
            "name": "Chase",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "021000021",
                "021000128",
                "021031207",
                "021100361",
                "021114205",
                "021202337",
                "021202719",
                "021272723",
                "021300462",
                "021309379",
                "021409169",
                "021410637",
                "022000842",
                "022300173",
                "028000024",
                "028000121",
                "031100144",
                "031100393",
                "044000037",
                "044115443",
                "051900366",
                "061092387",
                "065400137",
                "071000013",
                "071074528",
                "071100269",
                "071923226",
                "072000326",
                "072412927",
                "074000010",
                "075000019",
                "075902722",
                "083000137",
                "083006102",
                "102001017",
                "103000648",
                "107089555",
                "111000614",
                "111001150",
                "111300880",
                "111993776",
                "112000150",
                "113000609",
                "114000776",
                "122100024",
                "123271978",
                "124001545",
                "221971293",
                "263189865",
                "267084131",
                "322270521",
                "322271627",
                "325070760",
                "325070951"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109630",
            "name": "Dort Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "272479919"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109534",
            "name": "Eastman Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "264279350"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116618",
            "name": "Founders Federal Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "253278304",
                "253279439"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116868",
            "name": "GTE Financial",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "263182794"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_111000",
            "name": "Heartland Bank and Trust Company",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "071102173",
                "071102199",
                "071103949",
                "071104427",
                "071112066",
                "071115322",
                "071117184",
                "071121594",
                "071123262",
                "071126609",
                "071127022",
                "071908490",
                "071920960",
                "071924063",
                "071924775",
                "073922092",
                "073922953",
                "081226298"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_120026",
            "name": "Kinecta Federal Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "322078079",
                "322275490",
                "322275788",
                "322276062",
                "322278073"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109707",
            "name": "Landmark Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "275079714"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109979",
            "name": "Nusenda Credit Union",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "112206763",
                "307083665",
                "307087616"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_116954",
            "name": "Oregon Community Credit Union",
            "oauth": true,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "investments",
                "liabilities",
                "processor_payments",
                "recurring_transactions",
                "transfer"
            ],
            "routing_numbers": [
                "323274461"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_109725",
            "name": "Queensborough National Bank & Trust Company",
            "oauth": false,
            "products": [
                "assets",
                "balance",
                "transactions",
                "identity_match",
                "income",
                "identity",
                "recurring_transactions"
            ],
            "routing_numbers": [
                "061103166",
                "061103975",
                "061104301",
                "061202368"
            ]
        },
        {
            "country_codes": [
                "US"
            ],
            "institution_id": "ins_113439",
            "name": "Renasant Bank - Personal",
            "oauth": false,
            "products": [
                "assets",
                "auth",
                "balance",
                "transactions",
                "identity_match",
                "identity",
                "processor_payments",
                "transfer"
            ],
            "routing_numbers": [
                "061103276",
                "061104275",
                "061120217",
                "061120327",
                "061121054",
                "061121203",
                "061206982",
                "061219571",
                "061220146",
                "062201779",
                "062202367",
                "062202778",
                "062203104",
                "062204132",
                "062205733",
                "062206101",
                "063115686",
                "064004181",
                "064009144",
                "065301265",
                "065302633",
                "065303085",
                "065305478",
                "084003191",
                "084008507",
                "084201003",
                "084201171",
                "084201223",
                "084201294",
                "084201511",
                "084201621",
                "084201692",
                "084201838",
                "084201841",
                "084201977",
                "084202060",
                "084202112",
                "084202248",
                "084202442",
                "084202769",
                "084202837",
                "084202879",
                "084203043",
                "084203137",
                "084203276",
                "084205643",
                "084205656",
                "084205766",
                "084205889",
                "084205931",
                "084305129",
                "261271115",
                "284272625",
                "284272780"
            ]
        }
    ],
    "request_id": "TdZgCA9ICurGyn3",
    "total": 9710
}
""";
