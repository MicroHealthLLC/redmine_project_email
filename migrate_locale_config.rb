require 'yaml'

Dir.foreach("./config/locales") do |f|
 unless f == "." || f == ".."
	 filename = "../../../config/locales/" + f
	 outfilename = "./config/locales/" + f
	 basename = File.basename(filename)
	 lang = basename.split('.')[0]
	 file = File.open(filename)
	 yml = YAML::load(file)
	 setting_mail_from = yml[lang]['setting_mail_from']
	 outl = "#{lang}:\n  field_mail_from: #{setting_mail_from}"
     File.open(outfilename, 'w') { |outf|
       outf.write(outl)
     }
 end
end