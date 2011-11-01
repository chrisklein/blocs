# app/views/blocs/show.json.rabl

object @bloc

attributes :content, :id

child :blocposts do
	extends "blocposts/show"
end

