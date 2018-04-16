Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    resources :menus, only: [:index, :show]

    post 'export/menus', to: 'export#menus'

    resources :import, only: [] do
      collection do
        post 'dishes'
        post 'menus'
        post 'menu_pages'
        post 'menu_items'
      end
    end
  end
end
