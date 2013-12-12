class Person < ActiveRecord::Base
  self.table_name = "ministry_person"
  self.primary_key = "personID"

  has_many                :rides, :foreign_key => "fk_personID"

  #belongs_to              :user, :foreign_key => "fk_ssmUserId"  #Link it to SSM

  #has_one                 :staff

  ## Addresses
  #has_one                 :current_address, -> { where :addressType => 'current' }, :foreign_key => "fk_PersonID", :class_name => 'Address'
  #has_one                 :permanent_address, -> { where :addressType => 'permanent' }, :foreign_key => "fk_PersonID", :class_name => 'Address'
  #has_one                 :emergency_address1, -> { where :addressType => 'emergency1' }, :foreign_key => "fk_PersonID", :class_name => 'Address'
  #has_many                :addresses, :foreign_key => "fk_PersonID"

  ## General
  #attr_accessor           :school

  #def emergency_address
    #emergency_address1
  #end
  #def emergency_address=(address)
    #self.emergency_address1 = address
  #end

  #def region
    #self[:region] || self.target_area.try(:region)
  #end

  #def campus=(campus_name)
    #write_attribute("campus", campus_name)
    #if target_area
      #write_attribute("region", self.school.region)
    #end
  #end

  #def target_area
    #if (self.school)
      #self.school
    #else
      #if (campus?)
        #self.school = TargetArea.find(:first,
                    #:conditions => ["name = ?", campus])
      #else
        #self.school = nil
      #end
    #end
  #end

  def full_name
    [nickname, last_name].compact.join(' ')
  end


  ## an alias for firstName using standard ruby/rails conventions
  #def first_name
    #firstName
  #end

  #def first_name=(f)
    #write_attribute("firstName", f)
  #end

  ## an alias for middleName using standard ruby/rails conventions
  #def middle_name
    #middleName
  #end

  #def middle_name=(m)
    #write_attribute("middleName", m)
  #end

  ## an alias for lastName using standard ruby/rails conventions
  def last_name
    lastName
  end

  #def last_name=(l)
    #write_attribute("lastName", l)
  #end

  ##a little more than an alias.  Nickname is the preferredName if one is listed.  Otherwise it is first name
  def nickname
    (preferredName and not preferredName.strip.empty?) ? preferredName : firstName
  end

  ##nickname is an alias for preferredName
  #def nickname=(name)
    #write_attribute("preferredName", name)
  #end

  ## an alias for yearInSchool
  #def year
    #yearInSchool
  #end

  #def year=(y)
    #write_attribute("yearInSchool", y)
  #end

  #def marital_status
    #Person::MARITAL_STATUSES[maritalStatus]
  #end

  #MARITAL_STATUSES = {'S' => 'Single',
                      #'M' => 'Married',
                      #'D' => 'Divorced',
                      #'W' => 'Widowed',
                      #'P' => 'Seperated'}

  ##set dateChanged and changedBy
  #def stamp
    #self.dateChanged = Time.now
    #self.changedBy = ApplicationController.application_name
  #end

  ##include FileColumnHelper

  ## file_column picture
  #def pic(size = "mini")
    #if image.nil?
      #"/assets/nophoto_" + size + ".gif"
    #else
      #url_for_file_column(self, "image", size)
    #end
  #end

  #def mini_pic
    #pic("mini")
  #end

  #def thumb_pic
    #pic("thumb")
  #end

  #def med_pic
    #pic("medium")
  #end

  #def email
    #email_address
  #end

  #def email_address
    #current_address.email if current_address
  #end


  #def contact_method
    #contact_method
  #end



  #def is_secure
    #if staff
      #(staff.isSecure == 'T' ? true : false)
    #else
      #false
    #end
  #end

  ## Find an exact match by email
  #def self.find_exact(person, address)
    ## try by address first
    #person = Person.where("email = ?", address.email).includes(:current_address).first
    ## then try by username
    #person ||= Person.where("username = ?", address.email).includes(:user)
    #return person
  #end

  ## Make sure account numbers are 9 or 10 digits long
  #def self.fix_acct_no(acct_no)
    #result = acct_no
    #if !acct_no.blank?
      #fix_length = 9
      #if acct_no.ends_with?("S") || acct_no.ends_with?("s")
        #fix_length = 10
      #end
      #result = "0" * (fix_length - acct_no.length) + acct_no
    #end
    #result
  #end

end

