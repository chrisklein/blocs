# app/views/blocs/index.rabl

collection @blocs

extends "blocs/show"

child :user do
	extends "users/show"
end