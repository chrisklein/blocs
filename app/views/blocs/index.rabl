object @bloc

attributes :content

child :user do
	# extends "user/show"
	attributes :name, :email
end