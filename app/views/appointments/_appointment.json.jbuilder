json.extract! appointment, :id, :customer_id, :app_type, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
