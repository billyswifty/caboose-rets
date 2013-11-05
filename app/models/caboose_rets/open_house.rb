
class CabooseRets::OpenHouse < ActiveRecord::Base
  self.table_name = "rets_open_houses"
  
  def parse(data)
    self.id 		          = data['ID']
    self.comments 		    = data['COMMENTS']
    self.date_created 		= data['DATE_CREATED']
    self.date_modified 		= data['DATE_MODIFIED']
    self.end_time 		    = data['END_TIME']    
    self.la_code 		      = data['LA_CODE']
    self.mls_acct 		    = data['MLS_ACCT']
    self.open_house_date 	= data['OPEN_HOUSE_DATE']
    self.open_house_type 	= data['OPEN_HOUSE_TYPE']
    self.perpetual_yn 		= data['PERPETUAL_YN']
    self.prop_type 		    = data['PROP_TYPE']
    self.start_time 		  = data['START_TIME']
  end
end