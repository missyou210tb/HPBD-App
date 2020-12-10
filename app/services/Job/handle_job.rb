module Job
  class HandleJob
    def self.birthdaythisyear day_of_birth
      day_month = day_of_birth.to_s.slice(4...day_of_birth.to_s.size)
      birthday = Date.parse(Time.zone.now.year.to_s + day_month) 
      birthday
    end 

    def self.get_nickname_from_display_name display_name
      string_temp = display_name.split(" ")
      string_temp = string_temp.join("")
      if string_temp.index("(") && string_temp.index(")")
          a = string_temp.index("(") + 1
          b = string_temp.index(")") - 1
          return string_temp[a..b]
      else
        nil
      end
    end
  end
end
