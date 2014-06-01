json.array!(@parties) do |party|
  json.extract! party, :id, :theme, :location, :when_held, :host, :host_email
  json.url party_url(party, format: :json)
end
