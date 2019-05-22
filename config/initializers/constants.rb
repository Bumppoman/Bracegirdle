# frozen_string_literal: true

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

FILE_ICONS = {
    'doc' => 'fa-file-word-o',
    'docx' => 'fa-file-word-o',
    'jpg' => 'fa-file-picture-o',
    'pdf' => 'fa-file-pdf-o',
    'png' => 'fa-file-picture-o',
    'xls' => 'fa-file-excel-o',
    'xlsx' => 'fa-file-excel-o'
}.freeze

INVESTIGATOR_COUNTIES_BY_REGION = {
    1 => 2, 2 => 3, 3 => 1, 4 => 5,
    5 => 3, 6 => 4, 7 => 3, 8 => 5,
    9 => 5, 10 => 2, 11 => 2, 12 => 5,
    13 => 5, 14 => 1, 15 => 3, 16 => 2,
    17 => 2, 18 => 2, 19 => 3, 20 => 2,
    21 => 4, 22 => 4, 23 => 4, 24 => 1,
    25 => 4, 26 => 3, 27 => 4, 28 => 3,
    29 => 2, 30 => 1, 31 => 1, 32 => 3,
    33 => 4, 34 => 4, 35 => 3, 36 => 5,
    37 => 3, 38 => 4, 39 => 5, 40 => 2,
    41 => 1, 42 => 2, 43 => 1, 44 => 1,
    45 => 4, 46 => 2, 47 => 2, 48 => 2,
    49 => 5, 50 => 3, 51 => 5, 52 => 1,
    53 => 5, 54 => 5, 55 => 5, 56 => 2,
    57 => 2, 58 => 2, 59 => 4, 60 => 1,
    61 => 3, 62 => 3
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

NAMED_REGIONS = {
    1 => 'NYC',
    2 => 'Albany',
    3 => 'Buffalo',
    4 => 'Syracuse',
    5 => 'Binghamton'
}.freeze

NAMED_ROLES = {
    supervisor: 4
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
    1 => [3, 24, 30, 31, 41, 43, 44, 52, 60],
    2 => [1, 10, 11, 14, 16, 18, 20, 29, 40, 42, 46, 47, 48, 56, 57, 58],
    3 => [2, 5, 7, 15, 19, 26, 28, 32, 35, 37, 50, 61, 62],
    4 => [6, 17, 21, 22, 23, 25, 27, 33, 34, 38, 45, 59],
    5 => [4, 8, 9, 12, 13, 36, 39, 49, 51, 53, 54, 55]
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

WARRANTY_LENGTHS = {
    10 => '10 years',
    20 => '20 years',
    75 => '75 years',
    1000 => 'Lifetime'
}.freeze