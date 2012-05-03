module ManualAuth
module_function
	VIEW = "viewer"
	EDIT = "editor"
	ADMIN = "admin"
	def auth_info
		$auth_info ||= YAML.load(File.read(Rails.root.join("config", "auth.yml")))
	rescue
		{}
	end
	def email_ok_for?(email, what)
		return false unless email
		name, domain = email.split(/@/)
		info = auth_info[what]
		if info
			return true if info['emails'] && info['emails'].include?(email)
			return true if info['domains'] && info['domains'].include?(domain)
			false
		else
			Rails.logger.warn("Can't find auth info for #{what}")
			false
		end
	end

end
