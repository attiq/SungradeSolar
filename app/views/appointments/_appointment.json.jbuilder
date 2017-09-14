json.extract! appointment, :id, :title
json.customer appointment.user.profile.name
json.start appointment.scheduled_at
json.end appointment.scheduled_at + 1.hour
json.app_type appointment.app_type
json.staff appointment.staff_names
json.url appointment_url(appointment, format: :html)