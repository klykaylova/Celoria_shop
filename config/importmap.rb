pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"

pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "products_gallery", to: "products_gallery.js"
pin "catalog", to: "catalog.js"
pin "order_form"
pin "admin_characteristics"
