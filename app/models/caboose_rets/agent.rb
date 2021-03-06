
class CabooseRets::Agent < ActiveRecord::Base
  self.table_name = "rets_agents"  
  
  has_one :meta, :class_name => 'AgentMeta', :primary_key => 'la_code', :foreign_key => 'la_code'
  has_many :commercial_properties
  has_many :residential_properties    
  attr_accessible :id, :la_code
  after_initialize :fix_name
  
  def image
    return nil if self.meta.nil?
    return self.meta.image
  end
  
  def assistants
    CabooseRets::Agent.where(:assistant_to => self.la_code).reorder(:last_name, :first_name).all
  end

  def office
    CabooseRets::Office.where(:lo_code => self.lo_code).first
  end
  
  def fix_name
    return if self.first_name.nil?
    self.first_name = self.first_name.split(' ').collect{ |str| str.downcase.capitalize }.join(' ')
    return if self.last_name.nil?          
    self.last_name  = self.last_name.split(' ').collect{ |str| str.downcase.capitalize }.join(' ')    
    if self.last_name.starts_with?('Mc')
      self.last_name[2] = self.last_name[2].upcase
    end
  end
  
  def refresh_from_mls        
    CabooseRets::RetsImporter.import("(MLS_ACCT=#{self.mls_acct})", 'Property', 'RES')
    CabooseRets::RetsImporter.download_property_images(self)
  end
  
  def self.refresh_from_mls(la_code)
    CabooseRets::RetsImporter.import("(LA_LA_CODE=#{la_code})", 'Agent', 'AGT')
    CabooseRets::RetsImporter.import_property(mls_acct)          
  end
    
  def parse(data)
    self.beeper_phone         = data['LA_BEEPER_PHONE']
	  self.last_name            = data['LA_LAST_NAME']
	  self.member_email         = data['LA_MEMBER_EMAIL']
	  self.phone_home_fax       = data['LA_PHONE_HOME_FAX']
	  self.car_phone            = data['LA_CAR_PHONE']
	  self.la_code              = data['LA_LA_CODE']
	  self.member_page          = data['LA_MEMBER_PAGE']
	  self.phone_pager          = data['LA_PHONE_PAGER']
	  self.date_created         = data['LA_DATE_CREATED']
	  self.lo_code              = data['LA_LO_CODE']
	  self.member_status        = data['LA_MEMBER_STATUS']
	  self.phone_second_home    = data['LA_PHONE_SECOND_HOME']
	  self.date_modified        = data['LA_DATE_MODIFIED']
	  self.mail_addr1           = data['LA_MAIL_ADDR1']
	  self.nrds_id              = data['LA_NRDS_ID']
	  self.phone_toll_free      = data['LA_PHONE_TOLL_FREE']
	  self.defaultemail         = data['LA_DEFAULTEMAIL']
	  self.mail_addr2           = data['LA_MAIL_ADDR2']
	  self.office_phone         = data['LA_OFFICE_PHONE']
	  self.phone_voice_mail     = data['LA_PHONE_VOICE_MAIL']
	  self.fax_phone            = data['LA_FAX_PHONE']
	  self.mail_city            = data['LA_MAIL_CITY']
	  self.other_phone          = data['LA_OTHER_PHONE']
	  self.phone_voice_pager    = data['LA_PHONE_VOICE_PAGER']
	  self.first_name           = data['LA_FIRST_NAME']
	  self.mail_state           = data['LA_MAIL_STATE']
	  self.phone_change_date    = data['LA_PHONE_CHANGE_DATE']
	  self.photo_count          = data['PHOTO_COUNT']
	  self.home_phone           = data['LA_HOME_PHONE']
	  self.mail_zip             = data['LA_MAIL_ZIP']
	  self.phone_direct_office  = data['LA_PHONE_DIRECT_OFFICE']
	  self.photo_date_modified  = data['PHOTO_DATE_MODIFIED']
	  #self.photo_url            = ""
	end
	
	def verify_meta_exists
	  self.meta = CabooseRets::AgentMeta.create(:la_code => self.la_code) if self.meta.nil?
	end
	
	def image_url(style)	  	    	    
    if CabooseRets::use_hosted_images == true
      #return "#{CabooseRets::agents_base_url}/#{self.image_location}"
      self.verify_meta_exists      
      return self.meta.image_location
    end
    return "" if self.image.nil?
    return self.image.url(style)           
  end
     
end
