KEY_LENGHT = 6
KEY_ALLOWED_CHARACTERS = [('0'..'9'), ('a'..'z')].map { |i| i.to_a }.flatten - ['o', '0', 'l', '1']

AUTHOR_UUID = "6493fb03-786b-40fa-990d-9347efcc0df2"

DEFAULT_REFERRAL_LIMIT = 3
REFERRAL_REQUEST_EMAIL = URI.escape "\"David Chouinard\"<david@davidchouinard.com>"
REFERRAL_REQUEST_SUBJECT = "Compliment Gossip: requesting more cards"
REFERRAL_REQUEST_BODY = "David—

I'd love to be able to send a few other cards on Compliment Gossip. Thanks!"

if Rails.env.production?
  MIXPANEL_TOKEN = "bfd59c67d03d9d1763a9301bf838de31"
  MIXPANEL = Mixpanel::Tracker.new(MIXPANEL_TOKEN)
end

TEST_API_KEY = "test_d7b407a97a9b0a53004fc28e88b46abdc36"
LIVE_API_KEY = "live_824b49ca966125c15425f5ecd003fa5744a"

if Rails.env.production?
  LOB = Lob.load(api_key: LIVE_API_KEY)
else
  LOB = Lob.load(api_key: TEST_API_KEY)
end

# from https://api.lob.com/v1/countries/
COUNTRIES = [
  {"name"=>"United States", "short_name"=>"US", "object"=>"country"},
  {"name"=>"Afghanistan", "short_name"=>"AF", "object"=>"country"},
  {"name"=>"Albania", "short_name"=>"AL", "object"=>"country"},
  {"name"=>"Algeria", "short_name"=>"DZ", "object"=>"country"},
  {"name"=>"American Samoa", "short_name"=>"AS", "object"=>"country"},
  {"name"=>"Andorra", "short_name"=>"AD", "object"=>"country"},
  {"name"=>"Angola", "short_name"=>"AO", "object"=>"country"},
  {"name"=>"Anguilla", "short_name"=>"AI", "object"=>"country"},
  {"name"=>"Antarctica", "short_name"=>"AQ", "object"=>"country"},
  {"name"=>"Antigua and Barbuda", "short_name"=>"AG", "object"=>"country"},
  {"name"=>"Argentina", "short_name"=>"AR", "object"=>"country"},
  {"name"=>"Armenia", "short_name"=>"AM", "object"=>"country"},
  {"name"=>"Aruba", "short_name"=>"AW", "object"=>"country"},
  {"name"=>"Australia", "short_name"=>"AU", "object"=>"country"},
  {"name"=>"Austria", "short_name"=>"AT", "object"=>"country"},
  {"name"=>"Azerbaijan", "short_name"=>"AZ", "object"=>"country"},
  {"name"=>"Bahamas", "short_name"=>"BS", "object"=>"country"},
  {"name"=>"Bahrain", "short_name"=>"BH", "object"=>"country"},
  {"name"=>"Bangladesh", "short_name"=>"BD", "object"=>"country"},
  {"name"=>"Barbados", "short_name"=>"BB", "object"=>"country"},
  {"name"=>"Belarus", "short_name"=>"BY", "object"=>"country"},
  {"name"=>"Belgium", "short_name"=>"BE", "object"=>"country"},
  {"name"=>"Belize", "short_name"=>"BZ", "object"=>"country"},
  {"name"=>"Benin", "short_name"=>"BJ", "object"=>"country"},
  {"name"=>"Bermuda", "short_name"=>"BM", "object"=>"country"},
  {"name"=>"Bhutan", "short_name"=>"BT", "object"=>"country"},
  {"name"=>"Bolivia", "short_name"=>"BO", "object"=>"country"},
  {"name"=>"Bosnia and Herzegovina", "short_name"=>"BA", "object"=>"country"},
  {"name"=>"Botswana", "short_name"=>"BW", "object"=>"country"},
  {"name"=>"Brazil", "short_name"=>"BR", "object"=>"country"},
  {"name"=>"British Indian Ocean Territory", "short_name"=>"IO", "object"=>"country"},
  {"name"=>"British Virgin Islands", "short_name"=>"VG", "object"=>"country"},
  {"name"=>"Brunei", "short_name"=>"BN", "object"=>"country"},
  {"name"=>"Bulgaria", "short_name"=>"BG", "object"=>"country"},
  {"name"=>"Burkina Faso", "short_name"=>"BF", "object"=>"country"},
  {"name"=>"Burma", "short_name"=>"MM", "object"=>"country"},
  {"name"=>"Burundi", "short_name"=>"BI", "object"=>"country"},
  {"name"=>"Cambodia", "short_name"=>"KH", "object"=>"country"},
  {"name"=>"Cameroon", "short_name"=>"CM", "object"=>"country"},
  {"name"=>"Canada", "short_name"=>"CA", "object"=>"country"},
  {"name"=>"Cape Verde", "short_name"=>"CV", "object"=>"country"},
  {"name"=>"Caribbean Netherlands", "short_name"=>"BQ", "object"=>"country"},
  {"name"=>"Cayman Islands", "short_name"=>"KY", "object"=>"country"},
  {"name"=>"Central African Republic", "short_name"=>"CF", "object"=>"country"},
  {"name"=>"Chad", "short_name"=>"TD", "object"=>"country"},
  {"name"=>"Chile", "short_name"=>"CL", "object"=>"country"},
  {"name"=>"China", "short_name"=>"CN", "object"=>"country"},
  {"name"=>"Christmas Island", "short_name"=>"CX", "object"=>"country"},
  {"name"=>"Cocos (Keeling) Islands", "short_name"=>"CC", "object"=>"country"},
  {"name"=>"Colombia", "short_name"=>"CO", "object"=>"country"},
  {"name"=>"Comoros", "short_name"=>"KM", "object"=>"country"},
  {"name"=>"Congo (Brazzaville)", "short_name"=>"CG", "object"=>"country"},
  {"name"=>"Congo (Kinshasa)", "short_name"=>"CD", "object"=>"country"},
  {"name"=>"Cook Islands", "short_name"=>"CK", "object"=>"country"},
  {"name"=>"Costa Rica", "short_name"=>"CR", "object"=>"country"},
  {"name"=>"Croatia", "short_name"=>"HR", "object"=>"country"},
  {"name"=>"C̫te d'Ivoire", "short_name"=>"CI", "object"=>"country"},
  {"name"=>"Cuba", "short_name"=>"CU", "object"=>"country"},
  {"name"=>"Cura̤ao", "short_name"=>"CW", "object"=>"country"},
  {"name"=>"Cyprus", "short_name"=>"CY", "object"=>"country"},
  {"name"=>"Czech Republic", "short_name"=>"CZ", "object"=>"country"},
  {"name"=>"Denmark", "short_name"=>"DK", "object"=>"country"},
  {"name"=>"Djibouti", "short_name"=>"DJ", "object"=>"country"},
  {"name"=>"Dominica", "short_name"=>"DM", "object"=>"country"},
  {"name"=>"Dominican Republic", "short_name"=>"DO", "object"=>"country"},
  {"name"=>"Ecuador", "short_name"=>"EC", "object"=>"country"},
  {"name"=>"Egypt", "short_name"=>"EG", "object"=>"country"},
  {"name"=>"El Salvador", "short_name"=>"SV", "object"=>"country"},
  {"name"=>"Equatorial Guinea", "short_name"=>"GQ", "object"=>"country"},
  {"name"=>"Eritrea", "short_name"=>"ER", "object"=>"country"},
  {"name"=>"Estonia", "short_name"=>"EE", "object"=>"country"},
  {"name"=>"Ethiopia", "short_name"=>"ET", "object"=>"country"},
  {"name"=>"Falkland Islands", "short_name"=>"FK", "object"=>"country"},
  {"name"=>"Faroe Islands", "short_name"=>"FO", "object"=>"country"},
  {"name"=>"Fiji", "short_name"=>"FJ", "object"=>"country"},
  {"name"=>"Finland", "short_name"=>"FI", "object"=>"country"},
  {"name"=>"France", "short_name"=>"FR", "object"=>"country"},
  {"name"=>"French Guiana", "short_name"=>"GF", "object"=>"country"},
  {"name"=>"French Polynesia", "short_name"=>"PF", "object"=>"country"},
  {"name"=>"French Southern Territories", "short_name"=>"TF", "object"=>"country"},
  {"name"=>"Gabon", "short_name"=>"GA", "object"=>"country"},
  {"name"=>"Gambia", "short_name"=>"GM", "object"=>"country"},
  {"name"=>"Georgia", "short_name"=>"GE", "object"=>"country"},
  {"name"=>"Germany", "short_name"=>"DE", "object"=>"country"},
  {"name"=>"Ghana", "short_name"=>"GH", "object"=>"country"},
  {"name"=>"Gibraltar", "short_name"=>"GI", "object"=>"country"},
  {"name"=>"Greece", "short_name"=>"GR", "object"=>"country"},
  {"name"=>"Greenland", "short_name"=>"GL", "object"=>"country"},
  {"name"=>"Grenada", "short_name"=>"GD", "object"=>"country"},
  {"name"=>"Guadeloupe", "short_name"=>"GP", "object"=>"country"},
  {"name"=>"Guam", "short_name"=>"GU", "object"=>"country"},
  {"name"=>"Guatemala", "short_name"=>"GT", "object"=>"country"},
  {"name"=>"Guernsey", "short_name"=>"GG", "object"=>"country"},
  {"name"=>"Guinea", "short_name"=>"GN", "object"=>"country"},
  {"name"=>"Guinea-Bissau", "short_name"=>"GW", "object"=>"country"},
  {"name"=>"Guyana", "short_name"=>"GY", "object"=>"country"},
  {"name"=>"Haiti", "short_name"=>"HT", "object"=>"country"},
  {"name"=>"Honduras", "short_name"=>"HN", "object"=>"country"},
  {"name"=>"Hong Kong", "short_name"=>"HK", "object"=>"country"},
  {"name"=>"Hungary", "short_name"=>"HU", "object"=>"country"},
  {"name"=>"Iceland", "short_name"=>"IS", "object"=>"country"},
  {"name"=>"India", "short_name"=>"IN", "object"=>"country"},
  {"name"=>"Indonesia", "short_name"=>"ID", "object"=>"country"},
  {"name"=>"Iran", "short_name"=>"IR", "object"=>"country"},
  {"name"=>"Iraq", "short_name"=>"IQ", "object"=>"country"},
  {"name"=>"Ireland", "short_name"=>"IE", "object"=>"country"},
  {"name"=>"Isle of Man", "short_name"=>"IM", "object"=>"country"},
  {"name"=>"Israel", "short_name"=>"IL", "object"=>"country"},
  {"name"=>"Italy", "short_name"=>"IT", "object"=>"country"},
  {"name"=>"Jamaica", "short_name"=>"JM", "object"=>"country"},
  {"name"=>"Japan", "short_name"=>"JP", "object"=>"country"},
  {"name"=>"Jersey", "short_name"=>"JE", "object"=>"country"},
  {"name"=>"Jordan", "short_name"=>"JO", "object"=>"country"},
  {"name"=>"Kazakhstan", "short_name"=>"KZ", "object"=>"country"},
  {"name"=>"Kenya", "short_name"=>"KE", "object"=>"country"},
  {"name"=>"Kiribati", "short_name"=>"KI", "object"=>"country"},
  {"name"=>"Kosovo", "short_name"=>"KS", "object"=>"country"},
  {"name"=>"Kuwait", "short_name"=>"KW", "object"=>"country"},
  {"name"=>"Kyrgyzstan", "short_name"=>"KG", "object"=>"country"},
  {"name"=>"Laos", "short_name"=>"LA", "object"=>"country"},
  {"name"=>"Latvia", "short_name"=>"LV", "object"=>"country"},
  {"name"=>"Lebanon", "short_name"=>"LB", "object"=>"country"},
  {"name"=>"Lesotho", "short_name"=>"LS", "object"=>"country"},
  {"name"=>"Liberia", "short_name"=>"LR", "object"=>"country"},
  {"name"=>"Libya", "short_name"=>"LY", "object"=>"country"},
  {"name"=>"Liechtenstein", "short_name"=>"LI", "object"=>"country"},
  {"name"=>"Lithuania", "short_name"=>"LT", "object"=>"country"},
  {"name"=>"Luxembourg", "short_name"=>"LU", "object"=>"country"},
  {"name"=>"Macau", "short_name"=>"MO", "object"=>"country"},
  {"name"=>"Macedonia", "short_name"=>"MK", "object"=>"country"},
  {"name"=>"Madagascar", "short_name"=>"MG", "object"=>"country"},
  {"name"=>"Malawi", "short_name"=>"MW", "object"=>"country"},
  {"name"=>"Malaysia", "short_name"=>"MY", "object"=>"country"},
  {"name"=>"Maldives", "short_name"=>"MV", "object"=>"country"},
  {"name"=>"Mali", "short_name"=>"ML", "object"=>"country"},
  {"name"=>"Malta", "short_name"=>"MT", "object"=>"country"},
  {"name"=>"Marshall Islands", "short_name"=>"MH", "object"=>"country"},
  {"name"=>"Martinique", "short_name"=>"MQ", "object"=>"country"},
  {"name"=>"Mauritania", "short_name"=>"MR", "object"=>"country"},
  {"name"=>"Mauritius", "short_name"=>"MU", "object"=>"country"},
  {"name"=>"Mayotte", "short_name"=>"YT", "object"=>"country"},
  {"name"=>"Mexico", "short_name"=>"MX", "object"=>"country"},
  {"name"=>"Micronesia", "short_name"=>"FM", "object"=>"country"},
  {"name"=>"Moldova", "short_name"=>"MD", "object"=>"country"},
  {"name"=>"Monaco", "short_name"=>"MC", "object"=>"country"},
  {"name"=>"Mongolia", "short_name"=>"MN", "object"=>"country"},
  {"name"=>"Montenegro", "short_name"=>"ME", "object"=>"country"},
  {"name"=>"Montserrat", "short_name"=>"MS", "object"=>"country"},
  {"name"=>"Morocco", "short_name"=>"MA", "object"=>"country"},
  {"name"=>"Mozambique", "short_name"=>"MZ", "object"=>"country"},
  {"name"=>"Namibia", "short_name"=>"NA", "object"=>"country"},
  {"name"=>"Nauru", "short_name"=>"NR", "object"=>"country"},
  {"name"=>"Nepal", "short_name"=>"NP", "object"=>"country"},
  {"name"=>"Netherlands", "short_name"=>"NL", "object"=>"country"},
  {"name"=>"New Caledonia", "short_name"=>"NC", "object"=>"country"},
  {"name"=>"New Zealand", "short_name"=>"NZ", "object"=>"country"},
  {"name"=>"Nicaragua", "short_name"=>"NI", "object"=>"country"},
  {"name"=>"Niger", "short_name"=>"NE", "object"=>"country"},
  {"name"=>"Nigeria", "short_name"=>"NG", "object"=>"country"},
  {"name"=>"Niue", "short_name"=>"NU", "object"=>"country"},
  {"name"=>"Norfolk Island", "short_name"=>"NF", "object"=>"country"},
  {"name"=>"Northern Mariana Islands", "short_name"=>"MP", "object"=>"country"},
  {"name"=>"North Korea", "short_name"=>"KP", "object"=>"country"},
  {"name"=>"Norway", "short_name"=>"NO", "object"=>"country"},
  {"name"=>"Oman", "short_name"=>"OM", "object"=>"country"},
  {"name"=>"Pakistan", "short_name"=>"PK", "object"=>"country"},
  {"name"=>"Palau", "short_name"=>"PW", "object"=>"country"},
  {"name"=>"Palestinian Territory", "short_name"=>"PS", "object"=>"country"},
  {"name"=>"Panama", "short_name"=>"PA", "object"=>"country"},
  {"name"=>"Papua New Guinea", "short_name"=>"PG", "object"=>"country"},
  {"name"=>"Paraguay", "short_name"=>"PY", "object"=>"country"},
  {"name"=>"Perú", "short_name"=>"PE", "object"=>"country"},
  {"name"=>"Philippines", "short_name"=>"PH", "object"=>"country"},
  {"name"=>"Pitcairn", "short_name"=>"PN", "object"=>"country"},
  {"name"=>"Poland", "short_name"=>"PL", "object"=>"country"},
  {"name"=>"Portugal", "short_name"=>"PT", "object"=>"country"},
  {"name"=>"Puerto Rico", "short_name"=>"PR", "object"=>"country"},
  {"name"=>"Qatar", "short_name"=>"QA", "object"=>"country"},
  {"name"=>"Romania", "short_name"=>"RO", "object"=>"country"},
  {"name"=>"R̩union", "short_name"=>"RE", "object"=>"country"},
  {"name"=>"Russia", "short_name"=>"RU", "object"=>"country"},
  {"name"=>"Rwanda", "short_name"=>"RW", "object"=>"country"},
  {"name"=>"Saint Barth̩lemy", "short_name"=>"BL", "object"=>"country"},
  {"name"=>"Saint Helena", "short_name"=>"SH", "object"=>"country"},
  {"name"=>"Saint Kitts and Nevis", "short_name"=>"KN", "object"=>"country"},
  {"name"=>"Saint Lucia", "short_name"=>"LC", "object"=>"country"},
  {"name"=>"Saint Martin", "short_name"=>"MF", "object"=>"country"},
  {"name"=>"Saint Pierre and Miquelon", "short_name"=>"PM", "object"=>"country"},
  {"name"=>"Saint Vincent and the Grenadines", "short_name"=>"VC", "object"=>"country"},
  {"name"=>"Samoa", "short_name"=>"WS", "object"=>"country"},
  {"name"=>"San Marino", "short_name"=>"SM", "object"=>"country"},
  {"name"=>"Saudi Arabia", "short_name"=>"SA", "object"=>"country"},
  {"name"=>"Senegal", "short_name"=>"SN", "object"=>"country"},
  {"name"=>"Serbia", "short_name"=>"RS", "object"=>"country"},
  {"name"=>"Seychelles", "short_name"=>"SC", "object"=>"country"},
  {"name"=>"Sierra Leone", "short_name"=>"SL", "object"=>"country"},
  {"name"=>"Singapore", "short_name"=>"SG", "object"=>"country"},
  {"name"=>"Sint Maarten", "short_name"=>"SX", "object"=>"country"},
  {"name"=>"Slovakia", "short_name"=>"SK", "object"=>"country"},
  {"name"=>"Slovenia", "short_name"=>"SI", "object"=>"country"},
  {"name"=>"Solomon Islands", "short_name"=>"SB", "object"=>"country"},
  {"name"=>"Somalia", "short_name"=>"SO", "object"=>"country"},
  {"name"=>"Ṣo Tom̩ and Principe", "short_name"=>"ST", "object"=>"country"},
  {"name"=>"South Africa", "short_name"=>"ZA", "object"=>"country"},
  {"name"=>"South Georgia and the South Sandwich Islands", "short_name"=>"GS", "object"=>"country"},
  {"name"=>"South Korea", "short_name"=>"KR", "object"=>"country"},
  {"name"=>"South Sudan", "short_name"=>"SS", "object"=>"country"},
  {"name"=>"Spain", "short_name"=>"ES", "object"=>"country"},
  {"name"=>"Sri Lanka", "short_name"=>"LK", "object"=>"country"},
  {"name"=>"Sudan", "short_name"=>"SD", "object"=>"country"},
  {"name"=>"Suriname", "short_name"=>"SR", "object"=>"country"},
  {"name"=>"Swaziland", "short_name"=>"SZ", "object"=>"country"},
  {"name"=>"Sweden", "short_name"=>"SE", "object"=>"country"},
  {"name"=>"Switzerland", "short_name"=>"CH", "object"=>"country"},
  {"name"=>"Syria", "short_name"=>"SY", "object"=>"country"},
  {"name"=>"Taiwan", "short_name"=>"TW", "object"=>"country"},
  {"name"=>"Tajikistan", "short_name"=>"TJ", "object"=>"country"},
  {"name"=>"Tanzania", "short_name"=>"TZ", "object"=>"country"},
  {"name"=>"Thailand", "short_name"=>"TH", "object"=>"country"},
  {"name"=>"Timor-Leste", "short_name"=>"TL", "object"=>"country"},
  {"name"=>"Togo", "short_name"=>"TG", "object"=>"country"},
  {"name"=>"Tokelau", "short_name"=>"TK", "object"=>"country"},
  {"name"=>"Tonga", "short_name"=>"TO", "object"=>"country"},
  {"name"=>"Trinidad and Tobago", "short_name"=>"TT", "object"=>"country"},
  {"name"=>"Tunisia", "short_name"=>"TN", "object"=>"country"},
  {"name"=>"Turkey", "short_name"=>"TR", "object"=>"country"},
  {"name"=>"Turkmenistan", "short_name"=>"TM", "object"=>"country"},
  {"name"=>"Turks and Caicos Islands", "short_name"=>"TC", "object"=>"country"},
  {"name"=>"Tuvalu", "short_name"=>"TV", "object"=>"country"},
  {"name"=>"Uganda", "short_name"=>"UG", "object"=>"country"},
  {"name"=>"Ukraine", "short_name"=>"UA", "object"=>"country"},
  {"name"=>"United Arab Emirates", "short_name"=>"AE", "object"=>"country"},
  {"name"=>"United Kingdom", "short_name"=>"GB", "object"=>"country"},
  {"name"=>"United States Minor Outlying Islands", "short_name"=>"UM", "object"=>"country"},
  {"name"=>"Uruguay", "short_name"=>"UY", "object"=>"country"},
  {"name"=>"U.S. Virgin Islands", "short_name"=>"VI", "object"=>"country"},
  {"name"=>"Uzbekistan", "short_name"=>"UZ", "object"=>"country"},
  {"name"=>"Vanuatu", "short_name"=>"VU", "object"=>"country"},
  {"name"=>"Vatican City", "short_name"=>"VA", "object"=>"country"},
  {"name"=>"Venezuela", "short_name"=>"VE", "object"=>"country"},
  {"name"=>"Vietnam", "short_name"=>"VN", "object"=>"country"},
  {"name"=>"Wallis and Futuna", "short_name"=>"WF", "object"=>"country"},
  {"name"=>"Western Sahara", "short_name"=>"EH", "object"=>"country"},
  {"name"=>"Yemen", "short_name"=>"YE", "object"=>"country"},
  {"name"=>"Zambia", "short_name"=>"ZM", "object"=>"country"},
  {"name"=>"Zimbabwe", "short_name"=>"ZW", "object"=>"country"},
]

# from https://api.lob.com/v1/states/
STATES = [
  {"name"=>"Alabama", "short_name"=>"AL", "object"=>"state"},
  {"name"=>"Alaska", "short_name"=>"AK", "object"=>"state"},
  {"name"=>"American Somoa", "short_name"=>"AS", "object"=>"state"},
  {"name"=>"Arizona", "short_name"=>"AZ", "object"=>"state"},
  {"name"=>"Arkansas", "short_name"=>"AR", "object"=>"state"},
  {"name"=>"California", "short_name"=>"CA", "object"=>"state"},
  {"name"=>"Colorado", "short_name"=>"CO", "object"=>"state"},
  {"name"=>"Connecticut", "short_name"=>"CT", "object"=>"state"},
  {"name"=>"Delaware", "short_name"=>"DE", "object"=>"state"},
  {"name"=>"District Of Columbia", "short_name"=>"DC", "object"=>"state"},
  {"name"=>"Federated States of Micronesia", "short_name"=>"FM", "object"=>"state"},
  {"name"=>"Florida", "short_name"=>"FL", "object"=>"state"},
  {"name"=>"Georgia", "short_name"=>"GA", "object"=>"state"},
  {"name"=>"Guam", "short_name"=>"GU", "object"=>"state"},
  {"name"=>"Hawaii", "short_name"=>"HI", "object"=>"state"},
  {"name"=>"Idaho", "short_name"=>"ID", "object"=>"state"},
  {"name"=>"Illinois", "short_name"=>"IL", "object"=>"state"},
  {"name"=>"Indiana", "short_name"=>"IN", "object"=>"state"},
  {"name"=>"Iowa", "short_name"=>"IA", "object"=>"state"},
  {"name"=>"Kansas", "short_name"=>"KS", "object"=>"state"},
  {"name"=>"Kentucky", "short_name"=>"KY", "object"=>"state"},
  {"name"=>"Louisiana", "short_name"=>"LA", "object"=>"state"},
  {"name"=>"Maine", "short_name"=>"ME", "object"=>"state"},
  {"name"=>"Marshall Islands", "short_name"=>"MH", "object"=>"state"},
  {"name"=>"Maryland", "short_name"=>"MD", "object"=>"state"},
  {"name"=>"Massachusetts", "short_name"=>"MA", "object"=>"state"},
  {"name"=>"Michigan", "short_name"=>"MI", "object"=>"state"},
  {"name"=>"Minnesota", "short_name"=>"MN", "object"=>"state"},
  {"name"=>"Mississippi", "short_name"=>"MS", "object"=>"state"},
  {"name"=>"Missouri", "short_name"=>"MO", "object"=>"state"},
  {"name"=>"Montana", "short_name"=>"MT", "object"=>"state"},
  {"name"=>"Nebraska", "short_name"=>"NE", "object"=>"state"},
  {"name"=>"Nevada", "short_name"=>"NV", "object"=>"state"},
  {"name"=>"New Hampshire", "short_name"=>"NH", "object"=>"state"},
  {"name"=>"New Jersey", "short_name"=>"NJ", "object"=>"state"},
  {"name"=>"New Mexico", "short_name"=>"NM", "object"=>"state"},
  {"name"=>"New York", "short_name"=>"NY", "object"=>"state"},
  {"name"=>"North Carolina", "short_name"=>"NC", "object"=>"state"},
  {"name"=>"North Dakota", "short_name"=>"ND", "object"=>"state"},
  {"name"=>"Northern Mariana Islands", "short_name"=>"MP", "object"=>"state"},
  {"name"=>"Ohio", "short_name"=>"OH", "object"=>"state"},
  {"name"=>"Oklahoma", "short_name"=>"OK", "object"=>"state"},
  {"name"=>"Oregon", "short_name"=>"OR", "object"=>"state"},
  {"name"=>"Palau", "short_name"=>"PW", "object"=>"state"},
  {"name"=>"Pennsylvania", "short_name"=>"PA", "object"=>"state"},
  {"name"=>"Puerto Rico", "short_name"=>"PR", "object"=>"state"},
  {"name"=>"Rhode Island", "short_name"=>"RI", "object"=>"state"},
  {"name"=>"South Carolina", "short_name"=>"SC", "object"=>"state"},
  {"name"=>"South Dakota", "short_name"=>"SD", "object"=>"state"},
  {"name"=>"Tennessee", "short_name"=>"TN", "object"=>"state"},
  {"name"=>"Texas", "short_name"=>"TX", "object"=>"state"},
  {"name"=>"U.S. Armed Forces – Americas", "short_name"=>"AA", "object"=>"state"},
  {"name"=>"U.S. Armed Forces – Europe", "short_name"=>"AE", "object"=>"state"},
  {"name"=>"U.S. Armed Forces – Pacific", "short_name"=>"AP", "object"=>"state"},
  {"name"=>"Utah", "short_name"=>"UT", "object"=>"state"},
  {"name"=>"Vermont", "short_name"=>"VT", "object"=>"state"},
  {"name"=>"Virginia", "short_name"=>"VA", "object"=>"state"},
  {"name"=>"Virgin Islands", "short_name"=>"VI", "object"=>"state"},
  {"name"=>"Washington", "short_name"=>"WA", "object"=>"state"},
  {"name"=>"West Virginia", "short_name"=>"WV", "object"=>"state"},
  {"name"=>"Wisconsin", "short_name"=>"WI", "object"=>"state"},
  {"name"=>"Wyoming", "short_name"=>"WY", "object"=>"state"},
]
