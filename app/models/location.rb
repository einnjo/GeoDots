# Represents a location geocoded with latitude and longitude values and a title descriptor
class Location < ActiveRecord::Base
	# validation constants
	MIN_TITLE_LENGTH = 1
	MAX_TITLE_LENGTH = 64
	MIN_ADDRESS_LENGTH = 1
	MAX_ADDRESS_LENGTH = 256

	# validations
	validates_presence_of :title,:address
	validates_length_of :title,
		:in => MIN_TITLE_LENGTH .. MAX_TITLE_LENGTH
	validates_length_of :address,
		:in => MIN_ADDRESS_LENGTH .. MAX_ADDRESS_LENGTH
	validate :ensure_address_exists, :before => :create
	validate :ensure_address_exists, :before => :update

	# Geocoding direction Address => Lat, Lon
	geocoded_by :address

	# Searches
	def self.search(search)
		# if a search term is received
		if search
			# remove whitespace
			search.strip
			# locations where search term matches any of the attributes
			where("title LIKE ? OR address LIKE ? OR latitude LIKE ? OR longitude LIKE ?","%#{search}%","%#{search}%","%#{search}%","%#{search}%")
		else
			# default to all existing locations
			Location.all
		end
	end

	private

	# verifies that coordinates exist for the specified address
	def ensure_address_exists
		self.latitude = nil
		self.longitude = nil
		geocode
		if self.latitude.nil?
			errors.add(:address,:invalid)
		end
	end

end
