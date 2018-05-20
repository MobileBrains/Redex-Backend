json.extract! management_report, :id, :name, :link, :description, :user_id, :client_id, :created_at, :updated_at
json.url management_report_url(management_report, format: :json)
