Geocoder.configure(
  timeout: 3,
  lookup: :nominatim,
  ip_lookup: Rails.env.production? ? :ipinfo_io : :test,
  use_https: true,
  ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
)

if Rails.env.development?
  require "geocoder/lookups/test"
  Geocoder::Lookup::Test.add_stub(
    "8.8.8.8", [
      {
        "latitude"  => 40.0,
        "longitude" => -8.0,
        "city"      => "Localhost City",
        "country"   => "Localhost Country"
      }
    ]
  )
end
