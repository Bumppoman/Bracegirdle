# frozen_string_literal: true

COMPLAINT_STATUSES = {
    1 => 'Complaint Received',
    2 => 'Investigation Begun',
    3 => 'Investigation Closed',
    4 => 'Closure Recommended',
    5 => 'Complaint Closed'
}.freeze

COUNTIES = {
    1 => 'Albany',
    2 => 'Allegany',
    3 => 'Bronx',
    4 => 'Broome',
    5 => 'Cattaraugus',
    6 => 'Cayuga',
    7 => 'Chautauqua',
    8 => 'Chemung',
    9 => 'Chenango',
    10 => 'Clinton',
    11 => 'Columbia',
    12 => 'Cortland',
    13 => 'Delaware',
    14 => 'Dutchess',
    15 => 'Erie',
    16 => 'Essex',
    17 => 'Franklin',
    18 => 'Fulton',
    19 => 'Genesee',
    20 => 'Greene',
    21 => 'Hamilton',
    22 => 'Herkimer',
    23 => 'Jefferson',
    24 => 'Kings',
    25 => 'Lewis',
    26 => 'Livingston',
    27 => 'Madison',
    28 => 'Monroe',
    29 => 'Montgomery',
    30 => 'Nassau',
    31 => 'New York',
    32 => 'Niagara',
    33 => 'Oneida',
    34 => 'Onondaga',
    35 => 'Ontario',
    36 => 'Orange',
    37 => 'Orleans',
    38 => 'Oswego',
    39 => 'Otsego',
    40 => 'Putnam',
    41 => 'Queens',
    42 => 'Rensselaer',
    43 => 'Richmond',
    44 => 'Rockland',
    45 => 'St. Lawrence',
    46 => 'Saratoga',
    47 => 'Schenectady',
    48 => 'Schoharie',
    49 => 'Schuyler',
    50 => 'Seneca',
    51 => 'Steuben',
    52 => 'Suffolk',
    53 => 'Sullivan',
    54 => 'Tioga',
    55 => 'Tompkins',
    56 => 'Ulster',
    57 => 'Warren',
    58 => 'Washington',
    59 => 'Wayne',
    60 => 'Westchester',
    61 => 'Wyoming',
    62 => 'Yates'
}.freeze

DOCUMENTS = {
    1 => "Rules and Regulations"
}.freeze

GROUPED_COMPLAINT_TYPES = [
    ['Investigatory', [
        ['Board member issue', 1],
        ['Burial issues', 2],
        ['Burial rights', 3],
        ['Burial records', 4],
        ['Burial society issues', 5],
        ['Cemetery maintenance issues', 6],
        ['Cremation process', 7],
        ['Damaged monument', 8],
        ['Dangerous conditions', 9],
        ['Lot owner issues', 10],
        ['Monument issues', 11],
        ['Operating illegal cemetery', 12],
        ['Perpetual care issues', 13],
        ['Pet burial issues', 14],
        ['Rules and regulations issues', 15],
        ['Tree removal', 16],
        ['Winter burial', 17]
    ]],
    ['Accounting', [
        ['Embezzlement/Fraud', 18],
        ['Financial issues', 19],
        ['Financial records issues', 20],
        ['Service fee issues', 21],
        ['Sales contract issues', 22]
    ]]
].freeze

MANNERS_OF_CONTACT = {
    1 => "Phone",
    2 => "Letter",
    3 => "Email",
    4 => "In Person"
}.freeze

NAMED_REGIONS = {
    1 => 'nyc',
    2 => 'albany',
    3 => 'buffalo',
    4 => 'syracuse',
    5 => 'binghamton'
}.freeze

NAMED_ROLES = {
    supervisor: 4
}.freeze

NOTICE_STATUSES = {
    1 => 'Notice Issued',
    2 => 'Response Received',
    3 => 'Follow-Up Completed',
    4 => 'Notice Resolved'
}.freeze

OWNERSHIP_TYPES = {
    1 => "Purchase",
    2 => "Inheritance",
    3 => "Gift",
    4 => "Other"
}.freeze

POSITIONS = {
    1 => "President",
    2 => "Vice President",
    3 => "Secretary",
    4 => "Treasurer",
    5 => "Superintendent",
    6 => "Trustee",
    7 => "Operator",
    8 => "Employee"
}.freeze

RAW_COMPLAINT_TYPES = {
    1 => 'Board member issue',
    2 => 'Burial issues',
    3 => 'Burial rights',
    4 => 'Burial records',
    5 => 'Burial society issues',
    6 => 'Cemetery maintenance issues',
    7 => 'Cremation process',
    8 => 'Damaged monument',
    9 => 'Dangerous conditions',
    10 => 'Lot owner issues',
    11 => 'Monument issues',
    12 => 'Operating illegal cemetery',
    13 => 'Perpetual care issues',
    14 => 'Pet burial issues',
    15 => 'Rules and regulations issues',
    16 => 'Tree removal',
    17 => 'Winter burial',
    18 => 'Embezzlement/Fraud',
    19 => 'Financial issues',
    20 => 'Financial records issues',
    21 => 'Service fee issues',
    22 => 'Sales contract issues'
}.freeze

REGIONS = {
    4 => [6, 34],
    5 => [4, 8, 9, 12, 13, 39, 49, 51, 53, 54, 55]
}.freeze

ROLES = {
    1 => "Cemeterian",
    2 => "Investigator",
    3 => "Accountant",
    4 => "Administrator",
    5 => 'Superuser'
}.freeze

STATES = {
    "AL" => "AL",
    "AK" => "AK",
    "AZ" => "AZ",
    "AR" => "AR",
    "CA" => "CA",
    "CO" => "CO",
    "CT" => "CT",
    "NY" => "NY"
}.freeze