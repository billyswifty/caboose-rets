require "caboose_rets/version"

namespace :caboose_rets do

  desc "Initialize RETS database"
  task :init_db => :environment do
    c = ActiveRecord::Base.connection
    create_agents(c)
    create_offices(c)
    create_media(c)
    create_open_houses(c)
    create_residential(c)
    create_commercial(c)
    create_land(c)
    create_multi_family(c)    
  end
  
  desc "Updates all the listings from MLS"
  task :update_rets => :environment do
    if task_is_locked
      CabooseRets::RetsImporter.log("caboose_rets:update_rets task is locked. Aborting.")
      next
    end
    CabooseRets::RetsImporter.log("Updating rets data...")
    task_started = lock_task    
    
    begin
      # RetsImporter.update_all_after(last_updated - Rational(1,86400))
      CabooseRets::RetsImporter.update_after(last_updated)		  
		  save_last_updated(task_started)
		  unlock_task
		rescue
		  raise
		ensure
		  unlock_task_if_last_updated(task_started)
		end       
  end
  
  def last_updated
    if !Caboose::Setting.exists?(:name => 'rets_last_updated')
      Caboose::Setting.create(:name => 'rets_last_updated', :value => '2013-08-06T00:00:01')
    end
    s = Caboose::Setting.where(:name => 'rets_last_updated').first
    return DateTime.parse(s.value)
  end
  
  def save_last_updated(d)
    s = Caboose::Setting.where(:name => 'rets_last_updated').first
    s.value = d.strftime('%FT%T')
    s.save
  end
  
  def task_is_locked
    return Caboose::Setting.exists?(:name => 'rets_update_running')
  end
  
  def lock_task
    date = DateTime.now
    Caboose::Setting.create(:name => 'rets_update_running', :value => date.strftime('%F %T'))
    return date
  end
  
  def unlock_task
    Caboose::Setting.where(:name => 'rets_update_running').first.destroy
  end
  
  def unlock_task_if_last_updated(d)
    setting = Caboose::Setting.where(:name => 'rets_update_running').first
    unlock_task if setting && d.strftime('%F %T') == setting.value
  end
  
  #=============================================================================
  def create_agents(c)
    c.drop_table :rets_agents if c.table_exists?('rets_agents')
    c.create_table :rets_agents do |t|
      t.string :beeper_phone         
	    t.string :last_name            
	    t.string :member_email         
	    t.string :phone_home_fax       
	    t.string :car_phone            
	    t.string :la_code              
	    t.string :member_page          
	    t.string :phone_pager          
	    t.string :date_created         
	    t.string :lo_code              
	    t.string :member_status        
	    t.string :phone_second_home    
	    t.string :date_modified        
	    t.string :mail_addr1           
	    t.string :nrds_id              
	    t.string :phone_toll_free      
	    t.string :defaultemail         
	    t.string :mail_addr2           
	    t.string :office_phone         
	    t.string :phone_voice_mail     
	    t.string :fax_phone            
	    t.string :mail_city            
	    t.string :other_phone          
	    t.string :phone_voice_pager    
	    t.string :first_name           
	    t.string :mail_state           
	    t.string :phone_change_date    
	    t.string :photo_count          
	    t.string :home_phone           
	    t.string :mail_zip             
	    t.string :phone_direct_office  
	    t.string :photo_date_modified
	    
	    t.boolean  :hide, :default => false
	    t.text     :bio
	    t.text     :contact_info
	    t.string   :assistant_to
	  end          
	  c.add_attachment :rets_agents, :image
	end
  
  def create_offices(c)
    c.drop_table :rets_offices if c.table_exists?('rets_offices')
    c.create_table :rets_offices do |t|
      t.string :lo_date_created 	 
      t.string :lo_date_modified 	 
      t.string :lo_email 		       
      t.string :lo_fax_phone 	     
      t.string :lo_idx_yn 		     
      t.string :lo_code 	       
      t.string :lo_mailaddr1 	     
      t.string :lo_mailaddr2 	     
      t.string :lo_mailcity 	     
      t.string :lo_mailstate 	     
      t.string :lo_mailzip 	       
      t.string :lo_main_lo_code 	 
      t.string :lo_name 	         
      t.string :lo_other_phone 	   
      t.string :lo_page 		       
      t.string :lo_phone 	         
      t.string :lo_status 		     
      t.string :photo_count 		   
      t.string :photo_date_modified
    end
  end
  
  def create_media(c)
    c.drop_table :rets_media if c.table_exists?('rets_media')
    c.create_table :rets_media do |t|
      t.string :date_modified
      t.string :file_name 		
      t.string :media_id 		 
      t.string :media_order 	
      t.text :media_remarks
      t.string :media_type 		
      t.string :mls_acct 		 
      t.text :url 		     
    end
    c.add_attachment :rets_media, :image
  end
    
  def create_open_houses(c)
    c.drop_table :rets_open_houses if c.table_exists?('rets_open_houses')
    c.create_table :rets_open_houses do |t|
      #t.string :id
      t.string :comments 		    
      t.string :date_created 		
      t.string :date_modified 	
      t.string :end_time 		    
      t.string :la_code 		    
      t.string :mls_acct 		    
      t.string :open_house_date 
      t.string :open_house_type 
      t.string :perpetual_yn 		
      t.string :prop_type 		  
      t.string :start_time
    end
  end
  
  def create_residential(c)
    c.drop_table :rets_residential if c.table_exists?('rets_residential')
    c.create_table :rets_residential do |t|
      t.text :bedrooms                      
	    t.text :dom                             
	    t.text :ftr_pool                        
	    t.text :rm_other3_desc                  
	    t.text :baths_full                      
	    t.text :ftr_diningroom                  
	    t.text :ftr_porchpatio                  
	    t.text :rm_other3_name                  
	    t.text :baths_half                      
	    t.text :directions                      
	    t.text :ftr_possession                  
	    t.text :rm_other4                       
	    t.text :baths                           
	    t.text :display_address_yn              
	    t.integer :current_price, :default => 0                   
	    t.text :rm_other4_desc                  
	    t.text :avm_automated_sales_disabled    
	    t.text :ftr_drive                       
	    t.text :price_change_date               
	    t.text :rm_other4_name                  
	    t.text :avm_instant_valuation_disabled  
	    t.text :elem_school                     
	    t.text :price_sqft                      
	    t.text :rm_recrm                        
	    t.text :acreage                         
	    t.text :expire_date                     
	    t.text :prop_type                       
	    t.text :rm_recrm_desc                   
	    t.text :ftr_age                         
	    t.text :ftr_exterior                    
	    t.text :rm_bath1                        
	    t.text :rm_study                        
	    t.text :agent_notes                     
	    t.text :ftr_citycommunit                
	    t.text :rm_bath1_desc                   
	    t.text :rm_study_desc                   
	    t.text :agent_other_contact_desc        
	    t.text :ftr_fireplace                   
	    t.text :rm_bath2                        
	    t.text :rm_sun                          
	    t.text :agent_other_contact_phone       
	    t.text :flood_plain                     
	    t.text :rm_bath2_desc                   
	    t.text :rm_sun_desc                     
	    t.text :annual_taxes                    
	    t.text :foreclosure_yn                  
	    t.text :rm_bath3                        
	    t.text :remarks                         
	    t.text :internet_yn                     
	    t.text :georesult                       
	    t.text :rm_bath3_desc                   
	    t.text :right_red_date                  
	    t.text :ftr_appliances                  
	    t.text :ftr_garage                      
	    t.text :rm_br1                          
	    t.text :ftr_roof                        
	    t.text :tot_heat_sqft                   
	    t.text :geo_precision                   
	    t.text :rm_br1_desc                     
	    t.text :status_flag                     
	    t.text :area                            
	    t.text :ftr_hoaamenities                
	    t.text :rm_br2                          
	    t.text :hoa_fee                         
	    t.text :ftr_hoaincludes                 
	    t.text :rm_br2_desc                     
	    t.text :sale_notes                      
	    t.text :hoa_term                        
	    t.text :hoa_fee_yn                      
	    t.text :rm_br3                          
	    t.text :ftr_terms                       
	    t.text :ftr_attic                       
	    t.text :ftr_heating                     
	    t.text :rm_br3_desc                     
	    t.text :sale_lease                      
	    t.text :ftr_docs_on_file                
	    t.text :high_school                     
	    t.text :rm_br4                          
	    t.text :owner_name                      
	    t.text :bom_date                        
	    t.text :homestead_yn                    
	    t.text :rm_br4_desc                     
	    t.text :owner_phone                     
	    t.text :basement_yn                     
	    t.text :ftr_interior                    
	    t.text :rm_br5                          
	    t.text :sa_code                         
	    t.text :ftr_basement                    
	    t.text :lease_exp_date                  
	    t.text :rm_br5_desc                     
	    t.text :so_code                         
	    t.text :book_number                     
	    t.text :ftr_landscaping                 
	    t.text :rm_brkfst                       
	    t.text :ftr_sewer                       
	    t.text :book_page                       
	    t.text :ftr_laundry                     
	    t.text :rm_brkfst_desc                  
	    t.text :ftr_showing                     
	    t.text :book_type                       
	    t.text :legals                          
	    t.text :rm_den                          
	    t.text :sold_date                       
	    t.text :buyer_name                      
	    t.text :levels                          
	    t.text :rm_den_desc                     
	    t.text :sold_price                      
	    t.text :city_code                       
	    t.text :list_price                      
	    t.text :rm_dining                       
	    t.text :sold_terms                      
	    t.text :converted                       
	    t.text :list_date                       
	    t.text :rm_dining_desc                  
	    t.text :sqft_source                     
	    t.text :currentlease_yn                 
	    t.text :status                          
	    t.text :rm_family                       
	    t.text :state                           
	    t.text :category                        
	    t.text :listing_type                    
	    t.text :rm_family_desc                  
	    t.text :street_dir                      
	    t.text :city                            
	    t.text :la_code                         
	    t.text :rm_foyer                        
	    t.text :street_name                     
	    t.text :co_la_code                      
	    t.text :lo_code                         
	    t.text :rm_foyer_desc                   
	    t.text :street_num                      
	    t.text :co_lo_code                      
	    t.text :ftr_lotdesc                     
	    t.text :rm_great                        
	    t.text :style                           
	    t.text :co_so_code                      
	    t.text :lot_dimensions                  
	    t.text :rm_great_desc                   
	    t.text :subdivision                     
	    t.text :co_sa_code                      
	    t.text :mls_acct                        
	    t.text :rm_kitchen                      
	    t.text :take_photo_yn                   
	    t.text :buyer_broker                    
	    t.text :master_bed_lvl                  
	    t.text :rm_kitchen2                     
	    t.text :upload_source                   
	    t.text :buyer_broker_type               
	    t.text :middle_school                   
	    t.text :rm_kitchen2_desc                
	    t.text :unit_num                        
	    t.text :sub_agent                       
	    t.text :ftr_miscellaneous               
	    t.text :rm_kitchen_desc                 
	    t.text :valuation_yn                    
	    t.text :sub_agent_type                  
	    t.text :other_fee                       
	    t.text :rm_laundry                      
	    t.text :third_party_comm_yn             
	    t.text :contr_broker                    
	    t.text :off_mkt_date                    
	    t.text :rm_laundry_desc                 
	    t.text :vt_yn                           
	    t.text :contr_broker_type               
	    t.text :off_mkt_days                    
	    t.text :rm_living                       
	    t.text :ftr_warrantyprogrm              
	    t.text :construction_date_comp          
	    t.text :outlier_yn                      
	    t.text :rm_living_desc                  
	    t.text :wf_feet                         
	    t.text :ftr_construction                
	    t.text :office_notes                    
	    t.text :rm_lrdr                         
	    t.text :ftr_waterheater                 
	    t.text :construction_status             
	    t.text :onsite_yn                       
	    t.text :rm_lrdr_desc                    
	    t.text :ftr_watersupply                 
	    t.text :contacts                        
	    t.text :onsite_days_hours               
	    t.text :rm_master                       
	    t.text :waterfront                      
	    t.text :ftr_cooling                     
	    t.text :orig_lp                         
	    t.text :rm_master_desc                  
	    t.text :ftr_window_treat                
	    t.text :county                          
	    t.text :other_fee_type                  
	    t.text :rm_other1                       
	    t.text :ftr_windows                     
	    t.text :df_yn                           
	    t.text :photo_count                     
	    t.text :rm_other1_desc                  
	    t.text :year_built                      
	    t.text :date_modified                   
	    t.text :photo_date_modified             
	    t.text :rm_other1_name                  
	    t.text :year_built_source               
	    t.text :status_date                     
	    t.text :prop_id                         
	    t.text :rm_other2                       
	    t.text :zip                             
	    t.text :date_created                    
	    t.text :parcel_id                       
	    t.text :rm_other2_desc                  
	    t.text :proj_close_date                 
	    t.text :pending_date                    
	    t.text :rm_other2_name                  
	    t.text :withdrawn_date                  
	    t.text :media_flag                      
	    t.text :rm_other3                       
	    t.text :virtual_tour
	    
	    t.float :latitude
	    t.float :longitude
    end
  end
  
  def create_commercial(c)
    c.drop_table :rets_commercial if c.table_exists?('rets_commercial')
    c.create_table :rets_commercial do |t|
      t.text :acreage                  
      t.text :adjoining_land_use         
      t.text :agent_notes                
      t.text :agent_other_contact_desc   
      t.text :agent_other_contact_phone  
      t.text :annual_taxes               
      t.text :approx_age                 
      t.text :area                       
      t.text :baths                      
      t.text :baths_full                 
      t.text :baths_half                 
      t.text :bedrooms                   
      t.text :bom_date                   
      t.text :book_number                
      t.text :book_page                  
      t.text :book_type                  
      t.text :box_on_unit                
      t.text :box_on_unit_yn             
      t.text :business_included_yn       
      t.text :buyer_broker               
      t.text :buyer_broker_type          
      t.text :buyer_city                 
      t.text :buyer_name                 
      t.text :buyer_state                
      t.text :buyer_zip                  
      t.text :category                   
      t.text :city                       
      t.text :city_code                  
      t.text :co_la_code                 
      t.text :co_lo_code                 
      t.text :co_sa_code                 
      t.text :co_so_code                 
      t.text :contacts                   
      t.text :contr_broker               
      t.text :contr_broker_type          
      t.text :county                     
      t.integer :current_price, :default => 0              
      t.text :date_created               
      t.text :date_leased                
      t.text :date_modified              
      t.text :df_yn                      
      t.text :directions                 
      t.text :display_address_yn         
      t.text :dom                        
      t.text :elem_school                
      t.text :expenses_assoc             
      t.text :expenses_ins               
      t.text :expenses_maint             
      t.text :expenses_mgmt              
      t.text :expenses_other             
      t.text :expenses_tax               
      t.text :expenses_utility           
      t.text :expire_date                
      t.text :flood_plain                
      t.text :ftr_building               
      t.text :ftr_building_type          
      t.text :ftr_closing                
      t.text :ftr_cooling                
      t.text :ftr_docs_on_file           
      t.text :ftr_exterior               
      t.text :ftr_financing              
      t.text :ftr_flooring               
      t.text :ftr_heating                
      t.text :ftr_interior               
      t.text :ftr_internet               
      t.text :ftr_lease_terms            
      t.text :ftr_property_desc          
      t.text :ftr_roof                   
      t.text :ftr_sale_terms             
      t.text :ftr_sewer                  
      t.text :ftr_showing                
      t.text :ftr_sprinkler              
      t.text :ftr_style                  
      t.text :ftr_utilities              
      t.text :ftr_utilities_rental       
      t.text :ftr_water                  
      t.text :geo_precision              
      t.text :georesult                  
      t.text :high_school                
      t.text :hoa_fee                    
      t.text :hoa_fee_yn                 
      t.text :hoa_term                   
      t.text :income_gross               
      t.text :income_net                 
      t.text :income_other               
      t.text :income_rental              
      t.text :internet_yn                
      t.text :la_code                    
      t.text :leased_through             
      t.text :legal_block                
      t.text :legal_lot                  
      t.text :legals                     
      t.text :list_date                  
      t.text :list_price                 
      t.text :listing_type               
      t.text :lo_code                    
      t.text :lockbox_yn                 
      t.text :lot_dimensions             
      t.text :lot_dimensions_source      
      t.text :media_flag                 
      t.text :middle_school              
      t.text :mls_acct                   
      t.text :municipality               
      t.text :num_units                  
      t.text :num_units_occupied         
      t.text :off_mkt_date               
      t.text :off_mkt_days               
      t.text :office_notes               
      t.text :orig_lp                    
      t.text :other_fee                  
      t.text :other_fee_type             
      t.text :owner_name                 
      t.text :owner_phone                
      t.text :parcel_id                  
      t.text :pending_date               
      t.text :photo_count                
      t.text :photo_date_modified        
      t.text :photo_description          
      t.text :photo_instr                
      t.text :posession                  
      t.text :price_change_date          
      t.text :price_sqft                 
      t.text :proj_close_date            
      t.text :prop_desc                  
      t.text :prop_id                    
      t.text :prop_type                  
      t.text :remarks                    
      t.text :road_frontage_ft           
      t.text :sa_code                    
      t.text :sale_lease                 
      t.text :sale_notes                 
      t.text :so_code                    
      t.text :sold_date                  
      t.text :sold_price                 
      t.text :sold_terms                 
      t.text :sqft_source                
      t.text :state                      
      t.text :status                     
      t.text :status_date                
      t.text :status_flag                
      t.text :street                     
      t.text :street_dir                 
      t.text :street_name                
      t.text :street_num                 
      t.text :sub_agent                  
      t.text :sub_agent_type             
      t.text :sub_area                   
      t.text :subdivision                
      t.text :take_photo_yn              
      t.text :third_party_comm_yn        
      t.text :tot_heat_sqft              
      t.text :tour_date                  
      t.text :tour_submit_date           
      t.text :type_detailed              
      t.text :u1_dims                    
      t.text :u1_free_standing_yn        
      t.text :u1_sqft_manuf              
      t.text :u1_sqft_office             
      t.text :u1_sqft_retail             
      t.text :u1_sqft_total              
      t.text :u1_sqft_warehouse          
      t.text :u1_year_built              
      t.text :u2_dims                    
      t.text :u2_free_standing_yn        
      t.text :u2_sqft_manuf              
      t.text :u2_sqft_office             
      t.text :u2_sqft_retail             
      t.text :u2_sqft_total              
      t.text :u2_sqft_warehouse          
      t.text :u2_year_built              
      t.text :u3_dims                    
      t.text :u3_free_standing_yn        
      t.text :u3_sqft_manuf              
      t.text :u3_sqft_office             
      t.text :u3_sqft_retail             
      t.text :u3_sqft_total              
      t.text :u3_sqft_warehouse          
      t.text :u3_year_built              
      t.text :unit_num                   
      t.text :upload_source              
      t.text :vacancy_rate               
      t.text :vacant_yn                  
      t.text :valuation_yn               
      t.text :vt_yn                      
      t.text :waterfront_yn              
      t.text :withdrawn_date             
      t.text :year_built                 
      t.text :zip                        
      t.text :zoning_northport           
      t.text :zoning_tusc                
      t.text :virtual_tour
      
      t.float :latitude
	    t.float :longitude
    end
  end
  
  def create_land(c)
    c.drop_table :rets_land if c.table_exists?('rets_land')
    c.create_table :rets_land do |t|
      t.text :acreage                  
      t.text :acreage_source             
      t.text :adjoining_land_use         
      t.text :agent_notes                
      t.text :agent_other_contact_desc   
      t.text :agent_other_contact_phone  
      t.text :annual_taxes               
      t.text :area                       
      t.text :bom_date                   
      t.text :book_number                
      t.text :book_page                  
      t.text :book_type                  
      t.text :buyer_broker               
      t.text :buyer_broker_type          
      t.text :buyer_name                 
      t.text :category                   
      t.text :city                       
      t.text :city_code                  
      t.text :co_la_code                 
      t.text :co_lo_code                 
      t.text :co_sa_code                 
      t.text :co_so_code                 
      t.text :contacts                   
      t.text :contr_broker               
      t.text :contr_broker_type          
      t.text :converted                  
      t.text :county                     
      t.integer :current_price, :default => 0              
      t.text :date_created               
      t.text :date_modified              
      t.text :df_yn                      
      t.text :directions                 
      t.text :display_address_yn         
      t.text :dom                        
      t.text :elem_school                
      t.text :expire_date                
      t.text :ftr_access                 
      t.text :ftr_docs_on_file           
      t.text :ftr_existing_struct        
      t.text :ftr_extras                 
      t.text :ftr_internet               
      t.text :ftr_lotdesc                
      t.text :ftr_mineralrights          
      t.text :ftr_possibleuse            
      t.text :ftr_restrictions           
      t.text :ftr_sewer                  
      t.text :ftr_showing                
      t.text :ftr_terms                  
      t.text :ftr_topography             
      t.text :ftr_utils                  
      t.text :ftr_zoning                 
      t.text :geo_precision              
      t.text :georesult                  
      t.text :high_school                
      t.text :internet_yn                
      t.text :la_code                    
      t.text :legal_block                
      t.text :legal_lot                  
      t.text :legal_section              
      t.text :legals                     
      t.text :list_date                  
      t.text :list_price                 
      t.text :listing_type               
      t.text :lo_code                    
      t.text :lot_dim_source             
      t.text :lot_dimensions             
      t.text :media_flag                 
      t.text :middle_school              
      t.text :mls_acct                   
      t.text :municipality               
      t.text :off_mkt_date               
      t.text :off_mkt_days               
      t.text :office_notes               
      t.text :orig_lp                    
      t.text :orig_price                 
      t.text :other_fee                  
      t.text :other_fee_type             
      t.text :owner_name                 
      t.text :owner_phone                
      t.text :parcel_id                  
      t.text :pending_date               
      t.text :photo_count                
      t.text :photo_date_modified        
      t.text :price_change_date          
      t.text :price_sqft                 
      t.text :proj_close_date            
      t.text :prop_id                    
      t.text :prop_type                  
      t.text :remarks                    
      t.text :road_frontage_ft           
      t.text :sa_code                    
      t.text :sale_lease                 
      t.text :sale_notes                 
      t.text :so_code                    
      t.text :sold_date                  
      t.text :sold_price                 
      t.text :sold_terms                 
      t.text :state                      
      t.text :status                     
      t.text :status_date                
      t.text :status_flag                
      t.text :street                     
      t.text :street_dir                 
      t.text :street_name                
      t.text :street_num                 
      t.text :sub_agent                  
      t.text :sub_agent_type             
      t.text :subdivision                
      t.text :third_party_comm_yn        
      t.text :unit_num                   
      t.text :upload_source              
      t.text :valuation_yn               
      t.text :vt_yn                      
      t.text :waterfront                 
      t.text :waterfront_yn              
      t.text :wf_feet                    
      t.text :withdrawn_date             
      t.text :zip                        
      t.text :zoning_northport           
      t.text :zoning_tusc
      
      t.float :latitude
	    t.float :longitude
    end
  end
  
  def create_multi_family(c)
    c.drop_table :rets_multi_family if c.table_exists?('rets_multi_family')
    c.create_table :rets_multi_family do |t|      
      t.text :acreage                 
      t.text :agent_notes               
      t.text :agent_other_contact_desc  
      t.text :agent_other_contact_phone 
      t.text :annual_taxes              
      t.text :area                      
      t.text :bom_date                  
      t.text :book_number               
      t.text :book_page                 
      t.text :book_type                 
      t.text :box_on_unit               
      t.text :buyer_broker              
      t.text :buyer_broker_type         
      t.text :buyer_name                
      t.text :category                  
      t.text :city                      
      t.text :city_code                 
      t.text :contacts                  
      t.text :contr_broker              
      t.text :contr_broker_type         
      t.text :county                    
      t.text :co_la_code                
      t.text :co_lo_code                
      t.text :co_sa_code                
      t.text :co_so_code                
      t.integer :current_price             
      t.text :date_created              
      t.text :date_leased               
      t.text :date_modified             
      t.text :df_yn                     
      t.text :directions                
      t.text :display_address_yn        
      t.text :dom                       
      t.text :elem_school               
      t.text :expenses_association      
      t.text :expenses_insurance        
      t.text :expenses_maintenance      
      t.text :expenses_management       
      t.text :expenses_other            
      t.text :expenses_tax              
      t.text :expire_date               
      t.text :flood_plain               
      t.text :ftr_building_type         
      t.text :ftr_construction          
      t.text :ftr_cooling               
      t.text :ftr_exterior              
      t.text :ftr_exterioramenit        
      t.text :ftr_floors                
      t.text :ftr_heating               
      t.text :ftr_interior              
      t.text :ftr_rent_incl             
      t.text :ftr_roof                  
      t.text :ftr_roof_age              
      t.text :ftr_showing               
      t.text :ftr_utils                 
      t.text :ftr_zoning                
      t.text :georesult                 
      t.text :geo_precision             
      t.text :high_school               
      t.text :hoa_fee                   
      t.text :hoa_fee_yn                
      t.text :hoa_term                  
      t.text :income                    
      t.text :income_other              
      t.text :income_rent               
      t.text :internet_yn               
      t.text :la_code                   
      t.text :legals                    
      t.text :limited_service_yn        
      t.text :listing_type              
      t.text :list_date                 
      t.text :list_price                
      t.text :lot_dimensions            
      t.text :lot_dimensions_source     
      t.text :lo_code                   
      t.text :management                
      t.text :media_flag                
      t.text :middle_school             
      t.text :mls_acct                  
      t.text :municipality              
      t.text :num_units                 
      t.text :num_units_occupied        
      t.text :office_notes              
      t.text :off_mkt_date              
      t.text :off_mkt_days              
      t.text :orig_lp                   
      t.text :orig_price                
      t.text :other_fee                 
      t.text :other_fee_type            
      t.text :owner_name                
      t.text :owner_phone               
      t.text :parcel_id                 
      t.text :pending_date              
      t.text :photo_count               
      t.text :photo_date_modified       
      t.text :price_change_date         
      t.text :price_sqft                
      t.text :proj_close_date           
      t.text :prop_id                   
      t.text :prop_type                 
      t.text :remarks                   
      t.text :sale_notes                
      t.text :sale_rent                 
      t.text :sa_code                   
      t.text :sold_date                 
      t.text :sold_price                
      t.text :sold_terms                
      t.text :so_code                   
      t.text :state                     
      t.text :status                    
      t.text :status_date               
      t.text :status_flag               
      t.text :street                    
      t.text :street_dir                
      t.text :street_name               
      t.text :street_num                
      t.text :subdivision               
      t.text :sub_agent                 
      t.text :sub_agent_type            
      t.text :third_party_comm_yn       
      t.text :tot_heat_sqft             
      t.text :u1_baths                  
      t.text :u1_num                    
      t.text :u1_occ                    
      t.text :u1_rent                   
      t.text :u1_sqft                   
      t.text :u1_yn                     
      t.text :u2_baths                  
      t.text :u2_num                    
      t.text :u2_occ                    
      t.text :u2_rent                   
      t.text :u2_sqft                   
      t.text :u2_yn                     
      t.text :u3_baths                  
      t.text :u3_num                    
      t.text :u3_occ                    
      t.text :u3_rent                   
      t.text :u3_sqft                   
      t.text :u3_yn                     
      t.text :u4_baths                  
      t.text :u4_num                    
      t.text :u4_occ                    
      t.text :u4_rent                   
      t.text :u4_sqft                   
      t.text :u4_yn                     
      t.text :u5_baths                  
      t.text :u5_num                    
      t.text :u5_occ                    
      t.text :u5_rent                   
      t.text :u5_sqft                   
      t.text :u5_yn                     
      t.text :u6_baths                  
      t.text :u6_num                    
      t.text :u6_occ                    
      t.text :u6_rent                   
      t.text :u6_sqft                   
      t.text :u6_yn                     
      t.text :u7_baths                  
      t.text :u7_num                    
      t.text :u7_occ                    
      t.text :u7_rent                   
      t.text :u7_sqft                   
      t.text :u7_yn                     
      t.text :u8_num                    
      t.text :u8_occ                    
      t.text :u8_rent                   
      t.text :u8_sqft                   
      t.text :u8_yn                     
      t.text :unit_num                  
      t.text :upload_source             
      t.text :valuation_yn              
      t.text :vt_yn                     
      t.text :withdrawn_date            
      t.text :year_built                
      t.text :zip                       
            
      t.float :latitude
	    t.float :longitude
    end
  end

end