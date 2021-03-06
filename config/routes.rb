CabooseRets::Engine.routes.draw do
 
  get  "/agents"                                   => "agents#index"
  get  "/agents/:la_code"                          => "agents#details"                             
  get  "/agents/:la_code/listings"                 => "agents#listings"
  get  "/admin/agents"                             => "agents#admin_index"
  get  "/admin/agents/assistant-to-options"        => "agents#admin_assistant_to_options"
  get  "/admin/agents/options"                     => "agents#agent_options"
  get  "/admin/agents/:id/edit"                    => "agents#admin_edit"
  get  "/admin/agents/:id/edit-bio"                => "agents#admin_edit_bio"
  get  "/admin/agents/:id/edit-contact-info"       => "agents#admin_edit_contact_info"
  get  "/admin/agents/:id/edit-mls-info"           => "agents#admin_edit_mls_info"
  get  "/admin/agents/:id/refresh"                 => "agents#admin_refresh"
  put  "/admin/agents/:id"                         => "agents#admin_update"
  post "/admin/agents/:id"                         => "agents#admin_update"
  
  get  "/open-houses"                              => "open_houses#index"                         
  get  "/open-houses/:id"                          => "open_houses#details"
  get  "/admin/open-houses"                        => "open_houses#admin_index"
  get  "/admin/open-houses/refresh"                => "open_houses#admin_refresh"    
  
  get  "/admin/offices/options"                    => "offices#admin_options"
  get  "/admin/offices"                            => "offices#admin_index"
  get  "/admin/offices/:id"                        => "offices#admin_edit"
  get  "/admin/offices/:id/refresh"                => "offices#admin_refresh"
  
  get  "/admin/rets/import"                        => "rets#admin_import_form"
  post "/admin/rets/import"                        => "rets#admin_import"  
  
  get  "/commercial/search:search_params"          => "commercial#index", :constraints => {:search_params => /.*/}                             
  get  "/commercial/:mls_acct/details"             => "commercial#details"
  get  "/commercial/:mls_acct"                     => "commercial#details"
  get  "/commercial"                               => "commercial#index"
  get  "/admin/commercial/new"                     => "commercial#admin_new"
  post "/admin/commercial"                         => "commercial#admin_add"
  get  "/admin/commercial"                         => "commercial#admin_index"
  get  "/admin/commercial/:mls_acct/edit"          => "commercial#admin_edit"
  get  "/admin/commercial/:mls_acct/refresh"       => "commercial#admin_refresh"
  put  "/admin/commercial/:mls_acct"               => "commercial#admin_update"
  post "/admin/commercial/:mls_acct"               => "commercial#admin_update"
  
  get  "/residential/search-options"               => "residential#search_options"
  get  "/residential/search:search_params"         => "residential#index", :constraints => {:search_params => /.*/}  
  get  "/residential/:mls_acct/details"            => "residential#details"
  get  "/residential/:mls_acct"                    => "residential#details"
  get  "/residential"                              => "residential#index"
  get  "/admin/residential"                        => "residential#admin_index"
  get  "/admin/residential/:mls_acct/edit"         => "residential#admin_edit"
  get  "/admin/residential/:mls_acct/refresh"      => "residential#admin_refresh"
  put  "/admin/residential/:mls_acct"              => "residential#admin_update"
  post "/admin/residential/:mls_acct"              => "residential#admin_update"
  
  get  "/land/search:search_params"                => "land#index", :constraints => {:search_params => /.*/}    
  get  "/land/:mls_acct/details"                   => "land#details"
  get  "/land/:mls_acct"                           => "land#details"
  get  "/land"                                     => "land#index"
  get  "/admin/land"                               => "land#admin_index"
  get  "/admin/land/:mls_acct/edit"                => "land#admin_edit"
  get  "/admin/land/:mls_acct/refresh"             => "land#admin_refresh"
  put  "/admin/land/:mls_acct"                     => "land#admin_update"
  post "/admin/land/:mls_acct"                     => "land#admin_update"
  
  get  "/multi-family/search:search_params"        => "multi_family#index", :constraints => {:search_params => /.*/}    
  get  "/multi-family/:mls_acct/details"           => "multi_family#details"
  get  "/multi-family/:mls_acct"                   => "multi_family#details"
  get  "/multi-family"                             => "multi_family#index"
  get  "/admin/multi-family"                       => "multi_family#admin_index"
  get  "/admin/multi-family/:mls_acct/edit"        => "multi_family#admin_edit"
  get  "/admin/multi-family/:mls_acct/refresh"     => "multi_family#admin_refresh"
  put  "/admin/multi-family/:mls_acct"             => "multi_family#admin_update"
  post "/admin/multi-family/:mls_acct"             => "multi_family#admin_update"
  
  get    "/saved-searches"                         => "saved_searches#index"
  post   "/saved-searches"                         => "saved_searches#add"
  get    "/saved-searches/:id"                     => "saved_searches#redirect"
  put    "/saved-searches/:id"                     => "saved_searches#update"
  delete "/saved-searches/:id"                     => "saved_searches#delete"
  
  get    "/saved-properties/:mls_acct/status"      => "saved_properties#status"
  get    "/saved-properties/:mls_acct/toggle"      => "saved_properties#toggle_save"
  get    "/saved-properties"                       => "saved_properties#index"
  post   "/saved-properties"                       => "saved_properties#add"    
  delete "/saved-properties/:mls_acct"             => "saved_properties#delete"
        
  get    "/admin/properties/:mls_acct/photos"       => "rets_media#admin_photos"
  get    "/admin/properties/:mls_acct/files"        => "rets_media#admin_files"
  get    "/admin/properties/:mls_acct/media"        => "rets_media#admin_property_media"  
  put    "/admin/properties/:mls_acct/media/order"  => "rets_media#admin_update_order"
  post   "/admin/properties/:mls_acct/photos"       => "rets_media#admin_add_photo"
  post   "/admin/properties/:mls_acct/files"        => "rets_media#admin_add_file"
  get    "/admin/rets/media/:id"                    => "rets_media#admin_index"  
  delete "/admin/rets/media/:id"                    => "rets_media#admin_delete"  

end
