# frozen_string_literal: true

Rails.application.routes.draw do
  get "welcome/index"

  root "welcome#index"

  post "devices/:id/readings", to: "reading#update", as: "device_readings"
  get "devices/:id/readings/latest", to: "reading_latest#show", as: "device_readings_latest"
  get "devices/:id/readings/sum", to: "reading_sum#show", as: "device_readings_sum"
end
