# frozen_string_literal: true

DEFAULTS = {
  FOI_REQUEST_EMAIL: 'mhclgcorrespondence@communities.gov.uk',
  FOI_REQUEST_POSTAL_ADDRESS: <<~ADDRESS
    Knowledge & Information Access Team
    Ministry of Housing, Communities and Local Government
    2nd floor NW, Fry Building
    2 Marsham Street
    London
    SW1P 4DF
    United Kingdom
ADDRESS
}.freeze

def env_var_or_default(name)
  ENV[name.to_s] || DEFAULTS[name.to_sym]
end

Rails.configuration.x.foi_request_email = env_var_or_default 'FOI_REQUEST_EMAIL'
Rails.configuration.x.foi_request_postal_address = env_var_or_default(
  'FOI_REQUEST_POSTAL_ADDRESS'
)
